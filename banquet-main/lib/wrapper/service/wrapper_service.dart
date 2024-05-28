import 'dart:convert';
import 'package:banquet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WrapperService{

  User? user = FirebaseAuth.instance.currentUser;

  WrapperService(){
    listenAuthUser();
  }

  Future<Map<String, dynamic>?> getUser() async{
    try {
     if(user != null){
       DatabaseEvent event = await FirebaseDatabase.instance.ref(users).child((user?.uid)!).once();
       if (event.snapshot.value != null) {
         Map<String, dynamic> userData = jsonDecode(jsonEncode(event.snapshot.value));
         userData.addIf(true, 'id', event.snapshot.key);
         return userData;
       } else{
         return null;
       }
     } else{
       return null;
     }
    } catch (error) {
      debugPrint('Failed to add food to database: $error');
      rethrow;
    }
  }

  void listenAuthUser(){
    FirebaseAuth.instance.authStateChanges().listen((event) {
      user = event;
    });
  }
}