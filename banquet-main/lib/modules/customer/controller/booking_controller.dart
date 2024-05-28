import 'dart:convert';
import 'package:banquet/modules/customer/models/booking_model.dart';
import 'package:banquet/modules/customer/services/booking_service.dart';
import 'package:banquet/modules/customer/services/rating_service.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController{

  RxBool isLoading = false.obs;
  RxList<BookingModel> bookingsList = <BookingModel>[].obs;
  
  @override
  void onInit() {
    isLoading.value = true;
    getMyBooking();
    _listenUpdatedBookingList();
    isLoading.value = false;
    super.onInit();
  }

  void getMyBooking() async{
   try{
     isLoading.value = true;
     final map = await BookingService().getBookings();
     if(map.isNotEmpty){
       map.forEach((key, value) { 
         Map<String, dynamic> map = value;
         map.addIf(true, 'id', key);
         bookingsList.add(BookingModel.fromJson(map));
       });
     }
     isLoading.value = false;
   } catch(e){
     isLoading.value = false;
     FrequentUtils.getFailureSnackBar('Error', somethingWentWrong);
     debugPrint('Catch Error -> ${e.toString()}');
   }
  }

  void giveRatings(BookingModel model, double rating) async{
    bool hasReviewed = await RatingService().giveReview(rating, model.banquetModel.id!);
    if(hasReviewed){
      bool updated = await BookingService().updateRatingFieldInBooking(model.id!);
      if(updated){
        FrequentUtils.getSuccessSnackBar('Success', 'Thanks for the feedback!');
      }
    }
  }

  void _listenUpdatedBookingList() {
    BookingService().getUpdateBookings().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      BookingModel model = BookingModel.fromJson(value);
      bookingsList.remove(bookingsList.firstWhere((p0) => p0.id == model.id));
      bookingsList.add(model);
    });
  }
}