import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
import 'package:hcms_revived2/screens/addedMaps/farm_cord_drawing_map.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/components/c2treedetail.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/components/c3treedetail.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/3plantation_planted_details.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/6environmental_conditions.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/components/map_view_with_poly_points.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/components/treefarminformationcomponents/seedlingsmappingModel.dart';
import 'package:hcms_revived2/services/locationservice.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

import '../../../main.dart';

class SeedlingMonitoringSeedlingMapping extends StatefulWidget {
  final List<String>? pickedSeedlingAlive;

  const SeedlingMonitoringSeedlingMapping({Key? key, this.pickedSeedlingAlive})
      : super(key: key);

  @override
  _SeedlingMonitoringSeedlingMappingState createState() =>
      _SeedlingMonitoringSeedlingMappingState();
}

class _SeedlingMonitoringSeedlingMappingState
    extends State<SeedlingMonitoringSeedlingMapping> {
  // GlobalController globalController = Get.find();
  MapFarmController mapFarmController = Get.put(MapFarmController());

  List<String> _establishmentType = [];

  List<SeedlingsMappingModel> items = [];
  List<SeedlingsMappingModel> selectedPoints = [];
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
    await regSP?.setString("ssr_mappedSurvidedSeedlings", encodedKeep!);

    print("Reg 1 shared preference worked");
  }

  // void getValls() {
  //   kk = (regSP?.getString("farmArea") ?? "");
  //   _establishmentType = (regSP?.getStringList("est") ?? "") as List<String>;

  //   print(
  //       "Establishment $_establishmentType and type ${_establishmentType.runtimeType}");
  // }

  String? _holderCategory;
  List<String> _holderCategoryValues = [];

  String _farmBoundaryData = "";
  List<FarmInformationArray> decodedFarmData = [];

  convertedFarmBoundaryData() {
    _farmBoundaryData = regSP?.getString("ssr_mappedFarmBoundaries") ?? "";
    debugPrint("ssr_mappedFarmBoundaries: $_farmBoundaryData");

    // final String encodedData = FarmInformationArray.encode(_farmBoundaryData);
    // encodedKeep = encodedData;
    decodedFarmData = FarmInformationArray.decode(_farmBoundaryData);

    print("Items data ${decodedFarmData.length}");
  }

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _priceController = TextEditingController();
    selectedPoints = [];

    _holderCategoryValues.addAll(widget.pickedSeedlingAlive!);

    convertedFarmBoundaryData();
  }

  converta() {
    final String encodedData = SeedlingsMappingModel.encode(items);
    encodedKeep = encodedData;
    final List<SeedlingsMappingModel> decodedData =
        SeedlingsMappingModel.decode(encodedData);

    setReg1Values();
    print("Items data ${items.length}");
    print("Decoded data $encodedData");
  }

  onSelectedRow(bool selected, SeedlingsMappingModel user) async {
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
          List<SeedlingsMappingModel> temp = [];
          temp.addAll(selectedPoints);
          for (SeedlingsMappingModel points in temp) {
            items.remove(points);
            selectedPoints.remove(points);
          }
        }
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  void _onIdTypeChanged(String _holderValue) {
    setState(() {
      _holderCategory = _holderValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fPrimaryColour,
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
                  "Seedling Monitoring".toUpperCase(),
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
                    } else if (_downChoice == SkipConstants.saveclose) {}
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
          SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * .86,
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
                          "Seedlings Mapping",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          NewLocationService(
                            onSelectLatLng: _selectLatLng,
                          ),
                          const SizedBox(height: 20),
                          items.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      isFullWidth: false,
                                      backgroundColor:
                                          AppColor.xLightBackground,
                                      borderColor: AppColor.black,
                                      borderWidth: 0.5,
                                      verticalPadding: 0.0,
                                      horizontalPadding: 8.0,
                                      onTap: () async {
                                        // mapFarmController
                                        //     .usePolygonDrawingTool();

                                        Navigator.of(context).push(
                                            CupertinoPageRoute(builder:
                                                (BuildContext context) {
                                          return MapPage(
                                            points: items,
                                            decodedFarmData: decodedFarmData,
                                          );
                                        }));
                                      },
                                      child: Text(
                                        'View on Map',
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 14),
                                      ),
                                    ),
                                    GetBuilder(
                                        init: mapFarmController,
                                        builder: (context) {
                                          if (items.isNotEmpty) {
                                            // for (var x in mapFarmController
                                            //     .polygon!.points) {
                                            //   items.add(
                                            //     SeedlingsMappingModel(
                                            //       date: formattedDate,
                                            //       latitude: x.latitude,
                                            //       longitude: x.longitude,
                                            //       accuracy: 0.0,
                                            //       pointID: uuid.v1(),
                                            //       wayPointNumber: uuid.v4(),
                                            //       // itemName: _itemController.text,
                                            //       // itemPrice: double.parse(_priceController.text),
                                            //     ),
                                            //   );
                                            // }
                                          }

                                          return items.isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: appIconBadgeCheck(
                                                      color: AppColor.primary,
                                                      size: 35),
                                                )
                                              : Container();
                                        }),
                                  ],
                                )
                              : const SizedBox(),
                          // Text("Lats ${mapFarmController.polygon?.points} of length ${mapFarmController.polygon?.points.length}"),

                          // Text(
                          //   'Farm Area in Hectares  ${mapFarmController.farmAreaTC?.text}',
                          //   style: TextStyle(fontWeight: FontWeight.w500),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor: fPrimaryColour,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  // shadowColor: fPrimaryColour,
                                  side: const BorderSide(
                                      width: 1.0, color: fPrimaryColour),
                                ),
                                child: const Text("Pick Seedling Cordinates",
                                    style: TextStyle(color: fPrimaryWhite)),
                                onPressed: () async {
                                  _showDialog(context);

                                  print("object2");
                                  // if (_pickedLocation != null) {
                                  //   items.add(
                                  //     SeedlingsMappingModel(
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
                                  print("Items $items");
                                  setState(() {
                                    _itemController?.clear();
                                    _priceController?.clear();
                                  });
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor: fPrimaryColour,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  // shadowColor: fPrimaryColour,
                                  side: const BorderSide(
                                      width: 1.0, color: fPrimaryColour),
                                ),
                                child: const Text("Delete Cordinates",
                                    style: TextStyle(color: fPrimaryWhite)),
                                onPressed: () async {
                                  if (selectedPoints.isEmpty) {
                                    overlayNotification(
                                        'No points selected!', "negative");
                                  } else {
                                    deleteSelected();
                                    print("Items ${items.length}");
                                    print("Items $items");
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: size.height * .45,
                            child: SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  sortColumnIndex: 1,
                                  sortAscending: sort,
                                  showCheckboxColumn: true,
                                  columnSpacing: 30.0,
                                  showBottomBorder: true,
                                  columns: [
                                    const DataColumn(
                                      label: Text('Seedling'),
                                    ),
                                    const DataColumn(
                                      label: Text('Latitude'),
                                    ),
                                    const DataColumn(
                                      label: Text('Longitude'),
                                    ),
                                    const DataColumn(
                                      label: Text('Altitude'),
                                    ),
                                    const DataColumn(
                                      label: Text('Accuracy'),
                                    ),
                                  ],
                                  rows: mapItemToDataRows(items).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: fDefaultPadding),
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
                                // getValls();
                                // if (items.length < 4) {
                                //   overlayNotification(
                                //       'Picked cordinates must be at least 4',
                                //       "negative");
                                // } else {
                                regSP?.setBool("ssr5.1_skipped", false);
                                converta();
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          SeedlingMonitoringEnvironmentalConditions()),
                                );
                                // }
                              },
                            ),
                          ),
                        ),
                        // Text("$_holderCategory"),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: fDefaultPadding),
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
                                // getValls();
                                regSP?.setBool("ssr5.1_skipped", true);
                                converta();
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          SeedlingMonitoringEnvironmentalConditions()),
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

  Iterable<DataRow> mapItemToDataRows(List<SeedlingsMappingModel> items) {
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
                item.seedlingName.toString(),
              ),
              onTap: () {
                print('Selected ${item.seedlingName.toString()}');
              },
            ),
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
            DataCell(
              Text(item.altitude.toString()),
            ),
            DataCell(
              Text('${item.accuracy?.toStringAsFixed(2)}m'),
            ),
          ]);
    });
    return dataRows;
  }

  Future _showDialog(context) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          String? showPicked;
          return AlertDialog(
            title: const Text("Select seedling"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.50, color: Colors.transparent),
                        ),
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.09,
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                hint: const Text("Tap to select"),
                                value: _holderCategory,
                                items: _holderCategoryValues
                                    .map((String holderValue) {
                                  // fD = dvalue;
                                  return new DropdownMenuItem(
                                    value: holderValue,
                                    child: new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: new Text(
                                            "$holderValue",
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  // Timer(Duration(seconds: 2), () {
                                  setState(() {
                                    showPicked = _holderCategory;
                                  });
                                  // });
                                  _onIdTypeChanged(value!);
                                },
                                onTap: () {
                                  setState(() {});
                                },
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              );
            }),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: fPrimaryColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  textStyle: const TextStyle(color: Colors.white),
                  // shadowColor: fPrimaryColour,
                  side: const BorderSide(width: 1.0, color: fPrimaryColour),
                ),
                child: const Text(
                  "Pick coordinates",
                  style: TextStyle(
                      color: fPrimaryWhite,
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () async {
                  // if (_pickedLocation != null) {
                  items.add(
                    SeedlingsMappingModel(
                      seedlingName: _holderCategory,
                      date: formattedDate,
                      latitude: _pickedLocation?.latitude,
                      longitude: _pickedLocation?.longitude,
                      altitude: _pickedLocation?.altitude,
                      accuracy: _pickedLocation?.accuracy,
                      pointID: uuid.v1(),
                      wayPointNumber: uuid.v4(),
                      // itemName: _itemController.text,
                      // itemPrice: double.parse(_priceController.text),
                    ),
                  );
                  print("Items ${items.length}");
                  // converta();
                  // items.insert(items.length, items.first);
                  // } else {
                  //   overlayNotification(
                  //       'GPS Accuracy must be 5m or below!', "negative");
                  // }

                  Navigator.pop(context);

                  setState(() {});
                },
              ),
              // new FlatButton(
              //     onPressed: () => debugPrint("Save button"), child: Text('Save')),
              // new FlatButton(
              //     onPressed: () => Navigator.pop(context), child: Text('Cancel'))
            ],
          );
        });
    // showDialog(
    //     context: context,
    //     builder: (_) {
    //       return alert;
    //     });
  }
}
