import 'dart:convert';
import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WishlistService{

  User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _dbRef;

  WishlistService(){
    _currentUser = _auth.currentUser;
    _dbRef = FirebaseDatabase.instance.ref().child(wishlist);
  }

  Future<bool> addWishlistToDatabase(BanquetModel model) async {
    try {
      await _dbRef.child((_currentUser?.uid)!).child(model.id!).set(model.toJson());
      debugPrint('addWishlistToDatabase successfully');
      return true;
    } catch (error) {
      debugPrint('Failed to addWishlistToDatabase: $error');
      return false;
    }
  }

  Future<bool> getSingleWishlist(String id) async {
    try {
      DatabaseEvent event = await _dbRef.child((_currentUser?.uid)!).child(id).once();
      if(event.snapshot.exists){
        return true;
      } else{
        return false;// Return true to indicate success
      }
    } catch (error) {
      debugPrint('Failed to fetched getSingleWishlist: $error');
      return false; // Return false to indicate failure
    }
  }

  Future<Map<String,dynamic>> getAllWishlist() async {
    try {
      DatabaseEvent event = await _dbRef.child((_currentUser?.uid)!).once();
      if(event.snapshot.exists){
        Map<String, dynamic> map = jsonDecode(jsonEncode(event.snapshot.value));
        return map;
      }
      debugPrint('getAllWishlist fetched successfully');
      return {}; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to fetched getAllWishlist: $error');
      return {}; // Return false to indicate failure
    }
  }
}