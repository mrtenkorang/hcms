import 'dart:async';

class LocationHelper {
  static StreamController<UserLocation> printLatandLong(
      {double? latitude,
      double? longitude,
      double? altitude,
      double? accuracy}) {
    return '${accuracy?.toInt()}m' as StreamController<UserLocation>;
  }
}

class UserLocation {
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? accuracy;

  UserLocation({this.latitude, this.longitude, this.altitude, this.accuracy});

  static String newprintLatandLong(
      {double? latitude,
      double? longitude,
      double? altitude,
      double? accuracy}) {
    return '${accuracy?.toInt()}m';
  }

  static String newprintLat(
      {double? latitude,
      double? longitude,
      double? altitude,
      double? accuracy}) {
    return '${latitude?.toDouble()}';
  }

  static String newprintLng(
      {double? latitude,
      double? longitude,
      double? altitude,
      double? accuracy}) {
    return '${longitude?.toDouble()}';
  }
}
