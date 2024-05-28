import 'package:banquet/auth/controller/auth_controller.dart';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/validator.dart';
import 'package:banquet/widgets/custom_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: Get.put(AuthController()),
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: SizedBox(
                height: Get.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Assets.images.authBg.image(),
                    ),
                    Text(
                        controller.isLoginScreenVisible.value
                            ? 'Login'
                            : 'Signup',
                        style:
                            const TextStyle(fontSize: 30,)),
                    Expanded(
                      child: Form(
                        key: controller.formKey,
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Visibility(
                              visible: !controller.isLoginScreenVisible.value,
                              child: Column(
                                children: [
                                  CustomTextFormFieldWidget(
                                    controller: controller.name,
                                    labelText: 'Name',
                                    keyboardType: TextInputType.name,
                                    validator: Validator.checkStringIsNotEmpty,
                                    textCapitalization: TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 25),
                                  CustomTextFormFieldWidget(
                                    controller: controller.phone,
                                    labelText: 'Phone',
                                    hintText: '03101234567',
                                    keyboardType: TextInputType.phone,
                                    validator:
                                        Validator.checkPhoneNumberIsValid,
                                    textInputAction: TextInputAction.next,
                                    maxLength: 11,
                                  ),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                            CustomTextFormFieldWidget(
                              controller: controller.email,
                              labelText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validator.checkEmailIsValid,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 25),
                            CustomTextFormFieldWidget(
                              controller: controller.pass,
                              labelText: 'Password',
                              keyboardType: TextInputType.visiblePassword,
                              validator: Validator.checkPasswordLength,
                              textInputAction:
                                  controller.isLoginScreenVisible.value
                                      ? TextInputAction.done
                                      : TextInputAction.next,
                              obscureText: controller.isPasswordVisible.value,
                              suffixIcon: IconButton(
                                  onPressed: controller.hideShowPassword,
                                  icon: const Icon(Icons.password)),
                            ),
                            Visibility(
                              visible: !controller.isLoginScreenVisible.value,
                              child: Column(
                                children: [
                                  const SizedBox(height: 25),
                                  CustomTextFormFieldWidget(
                                    controller: controller.confirmPass,
                                    labelText: 'Confirm Password',
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value){
                                      String pass = controller.pass.value.text;
                                      if(value! != pass){
                                        return 'Password doesn\'t match';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    obscureText: controller.isPasswordVisible.value,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !controller.isLoginScreenVisible.value,
                              child: SizedBox(
                                width: Get.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile(
                                          value: 1,
                                          groupValue: controller.getRadioGroupValue,
                                          title: Text('Banquet Owner'),
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            controller.setRadioGroupValue(value!);
                                          }),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                          value: 2,
                                          groupValue: controller.getRadioGroupValue,
                                          title: Text('Customer'),
                                          dense: true,
                                          onChanged: (value) {
                                            controller.setRadioGroupValue(value!);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: Obx(() {
                                        return ElevatedButton(
                                          onPressed: () {
                                            if (controller.formKey.currentState!
                                                .validate()) {
                                              if (controller
                                                  .isLoginScreenVisible.value) {
                                                controller.loginUser();
                                              } else {
                                                controller.createUserWithFirebase();
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColor),
                                            // padding: EdgeInsets.all(10),
                                          ),
                                          child: controller.isLoading.value
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  controller.isLoginScreenVisible
                                                          .value
                                                      ? 'Login'
                                                      : 'Signup',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: underlineTextButton(controller),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  Widget underlineTextButton(AuthController controller) {
    return InkWell(
      onTap: () {
        controller
          ..hideShowLoginScreen()
          ..clearTextFields();
      },
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 3, // Space between underline and text
        ),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          // color: Colors.white,
          width: 1.0, // Underline thickness
        ))),
        child: Text(
          controller.isLoginScreenVisible.value ? 'Signup' : 'Login',
          // style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
