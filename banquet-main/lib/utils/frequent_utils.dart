import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FrequentUtils{

  static void getSuccessSnackBar(String title, String msg){
    Get.snackbar(title, msg, backgroundColor: Colors.yellow.shade100);
  }

  static void getFailureSnackBar(String title, String msg){
    Get.snackbar(title, msg, backgroundColor: Colors.redAccent.shade200,
        colorText: Colors.white);
  }

  static String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
  }

  static String formatDateToddMMMyyyy(DateTime date){
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    return formattedDate;
  }

  static DateTime parseStringToDateTime(String dateTime){
    DateTime date = DateTime.parse(dateTime);
    return date;
  }
}