import 'dart:async';
import 'dart:convert';
import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/modules/banquet/models/package_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BanquetServices{

  User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _dbRef;

  BanquetServices(){
    _currentUser = _auth.currentUser;
    _dbRef = FirebaseDatabase.instance.ref().child(banquets);
  }

  Future<bool> addBanquetToDatabase(BanquetModel model) async {
    try {
      await _dbRef.child((_currentUser?.uid)!).set(model.toJson());
      debugPrint('Banquet added to database successfully');
      return true;
    } catch (error) {
      debugPrint('Failed to add banquet to database: $error');
      return false;
    }
  }

  Future<bool> addMenuToBanquet(MenuModel model) async {
    try {
      await _dbRef.child((_currentUser?.uid)!).child(menus).push().set(model.toJson());
      debugPrint('Menu added successfully');
      return true;
    } catch (error) {
      debugPrint('Failed to add menu to database: $error');
      return false;
    }
  }

  Future<bool> updateBanquetStatus(String id, String status) async {
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

  Future<Map<String, dynamic>?> getBanquet() async {
    try {
      DatabaseEvent event = await _dbRef.child((_currentUser?.uid)!).once();
      debugPrint('DB PATH: ${_dbRef.path} \n SNAPSHOT PATH: ${event.snapshot.ref.path}');
      if (event.snapshot.value != null) {
        Map<String, dynamic> banquets = jsonDecode(jsonEncode(event.snapshot.value));
        banquets.addIf(true, 'id', event.snapshot.key);
        return banquets;
      } else {
        print('Banquet data not found');
        return null;
      }
    } catch (error) {
      print('Failed to read banquet data: $error');
      return null;
    }
  }

  Future<Map<String,dynamic>> getAllBanquet() async {
    try {
      DatabaseEvent event = await _dbRef.orderByChild(status).equalTo(sApproved).once();
      if(event.snapshot.exists){
        Map<String, dynamic> map = jsonDecode(jsonEncode(event.snapshot.value));
        return map;
      }
      debugPrint('getAllBanquet fetched successfully');
      return {};
    } catch (error) {
      debugPrint('Failed to fetched getAllBanquet: $error');
      return {};
    }
  }

  Stream<DatabaseEvent> getBanquets(){
    return _dbRef.onChildAdded;
  }

  Stream<DatabaseEvent> getUpdateBanquets(){
    return _dbRef.onChildChanged;
  }

    Stream<DatabaseEvent> getMenus(){
    return _dbRef.child((_currentUser?.uid)!).child(menus).onChildAdded;
  }
}