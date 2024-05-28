import 'package:banquet/mixin/status_color_mixin.dart';
import 'package:banquet/modules/banquet/models/package_model.dart';
import 'package:flutter/material.dart';

class BanquetModel with StatusColor{
  static const String jId = 'id',
      jBrandName = 'brand_name',
      jVenueType = 'venue_type',
      jPersonCapacity = 'person_capacity',
      jParkingCapacity = 'parking_capacity',
      jBookingPrice = 'booking_price',
      jFacilities = 'facilities',
      jLocation = 'location',
      jDescription = 'description',
      jImage = 'image',
      jStatus = 'status',
  jRating = 'rating',
      jMenus = 'menus';

  String brandName,
      venueType,
      personCapacity,
      parkingCapacity,
      bookingPrice,
      facilities,
      location,
      description,
      status,
      image;

  double? rating;

  String? id;

  List<MenuModel>? menuModel;

  BanquetModel(
      {this.id, this.rating,
      required this.brandName,
      required this.venueType,
      required this.personCapacity,
      required this.parkingCapacity,
      required this.bookingPrice,
      required this.facilities,
      required this.location,
      required this.description, this.menuModel,
      required this.status,
      required this.image});

  factory BanquetModel.fromJson(Map<String, dynamic> json) {
    if(json[jMenus] != null){
      return BanquetModel(
          id: json[jId],
          rating: json[jRating],
          brandName: json[jBrandName],
          venueType: json[jVenueType],
          personCapacity: json[jPersonCapacity],
          parkingCapacity: json[jParkingCapacity],
          bookingPrice: json[jBookingPrice],
          facilities: json[jFacilities],
          location: json[jLocation],
          description: json[jDescription],
          menuModel: MenuModel.toMenuList(json[jMenus]),
          status: json[jStatus],
          image: json[jImage]);
    } else{
      return BanquetModel(
          id: json[jId],
          rating: json[jRating],
          brandName: json[jBrandName],
          venueType: json[jVenueType],
          personCapacity: json[jPersonCapacity],
          parkingCapacity: json[jParkingCapacity],
          bookingPrice: json[jBookingPrice],
          facilities: json[jFacilities],
          location: json[jLocation],
          description: json[jDescription],
          status: json[jStatus],
          image: json[jImage]);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      jId: id,
      jBrandName: brandName,
      jVenueType: venueType,
      jPersonCapacity: personCapacity,
      jParkingCapacity: parkingCapacity,
      jBookingPrice: bookingPrice,
      jFacilities: facilities,
      jLocation: location,
      jDescription: description,
      jStatus: status,
      jImage: image
    };
  }

  Color? getStatusColor(){
    return statusColor(status);
  }
}
