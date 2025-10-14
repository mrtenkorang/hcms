import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/treespecies.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/treeinformationoption0arraydetails.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EditSpeciesPopUp extends StatefulWidget {
  final item;
  const EditSpeciesPopUp({Key? key, this.item}) : super(key: key);

  @override
  State<EditSpeciesPopUp> createState() => _EditSpeciesPopUpState();
}

class _EditSpeciesPopUpState extends State<EditSpeciesPopUp> {
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
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<TreeSpeciesJson>> getLocalDistricts(BuildContext context) async {
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

 specFileInit() {
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

  void setTDValues() async {
    await regSP?.setString("c2treeplantationDetail", _encodedKeep!);
    print("Reg 2 shared preference worked");
  }

  convertu() {
    final String encodedData = TreeInformationOption0Array.encode(items);
    _encodedKeep = encodedData;
    final List<TreeInformationOption0Array> decodedData =
        TreeInformationOption0Array.decode(encodedData);

    setTDValues();
    print("Items Plantation data $items");
    print("Decoded Plantation data $decodedData");
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
    print("Delete working now");
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
      jsonFile = new File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        this.setState(
            () => fileContent = json.decode(jsonFile!.readAsStringSync()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select new "),
        !boxChecked
            ? Row(
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
                      future: mounted ? mySFuture : null,
                      builder: (context,
                          AsyncSnapshot<List<TreeSpeciesJson>> snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(fPrimaryColour),
                          );
                        else if (snapshot.hasData)
                          return fileExists
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.09,
                                  child: StatefulBuilder(
                                      builder: (context, state) {
                                    return DropdownButtonHideUnderline(
                                      child: new DropdownButton<String>(
                                        value: _disV,
                                        items: _treeSpeciesValues
                                            .map((TreeSpeciesJson dvalue) {
                                          // fD = dvalue;
                                          return new DropdownMenuItem<String>(
                                            value: dvalue.species,
                                            child: new Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
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
                                  child: StatefulBuilder(
                                      builder: (context, state) {
                                    return DropdownButtonHideUnderline(
                                      child: new DropdownButton<String>(
                                        value: _disV,
                                        items: _newtreeSpeciesValues
                                            .map((TreeSpeciesJson dvalue) {
                                          // fD = dvalue;
                                          return new DropdownMenuItem<String>(
                                            value: dvalue.species,
                                            child: new Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
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
              )
            :
            // Text("Or type in new "),
            NewBoilerTextFieldWidget(
                labelText: "Species",
                // onSubmitted: () {},
                type: TextInputType.text,
                labelStyle: TextStyle(color: fPrimaryColour),
                controller: _specName,
                // validator: (input) =>
                //     input!.trim().isEmpty ? 'Please enter Structure ID' : null,
              ),
        new CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Text(
            "Check box to type",
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
        LightButton(
          title: "Edit",
          onPress: () {
            Navigator.pop(context);

            if (_specName.text.trim().isNotEmpty) {
              setState(() {
                widget.item.speciesPlanted = _specName.text;
              });
            }
          },
        )
      ],
    );
  }
}
