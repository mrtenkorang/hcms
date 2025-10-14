import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/trainingLog/participantDetails.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TrainingLog extends StatefulWidget {
  const TrainingLog({Key? key}) : super(key: key);

  @override
  _SeedlingMonitoringState createState() => _SeedlingMonitoringState();
}

class _SeedlingMonitoringState extends State<TrainingLog> {
  final _formKey = GlobalKey<FormState>();

// "$stageBaseUrl/searchfarmer/?contact=0248823823&form=alternative

  final _communityName = TextEditingController();
  final _topic = TextEditingController();
  final _durHours = TextEditingController();
  final _durMins = TextEditingController();
  final _trainerName = TextEditingController();
  final _trainerOrg = TextEditingController();

  int? _communityVal;

  String? _visitDate;
  String? _visitNumber;

  bool isVisitDate = false;
  String? visitDateYearInString;

  bool errorMessage = false;

  int? selectedVisitRadio;

  void setTLValuesT() {
    regSP?.setString(
        'tLComName', boxChecked ? _communityName.text : _community!);
    regSP?.setString('tLTopic', _topic.text);
    regSP?.setString('tLDurationHour', _durHours.text);
    regSP?.setString('tLDurationMins', _durMins.text);
    regSP?.setString('tLTrainerName', _trainerName.text);
    regSP?.setString('tLTrainerOrg', _trainerOrg.text);
    regSP?.setString('tLVisitDate', _visitDate!);
    print("done setting");
  }

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
    File file = new File(dir.path + "/" + fileName);
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
      // districtjsonFile.writeAsString(json.encode(districtjsonFileContent));

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
          // districtjsonFile.writeAsString(json.encode(districtjsonFileContent));

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
      commjsonFile = new File(dir!.path + "/" + commfileName);
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

    commFileInit();
    myCFuture = writeToCommFile(this.context);
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
          "Training Log",
          style: TextStyle(color: fPrimaryWhite),
        ),
        actions: [
          Tooltip(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                child: Icon(Icons.home, color: fPrimaryWhite),
                onTap: () => Navigator.of(context).push(
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
        child: Center(
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Event Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ],
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
                                                                EdgeInsets.only(
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
                                                                  width: 0.50,
                                                                  color: Color(
                                                                      0xFF000000)),
                                                            ),
                                                            // width: MediaQuery.of(context)
                                                            //         .size
                                                            //         .width /
                                                            //     1.09,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6.0),
                                                            child: FutureBuilder<
                                                                List<
                                                                    CommunityJson>>(
                                                              future: mounted
                                                                  ? myCFuture
                                                                  : null,
                                                              builder: (context,
                                                                  AsyncSnapshot<
                                                                          List<
                                                                              CommunityJson>>
                                                                      snapshot) {
                                                                if (snapshot
                                                                        .connectionState !=
                                                                    ConnectionState
                                                                        .done)
                                                                  return CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<Color>(
                                                                            fPrimaryColour),
                                                                  );
                                                                else if (!snapshot
                                                                    .hasData)
                                                                  return Text(
                                                                      "Operation failed. Sync to get data.",
                                                                      style: TextStyle(
                                                                          color:
                                                                              fBackgroundColour));
                                                                else if (snapshot
                                                                    .hasData)
                                                                  return commfileExists
                                                                      ? Container(
                                                                          // width: MediaQuery.of(context).size.width / 1.09,
                                                                          child:
                                                                              StatefulBuilder(builder: (context, state) {
                                                                            return DropdownButtonHideUnderline(
                                                                              child: new DropdownButton<String>(
                                                                                value: _community,
                                                                                items: _commValues.map((CommunityJson dvalue) {
                                                                                  // fD = dvalue;
                                                                                  return new DropdownMenuItem<String>(
                                                                                    value: dvalue.name,
                                                                                    child: new Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: new Text(
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

                                                                                  _commValues.map((CommunityJson ccvalue) {
                                                                                    if (ccvalue.name == value) {
                                                                                      print(ccvalue.comcode);

                                                                                      setState(() {
                                                                                        _communityVal = ccvalue.comcode;

                                                                                        // opdagSP.setString(
                                                                                        //     'corptown',
                                                                                        //     _communityValue);

                                                                                        print("Com COm COm $_communityVal");

                                                                                        regSP?.setInt('tLcommunityValue', _communityVal!);
                                                                                      });
                                                                                    }
                                                                                  }).toString();
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
                                                                                value: _community,
                                                                                items: _newcommValues.map((CommunityJson dvalue) {
                                                                                  // fD = dvalue;
                                                                                  return new DropdownMenuItem<String>(
                                                                                    value: dvalue.name,
                                                                                    child: new Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: new Text(
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

                                                                                  _commValues.map((CommunityJson ccvalue) {
                                                                                    if (ccvalue.name == value) {
                                                                                      print(ccvalue.comcode);

                                                                                      setState(() {
                                                                                        _communityVal = ccvalue.comcode;

                                                                                        // opdagSP.setString(
                                                                                        //     'corptown',
                                                                                        //     _communityValue);

                                                                                        print("Com COm COm $_communityVal");

                                                                                        regSP?.setInt('tLcommunityValue', _communityVal!);
                                                                                      });
                                                                                    }
                                                                                  }).toString();
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
                                                            icon: Icon(
                                                                Icons.replay),
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
                                    // new CheckboxListTile(
                                    //   contentPadding: EdgeInsets.only(right: 0),
                                    //   title: Text(
                                    //     "Check box if community not found",
                                    //     style: TextStyle(
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    //   value: boxChecked,
                                    //   activeColor: fPrimaryColour,
                                    //   onChanged: (bool value) {
                                    //     _onWLChanged(value);
                                    //   },
                                    // ),
                                    // boxChecked
                                    //     ? TextFieldWidget(
                                    //         keyboardType: TextInputType.text,
                                    //         decoration: InputDecoration(
                                    //             labelText:
                                    //                 "(Enter community if not found)"),
                                    //         controller: _communityName,
                                    //         validator: (input) =>
                                    //             input.trim().isEmpty
                                    //                 ? 'Please enter community'
                                    //                 : null,
                                    //         readOnly:
                                    //             boxChecked ? false : boxChecked,
                                    //       )
                                    //     : SizedBox(),
                                    formFieldLabel(width: size.width * .9, "Topic"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration:
                                          InputDecoration(labelText: "Topic"),
                                      controller: _topic,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter topic'
                                              : null,
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
                                                  "Date event began",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: GestureDetector(
                                              child: isVisitDate == true
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color: fPrimaryColour,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      height: 40.0,
                                                      width:
                                                          MediaQuery.of(context)
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                visitDateYearInString ??
                                                                    "visit date",
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
                                                  isVisitDate = true;
                                                  visitDateYearInString =
                                                      '${date.year}-${date.month}-${date.day}';
                                                  setState(() {
                                                    _visitDate =
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
                                      margin: EdgeInsets.only(top: 0),
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
                                                    "Event duration",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 0),
                                      child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              child: TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: "Hours"),
                                                    labelText: "Hours",
                                                controller: _durHours,
                                                validator: (input) => input!
                                                        .trim()
                                                        .isEmpty
                                                    ? 'Please fill this space'
                                                    : null,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                              child: Center(child: Text(":")),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              child: TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: "Minutes"),
                                                    labelText: "Minutes",
                                                controller: _durMins,
                                                validator: (input) => input!
                                                        .trim()
                                                        .isEmpty
                                                    ? 'Please fill this space'
                                                    : null,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    formFieldLabel(width: size.width * .9, "Name of trainer"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: "Name of trainer"),
                                      controller: _trainerName,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter a name'
                                              : null,
                                    ),
                                    formFieldLabel(width: size.width * .9, "Trainer's organisation"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: "Trainer's organisation"),
                                      controller: _trainerOrg,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter a name'
                                              : null,
                                    ),
                                    SizedBox(height: 30.0),
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
                                                    BorderRadius.circular(10.0),
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
                                              if (_visitDate == null) {
                                                overlayNotification(
                                                    'Please select date',
                                                    "negative");
                                              } else if (_community == null &&
                                                  !boxChecked) {
                                                overlayNotification(
                                                    'Please select a community',
                                                    "negative");
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                setTLValuesT();
                                                // regSP?.setBool(
                                                //     "farmerskipped", false);
                                                Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        TrainingParticipantDetails(
                                                            comVal:
                                                                _communityVal!),
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
    );
  }
}
