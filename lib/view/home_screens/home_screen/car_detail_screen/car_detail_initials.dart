import 'package:flutter/foundation.dart';
import 'package:wizmo/models/dynamic_car_detail_model.dart';

class CarDetailInitials {
  DynamicCarDetailModel carDetails;
  VoidCallback onTap;
  bool? isFavourite;
  String? location;
  String? latitude;
  String? longitude;
  bool myCars;
  String? sellerType;
  List? features;
  List? featureName;

  CarDetailInitials(
      {required this.carDetails,
      required this.onTap,
      this.features,
      this.myCars = false,
      this.location,
      this.sellerType,
      this.longitude,
      this.latitude,
      this.featureName,
      this.isFavourite});
}
