import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../helpers/locationhelper.dart';

class NewLocationService extends StatefulWidget {
  final onSelectLatLng;
  final bool show;

  NewLocationService({this.onSelectLatLng, this.show = false});
  @override
  NewLocationServiceState createState() => NewLocationServiceState();
}

class NewLocationServiceState extends State<NewLocationService> {
  static var _previewlatlngCord;
  static var _previewlatlngCordu30;
  static var _previewlatlngCorda30;

  static var _previewLat;
  static var _previewLng;

  bool _approved = false;
  var saveLat;
  var saveLng;
  var colorGreen;
  var colorRed;

  var colorChange;
  bool? recep;

  static const lessthan = "";
  static const greaterthan = "";

  var newCor;
  var newCord;

  Location cat = Location();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      child:
          // widget.show
          //     ? Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               Container(
          //                 // width: 100,
          //                 child: Text(
          //                   'GPS Accuracy: ',
          //                 ),
          //               ),
          //               Container(
          //                 // width: 70.00,
          //                 child: colorChange == "green"
          //                     ? Text(
          //                         "$_previewlatlngCordu30",
          //                         style: TextStyle(color: Colors.black),
          //                       )
          //                     : colorChange == "red"
          //                         ? Text(
          //                             "$_previewlatlngCorda30",
          //                             style: TextStyle(color: Colors.red),
          //                           )
          //                         : Text(""),
          //               ),
          //             ],
          //           ),
          //           _previewLng != null
          //               ? Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: <Widget>[
          //                     Container(
          //                       // width: 100,
          //                       child: Text(
          //                         // 'location: ',
          //                         'Picked longitude: ',
          //                         textAlign: TextAlign.left,
          //                       ),
          //                     ),
          //                     Container(
          //                       // width: 70.00,
          //                       child: Text(
          //                         "$_previewLng",
          //                         style: TextStyle(color: fPrimaryColour),
          //                       ),
          //                     ),
          //                   ],
          //                 )
          //               : SizedBox(),
          //           _previewLat != null
          //               ? Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: <Widget>[
          //                     Container(
          //                       // width: 100,
          //                       child: Text(
          //                         // 'location: ',
          //                         'Picked latitude: ',
          //                         textAlign: TextAlign.left,
          //                       ),
          //                     ),
          //                     Container(
          //                       // width: 70.00,
          //                       child: Text(
          //                         "$_previewLat",
          //                         style: TextStyle(color: fPrimaryColour),
          //                       ),
          //                     ),
          //                   ],
          //                 )
          //               : SizedBox(),
          //         ],
          //       )
          // :
          Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                // width: 100,
                child: Text(
                  'GPS Accuracy: ',
                ),
              ),
              Container(
                // width: 70.00,
                child: colorChange == "green"
                    ? Text(
                        "$_previewlatlngCordu30",
                        style: TextStyle(color: Colors.black),
                      )
                    : colorChange == "red"
                        ? Text(
                            "$_previewlatlngCorda30",
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(""),
              ),
            ],
          ),
        ],
      ),
    );
  }

  UserLocation? _currentLocation;

  Location location = Location();
  NewLocationServiceState() {
    location.requestPermission().then((granted) {
      if (granted != null) {
        setState(() {
          // SendReport();
          LocationAccuracy.high;
        });
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            final latlngCord = UserLocation.newprintLatandLong(
                latitude: locationData.latitude,
                longitude: locationData.longitude,
                altitude: locationData.altitude,
                accuracy: locationData.accuracy);
            if (mounted) {
              // print("mounted");
              setState(() {
                _previewlatlngCord = latlngCord;
                // colorChange = false;
              });

              if (kDebugMode
                  ? locationData.accuracy!.toInt() <= 30
                  : locationData.accuracy!.toInt() <= 5) {
                // _locationsub.cancel();
                widget.onSelectLatLng(
                  locationData.latitude,
                  locationData.longitude,
                  locationData.altitude,
                  locationData.accuracy,
                );

                colorGreen = "green";
                colorChange = "green";
                setState(() {
                  saveLat = locationData.latitude;
                  saveLng = locationData.longitude;
                  _approved = true;
                  _previewlatlngCordu30 = (_previewlatlngCord);
                  _previewLat = UserLocation.newprintLat(
                      latitude: locationData.latitude,
                      longitude: locationData.longitude,
                      altitude: locationData.altitude,
                      accuracy: locationData.accuracy);
                  _previewLng = UserLocation.newprintLng(
                      latitude: locationData.latitude,
                      longitude: locationData.longitude,
                      altitude: locationData.altitude,
                      accuracy: locationData.accuracy);
                  recep = true;
                  // lessthan;
                  // newCor = _previewlatlngCord;
                });
                Locator();
              } else {
                colorRed = "red";
                colorChange = "red";
                setState(() {
                  _previewlatlngCorda30 = "$_previewlatlngCord";
                  _previewLat = null;
                  _previewLng = null;
                  recep = false;
                });
                Locator();
              }
            }
            // print("now mounted 1");
          }
        });
      } else {
        location.requestPermission();

        location.requestPermission().then((granted) {
          if (granted != null) {
            setState(() {
              // SendReport();
            });
            location.onLocationChanged.listen((locationData) {
              if (locationData != null) {
                final latlngCord = UserLocation.newprintLatandLong(
                    latitude: locationData.latitude,
                    longitude: locationData.longitude,
                    altitude: locationData.altitude,
                    accuracy: locationData.accuracy);
                if (mounted) {
                  // print("mounted");
                  setState(() {
                    _previewlatlngCord = latlngCord;
                    // colorChange = false;
                  });

                  if (kDebugMode
                      ? locationData.accuracy!.toInt() <= 30
                      : locationData.accuracy!.toInt() <= 5) {
                    // _locationsub.cancel();
                    widget.onSelectLatLng(
                      locationData.latitude,
                      locationData.longitude,
                      locationData.altitude,
                      locationData.accuracy,
                    );

                    colorGreen = "green";
                    colorChange = "green";
                    setState(() {
                      saveLat = locationData.latitude;
                      saveLng = locationData.longitude;
                      _approved = true;
                      _previewlatlngCordu30 = (_previewlatlngCord);
                      _previewLat = UserLocation.newprintLat(
                          latitude: locationData.latitude,
                          longitude: locationData.longitude,
                          altitude: locationData.altitude,
                          accuracy: locationData.accuracy);
                      _previewLng = UserLocation.newprintLng(
                          latitude: locationData.latitude,
                          longitude: locationData.longitude,
                          altitude: locationData.altitude,
                          accuracy: locationData.accuracy);
                      recep = true;
                      // lessthan;
                      // newCor = _previewlatlngCord;
                    });
                    Locator();
                  } else {
                    colorRed = "red";
                    colorChange = "red";
                    setState(() {
                      _previewlatlngCorda30 = "$_previewlatlngCord";
                      _previewLat = null;
                      _previewLng = null;
                      recep = false;
                      // greaterthan;
                      // newCord = _previewlatlngCord;
                    });
                    Locator();
                  }
                }
                // print("now mounted 2");
                // print(locationData.latitude);
                // print(locationData.longitude);
              }
            });
          }
        });
      }
    });
  }

  // Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
          altitude: userLocation.altitude,
          accuracy: userLocation.accuracy);
      // print("also mounted");
    } catch (e) {
      print('Could not get location: $e');
    }

    return _currentLocation!;
  }
}

class Locator extends StatefulWidget {
  @override
  _LocatorState createState() => _LocatorState();
}

class _LocatorState extends State<Locator> {
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Text(
        "${userLocation.accuracy}, ${userLocation.latitude}, ${userLocation.longitude} ${userLocation.altitude}");
  }
}
