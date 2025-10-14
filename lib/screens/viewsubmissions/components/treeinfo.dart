import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/treespecies.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/treeinformationoption0arraydetails.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/treeinformationoption2arraydetails.dart';
import 'package:hcms_revived2/services/locationservice.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TreeInfo extends StatefulWidget {
  final String? typeofEstablishment;
  final String? kk;

  const TreeInfo({Key? key, this.typeofEstablishment, this.kk})
      : super(key: key);

  @override
  _TreeInfoState createState() => _TreeInfoState();
}

class _TreeInfoState extends State<TreeInfo> {
  final _c2formKey = GlobalKey<FormState>();
  final _c3formKey = GlobalKey<FormState>();

  Directory? dir;

  final _itemController = TextEditingController();
  final _priceController = TextEditingController();

  PlaceLocation? _pickedLocation;
  // c2 Tree Information
  File? jsonFile;
  // Directory dir;
  String fileName = "treespecies.json";
  bool fileExists = false;
  var fileContent;
  bool confileContent = false;
  List<TreeSpeciesJson> _newtreeSpeciesValues = [];
  List<TreeSpeciesJson> _treeSpeciesValues = [];

  List<TreeInformationOption0Array> c2array = [];
  List<TreeInformationOption0Array> c2items = [];
  List<TreeInformationOption0Array> c2selectedPoints = [];
  String? _c2encodedKeep;

  final _numTrees = TextEditingController();
  final _plantingDistance = TextEditingController();
  // final _yoEstablishment = TextEditingController();

  String? _yoEstablishment;
  bool isyoEstablishmentDate = false;
  String? yoEstablishmentInString;
  DateTime? _selectedDateYear;
  bool c2sort = false;

  String? _c2disV;
  // Future myDFuture;

  // String kk;

  File? _pickedImage;
  String? _speciesbase64Image;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLatLng(double lat, double lng, double alt, double acc) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      altitude: alt,
      accuracy: acc,
    );
  }

  void getspeciesbase64Img() async {
    _speciesbase64Image = (regSP?.getString('speciesbase64Image') ?? "");
  }

  void createFile(var content, Directory dir, String fileName) {
    print("Creating file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<TreeSpeciesJson>> c2getLocalDistricts(
      BuildContext context) async {
    print("this place working");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/treespecies.json');
    final body = json.decode(data);

    _newtreeSpeciesValues =
        body.map<TreeSpeciesJson>(TreeSpeciesJson.fromJson).toList();

    return _newtreeSpeciesValues;
  }

  var treespeciesUrl = "$stageBaseUrl/treespeciesapi/";

  Future<List<TreeSpeciesJson>> writeToFile(BuildContext ctx) async {
    print("Writing to file!");
    if (fileExists) {
      print("File exists");

      try {
        var response = await http.get(Uri.parse(treespeciesUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("responselr");

          print("content $items");
          print("object");

          // var content = {key: items};

          var jsonFileContent = json.decode(jsonFile!.readAsStringSync());
          jsonFileContent.clear();
          jsonFileContent.addAll(items);
          jsonFile?.writeAsString(json.encode(jsonFileContent));
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is ");
      }
    } else {
      print("File does not exist!");
      try {
        var response = await http.get(Uri.parse(treespeciesUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("responselr");

          print("content $items");
          print("object");
          createFile(items, dir!, fileName);
        } else {
          print("didn't work here");
          c2getLocalDistricts(ctx);
        }
      } on SocketException {
        print("Error is ");
        c2getLocalDistricts(ctx);
      }
    }
    fileExists
        ? fileContent = await json.decode(await jsonFile!.readAsString())
        : null;
    print(fileContent);

    return fileExists
        ? _treeSpeciesValues =
            fileContent.map<TreeSpeciesJson>(TreeSpeciesJson.fromJson).toList()
        : _newtreeSpeciesValues;
  }

   specFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonFile = File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        fileContent = await json.decode(await jsonFile!.readAsString());
    });

    return fileContent;
  }

  void _onc2mmdasChanged(String mmdasVal) {
    setState(() {
      _c2disV = mmdasVal;
    });
  }

  c2convertu() {
    final String c2encodedData = TreeInformationOption0Array.encode(c2items);
    _c2encodedKeep = c2encodedData;
    final List<TreeInformationOption0Array> c2decodedData =
        TreeInformationOption0Array.decode(c2encodedData);

    // setTDValues();
    print("Items Plantation data $c2items");
    print("Decoded Plantation data $c2decodedData");
  }

  c2onSelectedRow(bool c2selected, TreeInformationOption0Array c2user) async {
    setState(() {
      if (c2selected) {
        c2selectedPoints.add(c2user);
      } else {
        c2selectedPoints.remove(c2user);
      }
    });
  }

  c2deleteSelected() async {
    print("Delete working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (c2selectedPoints.isNotEmpty) {
          List<TreeInformationOption0Array> temp = [];
          temp.addAll(c2selectedPoints);
          for (TreeInformationOption0Array points in temp) {
            c2items.remove(points);
            c2selectedPoints.remove(points);
          }

          final String encodedData =
              TreeInformationOption0Array.encode(c2items);
          regSP?.setString("c2itemsR", encodedData);
        }
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  _c2onDone() {
    c2convertu();
  }

  Future<List<TreeSpeciesJson>>? c2mySFuture;

  // c3 Tree Information
  List<TreeSpeciesJson> _c3newtreeSpeciesValues = [];
  List<TreeSpeciesJson> _c3treeSpeciesValues = [];

  List<TreeInformationOption2Array> c3array = [];
  List<TreeInformationOption2Array> c3items = [];
  List<TreeInformationOption2Array> c3selectedPoints = [];
  String? _c3encodedKeep;

  final _pn = TextEditingController();
  final _species = TextEditingController();
  final _sizeofTree = TextEditingController();
  // final _yearPlanted = TextEditingController();
  String? _yearPlanted;
  bool isyearPlantedDate = false;
  String? yearPlantedInString;
  DateTime? _selectedYearPlantedDateYear;

  // final _yearNurturingStarted = TextEditingController();
  String? _yearNurturingStarted;
  bool isyearNurturingStartedDate = false;
  String? yearNurturingStartedInString;
  DateTime? _selectedYearNurturingStartedDateYear;
  List<TreeLocation> treeLocation = [];

  bool c3sort = false;

  String? _c3disV;
  Future<List<TreeSpeciesJson>>? c3mySFuture;

  PlaceLocation? _c3pickedLocation;

  void _c3selectLatLng(double lat, double lng, double acc) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      accuracy: acc,
    );
  }

  c3convertu() {
    final String c3encodedData = TreeInformationOption2Array.encode(c3items);
    _c3encodedKeep = c3encodedData;
    // final List<TreeInformationOption2Array> c3item =
    //     TreeInformationOption2Array.decode(encodedData);

    final treeInfo2Option = c3encodedData.isNotEmpty
        ? json.decode(c3encodedData).cast<Map<String, dynamic>>()
        : Map();

    print("Items Plantation data $c3items");
    print("Decoded Plantation data $treeInfo2Option");
  }

  c3onSelectedRow(bool selected, TreeInformationOption2Array c3user) async {
    setState(() {
      if (selected) {
        c3selectedPoints.add(c3user);
      } else {
        c3selectedPoints.remove(c3user);
      }
    });
  }

  c3deleteSelected() async {
    print("Delete working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (c3selectedPoints.isNotEmpty) {
          List<TreeInformationOption2Array> temp = [];
          temp.addAll(c3selectedPoints);
          for (TreeInformationOption2Array points in temp) {
            c3items.remove(points);
            c3selectedPoints.remove(points);
          }

          final String encodedData =
              TreeInformationOption2Array.encode(c3items);
          regSP?.setString("c3itemsR", encodedData);
        }
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  void _onc3mmdasChanged(String mmdasVal) {
    setState(() {
      _c3disV = mmdasVal;
    });
  }

  _c3onDone() {
    c3convertu();
  }

  String? p_nValue;
  List<String> p_nValues = [];

  @override
  void initState() {
    super.initState();
    //c2
    String? ff = regSP!.getString("c2");
    ff!.isNotEmpty
        ? c2array = TreeInformationOption0Array.decode(ff)
        : c2array = [];
    c2items = c2array;

    //c3
    String? kk = regSP!.getString("c3");
    kk!.isNotEmpty
        ? c3array = TreeInformationOption2Array.decode(kk)
        : c3array = [];
    c3items = c3array;

    specFileInit();

    c2mySFuture = writeToFile(this.context);
    c3mySFuture = writeToFile(this.context);

    c2selectedPoints = [];
    c3selectedPoints = [];

    p_nValues.addAll([
      "Planted",
      "Natural",
    ]);
  }

  void _onPNChanged(String? iTValue) {
    setState(() {
      p_nValue = iTValue;
    });
  }

  var _lat, _lng, _acc;

  bool showEdit = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: widget.typeofEstablishment!.contains("Woodlot") ||
                    widget.typeofEstablishment!
                        .contains("Commercial_Plantation") ||
                    widget.typeofEstablishment!.contains("Other")
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Tree Information on Planted Species",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                              softWrap: true,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: Container(
                                width: size.width - 50,
                                child: Text(
                                  "c2 " + widget.typeofEstablishment!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(0xFFfc1d20),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          showEdit == true
                              ? Form(
                                  key: _c2formKey,
                                  child: Container(
                                    // width: 170.0,
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: 14.0,
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  "Select Species"),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.50,
                                                                color: Color(
                                                                    0xFF000000)),
                                                          ),
                                                          // width: MediaQuery.of(context)
                                                          //         .size
                                                          //         .width /
                                                          //     1.2,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      6.0),
                                                          child: FutureBuilder<
                                                              List<
                                                                  TreeSpeciesJson>>(
                                                            future: mounted
                                                                ? c2mySFuture
                                                                : null,
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        List<
                                                                            TreeSpeciesJson>>
                                                                    snapshot) {
                                                              if (!snapshot
                                                                  .hasData)
                                                                return CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      fPrimaryColour),
                                                                );
                                                              else if (snapshot
                                                                  .hasData)
                                                                return fileExists
                                                                    ? Container(
                                                                        // width: MediaQuery.of(context).size.width / 1.09,
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: _c2disV,
                                                                              items: _treeSpeciesValues.map((TreeSpeciesJson dvalue) {
                                                                                // fD = dvalue;
                                                                                return DropdownMenuItem<String>(
                                                                                  value: dvalue.species,
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(10.0),
                                                                                        child: Text(
                                                                                          "${dvalue.species}",
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (String? value) {
                                                                                _c2disV = value;
                                                                                _onc2mmdasChanged(value!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                      )
                                                                    : Container(
                                                                        // width: MediaQuery.of(context).size.width / 1.09,
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: _c2disV,
                                                                              items: _newtreeSpeciesValues.map((TreeSpeciesJson dvalue) {
                                                                                // fD = dvalue;
                                                                                return DropdownMenuItem<String>(
                                                                                  value: dvalue.species,
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(10.0),
                                                                                        child: Text(
                                                                                          "${dvalue.species}",
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (String? value) {
                                                                                _c2disV = value;
                                                                                _onc2mmdasChanged(value!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                      );
                                                              else
                                                                return Text(
                                                                  "Please sync data",
                                                                );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //species photo

                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      "Take picture of species",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SpeciesImage(_selectedImage),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            children: [
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //         top: 14.0,
                                              //       ),
                                              //       child: Row(
                                              //         children: <Widget>[
                                              //           Text(
                                              //               "No. of Tress (Stocking)"),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              formFieldLabel(width: size.width * .9, "No. of trees (Stocking)"),
                                              TextFieldWidget(
                                                // maxLines: 5,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: '',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        0.5)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0))),
                                                controller: _numTrees,
                                                validator: (input) =>
                                                    input!.trim().isEmpty
                                                        ? 'Please enter a value'
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            children: [
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //         top: 14.0,
                                              //       ),
                                              //       child: Row(
                                              //         children: <Widget>[
                                              //           Text(
                                              //               "Planting Distance (Spacing)"),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              formFieldLabel(width: size.width * .9, "Planting Distance (Spacing)"),
                                              TextFieldWidget(
                                                // maxLines: 5,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: '',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        0.5)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0))),
                                                controller: _plantingDistance,
                                                validator: (input) =>
                                                    input!.trim().isEmpty
                                                        ? 'Please enter a value'
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      "Year of Establishment",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child:
                                                      isyoEstablishmentDate ==
                                                              true
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    fPrimaryColour,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              height: 40.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.0,
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            22,
                                                                        color: Color(
                                                                            0xFFffe423),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          yoEstablishmentInString ??
                                                                              "Year",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFf9f9f9),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Row(
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .arrow_drop_down_circle,
                                                                  size: 18,
                                                                  color:
                                                                      fPrimaryColour,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  // size: 34,
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                              ],
                                                            ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Select Year"),
                                                          content: Container(
                                                            // Need to use container to add size constraint.
                                                            width: 300,
                                                            height: 300,
                                                            // color: fPrimaryColour,
                                                            child: YearPicker(
                                                              firstDate:
                                                                  DateTime(
                                                                      1800),
                                                              lastDate: DateTime
                                                                  .now(),
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              // save the selected date to _selectedDate DateTime variable.
                                                              // It's used to set the previous selected date when
                                                              // re-showing the dialog.
                                                              selectedDate:
                                                                  _selectedDateYear ??
                                                                      DateTime
                                                                          .now(),
                                                              onChanged:
                                                                  (DateTime
                                                                      date) {
                                                                // close the dialog when year is selected.
                                                                Navigator.pop(
                                                                    context);

                                                                // Do something with the dateTime selected.
                                                                // Remember that you need to use dateTime.year to get the year
                                                                print(
                                                                    'confirm $date');
                                                                isyoEstablishmentDate =
                                                                    true;
                                                                yoEstablishmentInString =
                                                                    '${date.year}';

                                                                setState(() {
                                                                  _selectedDateYear =
                                                                      date;
                                                                  _yoEstablishment =
                                                                      '${date.year}';
                                                                  print(
                                                                      "Year of Establishment ${date.year}-${date.month}-${date.day}");
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    ;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 14.0,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("Remarks"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TextField(
                                                // maxLines: 5,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    labelText: '',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        0.5)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0))),
                                                // controller: _descriptionController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                          // child: Divider(),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "List of Inputs".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showEdit = !showEdit;
                                    });
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFFfc1d20)))
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              sortColumnIndex: 1,
                              sortAscending: c2sort,
                              showCheckboxColumn: true,
                              columnSpacing: 30.0,
                              columns: [
                                DataColumn(
                                  label: Text('Species'),
                                ),
                                DataColumn(
                                  label: Text('Picture of species'),
                                ),
                                DataColumn(
                                  label: Text('No. of Trees'),
                                ),
                                DataColumn(
                                  label: Text('Year of Est.'),
                                ),
                                DataColumn(
                                  label: Text('Planting Dist.'),
                                ),
                              ],
                              rows: c2mapItemToDataRows(c2items).toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () async {
                              getspeciesbase64Img();

                              if (_c2disV != null &&
                                  _c2formKey.currentState!.validate()) {
                                c2items.add(
                                  TreeInformationOption0Array(
                                      numberOfTrees: _numTrees.text,
                                      plantingDistance: _plantingDistance.text,
                                      speciesPlanted: _c2disV,
                                      speciesImage: _speciesbase64Image,
                                      yearOfEstablishment: _yoEstablishment),
                                );
                                print(
                                    "Added items ${c2items.length} --- $c2items");
                                setState(() {});

                                final String encodedData =
                                    TreeInformationOption0Array.encode(c2items);
                                regSP?.setString("c2itemsR", encodedData);
                              } else if (_c2disV == null) {
                                overlayNotification(
                                    'Please select species', "negative");
                              }
                            },
                            child: Icon(
                              Icons.add,
                              color: fPrimaryColour,
                              size: 40,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              c2deleteSelected();

                              // final String encodedData =
                              //     TreeInformationOption0Array.encode(c2items);
                              // regSP?.setString("c2itemsR", encodedData);
                            },
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Tree Information on Planted Species",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                              softWrap: true,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: Container(
                                width: size.width - 50,
                                child: Text(
                                  "c3 - " + widget.typeofEstablishment!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(0xFFfc1d20),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            // width: 170.0,
                            padding: EdgeInsets.all(5.0),
                            child: Form(
                              key: _c3formKey,
                              child: showEdit == true
                                  ? Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(children: [
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 10.0,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("P/ N"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          //   borderRadius:
                                                          //       BorderRadius.circular(10),
                                                          //   border: Border.all(),
                                                          ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .55,
                                                      padding:
                                                          EdgeInsets.all(.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 0.50,
                                                                  color: Color(
                                                                      0xFF000000)),
                                                            ),
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        60),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .55,
                                                            child:
                                                                DropdownButton(
                                                              focusColor:
                                                                  fPrimaryColour,
                                                              isExpanded: true,
                                                              iconEnabledColor:
                                                                  fPrimaryColour,
                                                              value: p_nValue,
                                                              items: p_nValues
                                                                  .map((String
                                                                      iTValue) {
                                                                return DropdownMenuItem(
                                                                  value:
                                                                      iTValue,
                                                                  child:
                                                                      Row(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                        child:
                                                                            Text(
                                                                          "$iTValue",
                                                                        ),
                                                                      ),
                                                                      // Container(),
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                _onPNChanged(
                                                                    value);
                                                                setState(() {
                                                                  _pn.text = value
                                                                      .toString();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                            ])),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: 10.0,
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  "Select Species"),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.50,
                                                                color: Color(
                                                                    0xFF000000)),
                                                          ),
                                                          // width: MediaQuery.of(context)
                                                          //         .size
                                                          //         .width /
                                                          //     1.2,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      6.0),
                                                          child: FutureBuilder<
                                                              List<
                                                                  TreeSpeciesJson>>(
                                                            future: mounted
                                                                ? c3mySFuture
                                                                : null,
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        List<
                                                                            TreeSpeciesJson>>
                                                                    snapshot) {
                                                              if (!snapshot
                                                                  .hasData)
                                                                return CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      fPrimaryColour),
                                                                );
                                                              else if (snapshot
                                                                  .hasData)
                                                                return fileExists
                                                                    ? Container(
                                                                        // width: MediaQuery.of(context).size.width / 1.09,
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: _c3disV,
                                                                              items: _treeSpeciesValues.map((TreeSpeciesJson dvalue) {
                                                                                // fD = dvalue;
                                                                                return DropdownMenuItem<String>(
                                                                                  value: dvalue.species,
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(10.0),
                                                                                        child: Text(
                                                                                          "${dvalue.species}",
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (String? value) {
                                                                                _c3disV = value;
                                                                                _onc3mmdasChanged(value!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                      )
                                                                    : Container(
                                                                        // width: MediaQuery.of(context).size.width / 1.09,
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: _c3disV,
                                                                              items: _newtreeSpeciesValues.map((TreeSpeciesJson dvalue) {
                                                                                // fD = dvalue;
                                                                                return DropdownMenuItem<String>(
                                                                                  value: dvalue.species,
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(10.0),
                                                                                        child: Text(
                                                                                          "${dvalue.species}",
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (String? value) {
                                                                                _c3disV = value;
                                                                                _onc3mmdasChanged(value!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                      );
                                                              else
                                                                return Text(
                                                                  "Please sync data",
                                                                );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //species photo

                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      "Take picture of species",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SpeciesImage(_selectedImage),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            children: [
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //         top: 10.0,
                                              //       ),
                                              //       child: Row(
                                              //         children: <Widget>[
                                              //           Text(
                                              //               "Size of tree (dbh)"),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              formFieldLabel(width: size.width * .9, "Size of tree (dbh)"),
                                              TextFieldWidget(
                                                // maxLines: 5,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: '',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        0.5)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0))),
                                                controller: _sizeofTree,
                                                validator: (input) =>
                                                    input!.trim().isEmpty
                                                        ? 'Please enter a value'
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      "Year Planted",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child:
                                                      isyearPlantedDate == true
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    fPrimaryColour,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              height: 40.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.0,
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            22,
                                                                        color: Color(
                                                                            0xFFffe423),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          yearPlantedInString ??
                                                                              "Year",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFf9f9f9),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Row(
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .arrow_drop_down_circle,
                                                                  size: 18,
                                                                  color:
                                                                      fPrimaryColour,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  // size: 34,
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                              ],
                                                            ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Select Year"),
                                                          content: Container(
                                                            // Need to use container to add size constraint.
                                                            width: 300,
                                                            height: 300,
                                                            // color: fPrimaryColour,
                                                            child: YearPicker(
                                                              firstDate:
                                                                  DateTime(
                                                                      1800),
                                                              lastDate: DateTime
                                                                  .now(),
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              // save the selected date to _selectedDate DateTime variable.
                                                              // It's used to set the previous selected date when
                                                              // re-showing the dialog.
                                                              selectedDate:
                                                                  _selectedYearPlantedDateYear ??
                                                                      DateTime
                                                                          .now(),
                                                              onChanged:
                                                                  (DateTime
                                                                      date) {
                                                                // close the dialog when year is selected.
                                                                Navigator.pop(
                                                                    context);

                                                                // Do something with the dateTime selected.
                                                                // Remember that you need to use dateTime.year to get the year
                                                                print(
                                                                    'confirm $date');
                                                                isyearPlantedDate =
                                                                    true;
                                                                yearPlantedInString =
                                                                    '${date.year}';

                                                                setState(() {
                                                                  _selectedYearPlantedDateYear =
                                                                      date;
                                                                  _yearPlanted =
                                                                      '${date.year}';
                                                                  print(
                                                                      "Year of Establishment ${date.year}-${date.month}-${date.day}");
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    ;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      "Year Nurturing Started",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child:
                                                      isyearNurturingStartedDate ==
                                                              true
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    fPrimaryColour,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              height: 40.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.0,
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            22,
                                                                        color: Color(
                                                                            0xFFffe423),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          yearNurturingStartedInString ??
                                                                              "Year",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFFf9f9f9),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Row(
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .arrow_drop_down_circle,
                                                                  size: 18,
                                                                  color:
                                                                      fPrimaryColour,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  // size: 34,
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                              ],
                                                            ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Select Year"),
                                                          content: Container(
                                                            // Need to use container to add size constraint.
                                                            width: 300,
                                                            height: 300,
                                                            // color: fPrimaryColour,
                                                            child: YearPicker(
                                                              firstDate:
                                                                  DateTime(
                                                                      1800),
                                                              lastDate: DateTime
                                                                  .now(),
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              // save the selected date to _selectedDate DateTime variable.
                                                              // It's used to set the previous selected date when
                                                              // re-showing the dialog.
                                                              selectedDate:
                                                                  _selectedYearNurturingStartedDateYear ??
                                                                      DateTime
                                                                          .now(),
                                                              onChanged:
                                                                  (DateTime
                                                                      date) {
                                                                // close the dialog when year is selected.
                                                                Navigator.pop(
                                                                    context);

                                                                // Do something with the dateTime selected.
                                                                // Remember that you need to use dateTime.year to get the year
                                                                print(
                                                                    'confirm $date');
                                                                isyearNurturingStartedDate =
                                                                    true;
                                                                yearNurturingStartedInString =
                                                                    '${date.year}';

                                                                setState(() {
                                                                  _selectedYearNurturingStartedDateYear =
                                                                      date;
                                                                  _yearNurturingStarted =
                                                                      '${date.year}';
                                                                  print(
                                                                      "Year Nurturing Started ${date.year}-${date.month}-${date.day}");
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    ;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
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
                                                            10.0),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      color: fPrimaryWhite),
                                                  // shadowColor: fPrimaryColour,
                                                ),
                                                child: Text("Pick Cordinates", style: TextStyle(
          color: fPrimaryWhite),),
                                                onPressed: () async {
                                                  if (_pickedLocation != null) {
                                                    print(
                                                        "Picked is ${_pickedLocation?.latitude}");
                                                    print(
                                                        "Picked is ${_pickedLocation?.longitude}");
                                                    setState(() {
                                                      _lat = _pickedLocation
                                                          ?.latitude;
                                                      _lng = _pickedLocation
                                                          ?.longitude;
                                                      _acc = _pickedLocation
                                                          ?.accuracy;
                                                    });
                                                    overlayNotification(
                                                        'Cordinates saved!',
                                                        "negative");
                                                  } else {
                                                    overlayNotification(
                                                        'GPS Accuracy must be 5m or below!',
                                                        "negative");
                                                  }
                                                },
                                              ),
                                              NewLocationService(
                                                onSelectLatLng: _selectLatLng,
                                              ),
                                              SizedBox(
                                                height: 10,
                                                // child: Divider(),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Center(
                                        //   child: Text(
                                        //     "List of Inputs".toUpperCase(),
                                        //     style: TextStyle(fontWeight: FontWeight.bold),
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "List of Inputs".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showEdit = !showEdit;
                                    });
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFFfc1d20)))
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              sortColumnIndex: 1,
                              sortAscending: c3sort,
                              showCheckboxColumn: true,
                              columnSpacing: 30.0,
                              columns: [
                                DataColumn(
                                  label: Text('P/N'),
                                ),
                                DataColumn(
                                  label: Text('Size'),
                                ),
                                DataColumn(
                                  label: Text('Species'),
                                ),
                                DataColumn(
                                  label: Text('Species Photo'),
                                ),
                                DataColumn(
                                  label: Text('Year Pl.'),
                                ),
                                DataColumn(
                                  label: Text('Year Nurt.'),
                                ),
                                DataColumn(
                                  label: Text('Lat'),
                                ),
                                DataColumn(
                                  label: Text('Lng'),
                                ),
                              ],
                              rows: c3mapItemToDataRows(c3items).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  getspeciesbase64Img();

                                  if (_c3disV == null) {
                                    overlayNotification(
                                        'Please select a species', "negative");
                                  } else if (_speciesbase64Image!.isEmpty) {
                                    overlayNotification(
                                        'Please take picture of species',
                                        "negative");
                                  } else if (_lat == null && _lng == null) {
                                    overlayNotification(
                                        'Please pick cordinates', "negative");
                                  } else if (_c3formKey.currentState!
                                      .validate()) {
                                    c3items.add(
                                      TreeInformationOption2Array(
                                        pN: _pn.text,
                                        sizeofTree: _sizeofTree.text,
                                        species: _c3disV,
                                        speciesImage: _speciesbase64Image,
                                        yearPlanted: _yearPlanted,
                                        yearNurturingStarted:
                                            _yearNurturingStarted,
                                        treeLocation: TreeLocation(
                                            latitude: _lat,
                                            longitude: _lng,
                                            pointID: uuid.v1()),
                                      ),
                                    );

                                    print(
                                        "Added items ${c3items.length} --- $c3items");
                                    final String encodedData =
                                        TreeInformationOption2Array.encode(
                                            c3items);
                                    await regSP?.setString(
                                        "c3itemsR", encodedData);
                                    Timer(
                                      Duration(seconds: 1),
                                      () {
                                        setState(() {
                                          _lat = null;
                                          _lng = null;
                                        });
                                      },
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  color: fPrimaryColour,
                                  size: 40,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  c3deleteSelected();

                                  // final String encodedData =
                                  //     TreeInformationOption2Array.encode(
                                  //         c3items);
                                  // regSP?.setString("c3itemsR", encodedData);
                                },
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _priceController.dispose();
    // _itemController.dispose();
  }

  Iterable<DataRow> c2mapItemToDataRows(
      List<TreeInformationOption0Array> c2items) {
    Iterable<DataRow> dataRows = c2items.map((c2item) {
      final TextEditingController yearOfEstablishment = TextEditingController();

      return DataRow(
          selected: c2selectedPoints.contains(c2item),
          onSelectChanged: (t) {
            print("Onselect");
            c2onSelectedRow(t!, c2item);
          },
          cells: [
            DataCell(
              Text(c2item.speciesPlanted.toString()),
              showEditIcon: true,
              onTap: () {
                // print('Selected ${c3item.speciesPlanted.toString()}');
                // editValue(
                //   "P/N",
                //   "PN",
                //   _species,
                //   c3item.speciesPlanted,
                // );

                _species.text = c2item.speciesPlanted.toString();
                popUpDialogue(
                  context,
                  "${c2item.speciesPlanted}: Edit Species",
                  imageIcon: editSpeciesc2(c2item),
                );
                // setState(() {
                //   c3item.speciesPlanted = "now";
                // });
              },
            ),
            DataCell(
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: SpeciesImage(() {},
                    alreadyPic: c2item.speciesImage.toString()),
              ),
            ),
            DataCell(
              Text(c2item.numberOfTrees ?? "not found"),
              showEditIcon: true,
              onTap: () {
                _numTrees.text = c2item.numberOfTrees.toString();
                popUpDialogue(
                  context,
                  "${c2item.numberOfTrees}: Edit No. of Trees (Stocking)",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "No. of Trees (Stocking)",
                        // onSubmitted: () {},
                        type: TextInputType.number,
                        labelStyle: TextStyle(color: fPrimaryColour),
                        controller: _numTrees,
                        // validator: (input) =>
                        //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                      ),
                      LightButton(
                        title: "Edit",
                        onPress: () {
                          Navigator.pop(context);

                          if (_numTrees.text.trim().isNotEmpty) {
                            setState(() {
                              c2item.numberOfTrees = _numTrees.text;
                            });
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            DataCell(
              Text(c2item.yearOfEstablishment ?? "not found"),
              showEditIcon: true,
              onTap: () {
                // _species.text = c3item.yearOfEstablishment.toString();
                popUpDialogue(
                  context,
                  "${c2item.yearOfEstablishment}: Edit Year of Establishment",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "Year of Establishment",
                        // onSubmitted: () {},
                        type: TextInputType.datetime,
                        labelStyle: TextStyle(color: fPrimaryColour),
                        controller: yearOfEstablishment,
                        // validator: (input) =>
                        //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                      ),
                      LightButton(
                        title: "Edit",
                        onPress: () {
                          Navigator.pop(context);

                          if (yearOfEstablishment.text.trim().isNotEmpty) {
                            setState(() {
                              c2item.yearOfEstablishment =
                                  yearOfEstablishment.text;
                            });
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            DataCell(
              Text(c2item.plantingDistance ?? "not found"),
              showEditIcon: true,
              onTap: () {
                _plantingDistance.text = c2item.plantingDistance.toString();
                popUpDialogue(
                  context,
                  "${c2item.plantingDistance}: Edit Planting distance",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "Planting distance",
                        // onSubmitted: () {},
                        type: TextInputType.number,
                        labelStyle: TextStyle(color: fPrimaryColour),
                        controller: _plantingDistance,
                        // validator: (input) =>
                        //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                      ),
                      LightButton(
                        title: "Edit",
                        onPress: () {
                          Navigator.pop(context);

                          if (_plantingDistance.text.trim().isNotEmpty) {
                            setState(() {
                              c2item.plantingDistance = _plantingDistance.text;
                            });
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ]);
    });
    return dataRows;
  }

  Iterable<DataRow> c3mapItemToDataRows(
      List<TreeInformationOption2Array> c3items) {
    Iterable<DataRow> dataRows = c3items.map((c3item) {
      return DataRow(
          selected: c3selectedPoints.contains(c3item),
          onSelectChanged: (t) {
            print("Onselect");
            c3onSelectedRow(t!, c3item);
          },
          cells: [
            DataCell(
              Text(c3item.pN.toString()),
              // onTap: () {
              //   print('Selected ${c3item.latitude.toString()}');
              // },
              showEditIcon: true,
              onTap: () {
                _pn.text = c3item.pN.toString();
                popUpDialogue(
                  context,
                  "${c3item.pN}: Edit P/ N",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                //   borderRadius:
                                //       BorderRadius.circular(10),
                                //   border: Border.all(),
                                ),
                            width: MediaQuery.of(context).size.width * .55,
                            padding: EdgeInsets.all(.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.50, color: Color(0xFF000000)),
                                  ),
                                  constraints: BoxConstraints(minHeight: 60),
                                  width:
                                      MediaQuery.of(context).size.width * .55,
                                  child: DropdownButton(
                                    focusColor: fPrimaryColour,
                                    isExpanded: true,
                                    iconEnabledColor: fPrimaryColour,
                                    value: p_nValue,
                                    items: p_nValues.map((String iTValue) {
                                      return DropdownMenuItem(
                                        value: iTValue,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "$iTValue",
                                              ),
                                            ),
                                            // Container(),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      _onPNChanged(value);
                                      setState(() {
                                        _pn.text = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      LightButton(
                        title: "Edit",
                        onPress: () {
                          Navigator.pop(context);

                          if (_pn.text.trim().isNotEmpty) {
                            setState(() {
                              c3item.pN = _pn.text;
                            });
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            DataCell(
              Text(c3item.sizeofTree.toString()),
              showEditIcon: true,
              onTap: () {
                _sizeofTree.text = c3item.sizeofTree.toString();
                popUpDialogue(
                  context,
                  "${c3item.sizeofTree}: Edit Size of tree",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "Size of tree",
                        // onSubmitted: () {},
                        type: TextInputType.number,
                        labelStyle: TextStyle(color: fPrimaryColour),
                        controller: _sizeofTree,
                        // validator: (input) =>
                        //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                      ),
                      LightButton(
                        title: "Edit",
                        onPress: () {
                          Navigator.pop(context);

                          if (_sizeofTree.text.trim().isNotEmpty) {
                            setState(() {
                              c3item.sizeofTree = _sizeofTree.text;
                            });
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            DataCell(
              Text(c3item.species.toString()),
              showEditIcon: true,
              onTap: () {
                _species.text = c3item.species.toString();
                popUpDialogue(
                  context,
                  "${c3item.species}: Edit Species",
                  imageIcon: editSpeciesc3(c3item),
                );
                ;
              },
            ),
            DataCell(
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: SpeciesImage(() {},
                      alreadyPic: c3item.speciesImage.toString())),
            ),
            DataCell(
              Text(
                c3item.pN == "Planted" ? c3item.yearPlanted.toString() : "N/A",
              ),
              showEditIcon: c3item.pN == "Planted" ? true : false,
              onTap: c3item.pN == "Planted"
                  ? () {
                      _pn.text = c3item.yearPlanted.toString();
                      popUpDialogue(
                        context,
                        "${c3item.yearPlanted}: Edit Year Planted",
                        imageIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            NewBoilerTextFieldWidget(
                              labelText: "Year Planted",
                              // onSubmitted: () {},
                              type: TextInputType.number,
                              labelStyle: TextStyle(color: fPrimaryColour),
                              controller: _pn,
                              // validator: (input) =>
                              //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                            ),
                            LightButton(
                              title: "Edit",
                              onPress: () {
                                Navigator.pop(context);

                                if (_pn.text.trim().isNotEmpty) {
                                  setState(() {
                                    c3item.yearPlanted = _pn.text;
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      );
                    }
                  : null,
            ),
            DataCell(
              Text(
                c3item.pN == "Natural"
                    ? c3item.yearNurturingStarted.toString()
                    : "N/A",
              ),
              showEditIcon: c3item.pN == "Natural" ? true : false,
              onTap: c3item.pN == "Natural"
                  ? () {
                      _pn.text = c3item.yearNurturingStarted.toString();
                      popUpDialogue(
                        context,
                        "${c3item.yearNurturingStarted}: Edit Year Nurturing Started",
                        imageIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            NewBoilerTextFieldWidget(
                              labelText: "Year Nurturing Started",
                              // onSubmitted: () {},
                              type: TextInputType.number,
                              labelStyle: TextStyle(color: fPrimaryColour),
                              controller: _pn,
                              // validator: (input) =>
                              //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                            ),
                            LightButton(
                              title: "Edit",
                              onPress: () {
                                Navigator.pop(context);

                                if (_pn.text.trim().isNotEmpty) {
                                  setState(() {
                                    c3item.yearNurturingStarted = _pn.text;
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      );
                    }
                  : null,
            ),
            DataCell(
              Text(c3item.treeLocation?.latitude.toString() ?? "latitude"),
              showEditIcon: true,
              onTap: () {
                popUpDialogue(
                  context,
                  "Edit Coordinates",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewLocationService(
                        onSelectLatLng: _selectLatLng,
                        // show: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: LightButton(
                          title: "Edit",
                          onPress: () {
                            Navigator.pop(context);

                            if (_pickedLocation != null) {
                              print("Picked is ${_pickedLocation?.latitude}");
                              print("Picked is ${_pickedLocation?.longitude}");
                              setState(() {
                                c3item.treeLocation?.latitude =
                                    _pickedLocation?.latitude;
                                c3item.treeLocation?.longitude =
                                    _pickedLocation?.longitude;
                                // c3item.treeLocation?.accuracy = _pickedLocation?.accuracy;
                              });
                              overlayNotification(
                                  'Cordinates saved!', "positive",
                                  position: NotificationPosition.top);
                            } else {
                              overlayNotification(
                                  'GPS Accuracy must be 5m or below!',
                                  "negative",
                                  position: NotificationPosition.top);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            DataCell(
              Text(c3item.treeLocation?.longitude.toString() ?? "longitude"),
              showEditIcon: true,
              onTap: () {
                popUpDialogue(
                  context,
                  "Edit Coordinates",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NewLocationService(
                        onSelectLatLng: _selectLatLng,
                        // show: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: LightButton(
                          title: "Edit",
                          onPress: () {
                            Navigator.pop(context);

                            if (_pickedLocation != null) {
                              print("Picked is ${_pickedLocation?.latitude}");
                              print("Picked is ${_pickedLocation?.longitude}");
                              setState(() {
                                c3item.treeLocation?.latitude =
                                    _pickedLocation?.latitude;
                                c3item.treeLocation?.longitude =
                                    _pickedLocation?.longitude;
                                // c3item.treeLocation?.accuracy = _pickedLocation?.accuracy;
                              });
                              overlayNotification(
                                  'Cordinates saved!', "positive",
                                  position: NotificationPosition.top);
                            } else {
                              overlayNotification(
                                  'GPS Accuracy must be 5m or below!',
                                  "negative",
                                  position: NotificationPosition.top);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ]);
    });
    return dataRows;
  }

  Column editSpeciesc2(TreeInformationOption0Array c2item) {
    final _newspecName = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select new species"),
        Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.50, color: Color(0xFF000000)),
              ),
              // width: MediaQuery.of(context)
              //         .size
              //         .width /
              //     1.2,
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: FutureBuilder<List<TreeSpeciesJson>>(
                future: mounted ? c3mySFuture : null,
                builder:
                    (context, AsyncSnapshot<List<TreeSpeciesJson>> snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    );
                  else if (snapshot.hasData)
                    return fileExists
                        ? Container(
                            // width: MediaQuery.of(context).size.width * .7,
                            child: StatefulBuilder(builder: (context, state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _c3disV,
                                  items: _treeSpeciesValues
                                      .map((TreeSpeciesJson dvalue) {
                                    // fD = dvalue;
                                    return DropdownMenuItem<String>(
                                      value: dvalue.species,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "${dvalue.species}",
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    _c3disV = value;
                                    _onc3mmdasChanged(value!);

                                    setState(() {
                                      _newspecName.text = value;
                                    });
                                  },
                                ),
                              );
                            }),
                          )
                        : Container(
                            // width: MediaQuery.of(context).size.width / 1.09,
                            child: StatefulBuilder(builder: (context, state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _c3disV,
                                  items: _newtreeSpeciesValues
                                      .map((TreeSpeciesJson dvalue) {
                                    // fD = dvalue;
                                    return DropdownMenuItem<String>(
                                      value: dvalue.species,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "${dvalue.species}",
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    _c3disV = value;
                                    _onc3mmdasChanged(value!);

                                    setState(() {
                                      _newspecName.text = value;
                                    });
                                  },
                                ),
                              );
                            }),
                          );
                  else
                    return Text(
                      "Please sync data",
                    );
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        NewBoilerTextFieldWidget(
          labelText: "Click here to Type Species name ",
          // onSubmitted: () {},
          type: TextInputType.text,
          labelStyle: TextStyle(color: fPrimaryColour),
          controller: _newspecName,
          // validator: (input) =>
          //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
        ),
        LightButton(
          title: "Edit",
          onPress: () {
            Navigator.pop(context);

            if (_newspecName.text.trim().isNotEmpty) {
              setState(() {
                c2item.speciesPlanted = _newspecName.text;
              });
            }
          },
        )
      ],
    );
  }

  Column editSpeciesc3(TreeInformationOption2Array c3item) {
    final _newspecName = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select new species"),
        Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.50, color: Color(0xFF000000)),
              ),
              // width: MediaQuery.of(context)
              //         .size
              //         .width /
              //     1.2,
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: FutureBuilder<List<TreeSpeciesJson>>(
                future: mounted ? c3mySFuture : null,
                builder:
                    (context, AsyncSnapshot<List<TreeSpeciesJson>> snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    );
                  else if (snapshot.hasData)
                    return fileExists
                        ? Container(
                            // width: MediaQuery.of(context).size.width * .7,
                            child: StatefulBuilder(builder: (context, state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _c3disV,
                                  items: _treeSpeciesValues
                                      .map((TreeSpeciesJson dvalue) {
                                    // fD = dvalue;
                                    return DropdownMenuItem<String>(
                                      value: dvalue.species,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "${dvalue.species}",
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    _c3disV = value;
                                    _onc3mmdasChanged(value!);

                                    setState(() {
                                      _newspecName.text = value;
                                    });
                                  },
                                ),
                              );
                            }),
                          )
                        : Container(
                            // width: MediaQuery.of(context).size.width / 1.09,
                            child: StatefulBuilder(builder: (context, state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _c3disV,
                                  items: _newtreeSpeciesValues
                                      .map((TreeSpeciesJson dvalue) {
                                    // fD = dvalue;
                                    return DropdownMenuItem<String>(
                                      value: dvalue.species,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "${dvalue.species}",
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    _c3disV = value;
                                    _onc3mmdasChanged(value!);

                                    setState(() {
                                      _newspecName.text = value;
                                    });
                                  },
                                ),
                              );
                            }),
                          );
                  else
                    return Text(
                      "Please sync data",
                    );
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        NewBoilerTextFieldWidget(
          labelText: "Click here to Type Species name ",
          // onSubmitted: () {},
          type: TextInputType.text,
          labelStyle: TextStyle(color: fPrimaryColour),
          controller: _newspecName,
          // validator: (input) =>
          //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
        ),
        LightButton(
          title: "Edit",
          onPress: () {
            Navigator.pop(context);

            if (_newspecName.text.trim().isNotEmpty) {
              setState(() {
                c3item.species = _newspecName.text;
              });
            }
          },
        )
      ],
    );
  }
}
