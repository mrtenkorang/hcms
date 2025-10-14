import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/apimodels/treespecies.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/treeinformationoption0arraydetails.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/declaration.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class C2TreeInformation extends StatefulWidget {
  final String? pageTitle;

  const C2TreeInformation({Key? key, this.pageTitle}) : super(key: key);
  @override
  _C2TreeInformationState createState() => _C2TreeInformationState();
}

class _C2TreeInformationState extends State<C2TreeInformation> {
  final _formKey = GlobalKey<FormState>();

  File? jsonFile;
  Directory? dir;
  String fileName = "treespecies.json";
  bool fileExists = false;
  var fileContent;
  bool confileContent = false;
  List<TreeSpeciesJson> _newtreeSpeciesValues = [];
  List<TreeSpeciesJson> _treeSpeciesValues = [];

  List<TreeInformationOption0Array> items = [];
  List<TreeInformationOption0Array> selectedPoints = [];
  String? _encodedKeep;

  final _numTrees = TextEditingController();
  final _plantingDistance = TextEditingController();
  // final _yoEstablishment = TextEditingController();
  String? _yoEstablishment;
  bool isyoEstablishmentDate = false;
  String? yoEstablishmentInString;
  DateTime? _selectedDateYear;
  bool sort = false;

  String? _disV;
  // Future myDFuture;
  File? _pickedImage;
  String? _speciesbase64Image;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void createFile(var content, Directory dir, String fileName) {
    debugPrint("Creating file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<TreeSpeciesJson>> getLocalDistricts(BuildContext context) async {
    debugPrint("this place working");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/treespecies.json');
    final body = json.decode(data);

    _newtreeSpeciesValues =
        body.map<TreeSpeciesJson>(TreeSpeciesJson.fromJson).toList();

    return _newtreeSpeciesValues;
  }

  var treespeciesUrl = "$stageBaseUrl/treespeciesapi/";

  Future<List<TreeSpeciesJson>> writeToFile(BuildContext ctx) async {
    debugPrint("Writing to file!");
    if (fileExists) {
      debugPrint("File exists");

      try {
        var response = await http.get(Uri.parse(treespeciesUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("responselr");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var jsonFileContent = json.decode(jsonFile!.readAsStringSync());
          jsonFileContent.clear();
          jsonFileContent.addAll(items);
          jsonFile?.writeAsString(json.encode(jsonFileContent));
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is ");
      }
    } else {
      debugPrint("File does not exist!");
      try {
        var response = await http.get(Uri.parse(treespeciesUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("responselr");

          debugPrint("content $items");
          debugPrint("object");
          createFile(items, dir!, fileName);
        } else {
          debugPrint("didn't work here");
          getLocalDistricts(ctx);
        }
      } on SocketException {
        debugPrint("Error is ");
        getLocalDistricts(ctx);
      }
    }
    fileExists
        ? fileContent = await json.decode(await jsonFile!.readAsString())
        : null;
    debugPrint(fileContent);

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

  void _onmmdasChanged(String mmdasVal) {
    setState(() {
      _disV = mmdasVal;
    });
  }

  void setTDValues() async {
    await regSP?.setString("c2treeplantationDetail", _encodedKeep!);
    debugPrint("Reg 2 shared preference worked");
  }

  convertu() {
    final String encodedData = TreeInformationOption0Array.encode(items);
    _encodedKeep = encodedData;
    final List<TreeInformationOption0Array> decodedData =
        TreeInformationOption0Array.decode(encodedData);

    setTDValues();
    debugPrint("Items Plantation data $items");
    debugPrint("Decoded Plantation data $decodedData");
  }

  onSelectedRow(bool selected, TreeInformationOption0Array user) async {
    setState(() {
      if (selected) {
        selectedPoints.add(user);
      } else {
        selectedPoints.remove(user);
      }
    });
  }

  deleteSelected() async {
    debugPrint("Delete working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (selectedPoints.isNotEmpty) {
          List<TreeInformationOption0Array> temp = [];
          temp.addAll(selectedPoints);
          for (TreeInformationOption0Array points in temp) {
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

  Future<List<TreeSpeciesJson>>? mySFuture;

  final _specName = TextEditingController();
  // final _newspecName = TextEditingController();
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

  void getspeciesbase64Img() async {
    _speciesbase64Image = (regSP?.getString('speciesbase64Image') ?? "");
  }

  @override
  void initState() {
    super.initState();
    specFileInit();
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColour,
      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: const Text(
      //     "Tree Information",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: const Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == Constants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => const IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.load) {
      //           writeToFile(context);

      //           Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => this.widget));
      //         } else if (_downChoice == Constants.viewspecies) {
      //           // writeToFile(context);

      //           Navigator.push(
      //               context,
      //               CupertinoPageRoute(
      //                   builder: (BuildContext context) =>
      //                       const SpeciesGallery()));
      //         } else if (_downChoice == Constants.saveskip) {
      //           regSP?.setBool("cskipped", true);
      //           _onDone();
      //           Navigator.of(context).push(
      //             CupertinoPageRoute(
      //               builder: (BuildContext context) =>
      //                   Declaration(list: items.toList()),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.saveclose) {
      //           // regSP.setBool("closed", true);
      //           // setFDValuesT();
      //           // Navigator.of(context).push(
      //           //   CupertinoPageRoute(
      //           //     builder: (BuildContext context) => FarmCordinates(),
      //           //   ),
      //           // );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return Constants.newdownChoices.map((String _downChoice) {
      //           return PopupMenuItem<String>(
      //             value: _downChoice,
      //             child: Container(
      //               margin: const EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: const TextStyle(color: Color(0xFFFFFFFF)),
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
                  "Tree information".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                PopupMenuButton<String>(
                  offset: const Offset(2.00, 3.00),
                  color: Colors.black,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: primaryWhite,
                    size: 40.0,
                  ),
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
                      // writeToFile(context);

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
          ),
          Align(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Container(
                              // width: 170.0,
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  !boxChecked
                                      ? Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    // Row(
                                                    //   children: <Widget>[
                                                    //     Container(
                                                    //       margin: EdgeInsets.only(
                                                    //         top: 14.0,
                                                    //       ),
                                                    //       child: Row(
                                                    //         children: <Widget>[
                                                    //           Text("Select Species"),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    formFieldLabel(width: size.width * .9, 
                                                        "Select species"),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      width:
                                                                          0.50,
                                                                      color: const Color(
                                                                          0xFF000000)),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        15.0),
                                                                  )),
                                                          // width: MediaQuery.of(context)
                                                          //         .size
                                                          //         .width /
                                                          //     1.2,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: FutureBuilder<
                                                              List<
                                                                  TreeSpeciesJson>>(
                                                            future: mounted
                                                                ? mySFuture
                                                                : null,
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        List<
                                                                            TreeSpeciesJson>>
                                                                    snapshot) {
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return const CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      fPrimaryColour),
                                                                );
                                                              } else if (snapshot
                                                                  .hasData) {
                                                                return fileExists
                                                                    ? Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.09,
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: _disV,
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
                                                                                _disV = value;
                                                                                _onmmdasChanged(value!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                      )
                                                                    : Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.09,
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: _disV,
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
                                                                                _disV = value;
                                                                                _onmmdasChanged(value!);
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                            validator: (input) => input!
                                                    .trim()
                                                    .isEmpty
                                                ? 'Please enter name of species'
                                                : null,
                                            readonly:
                                                boxChecked ? false : boxChecked,
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
                                        formFieldLabel(width: size.width * .9, 
                                            "Take picture of species"),
                                        Row(
                                          children: [
                                            SpeciesImage(_selectedImage),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   children: <Widget>[
                                        //     Container(
                                        //       margin: EdgeInsets.only(
                                        //         top: 14.0,
                                        //       ),
                                        //       child: Row(
                                        //         children: <Widget>[
                                        //           Text("No. of Trees (Stocking)"),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, 
                                            "No. of Trees (Stocking)"),
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   children: <Widget>[
                                        //     Container(
                                        //       margin: EdgeInsets.only(
                                        //         top: 14.0,
                                        //       ),
                                        //       child: Row(
                                        //         children: <Widget>[
                                        //           Text("Planting Distance (Spacing)"),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, 
                                            "Planting Distance (Spacing)"),
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(0.0),
                                        //       child: Text(
                                        //         "Year of Establishment",
                                        //         style: TextStyle(
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, "Year of Establishment"),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: GestureDetector(
                                            child: isyoEstablishmentDate == true
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
                                                                yoEstablishmentInString ??
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
                                                            _selectedDateYear ??
                                                                DateTime.now(),
                                                        onChanged:
                                                            (DateTime date) {
                                                          // close the dialog when year is selected.
                                                          Navigator.pop(
                                                              context);

                                                          // Do something with the dateTime selected.
                                                          // Remember that you need to use dateTime.year to get the year
                                                          debugPrint(
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
                                                            debugPrint(
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 14.0,
                                              ),
                                              child: const Row(
                                                children: <Widget>[
                                                  Text("Remarks"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextFieldWidget(
                                          // maxLines: 5,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              labelText: '',
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 0.5)),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0))),
                                          controller: TextEditingController(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    // child: Divider(),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "List of Inputs".toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              sortColumnIndex: 1,
                              sortAscending: sort,
                              showCheckboxColumn: true,
                              columnSpacing: 30.0,
                              columns: const [
                                DataColumn(
                                  label: Text('Species'),
                                ),
                                DataColumn(
                                  label: Text('Species Photo'),
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
                              rows: mapItemToDataRows(items).toList(),
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
                          getspeciesbase64Img();

                          if (_yoEstablishment!.isEmpty) {
                            setState(() {
                              _yoEstablishment = "0";
                            });
                          }
                          if (!boxChecked && _disV == null) {
                            overlayNotification(
                                'Please select species', "negative");
                          } else if (_speciesbase64Image!.isEmpty) {
                            overlayNotification(
                                'Please take picture of species', "negative");
                          } else if (_formKey.currentState!.validate()) {
                            items.add(
                              TreeInformationOption0Array(
                                  numberOfTrees: _numTrees.text,
                                  plantingDistance: _plantingDistance.text,
                                  speciesPlanted:
                                      !boxChecked ? _disV! : _specName.text,
                                  speciesImage: _speciesbase64Image,
                                  yearOfEstablishment:
                                      _yoEstablishment.toString()),
                            );

                            debugPrint("Added items ${items.length} --- $items");
                            setState(() {});
                          }
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
                              side: const BorderSide(
                                  width: 1.0, color: fPrimaryColour),
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
                              // debugPrint("Leaving items $items");
                              // debugPrint("Leaving itemslist ${items.toList()}");
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
                              debugPrint("Entriesss second $items");
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _priceController.dispose();
    // _itemController.dispose();
  }

  Iterable<DataRow> mapItemToDataRows(List<TreeInformationOption0Array> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      return DataRow(
          selected: selectedPoints.contains(item),
          onSelectChanged: (t) {
            debugPrint("Onselect");
            onSelectedRow(t!, item);
          },
          cells: [
            DataCell(
              Text(item.speciesPlanted ?? "species"),
              showEditIcon: true,
              onTap: () {
                // debugPrint('Selected ${item.speciesPlanted.toString()}');
                // editValue(
                //   "P/N",
                //   "PN",
                //   _specName,
                //   item.speciesPlanted,
                // );

                _specName.text = item.speciesPlanted.toString();
                popUpDialogue(
                  context,
                  "${item.speciesPlanted}: Edit Species",
                  imageIcon: editSpecies(item),
                );
                // setState(() {
                //   item.speciesPlanted = "now";
                // });
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
                item.numberOfTrees ?? "numberOfTrees",
              ),
              showEditIcon: true,
              onTap: () {
                _numTrees.text = item.numberOfTrees.toString();
                popUpDialogue(
                  context,
                  "${item.numberOfTrees}: Edit No. of Trees (Stocking)",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "No. of Trees (Stocking)",
                        // onSubmitted: () {},
                        type: TextInputType.number,
                        labelStyle: const TextStyle(color: fPrimaryColour),
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
                              item.numberOfTrees = _numTrees.text;
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
              Text(item.yearOfEstablishment ?? "yearEstablished"),
              showEditIcon: true,
              onTap: () {
                _specName.text = item.yearOfEstablishment.toString();
                popUpDialogue(
                  context,
                  "${item.yearOfEstablishment}: Edit Year of Establishment",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "Year of Establishment",
                        // onSubmitted: () {},
                        type: TextInputType.datetime,
                        labelStyle: const TextStyle(color: fPrimaryColour),
                        controller: _specName,
                        // validator: (input) =>
                        //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
                      ),
                      LightButton(
                        title: "Edit",
                        onPress: () {
                          Navigator.pop(context);

                          if (_specName.text.trim().isNotEmpty) {
                            setState(() {
                              item.yearOfEstablishment = _specName.text;
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
              Text(item.plantingDistance ?? "plantingDistance"),
              showEditIcon: true,
              onTap: () {
                _plantingDistance.text = item.plantingDistance.toString();
                popUpDialogue(
                  context,
                  "${item.plantingDistance}: Edit Planting distance",
                  imageIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NewBoilerTextFieldWidget(
                        labelText: "Planting distance",
                        // onSubmitted: () {},
                        type: TextInputType.number,
                        labelStyle: const TextStyle(color: fPrimaryColour),
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
                              item.plantingDistance = _plantingDistance.text;
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

  Column editSpecies(TreeInformationOption0Array item) {
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
                border: Border.all(width: 0.50, color: const Color(0xFF000000)),
              ),
              // width: MediaQuery.of(context)
              //         .size
              //         .width /
              //     1.2,
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: FutureBuilder<List<TreeSpeciesJson>>(
                future: mounted ? mySFuture : null,
                builder:
                    (context, AsyncSnapshot<List<TreeSpeciesJson>> snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    );
                  else if (snapshot.hasData)
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
                  else
                    return const Text(
                      "Please sync data",
                    );
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
                item.speciesPlanted = _newspecName.text;
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
            // onSubmitted: () {},
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
