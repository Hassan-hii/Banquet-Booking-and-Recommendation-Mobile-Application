import 'package:banquet/auth/service/auth_service.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/wrapper/controller/wrapper_controller.dart';
import 'package:banquet/wrapper/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

  // static late final UserCredential userCredential;

  // Rx<TextEditingController> name = TextEditingController().obs;
  // Rx<TextEditingController> email = TextEditingController().obs;
  // Rx<TextEditingController> phone = TextEditingController().obs;
  // Rx<TextEditingController> pass = TextEditingController().obs;
  // Rx<TextEditingController> confirmPass = TextEditingController().obs;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxString errorMsg = ''.obs;
  Rx<User>? userModel;
  RxBool isPasswordVisible = true.obs;
  RxBool isLoginScreenVisible = true.obs;
  final RxInt _radioGroupValue = 0.obs;
  final AuthService _authService = AuthService();

  void loginUser() async {
    try {
      isLoading.value = true;
      update();
      UserCredential userCredential =
          await _authService.loginUser(email.value.text, pass.value.text);
      // userCredential = userCredential;
      isLoading.value = false;
      update();
      // FrequentUtils.getSuccessSnackBar("User", userCredential.user!.email ?? "email");
      await Get.find<WrapperController>().checkUser(email.value.text);
      await Get.off(() => WrapperScreen());
    } catch (e) {
      isLoading.value = false;
      update();
      FrequentUtils.getFailureSnackBar("Error: ", e.toString());
    }
  }

  void createUserWithFirebase() async {
    try {
      isLoading.value = true;
      update();
      User? usrModel = await _authService.signUpUser(email.value.text, pass.value.text);
      if (usrModel != null) {
        bool isUserAdded = await _authService.addUserToDatabase(
            usrModel.uid, name.value.text, phone.value.text, email.value.text, pass.value.text, _getUserType());
        if (isUserAdded) {
          isLoading.value = false;
          userModel?.value = usrModel;
          clearTextFields();
          update();
          FrequentUtils.getSuccessSnackBar("Congrats", "Signup successful");
        } else {
          isLoading.value = false;
          userModel?.value = usrModel;
          update();
          FrequentUtils.getFailureSnackBar(error, "Signup unsuccessful");
          await usrModel.delete();
        }
      } else {
        isLoading.value = false;
        update();
        FrequentUtils.getFailureSnackBar(error, "Signup unsuccessful");
      }
    } catch (e) {
      isLoading.value = false;
      update();
      FrequentUtils.getFailureSnackBar(error, e.toString());
      debugPrint('createUserWithFirebase ex: $e');
      // errorMsg.value = "Something went wrong!";
    }
  }

  void hideShowPassword() {
    isPasswordVisible.toggle();
    update();
  }

  void hideShowLoginScreen() {
    isLoginScreenVisible.toggle();
    update();
  }

  void setRadioGroupValue(int value) {
    _radioGroupValue.value = value;
    update();
  }

  int get getRadioGroupValue => _radioGroupValue.value;

  _getUserType() {
    int radioGroupValue = _radioGroupValue.value;
    switch (radioGroupValue) {
      case 1:
        return "Banquet Owner";
      case 2:
        return "Customer";
      default:
        return "Admin";
    }
  }

  void clearTextFields() {
    name.clear();
    phone.clear();
    email.clear();
    pass.clear();
    confirmPass.clear();
    // formKey.currentState!.reset();
    // update();
  }
}
