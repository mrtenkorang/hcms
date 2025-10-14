import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmcord.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import '../../../main.dart';

class FarmCordinates extends StatefulWidget {
  @override
  _FarmCordinatesState createState() => _FarmCordinatesState();
}

class _FarmCordinatesState extends State<FarmCordinates> {
  String? _farmID;
  final _farmArea = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  int? pageChecker;

  static DateTime dateTime = DateTime.now();
  DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);

  PlaceLocation? _pickedLocation;

  void _selectLatLng(double lat, double lng, double alt, double acc) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      altitude: alt,
      accuracy: acc,
    );
  }

  void setFIValuesT() {
    regSP?.setString('farmID', _farmID!);
    regSP?.setString('farmArea', _farmArea.text);

    print("Farm Information values gotten!");
    getValls();
  }

  String? hh;
  String? kk;

  void getValls() {
    hh = (regSP?.getString("farmID") ?? "");
    kk = (regSP?.getString("farmArea") ?? "");

    print("FarmID in get $hh");
    print("farmArea in get $kk");
  }

  @override
  void initState() {
    super.initState();
    // getETValues();
    _farmID = uuid.v1();
  }

  @override
  Widget build(BuildContext context) {
    return FarmCord();
  }
}
