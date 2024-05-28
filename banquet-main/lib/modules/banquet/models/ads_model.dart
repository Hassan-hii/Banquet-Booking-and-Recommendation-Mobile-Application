import 'package:banquet/mixin/status_color_mixin.dart';
import 'package:flutter/material.dart';

class AdsModel with StatusColor{

  static const String jId = 'id', jAdImage = 'ad_image', jAdDays = 'ad_days',
      jAdDate = 'ad_date', jBanquetName = 'banquet_name', jBanquetId = 'banquet_id', jStatus = 'status';

  final String adImage, adDays, adDate, banquetId, banquetName, status;
  final String? id;

  AdsModel({this.id, required this.adImage, required this.adDays,
    required this.adDate, required this.banquetId, required this.status,
    required this.banquetName});

  factory AdsModel.fromJson(Map<String, dynamic> json){
    return AdsModel(id: json[jId], adImage: json[jAdImage], adDays: json[jAdDays],
        adDate: json[jAdDate], banquetId: json[jBanquetId], status: json[jStatus],
        banquetName: json[jBanquetName]);
  }

  Map<String, dynamic> toJson(){
    return {
      jAdImage: adImage,
      jAdDays: adDays,
      jAdDate: adDate,
      jBanquetId: banquetId,
      jStatus: status,
      jBanquetName: banquetName
    };
  }

  Color? getStatusColor(){
    return statusColor(status);
  }
}