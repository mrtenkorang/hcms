import 'package:flutter/foundation.dart';
import 'dart:io';

class PlaceLocation {
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? accuracy;

  const PlaceLocation(
      {this.latitude, this.longitude, this.altitude, this.accuracy});
}

class Place {
  final String? id;
  final String? wasteSize;
  final String? foneid;
  final String? quantity;
  String? checkCon;
  final String? comment;
  final File? image;
  final File? audio;
  final String? imageUrl;
  final PlaceLocation? location;

  final String? timeDisplay;
  final String? reportID;
  final String? reportStatus;

  Place({
    required this.id,
    this.wasteSize,
    this.foneid,
    this.quantity,
    this.checkCon,
    required this.comment,
    required this.image,
    this.audio,
    this.imageUrl,
    this.location,
    this.timeDisplay,
    this.reportID,
    this.reportStatus,
  });
}

class AlreadyUsed {
  String? confirm;

  AlreadyUsed({
    this.confirm,
  });
}
