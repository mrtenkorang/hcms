import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
import 'package:hcms_revived2/screens/addedMaps/farm_cord_drawing_map.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/locationservice.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

import '../../../main.dart';
import 'components/c2treedetail.dart';
import 'components/c3treedetail.dart';
import 'treeinformation.dart';

class FarmCord extends StatefulWidget {
  @override
  _FarmCordState createState() => _FarmCordState();
}

class _FarmCordState extends State<FarmCord> {
  // GlobalController globalController = Get.find();
  MapFarmController mapFarmController = Get.put(MapFarmController());

  Globals globals = Globals();

  List<String> _establishmentType = [];

  List<FarmInformationArray> items = [];
  List<FarmInformationArray> selectedPoints = [];
  bool sort = false;
  var id = new DateTime.now().millisecond;

  String? encodedKeep;

  final _formKey = GlobalKey<FormState>();
  TextEditingController? _itemController;
  TextEditingController? _priceController;

  PlaceLocation? _pickedLocation;

  String? kk;

  void _selectLatLng(double lat, double lng, double alt, double acc) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      altitude: alt,
      accuracy: acc,
    );
  }

  void setReg1Values() async {
    await regSP?.setString("pointsString", encodedKeep!);

    print("Reg 1 shared preference worked");
  }

  void getValls() {
    kk = (regSP?.getString("farmArea") ?? "");
    _establishmentType = (regSP?.getStringList("est") ?? "") as List<String>;

    print(
        "Establishment $_establishmentType and type ${_establishmentType.runtimeType}");
  }

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _priceController = TextEditingController();
    selectedPoints = [];
  }

  converta() {
    final String encodedData = FarmInformationArray.encode(items);
    encodedKeep = encodedData;
    final List<FarmInformationArray> decodedData =
        FarmInformationArray.decode(encodedData);

    setReg1Values();
    print("Items data ${items.length}");
    print("Decoded data $encodedData");
  }

  onSelectedRow(bool selected, FarmInformationArray user) async {
    setState(() {
      if (selected) {
        selectedPoints.add(user);
      } else {
        selectedPoints.remove(user);
      }
    });
  }

  deleteSelected() async {
    print("Delte working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (selectedPoints.isNotEmpty) {
          List<FarmInformationArray> temp = [];
          temp.addAll(selectedPoints);
          for (FarmInformationArray points in temp) {
            items.remove(points);
            selectedPoints.remove(points);
          }
        }
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  @override
  Widget build(BuildContext context) {
    mapFarmController.mapFarmScreenContext = context;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColour,
      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: Text(
      //     "Tree Farm Information",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == SkipConstants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == SkipConstants.saveskip) {
      //           getValls();
      //           regSP?.setBool("farmcordskipped", true);
      //           converta();
      //           Navigator.of(context).push(
      //             CupertinoPageRoute(
      //                 builder: (BuildContext context) => _establishmentType
      //                         .contains("Woodlot")
      //                     ? C2TreeInformation(
      //                         pageTitle: _establishmentType.toString())
      //                     : _establishmentType.contains("Commercial_Plantation")
      //                         ? C2TreeInformation(
      //                             pageTitle: _establishmentType.toString())
      //                         : _establishmentType.contains("Other")
      //                             ? C2TreeInformation(
      //                                 pageTitle: _establishmentType.toString())
      //                             : C3TreeInformation(
      //                                 pageTitle: _establishmentType.toString(),
      //                               )),
      //           );
      //         } else if (_downChoice == SkipConstants.saveclose) {
      //           // regSP.setBool("closed", true);
      //           // Navigator.of(context).push(
      //           //   CupertinoPageRoute(
      //           //     builder: (BuildContext context) => FarmDetails(),
      //           //   ),
      //           // );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return SkipConstants.downChoices.map((String _downChoice) {
      //           return PopupMenuItem<String>(
      //             value: _downChoice,
      //             child: Container(
      //               margin: EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: TextStyle(color: Color(0xFFFFFFFF)),
      //               ),
      //             ),
      //           );
      //         }).toList();
      //       },
      //     ),
      //   ],
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  elevation: 0.0,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: primaryColour,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: primaryWhite,
                        size: 40.0,
                      )),
                ),
                Text(
                  "Tree Farm Coordinates".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                PopupMenuButton<String>(
                  offset: const Offset(2.00, 3.00),
                  color: Colors.black,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: primaryWhite,
                    size: 40.0,
                  ),
                  onSelected: (String _downChoice) {
                    if (_downChoice == SkipConstants.home) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      );
                    } else if (_downChoice == SkipConstants.saveskip) {
                      getValls();
                      regSP?.setBool("farmcordskipped", true);
                      converta();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                _establishmentType.contains("Woodlot")
                                    ? C2TreeInformation(
                                        pageTitle:
                                            _establishmentType.toString())
                                    : _establishmentType
                                            .contains("Commercial_Plantation")
                                        ? C2TreeInformation(
                                            pageTitle:
                                                _establishmentType.toString())
                                        : _establishmentType.contains("Other")
                                            ? C2TreeInformation(
                                                pageTitle: _establishmentType
                                                    .toString())
                                            : C3TreeInformation(
                                                pageTitle: _establishmentType
                                                    .toString(),
                                              )),
                      );
                    } else if (_downChoice == SkipConstants.saveclose) {
                      // regSP.setBool("closed", true);
                      // Navigator.of(context).push(
                      //   CupertinoPageRoute(
                      //     builder: (BuildContext context) => FarmDetails(),
                      //   ),
                      // );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return SkipConstants.downChoices.map((String _downChoice) {
                      return PopupMenuItem<String>(
                        value: _downChoice,
                        child: Container(
                          margin: const EdgeInsets.only(right: 0),
                          child: Text(
                            _downChoice,
                            style: const TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .85,
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: fDefaultPadding),
                    child: Center(
                      child: Text(
                        "Map Farm Boundary",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              NewLocationService(
                                onSelectLatLng: _selectLatLng,
                              ),
                              const SizedBox(height: 20),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     CustomButton(
                              //       isFullWidth: false,
                              //       backgroundColor: AppColor.xLightBackground,
                              //       borderColor: AppColor.black,
                              //       borderWidth: 0.5,
                              //       verticalPadding: 0.0,
                              //       horizontalPadding: 8.0,
                              //       onTap: () async {
                              //         mapFarmController.usePolygonDrawingTool();
                              //       },
                              //       child: Text(
                              //         'Demarcate farm boundary',
                              //         style: TextStyle(
                              //             color: AppColor.black, fontSize: 14),
                              //       ),
                              //     ),
                              //     GetBuilder(
                              //         init: mapFarmController,
                              //         builder: (context) {
                              //           if (mapFarmController.markers != null &&
                              //               mapFarmController
                              //                       .polygon?.points.length !=
                              //                   items.length) {
                              //             for (var x
                              //                 in mapFarmController.polygon!.points) {
                              //               items.add(
                              //                 FarmInformationArray(
                              //                   date: formattedDate,
                              //                   latitude: x.latitude,
                              //                   longitude: x.longitude,
                              //                   accuracy: 0.0,
                              //                   pointID: uuid.v1(),
                              //                   wayPointNumber: uuid.v4(),
                              //                   // itemName: _itemController.text,
                              //                   // itemPrice: double.parse(_priceController.text),
                              //                 ),
                              //               );
                              //             }
                              //           }
                              //           ;
                              //           return mapFarmController.markers != null
                              //               ? Padding(
                              //                   padding:
                              //                       const EdgeInsets.only(left: 15.0),
                              //                   child: appIconBadgeCheck(
                              //                       color: AppColor.primary,
                              //                       size: 35),
                              //                 )
                              //               : Container();
                              //         }),
                              //   ],
                              // ),
                              // Text("Lats ${mapFarmController.polygon?.points} of length ${mapFarmController.polygon?.points.length}"),

                              GetBuilder(
                                  init: mapFarmController,
                                  builder: (context) {
                                    return mapFarmController.markers == null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      fPrimaryColour,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      color: Colors.white),
                                                  // shadowColor: fPrimaryColour,
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: fPrimaryColour),
                                                ),
                                                child: const Text(
                                                    "Pick farm boundary",
                                                    style: TextStyle(
                                                        color: fPrimaryWhite)),
                                                onPressed: () async {
                                                  // update();
                                                  // print("object2");
                                                  // if (_pickedLocation != null) {
                                                  //   items.add(
                                                  //     FarmInformationArray(
                                                  //       date: formattedDate,
                                                  //       latitude: _pickedLocation?.latitude,
                                                  //       longitude: _pickedLocation?.longitude,
                                                  //       accuracy: _pickedLocation?.accuracy,
                                                  //       pointID: uuid.v1(),
                                                  //       wayPointNumber: uuid.v4(),
                                                  //       // itemName: _itemController.text,
                                                  //       // itemPrice: double.parse(_priceController.text),
                                                  //     ),
                                                  //   );
                                                  //   print("Items ${items.length}");
                                                  //   // converta();
                                                  //   // items.insert(items.length, items.first);
                                                  // } else {
                                                  //   overlayNotification(
                                                  //       'GPS Accuracy must be 5m or below!',
                                                  //       "negative");
                                                  // }
                                                  // print("Items $items");
                                                  // setState(() {
                                                  //   _itemController?.clear();
                                                  //   _priceController?.clear();
                                                  // });

                                                  items.clear();

                                                  setState(() {});

                                                  mapFarmController
                                                      .usePolygonDrawingTool();

                                                  // setState(() {
                                                  //   if (mapFarmController.markers !=
                                                  //       null) {
                                                  //     // if (mapFarmController
                                                  //     //         .polygon?.points.length !=
                                                  //     //     items.length) {

                                                  //     for (var x in mapFarmController
                                                  //         .polygon!.points) {
                                                  //       items.add(
                                                  //         FarmInformationArray(
                                                  //           date: formattedDate,
                                                  //           latitude: x.latitude,
                                                  //           longitude: x.longitude,
                                                  //           accuracy: 0.0,
                                                  //           pointID: uuid.v1(),
                                                  //           wayPointNumber: uuid.v4(),
                                                  //           // itemName: _itemController.text,
                                                  //           // itemPrice: double.parse(_priceController.text),
                                                  //         ),
                                                  //       );
                                                  //       // }
                                                  //     }
                                                  //   }
                                                  // });
                                                },
                                              ),
                                              // ElevatedButton(
                                              //   style: ElevatedButton.styleFrom(
                                              //     elevation: 0.0,
                                              //     backgroundColor: fPrimaryColour,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(15.0),
                                              //     ),
                                              //     textStyle: const TextStyle(
                                              //         color: Colors.white),
                                              //     // shadowColor: fPrimaryColour,
                                              //     side: const BorderSide(
                                              //         width: 1.0,
                                              //         color: fPrimaryColour),
                                              //   ),
                                              //   child: Text("Delete Cordinates",
                                              //       style: TextStyle(
                                              //           color: fPrimaryWhite)),
                                              //   onPressed: () async {
                                              //     setState(() {});
                                              //     if (selectedPoints.isEmpty) {
                                              //       overlayNotification(
                                              //           'No points selected!',
                                              //           "negative");
                                              //     } else {
                                              //       deleteSelected();
                                              //       print("Items ${items.length}");
                                              //       print("Items $items");
                                              //     }
                                              //   },
                                              // ),
                                            ],
                                          )
                                        : const SizedBox();
                                  }),

                              const SizedBox(
                                height: 10,
                              ),
                              // GetBuilder(
                              //     init: mapFarmController,
                              //     builder: (context) {
                              //       return mapFarmController.markers != null
                              //           ? Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 Text(
                              //                   'Farm Boundaries Successfully mapped',
                              //                   style: TextStyle(
                              //                       fontWeight: FontWeight.w500),
                              //                 ),
                              //                 Padding(
                              //                   padding:
                              //                       const EdgeInsets.only(left: 10.0),
                              //                   child: appIconBadgeCheck(
                              //                       color: AppColor.primary,
                              //                       size: 35),
                              //                 ),
                              //               ],
                              //             )
                              //           : Container();
                              //     }),

                              const SizedBox(
                                height: 10,
                              ),

                              // Text(
                              //   'Farm Area in Hectares  ${mapFarmController.farmAreaTC?.text}',
                              //   style: TextStyle(fontWeight: FontWeight.w500),
                              // ),

                              mapFarmController.markers != null
                                  ? Material(
                                      elevation: 0,
                                      color: Colors.white,
                                      // insetPadding: const EdgeInsets.all(20.0),
                                      // contentPadding: EdgeInsets.zero,
                                      clipBehavior: Clip.none,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppBorderRadius.sm))),
                                      child: Container(
                                        width: double.maxFinite,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 30,
                                            horizontal: AppPadding.horizontal),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Image.asset(
                                            //     "lib/libassets/images/ruler-combined.png",
                                            //     height: 70),
                                            appIconBadgeCheck(
                                                color: AppColor.primary,
                                                size: 90),
                                            const SizedBox(height: 15),
                                            Text("Success",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.black)),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'mapped area estimates in hectares',
                                                      style: TextStyle(
                                                          color:
                                                              AppColor.black),
                                                      textAlign:
                                                          TextAlign.center),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                      '${mapFarmController.farmAreaTC != null && mapFarmController.farmAreaTC!.text.isNotEmpty ? double.parse(mapFarmController.farmAreaTC?.text ?? "0.0").truncateToDecimalPlaces(6).toString() : "0.0"} ha',
                                                      style: TextStyle(
                                                          color: AppColor.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.center),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            CustomButton(
                                              isFullWidth: true,
                                              backgroundColor: Colors.redAccent,
                                              verticalPadding: 0.0,
                                              horizontalPadding: 8.0,
                                              onTap: () {
                                                globals.primaryConfirmDialog(
                                                    context: context,
                                                    title: "New Boundary",
                                                    content: const Text(
                                                        "Please take note that proceeding means you are going to map the whole farm area again."),
                                                    okayTap: () {
                                                      Navigator.pop(context);
                                                      items.clear();

                                                      setState(() {});

                                                      mapFarmController
                                                          .usePolygonDrawingTool();
                                                    });
                                              },
                                              child: const Text(
                                                'Map new boundary',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //   children: [
                              //     ElevatedButton(
                              //       style: ElevatedButton.styleFrom(
                              //         elevation: 0.0,
                              //         backgroundColor: fPrimaryColour,
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(15.0),
                              //         ),
                              //         textStyle: const TextStyle(color: Colors.white),
                              //         // shadowColor: fPrimaryColour,
                              //         side: const BorderSide(
                              //             width: 1.0, color: fPrimaryColour),
                              //       ),
                              //       child: Text("Pick farm boundary",
                              //           style: TextStyle(color: fPrimaryWhite)),
                              //       onPressed: () async {
                              //         // update();
                              //         // print("object2");
                              //         // if (_pickedLocation != null) {
                              //         //   items.add(
                              //         //     FarmInformationArray(
                              //         //       date: formattedDate,
                              //         //       latitude: _pickedLocation?.latitude,
                              //         //       longitude: _pickedLocation?.longitude,
                              //         //       accuracy: _pickedLocation?.accuracy,
                              //         //       pointID: uuid.v1(),
                              //         //       wayPointNumber: uuid.v4(),
                              //         //       // itemName: _itemController.text,
                              //         //       // itemPrice: double.parse(_priceController.text),
                              //         //     ),
                              //         //   );
                              //         //   print("Items ${items.length}");
                              //         //   // converta();
                              //         //   // items.insert(items.length, items.first);
                              //         // } else {
                              //         //   overlayNotification(
                              //         //       'GPS Accuracy must be 5m or below!',
                              //         //       "negative");
                              //         // }
                              //         // print("Items $items");
                              //         // setState(() {
                              //         //   _itemController?.clear();
                              //         //   _priceController?.clear();
                              //         // });

                              //         mapFarmController.usePolygonDrawingTool();

                              //         setState(() {
                              //           if (mapFarmController.markers != null) {
                              //             // if (mapFarmController
                              //             //         .polygon?.points.length !=
                              //             //     items.length) {

                              //             items.clear();

                              //             for (var x
                              //                 in mapFarmController.polygon!.points) {
                              //               items.add(
                              //                 FarmInformationArray(
                              //                   date: formattedDate,
                              //                   latitude: x.latitude,
                              //                   longitude: x.longitude,
                              //                   accuracy: 0.0,
                              //                   pointID: uuid.v1(),
                              //                   wayPointNumber: uuid.v4(),
                              //                   // itemName: _itemController.text,
                              //                   // itemPrice: double.parse(_priceController.text),
                              //                 ),
                              //               );
                              //               // }
                              //             }
                              //           }
                              //         });
                              //       },
                              //     ),
                              //     ElevatedButton(
                              //       style: ElevatedButton.styleFrom(
                              //         elevation: 0.0,
                              //         backgroundColor: fPrimaryColour,
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(15.0),
                              //         ),
                              //         textStyle: const TextStyle(color: Colors.white),
                              //         // shadowColor: fPrimaryColour,
                              //         side: const BorderSide(
                              //             width: 1.0, color: fPrimaryColour),
                              //       ),
                              //       child: Text("Delete Cordinates",
                              //           style: TextStyle(color: fPrimaryWhite)),
                              //       onPressed: () async {
                              //         setState(() {});
                              //         if (selectedPoints.isEmpty) {
                              //           overlayNotification(
                              //               'No points selected!', "negative");
                              //         } else {
                              //           deleteSelected();
                              //           print("Items ${items.length}");
                              //           print("Items $items");
                              //         }
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // SingleChildScrollView(
                          //   // scrollDirection: Axis.horizontal,
                          //   child: DataTable(
                          //     sortColumnIndex: 1,
                          //     sortAscending: sort,
                          //     showCheckboxColumn: true,
                          //     columnSpacing: 30.0,
                          //     columns: [
                          //       DataColumn(
                          //         label: Text('Latitude'),
                          //       ),
                          //       DataColumn(
                          //         label: Text('Longitude'),
                          //       ),
                          //       // DataColumn(
                          //       //   label: Text('Accuracy'),
                          //       // ),
                          //     ],
                          //     rows: mapItemToDataRows(items).toList(),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: fDefaultPadding),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50.00,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: fPrimaryColour,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              // shadowColor: fPrimaryColour,
                              side: const BorderSide(
                                  width: 1.0, color: fPrimaryColour),
                            ),
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                  color: fPrimaryWhite,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () async {
                              getValls();
                              if (items.length < 4) {
                                overlayNotification(
                                    'Picked cordinates must be at least 4',
                                    "negative");
                              } else {
                                regSP?.setBool("farmcordskipped", false);
                                converta();
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          _establishmentType.contains("Woodlot")
                                              ? C2TreeInformation(
                                                  pageTitle: _establishmentType
                                                      .toString())
                                              : _establishmentType.contains(
                                                      "Commercial_Plantation")
                                                  ? C2TreeInformation(
                                                      pageTitle:
                                                          _establishmentType
                                                              .toString())
                                                  : _establishmentType
                                                          .contains("Other")
                                                      ? C2TreeInformation(
                                                          pageTitle:
                                                              _establishmentType
                                                                  .toString())
                                                      : C3TreeInformation(
                                                          pageTitle:
                                                              _establishmentType
                                                                  .toString(),
                                                        )),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: fDefaultPadding),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50.00,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: fPrimaryColour,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              // shadowColor: fPrimaryColour,
                              side: const BorderSide(
                                  width: 1.0, color: fPrimaryColour),
                            ),
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                  color: fPrimaryWhite,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () async {
                              getValls();
                              regSP?.setBool("farmcordskipped", true);
                              converta();
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        _establishmentType.contains("Woodlot")
                                            ? C2TreeInformation(
                                                pageTitle: _establishmentType
                                                    .toString())
                                            : _establishmentType.contains(
                                                    "Commercial_Plantation")
                                                ? C2TreeInformation(
                                                    pageTitle:
                                                        _establishmentType
                                                            .toString())
                                                : _establishmentType
                                                        .contains("Other")
                                                    ? C2TreeInformation(
                                                        pageTitle:
                                                            _establishmentType
                                                                .toString())
                                                    : C3TreeInformation(
                                                        pageTitle:
                                                            _establishmentType
                                                                .toString(),
                                                      )),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _priceController?.dispose();
    _itemController?.dispose();
  }

  Iterable<DataRow> mapItemToDataRows(List<FarmInformationArray> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      return DataRow(
          selected: selectedPoints.contains(item),
          onSelectChanged: (t) {
            print("Onselect");
            onSelectedRow(t!, item);
          },
          cells: [
            DataCell(
              Text(
                item.latitude.toString(),
              ),
              onTap: () {
                print('Selected ${item.latitude.toString()}');
              },
            ),
            DataCell(
              Text(item.longitude.toString()),
            ),
            // DataCell(
            //   Text('${item.accuracy?.toStringAsFixed(2)}m'),
            // ),
          ]);
    });
    return dataRows;
  }
}
