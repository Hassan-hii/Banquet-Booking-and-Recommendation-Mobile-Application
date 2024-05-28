import 'dart:convert';

import 'package:banquet/modules/customer/models/booking_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BookingService{
  User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _dbRef;

  BookingService(){
    _currentUser = _auth.currentUser;
    _dbRef = FirebaseDatabase.instance.ref().child(bookings);
  }

  Future<bool> addBookingToDatabase(BookingModel model) async {
    try {
      await _dbRef.push().set(model.toJson());
      debugPrint('Banquet added to database successfully');
      return true;
    } catch (error) {
      debugPrint('Failed to add banquet to database: $error');
      return false;
    }
  }

  Future<bool> updateRatingFieldInBooking(String id) async {
    try {
      await _dbRef.child(id).update({
        BookingModel.jHasReviewGiven: true
      });
      debugPrint('Booking model updated to database successfully');
      return true;
    } catch (error) {
      debugPrint('Failed to update booking to database: $error');
      return false;
    }
  }

  Future<Map<String,dynamic>> getBookings() async {
    try {
      DatabaseEvent event = await _dbRef.orderByChild('customer/id').equalTo(_currentUser?.uid).once();
      if(event.snapshot.exists){
        Map<String, dynamic> map = jsonDecode(jsonEncode(event.snapshot.value));
        return map;
      }
      debugPrint('getBookings fetched successfully');
      return {}; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to fetched getBookings: $error');
      return {}; // Return false to indicate failure
    }
  }

  Future<Map<String,dynamic>> getBanquetBookings() async {
    try {
      DatabaseEvent event = await _dbRef.orderByChild('banquet/id').equalTo(_currentUser?.uid).once();
      if(event.snapshot.exists){
        Map<String, dynamic> map = jsonDecode(jsonEncode(event.snapshot.value));
        return map;
      }
      debugPrint('getBookings fetched successfully');
      return {}; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to fetched getBookings: $error');
      return {}; // Return false to indicate failure
    }
  }

  Future<bool> updateBookingStatus(String id, String status) async {
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

  Stream<DatabaseEvent> getBookingStream(){
    return _dbRef.onChildAdded;
  }

  Stream<DatabaseEvent> getUpdateBookings(){
    return _dbRef.onChildChanged;
  }
}