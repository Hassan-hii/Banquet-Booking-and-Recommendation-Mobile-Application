import 'package:banquet/modules/banquet/models/ads_model.dart';
import 'package:banquet/modules/banquet/services/ads_service.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerDashboardController extends GetxController{

  RxBool isLoading = false.obs;
  RxList<AdsModel> ads = <AdsModel>[].obs;

  final AdsService _adsService = AdsService();

  @override
  void onInit() {
    getAllPublishedAds();
    super.onInit();
  }

  void getAllPublishedAds() async{
    try{
      isLoading.value = true;
      Map<String, dynamic> json = await _adsService.getPublishedBanquets();
      if(json.isNotEmpty){
        json.forEach((key, value) {
          Map<String, dynamic> modelJson = value;
          modelJson.addIf(true, 'id', key);
          AdsModel model = AdsModel.fromJson(modelJson);
          DateTime adDateTime = _getDate(model.adDate);
          dynamic now = FrequentUtils.formatDateToddMMMyyyy(DateTime.now());
          now = _getDate(now);
          var newDate = adDateTime.add(Duration(days: int.parse(model.adDays)));
          var after = newDate.isAfter(now);
          var moment = newDate.isAtSameMomentAs(now);
          if(after || moment){
            ads.add(model);
          }
        });
        isLoading.value = false;
      }
    } catch(e){
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar('Error', e.toString());
      debugPrint(('Error:  ${e.toString()}'));
    }
  }

  DateTime _getDate(String date){
    var tempDate = date.trim().replaceAll(RegExp(r' '), '-');
    DateFormat format = DateFormat('dd-MMM-yyyy');
    DateTime dateTime = format.parse(tempDate);
    return dateTime;
  }

  @override
  void onClose() {
    super.onClose();
    ads.clear();
  }
}