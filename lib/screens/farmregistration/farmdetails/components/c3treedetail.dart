import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/models/apimodels/treespecies.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/treeinformationoption2arraydetails.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/declaration.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/services/locationservice.dart';

import '../../../../main.dart';

class C3TreeInformation extends StatefulWidget {
  final String? pageTitle;

  const C3TreeInformation({Key? key, this.pageTitle}) : super(key: key);
  @override
  _C3TreeInformationState createState() => _C3TreeInformationState();
}

class _C3TreeInformationState extends State<C3TreeInformation> {
  final _formKey = GlobalKey<FormState>();

  File? jsonFile;
  Directory? dir;
  String fileName = "treespecies.json";
  bool fileExists = false;
  var fileContent;
  bool confileContent = false;
  List<TreeSpeciesJson> _newtreeSpeciesValues = [];
  List<TreeSpeciesJson> _treeSpeciesValues = [];

  List<TreeInformationOption2Array> items = [];
  List<TreeInformationOption2Array> selectedPoints = [];
  String? _encodedKeep;

  final _pn = TextEditingController();
  final _species = TextEditingController();
  final _sizeofTree = TextEditingController();
  // final _yearPlanted = TextEditingController();
  String _yearPlanted = "";
  bool isyearPlantedDate = false;
  String? yearPlantedInString;
  DateTime? _selectedYearPlantedDateYear;

  // final _yearNurturingStarted = TextEditingController();
  String _yearNurturingStarted = "";
  bool isyearNurturingStartedDate = false;
  String? yearNurturingStartedInString;
  DateTime? _selectedYearNurturingStartedDateYear;

  List<TreeLocation> treeLocation = [];
  int index = 0;

  String? p_nValue;
  List<String> p_nValues = [];

  bool sort = false;

  String? _disV;
  Future<List<TreeSpeciesJson>>? mySFuture;

  File? _pickedImage;
  String _speciesbase64Image = "";

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  PlaceLocation? _pickedLocation;

  void createFile(var content, Directory dir, String fileName) {
    print("Creating file!");
    File file = File(dir.path + "/" + fileName);
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

  commFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonFile = File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        fileContent = await json.decode(await jsonFile!.readAsString());
    });

    return fileContent;
  }

  void _onmmdasChanged(String? mmdasVal) {
    setState(() {
      _disV = mmdasVal;
    });
  }

  void setTDValues() async {
    await regSP?.setString("c3treeplantationDetail", _encodedKeep!);
    print("Reg 2 shared preference worked");
  }

  void _selectLatLng(double lat, double lng, double alt, double acc) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      altitude: alt,
      accuracy: acc,
    );
  }

  convertu() {
    final String encodedData = TreeInformationOption2Array.encode(items);
    _encodedKeep = encodedData;
    // final List<TreeInformationOption2Array> decodedData =
    //     TreeInformationOption2Array.decode(encodedData);

    final treeInfo2Option = encodedData.isNotEmpty
        ? json.decode(encodedData).cast<Map<String, dynamic>>()
        : Map();

    setTDValues();
    print("Items Plantation data $items");
    print("Decoded Plantation data $treeInfo2Option");
  }

  onSelectedRow(bool selected, TreeInformationOption2Array user) async {
    setState(() {
      if (selected) {
        selectedPoints.add(user);
      } else {
        selectedPoints.remove(user);
      }
    });
  }

  deleteSelected() async {
    print("Delete working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (selectedPoints.isNotEmpty) {
          List<TreeInformationOption2Array> temp = [];
          temp.addAll(selectedPoints);
          for (TreeInformationOption2Array points in temp) {
            items.remove(points);
            selectedPoints.remove(points);
          }
        }
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  _onDone() {
    convertu();
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

  Future getspeciesbase64Img() async {
    _speciesbase64Image = await regSP?.getString('speciesbase64Image') ?? "";
  }

  @override
  void initState() {
    super.initState();
    commFileInit();
    mySFuture = writeToFile(this.context);

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        this.setState(
            () => fileContent = json.decode(jsonFile!.readAsStringSync()));
    });

    items = [];
    selectedPoints = [];

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: const Text(
          "Tree Information",
          style: TextStyle(color: fPrimaryWhite),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(2.00, 3.00),
            color: Colors.black,
            onSelected: (String _downChoice) {
              if (_downChoice == Constants.home) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const IndexPage(),
                  ),
                );
              } else if (_downChoice == Constants.load) {
                writeToFile(context);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => this.widget));
              } else if (_downChoice == Constants.viewspecies) {
                writeToFile(context);

                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            const SpeciesGallery()));
              } else if (_downChoice == Constants.saveskip) {
                regSP?.setBool("cskipped", true);
                _onDone();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        Declaration(list: items.toList()),
                  ),
                );
              } else if (_downChoice == Constants.saveclose) {
                // regSP.setBool("closed", true);
                // setFDValuesT();
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (BuildContext context) => FarmCordinates(),
                //   ),
                // );
              }
            },
            itemBuilder: (BuildContext context) {
              return Constants.newdownChoices.map((String _downChoice) {
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
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  widget.pageTitle ?? "Title",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // width: 170.0,
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: const BoxDecoration(
                                            //   borderRadius:
                                            //       BorderRadius.circular(10),
                                            //   border: Border.all(),
                                            borderRadius:
                                                const BorderRadius.all(
                                          Radius.circular(15.0),
                                        )),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        padding: const EdgeInsets.all(.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // const Row(
                                            //   children: <Widget>[
                                            //     Text(
                                            //       "P/ N",
                                            //       style: TextStyle(
                                            //           color: Colors.black54),
                                            //     ),
                                            //   ],
                                            // ),
                                            formFieldLabel(width: size.width * .9, "P/ N"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.50,
                                                          color: const Color(
                                                              0xFF000000)),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15.0),
                                                      )),
                                                  constraints:
                                                      const BoxConstraints(
                                                          minHeight: 60),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .95,
                                                  child: DropdownButton(
                                                    focusColor: fPrimaryColour,
                                                    isExpanded: true,
                                                    iconEnabledColor:
                                                        fPrimaryColour,
                                                    value: p_nValue,
                                                    items: p_nValues
                                                        .map((String iTValue) {
                                                      return DropdownMenuItem(
                                                        value: iTValue,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
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
                                                        _pn.text =
                                                            value.toString();
                                                      });
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
                                ],
                              ),
                            ),
                            !boxChecked
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin:
                                              //           const EdgeInsets.only(
                                              //         top: 10.0,
                                              //       ),
                                              //       child: const Row(
                                              //         children: <Widget>[
                                              //           Text("Select Species"),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),

                                              formFieldLabel(width: size.width * .9, "Select Species"),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.50,
                                                            color: const Color(
                                                                0xFF000000)),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(15.0),
                                                        )),
                                                    // width: MediaQuery.of(context)
                                                    //         .size
                                                    //         .width /
                                                    //     1.2,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6.0),
                                                    child: FutureBuilder<
                                                        List<TreeSpeciesJson>>(
                                                      future: mounted
                                                          ? mySFuture
                                                          : null,
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  List<
                                                                      TreeSpeciesJson>>
                                                              snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    fPrimaryColour),
                                                          );
                                                        } else if (snapshot
                                                            .hasData) {
                                                          return fileExists
                                                              ? Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.09,
                                                                  child: StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              state) {
                                                                    return DropdownButtonHideUnderline(
                                                                      child: DropdownButton<
                                                                          String>(
                                                                        value:
                                                                            _disV,
                                                                        items: _treeSpeciesValues.map((TreeSpeciesJson
                                                                            dvalue) {
                                                                          // fD = dvalue;
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                dvalue.species,
                                                                            child:
                                                                                Row(
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
                                                                        onChanged:
                                                                            (String?
                                                                                value) {
                                                                          _disV =
                                                                              value;
                                                                          _onmmdasChanged(
                                                                              value);
                                                                        },
                                                                      ),
                                                                    );
                                                                  }),
                                                                )
                                                              : Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.09,
                                                                  child: StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              state) {
                                                                    return DropdownButtonHideUnderline(
                                                                      child: DropdownButton<
                                                                          String>(
                                                                        value:
                                                                            _disV,
                                                                        items: _newtreeSpeciesValues.map((TreeSpeciesJson
                                                                            dvalue) {
                                                                          // fD = dvalue;
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                dvalue.species,
                                                                            child:
                                                                                Row(
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
                                                                        onChanged:
                                                                            (String?
                                                                                value) {
                                                                          _disV =
                                                                              value;
                                                                          _onmmdasChanged(
                                                                              value);
                                                                        },
                                                                      ),
                                                                    );
                                                                  }),
                                                                );
                                                        } else {
                                                          return const Text(
                                                            "Please sync data",
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
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            CheckboxListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              // title: const Text(
                              //   "Check box if species not found or if unknown",
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //   ),
                              // ),
                              title: formFieldLabel(width: size.width * .9, 
                                  "Check box if species not found or if unknown"),
                              value: boxChecked,
                              activeColor: fPrimaryColour,
                              onChanged: (bool? value) {
                                _onSpecChanged(value!);
                              },
                            ),
                            boxChecked
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelText:
                                              "(Enter name of species if not found)",
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.5)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0))),
                                      labelText:
                                          "(Enter name of species if not found)",
                                      controller: _specName,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter name of species'
                                              : null,
                                      readonly: boxChecked ? false : boxChecked,
                                    ),
                                  )
                                : const SizedBox(),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // const Row(
                                  //   children: <Widget>[
                                  //     Padding(
                                  //       padding: EdgeInsets.all(0.0),
                                  //       child: Text(
                                  //         "Take picture of species",
                                  //         style: TextStyle(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  formFieldLabel(width: size.width * .9, "Take picture of species"),
                                  Row(
                                    children: [
                                      SpeciesImage(_selectedImage),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row(
                                  //   children: <Widget>[
                                  //     Container(
                                  //       margin: EdgeInsets.only(
                                  //         top: 10.0,
                                  //       ),
                                  //       child: Row(
                                  //         children: <Widget>[
                                  //           Text("Size of tree (dbh)"),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  formFieldLabel(width: size.width * .9, "Year of Establishment"),
                                  TextFieldWidget(
                                    // maxLines: 5,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: '',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.5)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0))),
                                    controller: _sizeofTree,
                                    validator: (input) => input!.trim().isEmpty
                                        ? 'Please enter a value'
                                        : null,
                                  ),
                                ],
                              ),
                            ),

                            _pn.text == "Planted"
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // const Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: EdgeInsets.all(0.0),
                                        //       child: Text(
                                        //         "Year Planted",
                                        //         style: TextStyle(
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, "Year planted"),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: GestureDetector(
                                            child: isyearPlantedDate == true
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: fPrimaryColour,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    height: 40.0,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.0,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            const Icon(
                                                              Icons
                                                                  .arrow_drop_down_circle,
                                                              size: 22,
                                                              color: Color(
                                                                  0xFFffe423),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                yearPlantedInString ??
                                                                    "Year",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xFFf9f9f9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons
                                                            .arrow_drop_down_circle,
                                                        size: 18,
                                                        color: fPrimaryColour,
                                                      ),
                                                      Icon(
                                                        Icons.calendar_today,
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Select Year"),
                                                    content: Container(
                                                      // Need to use container to add size constraint.
                                                      width: 300,
                                                      height: 300,
                                                      // color: fPrimaryColour,
                                                      child: YearPicker(
                                                        firstDate:
                                                            DateTime(1800),
                                                        lastDate:
                                                            DateTime.now(),
                                                        initialDate:
                                                            DateTime.now(),
                                                        // save the selected date to _selectedDate DateTime variable.
                                                        // It's used to set the previous selected date when
                                                        // re-showing the dialog.
                                                        selectedDate:
                                                            _selectedYearPlantedDateYear ??
                                                                DateTime.now(),
                                                        onChanged:
                                                            (DateTime date) {
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
                                  )
                                : const SizedBox(),
                            _pn.text == "Natural"
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // const Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: EdgeInsets.all(0.0),
                                        //       child: Text(
                                        //         "Year Nurturing Started",
                                        //         style: TextStyle(
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        formFieldLabel(width: size.width * .9, 
                                            "Year nurturing started"),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: GestureDetector(
                                            child: isyearNurturingStartedDate ==
                                                    true
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: fPrimaryColour,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    height: 40.0,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.0,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            const Icon(
                                                              Icons
                                                                  .arrow_drop_down_circle,
                                                              size: 22,
                                                              color: Color(
                                                                  0xFFffe423),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                yearNurturingStartedInString ??
                                                                    "Year",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xFFf9f9f9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons
                                                            .arrow_drop_down_circle,
                                                        size: 18,
                                                        color: fPrimaryColour,
                                                      ),
                                                      Icon(
                                                        Icons.calendar_today,
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Select Year"),
                                                    content: Container(
                                                      // Need to use container to add size constraint.
                                                      width: 300,
                                                      height: 300,
                                                      // color: fPrimaryColour,
                                                      child: YearPicker(
                                                        firstDate:
                                                            DateTime(1800),
                                                        lastDate:
                                                            DateTime.now(),
                                                        initialDate:
                                                            DateTime.now(),
                                                        // save the selected date to _selectedDate DateTime variable.
                                                        // It's used to set the previous selected date when
                                                        // re-showing the dialog.
                                                        selectedDate:
                                                            _selectedYearNurturingStartedDateYear ??
                                                                DateTime.now(),
                                                        onChanged:
                                                            (DateTime date) {
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
                                  )
                                : const SizedBox(),

                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      backgroundColor: fPrimaryColour,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      // shadowColor: fPrimaryColour,
                                      side: const BorderSide(
                                          width: 1.0, color: fPrimaryColour),
                                    ),
                                    child: const Text(
                                      "Pick Cordinates",
                                      style: TextStyle(color: fPrimaryWhite),
                                    ),
                                    onPressed: () async {
                                      if (_pickedLocation != null) {
                                        print(
                                            "Picked is ${_pickedLocation?.latitude}");
                                        print(
                                            "Picked is ${_pickedLocation?.longitude}");
                                        setState(() {
                                          _lat = _pickedLocation?.latitude;
                                          _lng = _pickedLocation?.longitude;
                                          _acc = _pickedLocation?.accuracy;
                                        });
                                        overlayNotification(
                                            'Cordinates saved!', "positive",
                                            position: NotificationPosition.top);
                                      } else {
                                        overlayNotification(
                                            'GPS Accuracy must be 5m or below!',
                                            "negative");
                                      }
                                    },
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      NewLocationService(
                                        onSelectLatLng: _selectLatLng,
                                        // show: true,
                                      ),
                                      _lng != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  // width: 100,
                                                  child: const Text(
                                                    // 'location: ',
                                                    'Picked longitude: ',
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Container(
                                                  // width: 70.00,
                                                  child: Text(
                                                    "$_lng",
                                                    style: const TextStyle(
                                                        color: fPrimaryColour),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      _lat != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  // width: 100,
                                                  child: const Text(
                                                    // 'location: ',
                                                    'Picked latitude: ',
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Container(
                                                  // width: 70.00,
                                                  child: Text(
                                                    "$_lat",
                                                    style: const TextStyle(
                                                        color: fPrimaryColour),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  const SizedBox(
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                sortColumnIndex: 1,
                                sortAscending: sort,
                                showCheckboxColumn: true,
                                columnSpacing: 30.0,
                                columns: [
                                  const DataColumn(
                                    label: Text('P/N'),
                                  ),
                                  const DataColumn(
                                    label: Text('Size'),
                                  ),
                                  const DataColumn(
                                    label: Text('Species'),
                                  ),
                                  const DataColumn(
                                    label: Text('Species Photo'),
                                  ),
                                  const DataColumn(
                                    label: Text('Year Pl.'),
                                  ),
                                  const DataColumn(
                                    label: Text('Year Nurt.'),
                                  ),
                                  const DataColumn(
                                    label: Text('Lat'),
                                  ),
                                  const DataColumn(
                                    label: Text('Lng'),
                                  ),
                                ],
                                rows: mapItemToDataRows(items).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    await getspeciesbase64Img().then((value) {
                      if (_yearPlanted.isEmpty) {
                        setState(() {
                          _yearPlanted = "0";
                        });
                      }
                      if (_yearNurturingStarted.isEmpty) {
                        setState(() {
                          _yearNurturingStarted = "0";
                        });
                      }
                      if (!boxChecked && _disV == null) {
                        overlayNotification(
                            'Please select a species', "negative");
                      } else if (_speciesbase64Image.isEmpty) {
                        overlayNotification(
                            'Please take picture of species', "negative");
                      } else if (_lat == null && _lng == null) {
                        overlayNotification(
                            'Please pick cordinates', "negative");
                      } else if (_formKey.currentState!.validate()) {
                        items.add(
                          TreeInformationOption2Array(
                            pN: _pn.text,
                            sizeofTree: _sizeofTree.text,
                            species: !boxChecked ? _disV : _specName.text,
                            speciesImage: _speciesbase64Image,
                            yearPlanted: _yearPlanted,
                            yearNurturingStarted: _yearNurturingStarted,
                            treeLocation: TreeLocation(
                                latitude: _lat,
                                longitude: _lng,
                                pointID: uuid.v1()),
                          ),
                        );

                        print("Added items ${items.length} --- $items");
                        Timer(
                          const Duration(seconds: 1),
                          () {
                            setState(() {
                              _lat = null;
                              _lng = null;
                              regSP?.setString("speciesbase64Image", "");
                              _pn.clear();
                              _sizeofTree.clear();
                              _yearPlanted = "";
                              _yearNurturingStarted = "";
                            });
                          },
                        );
                      }
                    });
                  },
                  child: const Icon(
                    Icons.add,
                    color: fPrimaryColour,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50.00,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        elevation: 0.0,
                        backgroundColor: fPrimaryColour,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                        // shadowColor: fPrimaryColour,
                        side:
                            const BorderSide(width: 1.0, color: fPrimaryColour),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            color: fPrimaryWhite,
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () async {
                        regSP?.setBool("cskipped", false);
                        _onDone();
                        // print("Leaving items $items");
                        // print("Leaving itemslist ${items.toList()}");
                        if (items.length > 0) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  Declaration(list: items.toList()),
                            ),
                          );
                        } else {
                          overlayNotification(
                              'Please add some data!', "negative");
                        }
                        print("Entriesss second $items");
                      },
                    ),
                  ),
                ),
                TextButton(
                  onPressed: deleteSelected,
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
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

  Iterable<DataRow> mapItemToDataRows(List<TreeInformationOption2Array> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      return DataRow(
          selected: selectedPoints.contains(item),
          onSelectChanged: (t) {
            print("Onselect");
            onSelectedRow(t!, item);
          },
          cells: [
            DataCell(
              Text(item.pN.toString()),
              showEditIcon: true,
              onTap: () {
                _pn.text = item.pN.toString();
                popUpDialogue(
                  context,
                  "${item.pN}: Edit P/ N",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                //   borderRadius:
                                //       BorderRadius.circular(10),
                                //   border: Border.all(),
                                ),
                            width: MediaQuery.of(context).size.width * .55,
                            padding: const EdgeInsets.all(.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.50,
                                        color: const Color(0xFF000000)),
                                  ),
                                  constraints:
                                      const BoxConstraints(minHeight: 60),
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
                              item.pN = _pn.text;
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
              Text(
                item.sizeofTree.toString(),
              ),
              showEditIcon: true,
              onTap: () {
                _sizeofTree.text = item.sizeofTree.toString();
                popUpDialogue(
                  context,
                  "${item.sizeofTree}: Edit Size of tree",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "Size of tree",
                        // onSubmitted: () {},
                        type: TextInputType.number,
                        labelStyle: const TextStyle(color: fPrimaryColour),
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
                              item.sizeofTree = _sizeofTree.text;
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
              Text(item.species.toString()),
              showEditIcon: true,
              onTap: () {
                _specName.text = item.species.toString();
                popUpDialogue(
                  context,
                  "${item.species}: Edit Species",
                  imageIcon: editSpecies(item),
                );
                ;
              },
            ),
            DataCell(Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: SpeciesImage(
                () {},
                alreadyPic: item.speciesImage,
              ),
            )),
            DataCell(
              Text(
                item.pN == "Planted" ? item.yearPlanted.toString() : "N/A",
              ),
              showEditIcon: item.pN == "Planted" ? true : false,
              onTap: item.pN == "Planted"
                  ? () {
                      _pn.text = item.yearPlanted.toString();
                      popUpDialogue(
                        context,
                        "${item.yearPlanted}: Edit Year Planted",
                        imageIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            NewBoilerTextFieldWidget(
                              labelText: "Year Planted",
                              // onSubmitted: () {},
                              type: TextInputType.number,
                              labelStyle:
                                  const TextStyle(color: fPrimaryColour),
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
                                    item.yearPlanted = _pn.text;
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
                item.pN == "Natural"
                    ? item.yearNurturingStarted.toString()
                    : "N/A",
              ),
              showEditIcon: item.pN == "Natural" ? true : false,
              onTap: item.pN == "Natural"
                  ? () {
                      _pn.text = item.yearNurturingStarted.toString();
                      popUpDialogue(
                        context,
                        "${item.yearNurturingStarted}: Edit Year Nurturing Started",
                        imageIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            NewBoilerTextFieldWidget(
                              labelText: "Year Nurturing Started",
                              // onSubmitted: () {},
                              type: TextInputType.number,
                              labelStyle:
                                  const TextStyle(color: fPrimaryColour),
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
                                    item.yearNurturingStarted = _pn.text;
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
              Text(item.treeLocation!.latitude.toString()),
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
                                item.treeLocation?.latitude =
                                    _pickedLocation?.latitude;
                                item.treeLocation?.longitude =
                                    _pickedLocation?.longitude;
                                // item.treeLocation?.accuracy = _pickedLocation?.accuracy;
                              });
                              overlayNotification(
                                  'Cordinates saved!', "positive",
                                  position: NotificationPosition.top);
                            } else {
                              overlayNotification(
                                  'GPS Accuracy must be 5m or below!',
                                  "negative");
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
              Text(item.treeLocation!.longitude.toString()),
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
                                item.treeLocation?.latitude =
                                    _pickedLocation?.latitude;
                                item.treeLocation?.longitude =
                                    _pickedLocation?.longitude;
                                // item.treeLocation?.accuracy = _pickedLocation?.accuracy;
                              });
                              overlayNotification(
                                  'Cordinates saved!', "positive",
                                  position: NotificationPosition.top);
                            } else {
                              overlayNotification(
                                  'GPS Accuracy must be 5m or below!',
                                  "negative");
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

  Column editSpecies(TreeInformationOption2Array item) {
    final _newspecName = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select new species"),
        Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 0.50, color: const Color(0xFF000000)),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  )),
              // width: MediaQuery.of(context)
              //         .size
              //         .width /
              //     1.2,
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: FutureBuilder<List<TreeSpeciesJson>>(
                future: mounted ? mySFuture : null,
                builder:
                    (context, AsyncSnapshot<List<TreeSpeciesJson>> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    );
                  } else if (snapshot.hasData) {
                    return fileExists
                        ? Container(
                            // width: MediaQuery.of(context).size.width * .7,
                            child: StatefulBuilder(builder: (context, state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _disV,
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
                                    _disV = value;
                                    _onmmdasChanged(value!);

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
                                  value: _disV,
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
                                    _disV = value;
                                    _onmmdasChanged(value!);

                                    setState(() {
                                      _newspecName.text = value;
                                    });
                                  },
                                ),
                              );
                            }),
                          );
                  } else {
                    return const Text(
                      "Please sync data",
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        NewBoilerTextFieldWidget(
          labelText: "Click here to Type Species name ",
          // onSubmitted: () {},
          type: TextInputType.text,
          labelStyle: const TextStyle(color: fPrimaryColour),
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
                item.species = _newspecName.text;
              });
            }
          },
        )
      ],
    );
  }

  editValue(String columnName, String labelText,
      TextEditingController controller, columnSavedVal) {
    popUpDialogue(
      context,
      "$columnName: Edit $labelText",
      imageIcon: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment:
        //     CrossAxisAlignment.start,
        children: [
          NewBoilerTextFieldWidget(
            labelText: "$labelText",
            onSubmitted: () {},
            type: TextInputType.text,
            labelStyle: const TextStyle(color: fPrimaryColour),
            controller: controller,
            // validator: (input) =>
            //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
          ),
          LightButton(
            title: "Edit",
            onPress: () {
              Navigator.pop(context);

              setState(() {
                columnSavedVal = controller.text;
              });
            },
          )
        ],
      ),
    );
  }
}
