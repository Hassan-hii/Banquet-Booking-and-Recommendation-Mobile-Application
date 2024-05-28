import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/modules/customer/services/wishlist_service.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListController extends GetxController{

  RxBool isLoading = false.obs;
  final _service = WishlistService();
  RxList<BanquetModel> wishlist = <BanquetModel>[].obs;

  @override
  void onInit() {
    getWishlist();
    super.onInit();
  }

  void addToWishList(BanquetModel model) async {
    bool isAlreadyPresent =
    await _service.getSingleWishlist(model.id!);
    if (isAlreadyPresent) {
      FrequentUtils.getSuccessSnackBar(
          'Message', 'Wishlist has already been added');
    } else {
      bool isAdded = await _service.addWishlistToDatabase(model);
      if (isAdded) {
        FrequentUtils.getSuccessSnackBar(
            'Success', 'Banquet is added in wishlist');
      } else {
        FrequentUtils.getSuccessSnackBar('Failed', somethingWentWrong);
      }
    }
  }

  void getWishlist() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> json = await _service.getAllWishlist();
      if (json.isNotEmpty) {
        json.forEach((key, value) {
          Map<String, dynamic> modelJson = value;
          modelJson.addIf(true, 'id', key);
          BanquetModel model = BanquetModel.fromJson(modelJson);
          wishlist.add(model);
        });
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar('Error', e.toString());
      debugPrint(('Error:  ${e.toString()}'));
    }
  }
}