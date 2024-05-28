import 'package:banquet/auth/view/login_screen.dart';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/admin/screens/admin_dashboard_screen.dart';
import 'package:banquet/modules/banquet/screens/banquet_dashboard_screen.dart';
import 'package:banquet/modules/customer/screens/customer_dashboard_screen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/wrapper/controller/wrapper_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class WrapperScreen extends StatelessWidget {
  WrapperScreen({super.key});

  final controller = Get.find<WrapperController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        } else{
          FlutterNativeSplash.remove();
          Widget returnWidget = noWidget;
          final user = controller.model.value;
          if (FirebaseAuth.instance.currentUser != null) {
            if (user.userType == UserType.admin.getName) {
              debugPrint('User type is Admin');
              returnWidget = AdminDashboardScreen();
            } else if (user.userType == UserType.banquetOwner.getName) {
              debugPrint('User type is Banquet Owner');
              returnWidget = const BanquetDashboardScreen();
            } else if (user.userType == UserType.customer.getName) {
              debugPrint('User type is Customer');
              returnWidget = const CustomerDashboardScreen();
            }
          } else {
            returnWidget = const LoginScreen();
          }
          return returnWidget;
        }
      }),
    );
  }
}
