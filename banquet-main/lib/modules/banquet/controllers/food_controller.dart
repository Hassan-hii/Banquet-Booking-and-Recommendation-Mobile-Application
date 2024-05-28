import 'dart:convert';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/banquet/models/food_model.dart';
import 'package:banquet/modules/banquet/services/food_service.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodController extends GetxController{

  Rx<TextEditingController> foodName = TextEditingController().obs;
  Rx<TextEditingController> foodDetails = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxList<FoodModel> children = <FoodModel>[].obs;

  final _banquetController = Get.find<BanquetDashboardController>();
  final FoodService _service = FoodService();

  @override
  void onInit() {
    super.onInit();
    _listenFoodList();
  }

  void addFood() async{
    try{
      isLoading.value = true;
      bool isAdded = await _service.addFoodToDatabase(
        FoodModel(foodName: foodName.value.text, foodDetails: foodDetails.value.text,
            foodDate: FrequentUtils.formatDateToddMMMyyyy(DateTime.now()),
            banquetName: _banquetController.banquetModel.brandName,
            banquetId: _banquetController.banquetModel.id!,
        )
      );
      if(isAdded){
        isLoading.value = false;
        FrequentUtils.getSuccessSnackBar("Success", 'Food added successfully');
        clearTextFields();
      } else{
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Food not added');
      }
    } catch (e){
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", e.toString());
    }
  }

  void _listenFoodList(){
    _service.getFoodStream().listen((event) {
      final Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      FoodModel model = FoodModel.fromJson(value);
      children.addIf(_banquetController.banquetModel.id == model.banquetId, model);
    });
  }

  void clearTextFields() {
    foodName.value.clear();
    foodDetails.value.clear();
    formKey.currentState?.reset();
  }

}