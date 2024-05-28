import 'package:banquet/utils/constants.dart';
import 'package:flutter/material.dart';

enum CommonStatus {pending, approved, rejected}

extension CommonStatusExtension on CommonStatus{

  String get getName{
    switch(this){
      case CommonStatus.pending:
        return sPending;
      case CommonStatus.approved:
        return sApproved;
      case CommonStatus.rejected:
        return sRejected;
    }
  }

  Color get getColor{
    switch(this){
      case CommonStatus.pending:
        return Colors.amber;
      case CommonStatus.approved:
        return Colors.green;
      case CommonStatus.rejected:
        return Colors.red;
    }
  }
}