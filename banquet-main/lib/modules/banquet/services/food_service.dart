import 'package:banquet/modules/banquet/models/food_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FoodService{

  late final User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _dbRef;

  FoodService(){
    _currentUser = _auth.currentUser;
    _dbRef = FirebaseDatabase.instance.ref()
        .child('foods');
  }

  Future<bool> addFoodToDatabase(FoodModel model) async {
    try {
      await _dbRef.push().set(model.toJson());
      debugPrint('food added to database successfully');
      return true; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to add food to database: $error');
      return false; // Return false to indicate failure
    }
  }

  Stream<DatabaseEvent> getFoodStream(){
    return _dbRef.onChildAdded;
  }
}