import 'dart:convert';
import 'package:banquet/modules/customer/models/booking_model.dart';
import 'package:banquet/modules/customer/services/booking_service.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController{

  RxBool isLoading = false.obs;
  final BookingService _bookingService = BookingService();
  RxList<BookingModel> bookings = <BookingModel>[].obs;

  @override
  void onInit() {
    isLoading.value = true;
    _listenBookingsList();
    isLoading.value = false;
    super.onInit();
  }

  void _listenBookingsList(){
    _bookingService.getBookingStream().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      BookingModel model = BookingModel.fromJson(value);
      DateTime bookingDate = FrequentUtils.parseStringToDateTime(model.bookingDate);
      if(bookingDate.isBefore(DateTime.now())){
        bookings.add(model);
      }
    });
  }

}