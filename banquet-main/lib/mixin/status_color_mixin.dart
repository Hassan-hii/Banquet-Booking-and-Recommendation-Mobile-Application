import 'package:banquet/enum/common_status.dart';
import 'package:banquet/utils/constants.dart';
import 'package:flutter/material.dart';

mixin StatusColor{
  Color? statusColor(String status){
    switch(status){
      case sPending:
        return CommonStatus.pending.getColor;
      case sApproved:
        return CommonStatus.approved.getColor;
      case sRejected:
        return CommonStatus.rejected.getColor;
      default:
        return null;
    }
  }
}