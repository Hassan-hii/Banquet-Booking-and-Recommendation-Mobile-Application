import 'dart:io';

import 'package:banquet/firebase_options.dart';
import 'package:banquet/modules/customer/controller/wishlist_controller.dart';
import 'package:banquet/wrapper/controller/wrapper_controller.dart';
import 'package:banquet/wrapper/wrapper.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  app = await Firebase.initializeApp(
    name: Platform.isIOS ? 'my-banquet-proj' : null,
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  Get.lazyPut(() => WrapperController());
  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => const MyApp(), // Wrap your app
  // ),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Banquet App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade700),
        useMaterial3: true,
      ),
      home: WrapperScreen(),
      // home: BanquetDashboardScreen(),
    );
  }
}
