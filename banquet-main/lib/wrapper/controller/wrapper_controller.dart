import 'dart:async';

import 'package:banquet/auth/model/user_model.dart';
import 'package:banquet/wrapper/service/wrapper_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WrapperController extends GetxController{

  final WrapperService _service = WrapperService();

  Rx<UserModel> model = UserModel.empty().obs;
  User? user = FirebaseAuth.instance.currentUser;
  RxBool isLoading = false.obs;

  @override
  void onInit() async{
    super.onInit();
    if(user != null){
      isLoading.value = true;
      dynamic map = await _service.getUser() as Map<String, dynamic>;
      debugPrint(map.toString());
      model.value = UserModel.fromJson(map);
      isLoading.value = false;
    }
  }

  Future<void> checkUser(String email) async{
    if(model.value.email != email){
      // isLoading.value = true;
      dynamic map = await _service.getUser() as Map<String, dynamic>;
      debugPrint(map.toString());
      model.value = UserModel.fromJson(map);
      update();
      await Future.delayed(const Duration(milliseconds: 300));
      // isLoading.value = false;
    }
  }
}