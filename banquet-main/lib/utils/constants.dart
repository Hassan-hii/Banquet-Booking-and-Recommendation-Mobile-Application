import 'package:flutter/material.dart';

const String error = "Error";
const String somethingWentWrong = "Something Went Wrong";
const String users = 'users';
const String foods = 'foods';
const String banquets = 'banquets';
const String bookings = 'bookings';
const String wishlist = 'wishlist';
const String events = 'events';
const String ads = 'ads';
const String menus = 'menus';
const String status = 'status';

const String sPending = 'Pending';
const String sApproved = 'Approved';
const String sRejected = 'Rejected';

const Widget noWidget = SizedBox.shrink();

const Color primaryColor = Color(0xFFE4BC81);

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);