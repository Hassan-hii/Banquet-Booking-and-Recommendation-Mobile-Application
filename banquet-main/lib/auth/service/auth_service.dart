import 'dart:convert';
import 'package:banquet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.toString()}');

      if (e.code == 'invalid-credential') {
        throw 'User not found';
      }
      throw somethingWentWrong;
    }
  }

  Future<User?> signUpUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.toString()}');

      if (e.code == 'email-already-in-use') {
        throw '$email has already been registered';
      }
      throw somethingWentWrong;
    }
  }

  Future<bool> addUserToDatabase(String uId, String name, String phoneNumber, String email, String password, String userType) async {
    try {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users').child(uId);
      await usersRef.set({
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'userType': userType
      });
      debugPrint('User added to database successfully');
      return true; // Return true to indicate success
    } catch (error) {
      debugPrint('Failed to add user to database: $error');
      return false; // Return false to indicate failure
    }
  }

  Future<Map<String, dynamic>?> getUser(String id) async{
    try {
      DatabaseEvent event = await FirebaseDatabase.instance.ref().child('users').child(id).once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> userData = jsonDecode(jsonEncode(event.snapshot.value));
        return userData;
      } else{
        return null;
      }
    } catch (error) {
      debugPrint('Failed to add food to database: $error');
      rethrow;
    }
  }

  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
