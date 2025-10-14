import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/services/locationservice.dart';

class PlotFarmInfo extends StatefulWidget {
  const PlotFarmInfo({Key? key}) : super(key: key);

  @override
  _PlotFarmInfoState createState() => _PlotFarmInfoState();
}

class _PlotFarmInfoState extends State<PlotFarmInfo> {
  // farm cordinates
  String? farmCord;
  List<FarmInformationArray> pp = [];
  List<FarmInformationArray> item = [];
  List<FarmInformationArray> selectedPoints = [];
  bool sort = false;
  var id = new DateTime.now().millisecond;

  String? encodedKeep;

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

  converta(cc) {
    final String encodedData = FarmInformationArray.encode(cc);
    encodedKeep = encodedData;
    // final List<FarmInformationArray> item =
    //     FarmInformationArray.decode(encodedData);

    print("Items data ${cc.length}");
    print("Decoded data $encodedData");
  }

  onSelectedCordRow(bool selected, FarmInformationArray user) async {
    setState(() {
      if (selected) {
        selectedPoints.add(user);
      } else {
        selectedPoints.remove(user);
      }
    });
  }

  deleteSelected(cc) async {
    print("Delte working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (selectedPoints.isNotEmpty) {
          List<FarmInformationArray> temp = [];
          temp.addAll(selectedPoints);
          for (FarmInformationArray points in temp) {
            cc.remove(points);
            selectedPoints.remove(points);
          }
        }

        final String encodedData = FarmInformationArray.encode(item);
        regSP?.setString("itemR", encodedData);
        debugPrint("Points deleted is ${item.length}");
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  @override
  void initState() {
    super.initState();
    //farmcord
    farmCord = regSP?.getString("farm");
    farmCord!.isNotEmpty
        ? pp = FarmInformationArray.decode(farmCord!)
        : pp = [];
    item = pp;

    // farm cordinates
    _itemController = TextEditingController();
    _priceController = TextEditingController();
    selectedPoints = [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Material(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Plot/ Farm Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: fDefaultPadding),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Farm Cordinate",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fPrimaryColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          textStyle: const TextStyle(color: fPrimaryWhite),
                          // shadowColor: fPrimaryColour,
                        ),
                        child: Text("Pick Cordinates", style: TextStyle(
          color: fPrimaryWhite),),
                        onPressed: () async {
                          print("object2");
                          if (_pickedLocation != null) {
                            item.add(
                              FarmInformationArray(
                                date: formattedDate,
                                latitude: _pickedLocation?.latitude,
                                longitude: _pickedLocation?.longitude,
                                accuracy: _pickedLocation?.accuracy,
                                pointID: uuid.v1(),
                                wayPointNumber: uuid.v4(),
                                // itemName: _itemController.text,
                                // itemPrice: double.parse(_priceController.text),
                              ),
                            );
                            print("Items ${item.length}");
                            // converta();
                            // items.insert(items.length, items.first);

                            final String encodedData =
                                FarmInformationArray.encode(item);
                            regSP?.setString("itemR", encodedData);
                          } else {
                            overlayNotification(
                                'GPS Accuracy must be 5m or below!',
                                "negative");
                          }
                          print("Items $item");
                          setState(() {
                            // _itemController
                            //     .clear();
                            _priceController?.clear();
                          });
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fPrimaryColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          textStyle: const TextStyle(color: fPrimaryWhite),
                          // shadowColor: fPrimaryColour,
                        ),
                        child: Text("Delete Cordinates", style: TextStyle(
          color: fPrimaryWhite),),
                        onPressed: () async {
                          if (selectedPoints.isEmpty) {
                            overlayNotification(
                                'No points selected!', "negative");
                          } else {
                            deleteSelected(item);

                            // final String encodedData =
                            //     FarmInformationArray.encode(item);
                            // regSP?.setString("itemR", encodedData);
                            // debugPrint(
                            //     "Points deleted is ${item.length} and ${selectedPoints.length}");
                          }
                        },
                      ),
                    ],
                  ),
                  NewLocationService(
                    onSelectLatLng: _selectLatLng,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Column(
                          //   children: [
                          //     // SizedBox(
                          //     //   height: 10,
                          //     // ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            // scrollDirection: Axis.horizontal,
                            child: DataTable(
                              sortColumnIndex: 1,
                              sortAscending: sort,
                              showCheckboxColumn: true,
                              columnSpacing: 30.0,
                              columns: [
                                DataColumn(
                                  label: Text('Latitude'),
                                ),
                                DataColumn(
                                  label: Text('Longitude'),
                                ),
                                DataColumn(
                                  label: Text('Accuracy'),
                                ),
                              ],
                              rows: mapItemToDataRows(item).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _priceController?.dispose();
    _itemController?.dispose();
  }

  Iterable<DataRow> mapItemToDataRows(List<FarmInformationArray> item) {
    Iterable<DataRow> dataRows = item.map((item) {
      return DataRow(
          selected: item == null ? false : selectedPoints.contains(item),
          onSelectChanged: (t) {
            print("Onselect");
            onSelectedCordRow(t!, item);
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
            DataCell(
              item.accuracy == null
                  ? Text('NA')
                  : Text('${item.accuracy?.toStringAsFixed(2)}m'),
            ),
          ]);
    });
    return dataRows;
  }
}
