import 'dart:convert';

import 'package:banquet/modules/banquet/models/ads_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdsService{

  late final User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _dbRef;

  AdsService(){
    _currentUser = _auth.currentUser;
    _dbRef = FirebaseDatabase.instance.ref().child('ads');
  }

  User get currentUser => _currentUser!;

  Future<bool> addAdvertiseToDatabase(AdsModel model) async {
    try {
      await _dbRef.push().set(model.toJson());
      debugPrint('ads added to database successfully');
      return true; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to add ads to database: $error');
      return false; // Return false to indicate failure
    }
  }

  Future<Map<String,dynamic>> getPublishedBanquets() async {
    try {
      DatabaseEvent event = await _dbRef.orderByChild('status').equalTo('Approved').once();
      if(event.snapshot.exists){
        Map<String, dynamic> map = jsonDecode(jsonEncode(event.snapshot.value));
        return map;
      }
      debugPrint('getPublishedBanquets fetched successfully');
      return {}; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to fetched getPublishedBanquets: $error');
      return {}; // Return false to indicate failure
    }
  }

  Future<bool> updateAdsStatus(String id, String status) async {
    try {
      await _dbRef.child(id).update({
        'status': status
      });
      debugPrint('status updated to database successfully');
      return true;
    } catch (error) {
      debugPrint('Failed to update status: $error');
      return false;
    }
  }

  Stream<DatabaseEvent> getAdsStream(){
    return _dbRef.onChildAdded;
  }

  Stream<DatabaseEvent> getUpdatedAdsStream(){
    return _dbRef.onChildChanged;
  }
}