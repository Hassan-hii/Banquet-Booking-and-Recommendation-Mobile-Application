import 'package:banquet/auth/model/user_model.dart';
import 'package:banquet/mixin/status_color_mixin.dart';
import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/modules/banquet/models/package_model.dart';
import 'package:flutter/material.dart';

class BookingModel with StatusColor{
  static const String jAdditionalNotes = 'additional_notes',
      jAttendantGuests = 'attendant_guests',
      jEventShift = 'event_shift',
      jEventDate = 'event_date',
      jBookingDate = 'booking_date',
      jBanquet = 'banquet',
      jMenu = 'menu',
      jStatus = 'status',
      jHasReviewGiven = 'review_given',
      jCustomer = 'customer', jId = 'id';

  final BanquetModel banquetModel;
  final MenuModel menuModel;
  final UserModel userModel;
  final String additionalNotes, attendantGuests, eventShift, eventDate, bookingDate, status;
  final String? id;
  final bool hasReviewGiven;

  BookingModel({
    required this.banquetModel,
    required this.menuModel,
    required this.additionalNotes,
    required this.attendantGuests,
    required this.eventShift,
    required this.eventDate,
    required this.userModel,
    required this.bookingDate,
    required this.status,
    required this.hasReviewGiven,
    this.id
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
        banquetModel: BanquetModel.fromJson(json[jBanquet]),
        menuModel: MenuModel.fromJson(json[jMenu]),
        additionalNotes: json[jAdditionalNotes],
        attendantGuests: json[jAttendantGuests],
        eventShift: json[jEventShift],
        eventDate: json[jEventDate],
        userModel: UserModel.fromJson(json[jCustomer]),
      bookingDate: json[jBookingDate],
      status: json[jStatus],
      hasReviewGiven: json[jHasReviewGiven],
      id: json[jId]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      jBanquet: banquetModel.toJson(),
      jMenu: menuModel.toJson(),
      jCustomer: userModel.toJson(),
      jAdditionalNotes: additionalNotes,
      jAttendantGuests: attendantGuests,
      jEventDate: eventDate,
      jEventShift: eventShift,
      jBookingDate: bookingDate,
      jStatus: status,
      jHasReviewGiven: hasReviewGiven,
      jId: id
    };
  }

  Color? getStatusColors(){
    return statusColor(status);
  }
}
