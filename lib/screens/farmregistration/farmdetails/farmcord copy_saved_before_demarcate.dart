// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:get/get.dart';
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/models/datamodels.dart';
// import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
// import 'package:hcms_revived2/screens/addedMaps/tree_registration_map.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/services/locationservice.dart';

// import '../../../main.dart';
// import 'components/c2treedetail.dart';
// import 'components/c3treedetail.dart';
// import 'treeinformation.dart';

// class FarmCord extends StatefulWidget {
//   @override
//   _FarmCordState createState() => _FarmCordState();
// }

// class _FarmCordState extends State<FarmCord> {
//   // GlobalController globalController = Get.find();
//   MapFarmController mapFarmController = Get.put(MapFarmController());

//   List<String> _establishmentType = [];

//   List<FarmInformationArray> items = [];
//   List<FarmInformationArray> selectedPoints = [];
//   bool sort = false;
//   var id = new DateTime.now().millisecond;

//   String? encodedKeep;

//   final _formKey = GlobalKey<FormState>();
//   TextEditingController? _itemController;
//   TextEditingController? _priceController;

//   PlaceLocation? _pickedLocation;

//   String? kk;

  // void _selectLatLng(double lat, double lng, double alt, double acc) {
  //   _pickedLocation = PlaceLocation(
  //     latitude: lat,
  //     longitude: lng,
  //     altitude: alt,
  //     accuracy: acc,
  //   );
  // }

//   void setReg1Values() async {
//     await regSP?.setString("pointsString", encodedKeep!);

//     print("Reg 1 shared preference worked");
//   }

//   void getValls() {
//     kk = (regSP?.getString("farmArea") ?? "");
//     _establishmentType = (regSP?.getStringList("est") ?? "") as List<String>;

//     print(
//         "Establishment $_establishmentType and type ${_establishmentType.runtimeType}");
//   }

//   @override
//   void initState() {
//     super.initState();
//     _itemController = TextEditingController();
//     _priceController = TextEditingController();
//     selectedPoints = [];
//   }

//   converta() {
//     final String encodedData = FarmInformationArray.encode(items);
//     encodedKeep = encodedData;
//     final List<FarmInformationArray> decodedData =
//         FarmInformationArray.decode(encodedData);

//     setReg1Values();
//     print("Items data ${items.length}");
//     print("Decoded data $encodedData");
//   }

//   onSelectedRow(bool selected, FarmInformationArray user) async {
//     setState(() {
//       if (selected) {
//         selectedPoints.add(user);
//       } else {
//         selectedPoints.remove(user);
//       }
//     });
//   }

//   deleteSelected() async {
//     print("Delte working now");
//     submissionOptions(
//         context, "Are you sure you want to delete?", "Yes", "", "No",
//         approvePress: () {
//       setState(() {
//         if (selectedPoints.isNotEmpty) {
//           List<FarmInformationArray> temp = [];
//           temp.addAll(selectedPoints);
//           for (FarmInformationArray points in temp) {
//             items.remove(points);
//             selectedPoints.remove(points);
//           }
//         }
//       });
//     }, editPress: () {}, disapprovePress: () {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: fPrimaryWhite,
//         automaticallyImplyLeading: false,
//         backgroundColor: fPrimaryColour,
//         title: Text(
//           "Tree Farm Information",
//           style: TextStyle(color: fPrimaryWhite),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             offset: Offset(2.00, 3.00),
//             color: Colors.black,
//             onSelected: (String _downChoice) {
//               if (_downChoice == SkipConstants.home) {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => IndexPage(),
//                   ),
//                 );
//               } else if (_downChoice == SkipConstants.saveskip) {
//                 getValls();
//                 regSP?.setBool("farmcordskipped", true);
//                 converta();
//                 Navigator.of(context).push(
//                   CupertinoPageRoute(
//                       builder: (BuildContext context) => _establishmentType
//                               .contains("Woodlot")
//                           ? C2TreeInformation(
//                               pageTitle: _establishmentType.toString())
//                           : _establishmentType.contains("Commercial_Plantation")
//                               ? C2TreeInformation(
//                                   pageTitle: _establishmentType.toString())
//                               : _establishmentType.contains("Other")
//                                   ? C2TreeInformation(
//                                       pageTitle: _establishmentType.toString())
//                                   : C3TreeInformation(
//                                       pageTitle: _establishmentType.toString(),
//                                     )),
//                 );
//               } else if (_downChoice == SkipConstants.saveclose) {
//                 // regSP.setBool("closed", true);
//                 // Navigator.of(context).push(
//                 //   CupertinoPageRoute(
//                 //     builder: (BuildContext context) => FarmDetails(),
//                 //   ),
//                 // );
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return SkipConstants.downChoices.map((String _downChoice) {
//                 return PopupMenuItem<String>(
//                   value: _downChoice,
//                   child: Container(
//                     margin: EdgeInsets.only(right: 0),
//                     child: Text(
//                       _downChoice,
//                       style: TextStyle(color: Color(0xFFFFFFFF)),
//                     ),
//                   ),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         // height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: fDefaultPadding),
//               child: Center(
//                 child: Text(
//                   "Farm Information",
//                   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Column(
//                       children: [
//                         NewLocationService(
//                           onSelectLatLng: _selectLatLng,
//                         ),
//                         const SizedBox(height: 20),
//                         Row(mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomButton(
//                               isFullWidth: false,
//                               backgroundColor: AppColor.xLightBackground,
//                               borderColor: AppColor.black,
//                               borderWidth: 0.5,
//                               verticalPadding: 0.0,
//                               horizontalPadding: 8.0,
//                               onTap: () async {
//                                 mapFarmController.usePolygonDrawingTool();
//                               },
//                               child: Text(
//                                 'Demarcate farm boundary',
//                                 style: TextStyle(
//                                     color: AppColor.black, fontSize: 14),
//                               ),
//                             ),
//                             GetBuilder(
//                                 init: mapFarmController,
//                                 builder: (context) {
//                                   if (mapFarmController.markers != null &&
//                                       mapFarmController
//                                               .polygon?.points.length !=
//                                           items.length) {
//                                     for (var x
//                                         in mapFarmController.polygon!.points) {
//                                       items.add(
//                                         FarmInformationArray(
//                                           date: formattedDate,
//                                           latitude: x.latitude,
//                                           longitude: x.longitude,
//                                           accuracy: 0.0,
//                                           pointID: uuid.v1(),
//                                           wayPointNumber: uuid.v4(),
//                                           // itemName: _itemController.text,
//                                           // itemPrice: double.parse(_priceController.text),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                   ;
//                                   return mapFarmController.markers != null
//                                       ? Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 15.0),
//                                           child: appIconBadgeCheck(
//                                               color: AppColor.primary,
//                                               size: 35),
//                                         )
//                                       : Container();
//                                 }),
//                           ],
//                         ),
//                         // Text("Lats ${mapFarmController.polygon?.points} of length ${mapFarmController.polygon?.points.length}"),

//                         Text(
//                           'Farm Area in Hectares  ${mapFarmController.farmAreaTC?.text}',
//                           style: TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 elevation: 0.0,
//                                 backgroundColor: fPrimaryColour,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                 ),
//                                 textStyle: const TextStyle(color: Colors.white),
//                                 // shadowColor: fPrimaryColour,
//                                 side: const BorderSide(
//                                     width: 1.0, color: fPrimaryColour),
//                               ),
//                               child: Text("Pick Cordinates",
//                                   style: TextStyle(color: fPrimaryWhite)),
//                               onPressed: () async {
//                                 print("object2");
//                                 if (_pickedLocation != null) {
//                                   items.add(
//                                     FarmInformationArray(
//                                       date: formattedDate,
//                                       latitude: _pickedLocation?.latitude,
//                                       longitude: _pickedLocation?.longitude,
//                                       accuracy: _pickedLocation?.accuracy,
//                                       pointID: uuid.v1(),
//                                       wayPointNumber: uuid.v4(),
//                                       // itemName: _itemController.text,
//                                       // itemPrice: double.parse(_priceController.text),
//                                     ),
//                                   );
//                                   print("Items ${items.length}");
//                                   // converta();
//                                   // items.insert(items.length, items.first);
//                                 } else {
//                                   overlayNotification(
//                                       'GPS Accuracy must be 5m or below!',
//                                       "negative");
//                                 }
//                                 print("Items $items");
//                                 setState(() {
//                                   _itemController?.clear();
//                                   _priceController?.clear();
//                                 });
//                               },
//                             ),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 elevation: 0.0,
//                                 backgroundColor: fPrimaryColour,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                 ),
//                                 textStyle: const TextStyle(color: Colors.white),
//                                 // shadowColor: fPrimaryColour,
//                                 side: const BorderSide(
//                                     width: 1.0, color: fPrimaryColour),
//                               ),
//                               child: Text("Delete Cordinates",
//                                   style: TextStyle(color: fPrimaryWhite)),
//                               onPressed: () async {
//                                 if (selectedPoints.isEmpty) {
//                                   overlayNotification(
//                                       'No points selected!', "negative");
//                                 } else {
//                                   deleteSelected();
//                                   print("Items ${items.length}");
//                                   print("Items $items");
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     SingleChildScrollView(
//                       // scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         sortColumnIndex: 1,
//                         sortAscending: sort,
//                         showCheckboxColumn: true,
//                         columnSpacing: 30.0,
//                         columns: [
//                           DataColumn(
//                             label: Text('Latitude'),
//                           ),
//                           DataColumn(
//                             label: Text('Longitude'),
//                           ),
//                           DataColumn(
//                             label: Text('Accuracy'),
//                           ),
//                         ],
//                         rows: mapItemToDataRows(items).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: fDefaultPadding),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 3,
//                     height: 50.00,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         elevation: 0.0,
//                         backgroundColor: fPrimaryColour,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         textStyle: const TextStyle(color: Colors.white),
//                         // shadowColor: fPrimaryColour,
//                         side:
//                             const BorderSide(width: 1.0, color: fPrimaryColour),
//                       ),
//                       child: Text(
//                         "Next",
//                         style: TextStyle(
//                             color: fPrimaryWhite,
//                             fontSize: 17.0,
//                             fontWeight: FontWeight.normal),
//                       ),
//                       onPressed: () async {
//                         getValls();
//                         if (items.length < 4) {
//                           overlayNotification(
//                               'Picked cordinates must be at least 4',
//                               "negative");
//                         } else {
//                           regSP?.setBool("farmcordskipped", false);
//                           converta();
//                           Navigator.of(context).push(
//                             CupertinoPageRoute(
//                                 builder: (BuildContext context) =>
//                                     _establishmentType.contains("Woodlot")
//                                         ? C2TreeInformation(
//                                             pageTitle:
//                                                 _establishmentType.toString())
//                                         : _establishmentType.contains(
//                                                 "Commercial_Plantation")
//                                             ? C2TreeInformation(
//                                                 pageTitle: _establishmentType
//                                                     .toString())
//                                             : _establishmentType
//                                                     .contains("Other")
//                                                 ? C2TreeInformation(
//                                                     pageTitle:
//                                                         _establishmentType
//                                                             .toString())
//                                                 : C3TreeInformation(
//                                                     pageTitle:
//                                                         _establishmentType
//                                                             .toString(),
//                                                   )),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: fDefaultPadding),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 3,
//                     height: 50.00,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         elevation: 0.0,
//                         backgroundColor: fPrimaryColour,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         textStyle: const TextStyle(color: Colors.white),
//                         // shadowColor: fPrimaryColour,
//                         side:
//                             const BorderSide(width: 1.0, color: fPrimaryColour),
//                       ),
//                       child: Text(
//                         "Skip",
//                         style: TextStyle(
//                             color: fPrimaryWhite,
//                             fontSize: 17.0,
//                             fontWeight: FontWeight.normal),
//                       ),
//                       onPressed: () async {
//                         getValls();
//                         regSP?.setBool("farmcordskipped", true);
//                         converta();
//                         Navigator.of(context).push(
//                           CupertinoPageRoute(
//                               builder: (BuildContext context) =>
//                                   _establishmentType.contains("Woodlot")
//                                       ? C2TreeInformation(
//                                           pageTitle:
//                                               _establishmentType.toString())
//                                       : _establishmentType
//                                               .contains("Commercial_Plantation")
//                                           ? C2TreeInformation(
//                                               pageTitle:
//                                                   _establishmentType.toString())
//                                           : _establishmentType.contains("Other")
//                                               ? C2TreeInformation(
//                                                   pageTitle: _establishmentType
//                                                       .toString())
//                                               : C3TreeInformation(
//                                                   pageTitle: _establishmentType
//                                                       .toString(),
//                                                 )),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _priceController?.dispose();
//     _itemController?.dispose();
//   }

//   Iterable<DataRow> mapItemToDataRows(List<FarmInformationArray> items) {
//     Iterable<DataRow> dataRows = items.map((item) {
//       return DataRow(
//           selected: selectedPoints.contains(item),
//           onSelectChanged: (t) {
//             print("Onselect");
//             onSelectedRow(t!, item);
//           },
//           cells: [
//             DataCell(
//               Text(
//                 item.latitude.toString(),
//               ),
//               onTap: () {
//                 print('Selected ${item.latitude.toString()}');
//               },
//             ),
//             DataCell(
//               Text(item.longitude.toString()),
//             ),
//             DataCell(
//               Text('${item.accuracy?.toStringAsFixed(2)}m'),
//             ),
//           ]);
//     });
//     return dataRows;
//   }
// }
