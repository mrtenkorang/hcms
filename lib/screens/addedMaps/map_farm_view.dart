// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/user_current_location.dart';
// import 'package:map_launcher/map_launcher.dart';

// class AssignedOutbreaksMapController extends GetxController {
//   BuildContext? assignedOutbreaksMapScreenContext;

//   GoogleMapController? mapController;

//   Globals globals = Globals();

//   // GlobalController globalController = Get.find();

//   CameraPosition initialCameraPosition = const CameraPosition(
//     target: LatLng(7.9527706, -1.0307118),
//     zoom: 8.0,
//     tilt: 30,
//     // bearing: 270.0,
//   );

//   late String mapStyle;

//   Set<Marker> markers = HashSet<Marker>();
//   Set<Polygon> polygons = HashSet<Polygon>();
//   Set<Polygon> polygonss = HashSet<Polygon>();

//   BitmapDescriptor? mapMarker;

//   Polygon? activePolygon;
//   var isLastPolygon = false.obs;
//   var isFirstPolygon = false.obs;
//   var emptyData = false.obs;

//   // Rx<AssignedOutbreak>? selectedOutbreak = AssignedOutbreak().obs;

//   @override
//   void onInit() {
//     super.onInit();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       // await createMarker();
//       // loadFarms();
//     });
//   }

//   // ============================================================
//   // START CREATE MAP MARKER
//   // ============================================================
//   // createMarker() async {
//   //   if (mapMarker == null) {
//   //     ImageConfiguration configuration = createLocalImageConfiguration(tmtMapScreenContext!);
//   //     BitmapDescriptor.fromAssetImage(configuration, 'assets/images/track_my_tree/tmt_marker.png')
//   //         .then((icon) {
//   //       mapMarker = icon;
//   //     });
//   //   }
//   // }
// // ============================================================
// // END CREATE MAP MARKER
// // ============================================================

//   // =================================================================================
//   // =================== START CALCULATE BOUNDS FROM POLYGON LATLNG ================
//   // =================================================================================
//   LatLngBounds boundsFromLatLngList(List<LatLng> list) {
//     assert(list.isNotEmpty);
//     double? x0, x1, y0, y1;
//     for (LatLng latLng in list) {
//       if (x0 == null) {
//         x0 = x1 = latLng.latitude;
//         y0 = y1 = latLng.longitude;
//       } else {
//         if (latLng.latitude > x1!) x1 = latLng.latitude;
//         if (latLng.latitude < x0) x0 = latLng.latitude;
//         if (latLng.longitude > y1!) y1 = latLng.longitude;
//         if (latLng.longitude < y0!) y0 = latLng.longitude;
//       }
//     }
//     return LatLngBounds(
//         northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
//   }
// // =================================================================================
// // =================== END CALCULATE BOUNDS FROM POLYGON LATLNG ================
// // =================================================================================

//   getPolygonCenter(Polygon poly) {
//     List<LatLng> vertices = poly.points;

//     // put all latitudes and longitudes in arrays
//     List<double> longitudes = vertices.map((e) => e.longitude).toList();
//     List<double> latitudes = vertices.map((e) => e.latitude).toList();

//     // sort the arrays low to high
//     latitudes.sort();
//     longitudes.sort();

//     // get the min and max of each
//     double lowX = latitudes[0];
//     double highX = latitudes[latitudes.length - 1];
//     double lowy = longitudes[0];
//     double highy = longitudes[latitudes.length - 1];

//     // center of the polygon is the starting point plus the midpoint
//     double centerX = lowX + ((highX - lowX) / 2);
//     double centerY = lowy + ((highy - lowy) / 2);

//     return LatLng(centerX, centerY);
//   }

//   loadAssignedOutbreaks() async {
//     // final assignedOutbreakDao = globalController.database!.assignedOutbreakDao;
//     // List<AssignedOutbreak> listOfAssignedOutbreak = await assignedOutbreakDao.findAllAssignedOutbreaks();

//     List<FarmInformationArray> listOfAssignedOutbreak = [];
//     int limit = 50;
//     int offset = 0;
//     bool hasMoreRecords = true;

//     while (hasMoreRecords) {
//       List<FarmInformationArray> records = await assignedOutbreakDao
//           .findAssignedOutbreakWithLimit(limit, offset);
//       if (records.isNotEmpty) {
//         listOfAssignedOutbreak.addAll(records);
//         offset += records.length;
//       } else {
//         hasMoreRecords = false;
//       }
//     }

//     for (var element in listOfAssignedOutbreak) {
//       var farmBoundaryString =
//           const Utf8Decoder().convert(element.obBoundary ?? []);
//       var farmBoundary = jsonDecode(farmBoundaryString);
//       var polyList = farmBoundary['coordinates'][0][0];
//       // print(farmBoundary);
//       List<LatLng> polygonLatLngs = [];
//       for (var element in polyList) {
//         polygonLatLngs.add(LatLng(element[1], element[0]));
//       }

//       Color polygonStrokeColour = Colors.red;
//       Color polygonFillColour = AppColor.primary.withOpacity(0.2);

//       polygons.add(Polygon(
//           polygonId: PolygonId(element.obCode.toString()),
//           points: polygonLatLngs,
//           strokeColor: polygonStrokeColour,
//           consumeTapEvents: true,
//           fillColor: polygonFillColour,
//           strokeWidth: 2,
//           onTap: () async {
//             Polygon polygon = polygonss.toList()[polygonss.toList().indexWhere(
//                 (e) => e.polygonId.value == element.obCode.toString())];
//             activePolygon = polygon.copyWith(fillColorParam: Colors.indigo);

//             // activePolygon.fillColor= Colors.indigo;
//             // polygonFillColour = Colors.indigo;

//             LatLng centerForMarker = getPolygonCenter(activePolygon!);

//             markers.clear();

//             markers.add(Marker(
//                 markerId: MarkerId(element.obCode.toString()),
//                 position: centerForMarker));

//             mapController!.animateCamera(
//               CameraUpdate.newLatLngBounds(
//                   boundsFromLatLngList(polygon.points), 140.0),
//             );

//             if (polygons.first == activePolygon &&
//                 polygons.last == activePolygon) {
//               isFirstPolygon.value = true;
//               isLastPolygon.value = true;
//             }
//             if (polygons.first == activePolygon) {
//               isFirstPolygon.value = true;
//             } else {
//               isFirstPolygon.value = false;
//             }
//             if (polygons.last == activePolygon) {
//               isLastPolygon.value = true;
//             } else {
//               isLastPolygon.value = false;
//             }

//             List<AssignedOutbreak> outbreaks = await assignedOutbreakDao
//                 .findAssignedOutbreakByCode(polygon.polygonId.value);
//             if (outbreaks.isNotEmpty) selectedOutbreak!.value = outbreaks.first;

//             // activePolygon!.copyWith(
//             //   fillColorParam: Colors.green,
//             //   strokeColorParam: Colors.indigo,
//             //   strokeWidthParam: 10,
//             // );

//             // globals.showToast("Clicked here");

//             update();
//           }));

//       polygonss.add(Polygon(
//           polygonId: PolygonId(element.obCode.toString()),
//           points: polygonLatLngs,
//           strokeColor: Colors.black,
//           consumeTapEvents: true,
//           fillColor: Colors.indigo,
//           strokeWidth: 2,
//           onTap: () async {
//             // globals.showToast("Clicked here");

//             update();
//           }));
//     }
//     update();

//     if (polygons.isNotEmpty) {
//       activePolygon = polygons.first;
//       mapController!.animateCamera(
//         CameraUpdate.newLatLngBounds(
//             boundsFromLatLngList(polygons.first.points), 140.0),
//       );

//       if (polygons.first == activePolygon && polygons.last == activePolygon) {
//         isFirstPolygon.value = true;
//         isLastPolygon.value = true;
//       }
//       if (polygons.first == activePolygon) {
//         isFirstPolygon.value = true;
//       } else {
//         isFirstPolygon.value = false;
//       }
//       if (polygons.last == activePolygon) {
//         isLastPolygon.value = true;
//       } else {
//         isLastPolygon.value = false;
//       }

//       //   List<AssignedOutbreak> outbreaks = await assignedOutbreakDao
//       //       .findAssignedOutbreakByCode(polygons.first.polygonId.value);
//       //   if (outbreaks.isNotEmpty) selectedOutbreak!.value = outbreaks.first;
//       // } else {
//       //   emptyData.value = true;
//       // }

//       update();
//     }

//     // goToNextPolygon(bool next) async {
//     //   int currentIndex =
//     //       activePolygon != null ? polygons.toList().indexOf(activePolygon!) : 0;

//     //   Polygon nextPolygon =
//     //       polygons.toList()[next ? currentIndex + 1 : currentIndex - 1];
//     //   activePolygon = nextPolygon;

//     //   // TrueKing added
//     //   LatLng centerForMarker = getPolygonCenter(activePolygon!);

//     //   markers.clear();

//     //   markers.add(Marker(
//     //     markerId: MarkerId(activePolygon!.polygonId.value),
//     //     position: centerForMarker,
//     //   ));

//     //   if (activePolygon != null) {
//     //     mapController!.animateCamera(
//     //       CameraUpdate.newLatLngBounds(
//     //           boundsFromLatLngList(activePolygon!.points), 140.0),
//     //     );

//     //     if (polygons.first == activePolygon && polygons.last == activePolygon) {
//     //       isFirstPolygon.value = true;
//     //       isLastPolygon.value = true;
//     //     }
//     //     if (polygons.first == activePolygon) {
//     //       isFirstPolygon.value = true;
//     //     } else {
//     //       isFirstPolygon.value = false;
//     //     }
//     //     if (polygons.last == activePolygon) {
//     //       isLastPolygon.value = true;
//     //     } else {
//     //       isLastPolygon.value = false;
//     //     }
//     //   }

//     //   final assignedFarmDao = globalController.database!.assignedOutbreakDao;
//     //   List<AssignedOutbreak> outbreaks = await assignedFarmDao
//     //       .findAssignedOutbreakByCode(activePolygon!.polygonId.value);

//     //   if (outbreaks.isNotEmpty) selectedOutbreak!.value = outbreaks.first;
//     // }

//     // goToSelectedPolygon(AssignedOutbreak assignedOutbreak) async {
//     //   // int currentIndex = polygons.toList().indexOf(activePolygon!);
//     //   // Polygon nextPolygon = polygons.toList()[next ? currentIndex + 1 : currentIndex - 1];
//     //   Polygon nextPolygon = polygons.toList().firstWhere((element) =>
//     //       element.polygonId.value.toString() == assignedOutbreak.obCode);

//     //   activePolygon = nextPolygon.copyWith(fillColorParam: Colors.indigo);

//     //   // TrueKing added
//     //   LatLng centerForMarker = getPolygonCenter(activePolygon!);

//     //   markers.clear();

//     //   markers.add(Marker(
//     //     markerId: MarkerId(activePolygon!.polygonId.value),
//     //     position: centerForMarker,
//     //   ));

//     //   if (activePolygon != null) {
//     //     mapController!.animateCamera(
//     //       CameraUpdate.newLatLngBounds(
//     //           boundsFromLatLngList(activePolygon!.points), 140.0),
//     //     );

//     //     if (polygons.first == activePolygon && polygons.last == activePolygon) {
//     //       isFirstPolygon.value = true;
//     //       isLastPolygon.value = true;
//     //     }
//     //     if (polygons.first == activePolygon) {
//     //       isFirstPolygon.value = true;
//     //     } else {
//     //       isFirstPolygon.value = false;
//     //     }
//     //     if (polygons.last == activePolygon) {
//     //       isLastPolygon.value = true;
//     //     } else {
//     //       isLastPolygon.value = false;
//     //     }
//     //   }
//     // }

//     // goToUserLocation() {
//     //   UserCurrentLocation? userCurrentLocation =
//     //       UserCurrentLocation(context: assignedOutbreaksMapScreenContext);
//     //   userCurrentLocation.getUserLocation(
//     //       forceEnableLocation: true,
//     //       onLocationEnabled: (isEnabled, pos) {
//     //         if (isEnabled == true) {
//     //           mapController?.animateCamera(
//     //             CameraUpdate.newCameraPosition(
//     //               CameraPosition(
//     //                 // bearing: 270.0,
//     //                 target: LatLng(pos!.latitude!, pos.longitude!),
//     //                 tilt: 30.0,
//     //                 // zoom: 18.0,
//     //                 zoom: 16.0,
//     //               ),
//     //             ),
//     //           );
//     //         }
//     //       });
//     // }

//     // Future<void> navigateToLocation() async {
//     //   UserCurrentLocation? userCurrentLocation =
//     //       UserCurrentLocation(context: assignedOutbreaksMapScreenContext);
//     //   userCurrentLocation.getUserLocation(
//     //       forceEnableLocation: true,
//     //       onLocationEnabled: (isEnabled, pos) async {
//     //         if (isEnabled == true) {
//     //           LatLng destination = getPolygonCenter(activePolygon!);
//     //           final availableMaps = await MapLauncher.installedMaps;
//     //           await availableMaps.first.showDirections(
//     //             origin: Coords(pos!.latitude!, pos.longitude!),
//     //             destinationTitle: "Assigned Outbreak Location",
//     //             destination: Coords(destination.latitude, destination.longitude),
//     //           );

//     //           //   final url = 'https://www.google.com/maps/dir/${pos!.latitude},+${pos.longitude}/${destination.latitude},+${destination.longitude}';
//     //           //   if (await canLaunchUrl(Uri.parse(url))) {
//     //           // await launchUrl(Uri.parse(url));
//     //           // } else {
//     //           // throw 'Could not launch $url';
//     //           // }
//     //         }
//     //       });
//     // }
//   }
// }
