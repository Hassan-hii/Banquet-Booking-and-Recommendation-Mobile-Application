import 'package:banquet/modules/banquet/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventService{

  late final User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _dbRef;

  EventService(){
    _currentUser = _auth.currentUser;
    _dbRef = FirebaseDatabase.instance.ref()
        .child('events');
  }

  Future<bool> addEventToDatabase(EventModel model) async {
    try {
      await _dbRef.push().set(model.toJson());
      debugPrint('event added to database successfully');
      return true; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to add event to database: $error');
      return false; // Return false to indicate failure
    }
  }

  Stream<DatabaseEvent> getEventStream(){
    return _dbRef.onChildAdded;
  }
}