// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/user_current_location.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class MapFarmController extends GetxController {
  late BuildContext mapFarmScreenContext;

  final mapFarmFormKey = GlobalKey<FormState>();

  Globals globals = Globals();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  TextEditingController? farmAreaTC = TextEditingController();
  TextEditingController? farmerNameTC = TextEditingController();
  TextEditingController? districtNameTC = TextEditingController();
  TextEditingController? regionNameTC = TextEditingController();
  TextEditingController? farmerContactTC = TextEditingController();
  // TextEditingController? farmSizeTC = TextEditingController();

  TextEditingController? farmIdTC = TextEditingController();

  var idType;

  LocationData? locationData;

  // FarmerFromServer? farmerFromServer = FarmerFromServer();

  Set<Marker>? markers;
  Polygon? polygon;

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
        context: mapFarmScreenContext,
      );
      userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true) {
            locationData = pos!;
            update();
          }
        },
      );
    });
  }

  usePolygonDrawingTool() {
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon != null) polys.add(polygon!);
    Get.to(
      () => PolygonDrawingTool(
        layers: polys,
        initialPolygon: polygon,
        viewInitialPolygon: polygon != null,
        // layers: HashSet<Polygon>(),
        useBackgroundLayers: false,
        allowTappingInputMethod: false,
        allowTracingInputMethod: false,
        maxAccuracy: MaxLocationAccuracy.max,
        persistMaxAccuracy: true,
        onSave: (poly, mkr, area) {
          if (mkr.isNotEmpty) {
            polygon = poly;
            markers = mkr;
            farmAreaTC?.text = area.truncateToDecimalPlaces(6).toString();
            update();
            globals.showOkayDialog(
              context: mapFarmScreenContext,
              title: 'Measurement Result',
              image: 'lib/libassets/logos/hcmslogo.jpeg',
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'measured area estimates in hectares',
                      style: TextStyle(color: AppColor.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${area.truncateToDecimalPlaces(6).toString()} ha',
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      transition: Transition.fadeIn,
    );
  }
}
