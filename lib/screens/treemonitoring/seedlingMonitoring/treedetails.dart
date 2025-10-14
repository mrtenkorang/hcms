import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/treespecies.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/farmerdetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/monitoredspecieslist.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/plantingarea.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TreeDetails extends StatefulWidget {
  final String? contact;

  const TreeDetails({Key? key, this.contact}) : super(key: key);

  @override
  _TreeDetailsState createState() => _TreeDetailsState();
}

class _TreeDetailsState extends State<TreeDetails> {
  final _formKey = GlobalKey<FormState>();

  final _quantityReceived = TextEditingController();
  final _quantityPlanted = TextEditingController();
  final _quantitySurvived = TextEditingController();

  String? _receivedDateYear;
  String? _plantedDateYear;
  String? _visitDateYear;

  bool isDateReceived = false;
  String? receivedDateYearInString;

  bool isDatePlanted = false;
  String? plantedDateYearInString;
  bool isVisitDate = false;
  String? visitDateYearInString;

  bool errorMessage = false;

  int? selectedVisitRadio;

  String? _disV;
  Future<List<TreeSpeciesJson>>? mySFuture;

  File? jsonFile;
  Directory? dir;
  String fileName = "treespecies.json";
  bool fileExists = false;
  var fileContent;
  bool confileContent = false;
  List<TreeSpeciesJson> _newtreeSpeciesValues = [];
  List<TreeSpeciesJson> _treeSpeciesValues = [];

  void createFile(var content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<TreeSpeciesJson>> getLocalDistricts(BuildContext context) async {
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
          getLocalDistricts(ctx);
        }
      } on SocketException {
        print("Error is ");
        getLocalDistricts(ctx);
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

  speciesFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonFile = new File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        fileContent = await json.decode(await jsonFile!.readAsString());
    });

    return fileContent;
  }

  void _onmmdasChanged(String mmdasVal) {
    setState(() {
      _disV = mmdasVal;
    });
  }

  void setTDValuesT() {
    regSP?.setString('tdSpecies', !boxChecked ? _disV! : _specName.text);
    regSP?.setString('tdDateReceived', _receivedDateYear!);
    regSP?.setString('tdDatePlanted', _plantedDateYear!);
    regSP?.setString('tdQuantityReceived', _quantityReceived.text);
    regSP?.setString('tdQuantityPlanted', _quantityPlanted.text);
    regSP?.setString('tdQuantitySurvived', _quantitySurvived.text);
    print("done setting");
  }

  final _specName = TextEditingController();
  // List<String> _specFound;
  bool boxChecked = false;

  // oncSelectedRow(bool selected, String selectedEst) async {
  //   setState(() {
  //     if (selected) {
  //       _commFound.add(selectedEst);
  //     } else {
  //       _commFound.remove(selectedEst);
  //     }
  //   });
  // }

  void _onSpecChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  @override
  void initState() {
    super.initState();
    speciesFileInit();
    mySFuture = writeToFile(this.context);

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        this.setState(
            () => fileContent = json.decode(jsonFile!.readAsStringSync()));
    });
  }

  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushReplacement(
          CupertinoPageRoute(
              builder: (c) => MonitoredSpeciesList(
                    contact: widget.contact,
                  )),
        )
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "error on going back";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: fPrimaryWhite,
          automaticallyImplyLeading: false,
          backgroundColor: fPrimaryColour,
          title: RichText(
            text: new TextSpan(children: [
              TextSpan(
                  text: "Tree Seedling Monitoring\n",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: "Welcome, ${regSP?.getString("smfarmername") ?? ""}"),
            ]),
          ),
          actions: [
            PopupMenuButton<String>(
              offset: Offset(2.00, 3.00),
              color: Colors.black,
              onSelected: (String _downChoice) {
                if (_downChoice == Constants.home) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => IndexPage(),
                    ),
                  );
                } else if (_downChoice == Constants.load) {
                  writeToFile(context);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => this.widget));
                }
              },
              itemBuilder: (BuildContext context) {
                return Constants.exceptiondownChoices.map((String _downChoice) {
                  return PopupMenuItem<String>(
                    value: _downChoice,
                    child: Container(
                      margin: EdgeInsets.only(right: 0),
                      child: Text(
                        _downChoice,
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Tree Details",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold, fontSize: 24.0),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    // height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Material(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Tree Details",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0),
                                          ),
                                        ],
                                      ),
                                      // Container(
                                      //   margin:
                                      //       EdgeInsets.symmetric(vertical: 20),
                                      //   child: new Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       Row(
                                      //         children: <Widget>[
                                      //           Padding(
                                      //             padding:
                                      //                 const EdgeInsets.all(0.0),
                                      //             child: Text(
                                      //               "Date of visit",
                                      //               style: TextStyle(
                                      //                   fontSize: 17,
                                      //                   color: Colors.black54),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //       Padding(
                                      //         padding: const EdgeInsets.all(10.0),
                                      //         child: GestureDetector(
                                      //           child: isVisitDate == true
                                      //               ? Container(
                                      //                   decoration: BoxDecoration(
                                      //                     color: fPrimaryColour,
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(30),
                                      //                   ),
                                      //                   height: 40.0,
                                      //                   width:
                                      //                       MediaQuery.of(context)
                                      //                               .size
                                      //                               .width /
                                      //                           2.5,
                                      //                   child: Padding(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                                 .symmetric(
                                      //                             horizontal:
                                      //                                 8.0),
                                      //                     child: Row(
                                      //                       children: <Widget>[
                                      //                         Icon(
                                      //                           Icons
                                      //                               .arrow_drop_down_circle,
                                      //                           size: 22,
                                      //                           color: Color(
                                      //                               0xFFffe423),
                                      //                         ),
                                      //                         Padding(
                                      //                           padding: const EdgeInsets
                                      //                                   .symmetric(
                                      //                               horizontal:
                                      //                                   8.0),
                                      //                           child: Text(
                                      //                             visitDateYearInString ??
                                      //                                 "visit date",
                                      //                             style:
                                      //                                 TextStyle(
                                      //                               color: Color(
                                      //                                   0xFFf9f9f9),
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                 )
                                      //               : Row(
                                      //                   children: <Widget>[
                                      //                     Icon(
                                      //                       Icons
                                      //                           .arrow_drop_down_circle,
                                      //                       size: 18,
                                      //                       color: fPrimaryColour,
                                      //                     ),
                                      //                     Icon(
                                      //                       Icons.calendar_today,
                                      //                       // size: 34,
                                      //                     ),
                                      //                     SizedBox(
                                      //                       width: 20,
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //           onTap: () {
                                      //             DatePicker.showDatePicker(
                                      //                 context,
                                      //                 theme: DatePickerTheme(
                                      //                   backgroundColor:
                                      //                       fPrimaryColour,
                                      //                   itemStyle: TextStyle(
                                      //                       color: Color(
                                      //                           0xFFf9f9f9)),
                                      //                   cancelStyle: TextStyle(
                                      //                       color: Color(
                                      //                           0xFFffe423)),
                                      //                   doneStyle: TextStyle(
                                      //                       color: Color(
                                      //                           0xFFf9f9f9)),
                                      //                   containerHeight: 210.0,
                                      //                 ),
                                      //                 showTitleActions: true,
                                      //                 minTime: DateTime(1800),
                                      //                 maxTime: DateTime.now(),
                                      //                 onConfirm: (date) {
                                      //               print('confirm $date');
                                      //               isVisitDate = true;
                                      //               visitDateYearInString =
                                      //                   '${date.year}-${date.month}-${date.day}';
                                      //               setState(() {
                                      //                 _visitDateYear =
                                      //                     '${date.year}-${date.month}-${date.day}';
                                      //                 print(
                                      //                     "DOOB ${date.year}-${date.month}-${date.day}");
                                      //               });
                                      //             },
                                      //                 // currentTime: DateTime.now(),
                                      //                 locale: LocaleType.en);
                                      //           },
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      !boxChecked
                                          ? Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: 10.0,
                                                              ),
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Text(
                                                                      "Select Species received"),
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
                                                                    ? mySFuture
                                                                    : null,
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            List<TreeSpeciesJson>>
                                                                        snapshot) {
                                                                  if (!snapshot
                                                                      .hasData)
                                                                    return CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<Color>(
                                                                              fPrimaryColour),
                                                                    );
                                                                  else if (snapshot
                                                                      .hasData)
                                                                    return fileExists
                                                                        ? Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 1.09,
                                                                            child:
                                                                                StatefulBuilder(builder: (context, state) {
                                                                              return DropdownButtonHideUnderline(
                                                                                child: new DropdownButton<String>(
                                                                                  value: _disV,
                                                                                  items: _treeSpeciesValues.map((TreeSpeciesJson dvalue) {
                                                                                    // fD = dvalue;
                                                                                    return new DropdownMenuItem<String>(
                                                                                      value: dvalue.species,
                                                                                      child: new Row(
                                                                                        children: <Widget>[
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                            child: new Text(
                                                                                              "${dvalue.species}",
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (String? value) {
                                                                                    _disV = value;
                                                                                    _onmmdasChanged(value!);
                                                                                  },
                                                                                ),
                                                                              );
                                                                            }),
                                                                          )
                                                                        : Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 1.09,
                                                                            child:
                                                                                StatefulBuilder(builder: (context, state) {
                                                                              return DropdownButtonHideUnderline(
                                                                                child: new DropdownButton<String>(
                                                                                  value: _disV,
                                                                                  items: _newtreeSpeciesValues.map((TreeSpeciesJson dvalue) {
                                                                                    // fD = dvalue;
                                                                                    return new DropdownMenuItem<String>(
                                                                                      value: dvalue.species,
                                                                                      child: new Row(
                                                                                        children: <Widget>[
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                            child: new Text(
                                                                                              "${dvalue.species}",
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (String? value) {
                                                                                    _disV = value;
                                                                                    _onmmdasChanged(value!);
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
                                            )
                                          : SizedBox(),
                                      new CheckboxListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 20),
                                        title: Text(
                                          "Check box if species not found",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        value: boxChecked,
                                        activeColor: fPrimaryColour,
                                        onChanged: (bool? value) {
                                          _onSpecChanged(value!);
                                        },
                                      ),
                                      boxChecked
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: .0),
                                              child: TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "(Enter name of species if not found)",
                                                ),
                                                labelText:
                                                    "(Enter name of species if not found)",
                                                controller: _specName,
                                                validator: (input) => input!
                                                        .trim()
                                                        .isEmpty
                                                    ? 'Please enter name of species'
                                                    : null,
                                                readonly: boxChecked
                                                    ? false
                                                    : boxChecked,
                                              ),
                                            )
                                          : SizedBox(),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Text(
                                                    "Date received",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GestureDetector(
                                                child: isDateReceived == true
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: fPrimaryColour,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        height: 40.0,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .arrow_drop_down_circle,
                                                                size: 22,
                                                                color: Color(
                                                                    0xFFffe423),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Text(
                                                                  receivedDateYearInString ??
                                                                      "quantity",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                                  DatePicker.showDatePicker(
                                                      context,
                                                      theme: DatePickerTheme(
                                                        backgroundColor:
                                                            fPrimaryColour,
                                                        itemStyle: TextStyle(
                                                            color: Color(
                                                                0xFFf9f9f9)),
                                                        cancelStyle: TextStyle(
                                                            color: Color(
                                                                0xFFffe423)),
                                                        doneStyle: TextStyle(
                                                            color: Color(
                                                                0xFFf9f9f9)),
                                                        containerHeight: 210.0,
                                                      ),
                                                      showTitleActions: true,
                                                      minTime: DateTime(1800),
                                                      maxTime: DateTime.now(),
                                                      onConfirm: (date) {
                                                    print('confirm $date');
                                                    isDateReceived = true;
                                                    receivedDateYearInString =
                                                        '${date.year}-${date.month}-${date.day}';
                                                    setState(() {
                                                      _receivedDateYear =
                                                          '${date.year}-${date.month}-${date.day}';
                                                      print(
                                                          "DOOB ${date.year}-${date.month}-${date.day}");
                                                    });
                                                  },
                                                      // currentTime: DateTime.now(),
                                                      locale: LocaleType.en);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Text(
                                                    "Date planted",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GestureDetector(
                                                child: isDatePlanted == true
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: fPrimaryColour,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        height: 40.0,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .arrow_drop_down_circle,
                                                                size: 22,
                                                                color: Color(
                                                                    0xFFffe423),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Text(
                                                                  plantedDateYearInString ??
                                                                      "planted date",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                                  DatePicker.showDatePicker(
                                                      context,
                                                      theme: DatePickerTheme(
                                                        backgroundColor:
                                                            fPrimaryColour,
                                                        itemStyle: TextStyle(
                                                            color: Color(
                                                                0xFFf9f9f9)),
                                                        cancelStyle: TextStyle(
                                                            color: Color(
                                                                0xFFffe423)),
                                                        doneStyle: TextStyle(
                                                            color: Color(
                                                                0xFFf9f9f9)),
                                                        containerHeight: 210.0,
                                                      ),
                                                      showTitleActions: true,
                                                      minTime: DateTime(1800),
                                                      maxTime: DateTime.now(),
                                                      onConfirm: (date) {
                                                    print('confirm $date');
                                                    isDatePlanted = true;
                                                    plantedDateYearInString =
                                                        '${date.year}-${date.month}-${date.day}';
                                                    setState(() {
                                                      _plantedDateYear =
                                                          '${date.year}-${date.month}-${date.day}';
                                                      print(
                                                          "DOOB ${date.year}-${date.month}-${date.day}");
                                                    });
                                                  },
                                                      // currentTime: DateTime.now(),
                                                      locale: LocaleType.en);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      formFieldLabel(width: size.width * .9, "Quantity received"),
                                      TextFieldWidget(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "Quantity received"),
                                        controller: _quantityReceived,
                                        validator: (input) =>
                                            input!.trim().isEmpty
                                                ? 'Please enter quantity'
                                                : null,
                                      ),
                                      formFieldLabel(width: size.width * .9, "Quantity planted"),
                                      TextFieldWidget(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "Quantity planted"),
                                        controller: _quantityPlanted,
                                        validator: (input) {
                                          if (input!.trim().isNotEmpty) {
                                            if (int.parse(input) >
                                                int.parse(
                                                    _quantityReceived.text)) {
                                              return "Value cannot be more than quantity received.";
                                            }
                                          } else {
                                            return 'Please enter quantity';
                                          }
                                          return null;
                                        },
                                      ),
                                      formFieldLabel(width: size.width * .9, "Quantity survived"),
                                      TextFieldWidget(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "Quantity survived"),
                                        controller: _quantitySurvived,
                                        validator: (input) {
                                          if (input!.trim().isNotEmpty) {
                                            if (int.parse(input) >
                                                int.parse(
                                                    _quantityPlanted.text)) {
                                              return "Value cannot be more than quantity planted.";
                                            }
                                          } else {
                                            return 'Please enter quantity';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 40.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            height: 50.00,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                backgroundColor: fPrimaryColour,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                textStyle: const TextStyle(
                                                    color: fPrimaryWhite),
                                                // shadowColor: fPrimaryColour,
                                              ),
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                    color: fPrimaryWhite,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              onPressed: () async {
                                                if (!boxChecked &&
                                                    _disV == null) {
                                                  overlayNotification(
                                                      'Please select species',
                                                      "negative");
                                                } else if (_receivedDateYear ==
                                                    null) {
                                                  overlayNotification(
                                                      'Please select date year received',
                                                      "negative");
                                                } else if (_plantedDateYear ==
                                                    null) {
                                                  overlayNotification(
                                                      'Please select date year planted',
                                                      "negative");
                                                } else if (_formKey
                                                    .currentState!
                                                    .validate()) {
                                                  setTDValuesT();
                                                  // regSP?.setBool(
                                                  //     "farmerskipped", false);
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          PlantingArea(
                                                        contact: widget.contact,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
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
                        ),
                      ],
                    ),
                  ),
                  // Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
