import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/treedetails.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SeedlingFarmer extends StatefulWidget {
  @override
  _SeedlingFarmerState createState() => _SeedlingFarmerState();
}

class _SeedlingFarmerState extends State<SeedlingFarmer> {
  final _formKey = GlobalKey<FormState>();

  final _communityName = TextEditingController();
  final _farmerfirstName = TextEditingController();
  final _farmerotherName = TextEditingController();
  final _farmersurName = TextEditingController();
  final _farmerContact = TextEditingController();
  String? _farmerGender;

  bool errorMessage = false;

  int? selectedFarmerRadioGender;

  void setFDValuesT() {
    regSP?.setString('smfarmerfirstName', _farmerfirstName.text);
    regSP?.setString('smfarmerotherName', _farmerotherName.text);
    regSP?.setString('smfarmersurName', _farmersurName.text);
    regSP?.setString('smfarmerContact', _farmerContact.text);
    regSP?.setString(
        'smfarmerGender',
        _farmerGender == "male"
            ? 'male'
            : _farmerGender == "female"
                ? 'female'
                : '');
    regSP?.setString(
        'smComName', boxChecked ? _communityName.text : _community!);

    print("done setting");
  }

  // authenticatingLoader() {
  //   showDialog(
  //       barrierColor: Colors.white38,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           child: Center(
  //             child: SpinKitChasingDots(
  //               color: Colors.orange,
  //               size: 80.0,
  //             ),
  //           ),
  //         );
  //       });
  // }

  var commUrl = "$stageBaseUrl/communityapi/";

  File? commjsonFile;
  File? regionjsonFile;
  Directory? dir;
  String commfileName = "community.json";
  bool commfileExists = false;
  var commfileContent;
  List<CommunityJson> _newcommValues = [];
  List<CommunityJson> _commValues = [];

  void createCommFile(var content, Directory dir, String fileName) {
    print("Creating Community file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<CommunityJson>> writeToCommFile(BuildContext ctx) async {
    print("Writing to community file! $commfileExists");
    if (commfileExists) {
      print("Community File exists $commfileExists");

      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Community");

          print("content $items");
          print("object");

          // var content = {key: items};

          var commjsonFileContent =
              await json.decode(await commjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile?.writeAsString(json.encode(commjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is first community");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("Community File does not exist! $commfileExists");
      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Community");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createCommFile(items, dir!, commfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          getLocalCommValues(ctx);
        }
      } on SocketException {
        print("Error is second comm");
        getLocalCommValues(ctx);
      }
    }
    commfileExists
        ? commfileContent =
            await json.decode(await commjsonFile!.readAsString())
        : null;
    print(commfileContent);

    return commfileExists
        ? _commValues =
            commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList()
        : _newcommValues;
  }

  Future<List<CommunityJson>> getLocalCommValues(BuildContext context) async {
    print("doing clocal comm");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/community.json');
    final body = json.decode(data);

    _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();

    return _newcommValues;
  }

  String? _community;

  void _oncommChanged(String commVal) {
    setState(() {
      _community = commVal;
    });
  }

  commFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      commjsonFile = File(dir!.path + "/" + commfileName);
      commfileExists = commjsonFile!.existsSync();
      if (commfileExists)
        commfileContent = await json.decode(await commjsonFile!.readAsString());
    });

    return commfileContent;
  }

  Future<List<CommunityJson>>? myCFuture;

  List<String> _commFound = [];
  bool boxChecked = false;

  onSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _commFound.add(selectedEst);
      } else {
        _commFound.remove(selectedEst);
      }
    });
  }

  void _onWLChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedFarmerRadioGender = 0;

    commFileInit();
    myCFuture = writeToCommFile(this.context);
  }

  setFarmerSelectedGender(val) {
    setState(() {
      selectedFarmerRadioGender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Tree Seedling Monitoring",
          style: TextStyle(color: fPrimaryWhite),
        ),
        actions: [
          Tooltip(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                child: Icon(Icons.home, color: fPrimaryWhite),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => IndexPage(),
                  ),
                ),
              ),
            ),
            message: "Takes you back to homepage",
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       "Farmer Details",
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 24.0),
                                        //     ),
                                        //   ],
                                        // ),
                                        titleOne("Farmer Details"),
                                        formFieldLabel(width: size.width * .9, "Farmer First Name"),
                                        TextFieldWidget(
                                          decoration: InputDecoration(
                                              labelText: "Farmer First Name"),
                                          controller: _farmerfirstName,
                                          validator: (input) =>
                                              input!.trim().isEmpty
                                                  ? 'Please enter first name'
                                                  : null,
                                        ),
                                        formFieldLabel(width: size.width * .9, "Other Names"),
                                        TextFieldWidget(
                                          decoration: InputDecoration(
                                              labelText: "Other Names"),
                                          controller: _farmerotherName,
                                          // validator: (input) => input.trim().isEmpty
                                          //     ? 'Please enter name'
                                          //     : null,
                                        ),
                                        formFieldLabel(width: size.width * .9, "Surname"),
                                        TextFieldWidget(
                                          decoration: InputDecoration(
                                              labelText: "Surname Name"),
                                          controller: _farmersurName,
                                          validator: (input) =>
                                              input!.trim().isEmpty
                                                  ? 'Please enter surname'
                                                  : null,
                                        ),
                                        formFieldLabel(width: size.width * .9, "Contact"),
                                        TextFieldWidget(
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              labelText: "Contact"),
                                          controller: _farmerContact,
                                          validator: (input) => input!
                                                  .trim()
                                                  .isEmpty
                                              ? 'Please enter a contact number'
                                              : null,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                      "Gender",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ButtonBar(
                                                alignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      GenderRadioButton(
                                                        value: 1,
                                                        group:
                                                            selectedFarmerRadioGender,
                                                        selected: (val) {
                                                          print(val);
                                                          setState(() {
                                                            selectedFarmerRadioGender =
                                                                val;
                                                            print(val);
                                                            _farmerGender =
                                                                "male";
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Male",
                                                        // style: TextStyle(
                                                        //     color: Color(0xFFf9f9f9)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      GenderRadioButton(
                                                        value: 2,
                                                        group:
                                                            selectedFarmerRadioGender,
                                                        selected: (val) {
                                                          print(val);
                                                          setState(() {
                                                            selectedFarmerRadioGender =
                                                                val;
                                                            _farmerGender =
                                                                "female";
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Female",
                                                        // style: TextStyle(
                                                        //     color:
                                                        //         Color(0xFFf9f9f9))
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        !boxChecked
                                            ? Container(
                                                // color: Color(0xFFFFFFFF),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: 8.0,
                                                        left: .0,
                                                        right: .0,
                                                        bottom: 18.0,
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom: 14.0,
                                                                ),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Text(
                                                                        "Select Community"),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width:
                                                                          0.50,
                                                                      color: Color(
                                                                          0xFF000000)),
                                                                ),
                                                                // width: MediaQuery.of(context)
                                                                //         .size
                                                                //         .width /
                                                                //     1.09,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            6.0),
                                                                child: FutureBuilder<
                                                                    List<
                                                                        CommunityJson>>(
                                                                  future: mounted
                                                                      ? myCFuture
                                                                      : null,
                                                                  builder: (context,
                                                                      AsyncSnapshot<
                                                                              List<CommunityJson>>
                                                                          snapshot) {
                                                                    if (snapshot
                                                                            .connectionState !=
                                                                        ConnectionState
                                                                            .done)
                                                                      return CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(fPrimaryColour),
                                                                      );
                                                                    else if (!snapshot
                                                                        .hasData)
                                                                      return Text(
                                                                          "Operation failed. Sync to get data.",
                                                                          style:
                                                                              TextStyle(color: fBackgroundColour));
                                                                    else if (snapshot
                                                                        .hasData)
                                                                      return commfileExists
                                                                          ? Container(
                                                                              // width: MediaQuery.of(context).size.width / 1.09,
                                                                              child: StatefulBuilder(builder: (context, state) {
                                                                                return DropdownButtonHideUnderline(
                                                                                  child: DropdownButton<String>(
                                                                                    value: _community,
                                                                                    items: _commValues.map((CommunityJson dvalue) {
                                                                                      // fD = dvalue;
                                                                                      return DropdownMenuItem<String>(
                                                                                        value: dvalue.name,
                                                                                        child: Row(
                                                                                          children: <Widget>[
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(10.0),
                                                                                              child: Text(
                                                                                                "${dvalue.name}",
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }).toList(),
                                                                                    onChanged: (String? value) {
                                                                                      _community = value;
                                                                                      _oncommChanged(value!);

                                                                                      print("Community"
                                                                                          "$_community");
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              }),
                                                                            )
                                                                          : SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 1.09,
                                                                              child: StatefulBuilder(builder: (context, state) {
                                                                                return DropdownButtonHideUnderline(
                                                                                  child: DropdownButton<String>(
                                                                                    value: _community,
                                                                                    items: _newcommValues.map((CommunityJson dvalue) {
                                                                                      // fD = dvalue;
                                                                                      return DropdownMenuItem<String>(
                                                                                        value: dvalue.name,
                                                                                        child: Row(
                                                                                          children: <Widget>[
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(10.0),
                                                                                              child: Text(
                                                                                                "${dvalue.name}",
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }).toList(),
                                                                                    onChanged: (String? value) {
                                                                                      _community = value;
                                                                                      _oncommChanged(value!);

                                                                                      print("Community"
                                                                                          "$_community");
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
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .replay),
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    myCFuture =
                                                                        writeToCommFile(
                                                                            this.context);
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        CheckboxListTile(
                                          contentPadding:
                                              EdgeInsets.only(right: 0),
                                          title: Text(
                                            "Check box if community not found",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: boxChecked,
                                          activeColor: fPrimaryColour,
                                          onChanged: (bool? value) {
                                            _onWLChanged(value!);
                                          },
                                        ),
                                        boxChecked
                                            ? TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "(Enter community if not found)"),
                                                    labelText:
                                                        "(Enter community if not found)",
                                                controller: _communityName,
                                                validator: (input) => input!
                                                        .trim()
                                                        .isEmpty
                                                    ? 'Please enter community'
                                                    : null,
                                                readonly: boxChecked
                                                    ? false
                                                    : boxChecked,
                                              )
                                            : SizedBox(),
                                        SizedBox(height: 30.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 50.00,
                                              child: ElevatedButton(
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
                                                child: Text(
                                                  "Next",
                                                  style: TextStyle(
                                                      color: fPrimaryWhite,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                onPressed: () async {
                                                  if (_farmerGender != "male" &&
                                                      _farmerGender !=
                                                          "female") {
                                                    overlayNotification(
                                                        'Farmer gender not selected',
                                                        "negative");
                                                  } else if (_community ==
                                                          null &&
                                                      !boxChecked) {
                                                    overlayNotification(
                                                        'Please select a community',
                                                        "negative");
                                                  } else if (_formKey
                                                      .currentState!
                                                      .validate()) {
                                                    setFDValuesT();
                                                    // regSP.setBool(
                                                    //     "farmerskipped", false);
                                                    Navigator.of(context).push(
                                                      CupertinoPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            TreeDetails(),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
