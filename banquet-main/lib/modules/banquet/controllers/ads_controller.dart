import 'dart:convert';
import 'dart:io';

import 'package:banquet/enum/common_status.dart';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/banquet/models/ads_model.dart';
import 'package:banquet/modules/banquet/services/ads_service.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdsController extends GetxController{

  RxList<AdsModel> children = <AdsModel>[].obs;
  Rx<File> image = File('').obs;
  RxBool isLoading = false.obs;
  final RxInt _days = 1.obs;

  final AdsService _service = AdsService();

  final _banquetController = Get.find<BanquetDashboardController>();

  set setPickedImage(value) => image = value;

  void incrementDays() => _days.value++;

  void decrementDays() {
    if(_days.value > 1 ) _days.value--;
  }

  void resetDays() => _days.value = 1;

  int get getDays => _days.value;


  @override
  void onInit() {
    isLoading.value = true;
    _listenAdvertiseList();
    _listenUpdatedAdvertiseList();
    isLoading.value = false;
    super.onInit();
  }

  void addAdvertise() async{
    try{
      isLoading.value = true;
      bool isAdded = await _service.addAdvertiseToDatabase(
          AdsModel(adDays: _days.value.toString(), status: CommonStatus.pending.getName,
              banquetId: _banquetController.banquetModel.id!, adImage: FrequentUtils.convertIntoBase64((image.value)),
              adDate: FrequentUtils.formatDateToddMMMyyyy(DateTime.now()),
            banquetName: _banquetController.banquetModel.brandName
          )
      );
      if(isAdded){
        isLoading.value = false;
        FrequentUtils.getSuccessSnackBar("Success", 'Ad added successfully');
        clearFields();
      } else{
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Ad not added');
      }
    } catch (e){
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", e.toString());
    }
  }

  void updateAdsStatus(String id, String status) async{
    try {
      isLoading.value = true;
      bool banquetUpdated = await _service.updateAdsStatus(id, status);
      if(banquetUpdated){
        isLoading.value = false;
        FrequentUtils.getSuccessSnackBar("Success", 'Ad updated successfully');
      } else{
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Ad not updated');
      }
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", e.toString());
    }
  }

  void _listenAdvertiseList(){
    _service.getAdsStream().listen((event) {
      final Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      AdsModel model = AdsModel.fromJson(value);
      children.addIf(_banquetController.banquetModel.id == model.banquetId, model);
    });
  }

  void _listenUpdatedAdvertiseList(){
    _service.getUpdatedAdsStream().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      AdsModel model = AdsModel.fromJson(value);
      children.remove(children.firstWhere((p0) => p0.id == model.id));
      children.addIf(_banquetController.banquetModel.id == model.banquetId, model);
    });
  }

  void clearFields() {
    resetDays();
    image.value = File('');
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image.value = File(pickedImage.path);
    } else {
      print('No image selected.');
    }
  }

}