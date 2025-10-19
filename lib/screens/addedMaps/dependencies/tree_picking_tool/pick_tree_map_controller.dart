// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/helpers/services/seedling_monitoring_services.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/seedling_monitoring_controller.dart';


class PickTreeMapController extends GetxController {
  BuildContext? pickTreesMapScreenContext;

  TextEditingController searchFarmController = TextEditingController();

  GoogleMapController? mapController;

  Globals globals = Globals();

  late final SeedlingMonitoringService seedlingMonitoringService;

  // PickTreeController pickTreeController = Get.put(PickTreeController());

  // GlobalController globalController = Get.find();

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(7.9527706, -1.0307118),
    zoom: 8.0,
    tilt: 30,
    // bearing: 270.0,
  );

  late String mapStyle;
  bool isActive = false;

  Set<Marker> markers = HashSet<Marker>();
  Set<Polygon> polygons = HashSet<Polygon>();

  BitmapDescriptor? mapMarker;

  Polygon? activePolygon;
  var isLastPolygon = false.obs;
  var isFirstPolygon = false.obs;
  var emptyData = false.obs;

  @override
  void onInit() {
    super.onInit();
    seedlingMonitoringService = Get.find<SeedlingMonitoringService>();
  }

  // ============================================================
  // START CREATE MAP MARKER
  // ============================================================
  // createMarker() async {
  //   if (mapMarker == null) {
  //     ImageConfiguration configuration = createLocalImageConfiguration(tmtMapScreenContext!);
  //     BitmapDescriptor.fromAssetImage(configuration, 'assets/images/track_my_tree/tmt_marker.png')
  //         .then((icon) {
  //       mapMarker = icon;
  //     });
  //   }
  // }
// ============================================================
// END CREATE MAP MARKER
// ============================================================

  // Removed direct reference to EditSeedlingMonitoringController to prevent circular dependency
  // Use callbacks or services for communication instead

  Future<void> loadFarms(Map<String, dynamic> farm) async {
    // var polyList;
    //
    // if(farm["farm_boundary"].contains("MultiPolygon")) {
    //   var farmBoundaryString = farm["farm_boundary"] as String;
    //   var farmBoundary = jsonDecode(farmBoundaryString);
    //
    //   polyList = farmBoundary['coordinates'][0][0];
    // } else{
    //   var farmBoundaryString = farm["farm_boundary"] as String;
    //   var farmBoundary = jsonDecode(farmBoundaryString);
    //
    //   polyList = farmBoundary['coordinates'][0];
    // }
    //
    // List<LatLng> polygonLatLngs = [];
    // for (var element in polyList) {
    //   // print("ELEMENT :: ${element[1]} ${element[0]}");
    //   polygonLatLngs.add(LatLng(element[1], element[0]));
    // }
    List<LatLng> polygonLatLngs = [];

    for (var element in farm["bounds"]) {
      polygonLatLngs.add(element);
    }

    polygons.add(
      Polygon(
        polygonId: PolygonId(farm["farm_reference"].toString()),
        points: polygonLatLngs,
        strokeColor: Colors.red,
        consumeTapEvents: true,
        fillColor: Colors.green.withOpacity(0.05),
        strokeWidth: 2,
        onTap: () async {
          Polygon polygon = polygons.toList()[polygons.toList().indexWhere(
                  (e) => e.polygonId.value == farm["farm_reference"].toString())];
          activePolygon = polygon;
          mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(
                boundsFromLatLngList(polygon.points), 140.0),
          );

          if (polygons.first == activePolygon &&
              polygons.last == activePolygon) {
            isFirstPolygon.value = true;
            isLastPolygon.value = true;
          }
          if (polygons.first == activePolygon) {
            isFirstPolygon.value = true;
          } else {
            isFirstPolygon.value = false;
          }
          if (polygons.last == activePolygon) {
            isLastPolygon.value = true;
          } else {
            isLastPolygon.value = false;
          }

          update();
        },
      ),
    );

    update();

    if (polygons.isNotEmpty) {
      activePolygon = polygons.first;
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(polygons.first.points), 140.0),
      );

      if (polygons.first == activePolygon && polygons.last == activePolygon) {
        isFirstPolygon.value = true;
        isLastPolygon.value = true;
      }
      if (polygons.first == activePolygon) {
        isFirstPolygon.value = true;
      } else {
        isFirstPolygon.value = false;
      }
      if (polygons.last == activePolygon) {
        isLastPolygon.value = true;
      } else {
        isLastPolygon.value = false;
      }

    } else {
      emptyData.value = true;
    }

    update();
    // }
  }




  // Future<void> loadFarms(Map<String, dynamic> farm) async {
  //   var farmBoundaryString = farm["farm_boundary"];
  //   var bounds = farmBoundaryString.split(",");
  //
  //   List<LatLng> polygonLatLngs = [];
  //
  //   for (int i = 0; i < bounds.length; i += 2) {
  //     var latitude = bounds[i].split("{")[1].split("latitude:");
  //     var longitude = bounds[i + 1].split("}")[0].split("longitude:");
  //
  //     latitude = latitude[1].split(",");
  //     longitude = longitude[1].split(",");
  //
  //     polygonLatLngs.add(LatLng(double.parse(latitude[0]), double.parse(longitude[0])));
  //
  //   }
  //
  //   polygons.add(
  //     Polygon(
  //       polygonId: PolygonId(farm["farm_reference"].toString()),
  //       points: polygonLatLngs,
  //       strokeColor: Colors.red,
  //       consumeTapEvents: true,
  //       fillColor: color.withOpacity(0.05),
  //       strokeWidth: 2,
  //       onTap: () async {
  //         Polygon polygon = polygons.toList()[polygons.toList().indexWhere(
  //                 (e) => e.polygonId.value == farm["farm_reference"].toString())];
  //         activePolygon = polygon;
  //         mapController!.animateCamera(
  //           CameraUpdate.newLatLngBounds(
  //               boundsFromLatLngList(polygon.points), 140.0),
  //         );
  //
  //         if (polygons.first == activePolygon &&
  //             polygons.last == activePolygon) {
  //           isFirstPolygon.value = true;
  //           isLastPolygon.value = true;
  //         }
  //         if (polygons.first == activePolygon) {
  //           isFirstPolygon.value = true;
  //         } else {
  //           isFirstPolygon.value = false;
  //         }
  //         if (polygons.last == activePolygon) {
  //           isLastPolygon.value = true;
  //         } else {
  //           isLastPolygon.value = false;
  //         }
  //
  //         // List<FarmsFromServer> farms =
  //         // await farmsDao.findFarmsByFarmRef(polygon.polygonId.value);
  //         // if (farms.isNotEmpty) selectedFarm!.value = farms.first;
  //
  //         update();
  //       },
  //     ),
  //   );
  //
  //   update();
  //
  //   if (polygons.isNotEmpty) {
  //     activePolygon = polygons.first;
  //     mapController?.animateCamera(
  //       CameraUpdate.newLatLngBounds(
  //           boundsFromLatLngList(polygons.first.points), 140.0),
  //     );
  //
  //     if (polygons.first == activePolygon && polygons.last == activePolygon) {
  //       isFirstPolygon.value = true;
  //       isLastPolygon.value = true;
  //     }
  //     if (polygons.first == activePolygon) {
  //       isFirstPolygon.value = true;
  //     } else {
  //       isFirstPolygon.value = false;
  //     }
  //     if (polygons.last == activePolygon) {
  //       isLastPolygon.value = true;
  //     } else {
  //       isLastPolygon.value = false;
  //     }
  //
  //     // List<FarmsFromServer> farms =
  //     // await farmsDao.findFarmsByFarmRef(polygons.first.polygonId.value);
  //     // if (farms.isNotEmpty) selectedFarm!.value = farms.first;
  //   } else {
  //     emptyData.value = true;
  //   }
  //
  //   update();
  // }

  goToNextPolygon(bool next) async {
    int currentIndex = polygons.toList().indexOf(activePolygon!);
    Polygon nextPolygon =
        polygons.toList()[next ? currentIndex + 1 : currentIndex - 1];
    activePolygon = nextPolygon;

    if (activePolygon != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(activePolygon!.points), 140.0),
      );

      if (polygons.first == activePolygon && polygons.last == activePolygon) {
        isFirstPolygon.value = true;
        isLastPolygon.value = true;
      }
      if (polygons.first == activePolygon) {
        isFirstPolygon.value = true;
      } else {
        isFirstPolygon.value = false;
      }
      if (polygons.last == activePolygon) {
        isLastPolygon.value = true;
      } else {
        isLastPolygon.value = false;
      }
    }


  }

  // goToSelectedPolygon(FarmsFromServer assignedFarm) async {
  //   Polygon nextPolygon = polygons.firstWhere((element) =>
  //       element.polygonId.value.toString() == assignedFarm.farmReference);
  //   activePolygon = nextPolygon;
  //
  //   if (activePolygon != null) {
  //     mapController!.animateCamera(
  //       CameraUpdate.newLatLngBounds(
  //         boundsFromLatLngList(activePolygon!.points),
  //         140.0,
  //       ),
  //     );
  //
  //     if (polygons.first == activePolygon && polygons.last == activePolygon) {
  //       isFirstPolygon.value = true;
  //       isLastPolygon.value = true;
  //     }
  //     if (polygons.first == activePolygon) {
  //       isFirstPolygon.value = true;
  //     } else {
  //       isFirstPolygon.value = false;
  //     }
  //     if (polygons.last == activePolygon) {
  //       isLastPolygon.value = true;
  //     } else {
  //       isLastPolygon.value = false;
  //     }
  //   }
  // }
  //
  // goToUserLocation() {
  //   UserCurrentLocation? userCurrentLocation =
  //       UserCurrentLocation(context: PickTreesMapScreenContext);
  //   userCurrentLocation.getUserLocation(
  //       forceEnableLocation: true,
  //       onLocationEnabled: (isEnabled, pos) {
  //         if (isEnabled == true) {
  //           mapController?.animateCamera(
  //             CameraUpdate.newCameraPosition(
  //               CameraPosition(
  //                 // bearing: 270.0,
  //                 target: LatLng(pos!.latitude!, pos.longitude!),
  //                 tilt: 30.0,
  //                 // zoom: 18.0,
  //                 zoom: 16.0,
  //               ),
  //             ),
  //           );
  //         }
  //       });
  // }
  //
  // Future<void> navigateToLocation() async {
  //   UserCurrentLocation? userCurrentLocation =
  //       UserCurrentLocation(context: PickTreesMapScreenContext);
  //   userCurrentLocation.getUserLocation(
  //       forceEnableLocation: true,
  //       onLocationEnabled: (isEnabled, pos) async {
  //         if (isEnabled == true) {
  //           LatLng destination = getPolygonCenter(activePolygon!);
  //           final availableMaps = await MapLauncher.installedMaps;
  //           await availableMaps.first.showDirections(
  //             origin: Coords(pos!.latitude!, pos.longitude!),
  //             destinationTitle:
  //                 "${selectedFarm!.value.farmer_name}\n${selectedFarm!.value.farmReference}",
  //             destination: Coords(destination.latitude, destination.longitude),
  //           );
  //         }
  //       });
  // }

  // =================================================================================
  // =================== START CALCULATE BOUNDS FROM POLYGON LATLNG ================
  // =================================================================================
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
// =================================================================================
// =================== END CALCULATE BOUNDS FROM POLYGON LATLNG ================
// =================================================================================

  getPolygonCenter(Polygon poly) {
    List<LatLng> vertices = poly.points;

    // put all latitudes and longitudes in arrays
    List<double> longitudes = vertices.map((e) => e.longitude).toList();
    List<double> latitudes = vertices.map((e) => e.latitude).toList();

    // sort the arrays low to high
    latitudes.sort();
    longitudes.sort();

    // get the min and max of each
    double lowX = latitudes[0];
    double highX = latitudes[latitudes.length - 1];
    double lowy = longitudes[0];
    double highy = longitudes[latitudes.length - 1];

    // center of the polygon is the starting point plus the midpoint
    double centerX = lowX + ((highX - lowX) / 2);
    double centerY = lowy + ((highy - lowy) / 2);

    return LatLng(centerX, centerY);
  }


  // getTreeTypes() async {
  //   TreeTypeFromServerDbHelper treeTypeFromServerDbHelper = TreeTypeFromServerDbHelper();
  //   treeTyp = await treeTypeFromServerDbHelper.getTreeTypes();
  //   for(var a in treeTyp){
  //     treeTypes.add(a.tree_type!);
  //   }
  //   update();
  // }

  // var treeTypes = [].obs;
  // List<TreeTypeFromServerModel> treeTyp = [];

  // List treeData = [];

  var treeType = "".obs;
  TextEditingController treeNameController = TextEditingController();
  TextEditingController treeCircumferenceController = TextEditingController();
  TextEditingController treeHeightController = TextEditingController();
  TextEditingController treeAgeController = TextEditingController();
  TextEditingController treeDiameterAtBreathHeightController =
      TextEditingController();
  TextEditingController generalRemarksController = TextEditingController();

  // validateFields() {
  //   if (treeType.value == "") {
  //     globals.showSnackBar(
  //         title: "Tree type",
  //         message: "Please select tree type",
  //         backgroundColor: Colors.red);
  //     return false;
  //   }
  //
  //   if (treeType.value == "Fruit Tree" || treeType.value == "Shade Tree") {
  //     if (treeCircumferenceController.text == "") {
  //       globals.showSnackBar(
  //           title: "Tree circumference",
  //           message: "Please provide tree circumference",
  //           backgroundColor: Colors.red);
  //       return false;
  //     }
  //
  //     if (treeHeightController.text == "") {
  //       globals.showSnackBar(
  //           title: "Tree height",
  //           message: "Please provide tree height",
  //           backgroundColor: Colors.red);
  //       return false;
  //     }
  //
  //     if (treeAgeController.text == "") {
  //       globals.showSnackBar(
  //           title: "Tree age",
  //           message: "Please provide tree age",
  //           backgroundColor: Colors.red);
  //       return false;
  //     }
  //   }
  //
  //   if (treeNameController.text.isEmpty) {
  //     globals.showSnackBar(
  //         title: "Tree name",
  //         message: "Please select tree name",
  //         backgroundColor: Colors.red);
  //     return false;
  //   }
  //
  //   // if (treeDiameterAtBreathHeightController.text == "") {
  //   //   globals.showSnackBar(title: "Tree diameter at breath height", message: "Please select tree type", backgroundColor: Colors.red);
  //   //   return;
  //   // }
  //
  //   // if (generalRemarksController.text == "") {
  //   //   Get.snackbar("Error", "Please enter general remarks");
  //   //   return;
  //   // }
  //   return true;
  // }

  // TreeDBHelper treeDBHelper = TreeDBHelper.instance;

  var deleteDone = false.obs;
  clearFields() {
    treeType.value = "";
    treeNameController.text = "";
    // treeCircumferenceController.clear();
    // treeHeightController.clear();
    // treeAgeController.clear();
    // treeDiameterAtBreathHeightController.clear();
    // generalRemarksController.clear();
  }

//   saveTreeOffline() {
//     if (treeData.isEmpty) {
//       globals.showSnackBar(
//           title: "Invalid action",
//           message: "No tree captured",
//           backgroundColor: Colors.red);
//       return;
//     }
//
//     // if (treeData.length <= 5) {
//     //   globals.showSnackBar(
//     //       title: "Invalid action",
//     //       message: "Trees must be more than 5",
//     //       backgroundColor: Colors.red);
//     //   return;
//     // }
//
// String name = "${globalController.userInfo.value.firstName} ${globalController.userInfo.value.firstName}";
//
//     treeData.forEach((t) async {
//       TreeModel tree = TreeModel(
//           uid: const Uuid().v4(),
//           latitude: t["latitude"],
//           userID: globalController.userInfo.value.userId,
//           submissionDate: DateTime.now().toString(),
//           longitude: t["longitude"],
//           farmRef: t["farmRef"],
//           tree_type: t["treeType"],
//           tree_name: t["treeName"],
//           tree_circumference: t["treeCircumference"],
//           tree_height: t["treeHeight"],
//           tree_age: t["treeAge"],
//           tree_diameter_at_breath_height: t["treeDiameterAtBreathHeight"],
//           general_remarks: t["generalRemarks"],
//           staffID: globalController.userInfo.value.userId,
//           staffName: name,
//           status: SubmissionStatus.pending);
//
//       Map<String, dynamic> treeMap = tree.toJson();
//
//       // print("THIS IS TREE DATA :::::::::::::::::::::::::: $treeMap");
//
//       treeDBHelper.saveTree(tree);
//     });
//
//     Get.back();
//     globals.showSnackBar(title: "Saved", message: "Trees saved successfully");
//   }
//
//   TreeApi api = TreeApi();
//  RxBool isLoading = false.obs;
//
//
//  TreeApi _treeApi = TreeApi();
//
//   submit()async {
//     if (treeData.isEmpty) {
//       globals.showSnackBar(
//           title: "Invalid action",
//           message: "No tree captured",
//           backgroundColor: Colors.red);
//       return;
//     }
//
//     // if (treeData.length <= 5) {
//     //   globals.showSnackBar(
//     //       title: "Invalid action",
//     //       message: "Trees must be more than 5",
//     //       backgroundColor: Colors.red);
//     //   return;
//     // }
//
//
//     isLoading.value = true;
//     String name =
//         "${globalController.userInfo.value.firstName} ${globalController.userInfo.value.lastName}";
//     var feedback = {};
//
//
//     treeData.forEach((t) async {
//       TreeModel tree = TreeModel(
//           uid: const Uuid().v4(),
//           userID: globalController.userInfo.value.userId,
//           district: globalController.userInfo.value.district,
//           staffID: globalController.userInfo.value.staff_id,
//           staffName: name,
//           submissionDate: DateTime.now().toString(),
//           latitude: t["latitude"],
//           longitude: t["longitude"],
//           farmRef: t["farmRef"],
//           tree_type: t["treeType"],
//           tree_name: t["treeName"],
//           tree_circumference: t["treeCircumference"],
//           tree_height: t["treeHeight"],
//           tree_age: t["treeAge"],
//           tree_diameter_at_breath_height: t["treeDiameterAtBreathHeight"],
//           general_remarks: t["generalRemarks"],
//           status: SubmissionStatus.submitted);
//
//       Map<String, dynamic> data = tree.toJson();
//
//       // print("THIS IS TREE DATA :::::::::::::::::::::::::: $data");
//
//       feedback = await api.saveTree(tree, data);
//
//       if (feedback["title"] == "Success") {
//         isLoading.value = false;
//         Get.back();
//         globals.showSnackBar(
//             title: feedback["title"],
//             message: feedback["msg"],
//             backgroundColor: feedback["color"]);
//       }
//
//       await _treeApi.loadTrees();
//       isLoading.value = false;
//
//      // Get.back();
//       globals.showSnackBar(
//           title: feedback["title"],
//           message: feedback["msg"],
//           backgroundColor: feedback["color"]);
//     });
//   }
}
