import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/2plantation_planting_details.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../../main.dart';

class SeedlingMonitoringGeneralInformation extends StatefulWidget {
  final String? name, contact;

  const SeedlingMonitoringGeneralInformation({
    Key? key,
    this.name,
    this.contact,
  }) : super(key: key);

  @override
  _SeedlingMonitoringGeneralInformationState createState() =>
      _SeedlingMonitoringGeneralInformationState();
}

class _SeedlingMonitoringGeneralInformationState
    extends State<SeedlingMonitoringGeneralInformation> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  final surveyorName = TextEditingController();
  final farmerName = TextEditingController();
  final farmerIDNumber = TextEditingController();
  String? _dateOfSurvey;
  String _dateOfSurveyError = '';
  String? _community;

  bool isDateofSurvey = false;
  String? dateOfSurveyInString;

  var timechecker = DateTime.now().year;

  bool errorMessage = false;

  final _communityName = TextEditingController();
  List<String> _commFound = [];
  bool boxChecked = false;

  Future setSSR1ValuesT() async {
    await regSP?.setString('ssr_nameOfSurveyor', surveyorName.text);
    await regSP?.setString('ssr_dateOfSurvey', _dateOfSurvey ?? "");
    regSP?.setString(
        'ssr_community', !boxChecked ? _community ?? "" : _communityName.text);
    await regSP?.setString('ssr_farmerName', farmerName.text);
    await regSP?.setString('ssr_farmerIDNumber', farmerIDNumber.text);

    debugPrint("done setting");
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

  // String? _community;
  String reg = "";
  String fD = "";

  var commUrl = "$stageBaseUrl/communityapi/";
  File? commjsonFile;
  Directory? dir;
  String commfileName = "community.json";
  bool commfileExists = false;
  var commfileContent;
  List<CommunityJson> _newcommValues = [];
  List<CommunityJson> _commValues = [];

  void createCommFile(var content, Directory dir, String fileName) {
    debugPrint("Creating Community file!");
    File file = File("${dir.path}/$fileName");
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<CommunityJson>> getLocalCommValues(BuildContext context) async {
    debugPrint("doing clocal comm");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/community.json');
    final body = json.decode(data);

    _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();

    return _newcommValues;
  }

Future<List<CommunityJson>> writeToCommFile(BuildContext ctx) async {
    debugPrint("Writing to community file! $commfileExists");
    if (commfileExists) {
      debugPrint("Community File exists $commfileExists");

      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Community");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var commjsonFileContent =
              await json.decode(await commjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile?.writeAsString(json.encode(commjsonFileContent));

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is first community");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      debugPrint("Community File does not exist! $commfileExists");
      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Community");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createCommFile(items, dir!, commfileName);

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
          getLocalCommValues(ctx);
        }
      } on SocketException {
        debugPrint("Error is second comm");
        getLocalCommValues(ctx);
      }
    }
    commfileExists
        ? commfileContent =
            await json.decode(await commjsonFile!.readAsString())
        : null;
    debugPrint(commfileContent);

    return commfileExists
        ? _commValues =
            commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList()
        : _newcommValues;
  }

 commFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      commjsonFile = File("${dir!.path}/$commfileName");
      commfileExists = commjsonFile!.existsSync();
      if (commfileExists) {
        commfileContent = await json.decode(await commjsonFile!.readAsString());
      }
    });

    return commfileContent;
  }

  Future<List<CommunityJson>>? myCFuture;

  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 3), () {
    //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // });


    commFileInit();
    super.initState();

    farmerName.text = widget.name ?? "";

    myCFuture = writeToCommFile(context);
    reg = "Western Region";
    fD = "First";
  }

  void _oncommChanged(String commVal) {
    setState(() {
      _community = commVal;
    });
  }

  void _onComChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fPrimaryColour,

      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   backgroundColor: fPrimaryColour,
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     "Seedling Monitoring",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     Tooltip(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //         child: InkWell(
      //           child: Icon(Icons.home, color: fPrimaryWhite),
      //           onTap: () => Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => IndexPage(),
      //             ),
      //           ),
      //         ),
      //       ),
      //       message: "Takes you back to homepage",
      //     )
      //   ],
      //   // actions: [
      //   //   PopupMenuButton<String>(
      //   //     offset: Offset(2.00, 3.00),
      //   //     color: Colors.black,
      //   //     onSelected: (String _downChoice) {
      //   //       if (_downChoice == SkipConstants.home) {
      //   //         Navigator.of(context).pushReplacement(
      //   //           MaterialPageRoute(
      //   //             builder: (BuildContext context) => IndexPage(),
      //   //           ),
      //   //         );
      //   //       } else if (_downChoice == SkipConstants.saveskip) {
      //   //         setFPValuesT();
      //   //         regSP?.setBool("farmerskipped", true);
      //   //         Navigator.of(context).push(
      //   //           CupertinoPageRoute(
      //   //             builder: (BuildContext context) => FarmDetails(),
      //   //           ),
      //   //         );
      //   //       } else if (_downChoice == SkipConstants.saveclose) {
      //   //         // regSP?.setBool("closed", true);
      //   //         // Navigator.of(context).push(
      //   //         //   CupertinoPageRoute(
      //   //         //     builder: (BuildContext context) => FarmDetails(),
      //   //         //   ),
      //   //         // );
      //   //       }
      //   //     },
      //   //     itemBuilder: (BuildContext context) {
      //   //       return SkipConstants.downChoices.map((String _downChoice) {
      //   //         return PopupMenuItem<String>(
      //   //           value: _downChoice,
      //   //           child: Container(
      //   //             margin: EdgeInsets.only(right: 0),
      //   //             child: Text(
      //   //               _downChoice,
      //   //               style: TextStyle(color: Color(0xFFFFFFFF)),
      //   //             ),
      //   //           ),
      //   //         );
      //   //       }).toList();
      //   //     },
      //   //   ),
      //   // ],
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
                  "Seedling Monitoring".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                Tooltip(
                  message: "Takes you back to homepage",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(
                      child: const Icon(Icons.home, color: fPrimaryWhite),
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      ),
                    ),
                  ),
                )
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
                margin: const EdgeInsets.all(0.0),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: primaryWhite,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 20.0),
                                    child: Column(
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       "General Information",
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 24.0),
                                        //     ),
                                        //   ],
                                        // ),
                                        titleOne("General Information"),
                                        // formFieldLabel(width: size.width * .9, "Name of surveyor"),
                                        // TextFieldWidget(
                                        //   decoration: const InputDecoration(
                                        //       labelText: "Name of surveyor"),
                                        //   controller: surveyorName,
                                        //   onChanged: (value) {},
                                        //   validator: (input) {
                                        //     if (input!.trim().isEmpty) {
                                        //       return 'Please enter name of surveyor';
                                        //     } else {
                                        //       setState(() {
                                        //         surveyorName.text = input;
                                        //       });
                                        //     }
                                        //   },
                                        // ),
                                        Container(
                                          // width: MediaQuery.of(context).size.width - 90,

                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              // const Row(
                                              //   children: <Widget>[
                                              //     Padding(
                                              //       padding:
                                              //           EdgeInsets.all(0.0),
                                              //       child: Text(
                                              //         "Date of survey",
                                              //         style: TextStyle(
                                              //             fontSize: 17),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),

                                              formFieldLabel(width: size.width * .9, "Date of survey"),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child: isDateofSurvey == true
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
                                                              2.5,
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
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Text(
                                                                    dateOfSurveyInString ??
                                                                        "survey date",
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
                                                        )
                                                      : const Row(
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
                                                        theme:
                                                            const DatePickerTheme(
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
                                                          containerHeight:
                                                              210.0,
                                                        ),
                                                        showTitleActions: true,
                                                        minTime: DateTime(
                                                            1800, 1, 1),
                                                        maxTime: DateTime.now(),
                                                        onConfirm: (date) {
                                                      // if (DateTime.now().year -
                                                      //         date.year <
                                                      //     18) {
                                                      //   overlayNotification(
                                                      //       'Must be 18 years and above',
                                                      //       "negative");
                                                      // } else {
                                                      debugPrint(
                                                          'confirm $date');
                                                      isDateofSurvey = true;
                                                      dateOfSurveyInString =
                                                          '${date.day}/${date.month}/${date.year}';
                                                      setState(() {
                                                        _dateOfSurvey =
                                                            '${date.year}-${date.month}-${date.day}';
                                                        debugPrint(
                                                            "DOOB $_dateOfSurvey");
                                                      });
                                                      // }
                                                    },
                                                        // currentTime: DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        !boxChecked
                                            ? Container(
                                                color: const Color(0xFFFFFFFF),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        top: 8.0,
                                                        left: .0,
                                                        right: .0,
                                                        bottom: 18.0,
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          // Row(
                                                          //   children: <Widget>[
                                                          //     Container(
                                                          //       margin:
                                                          //           const EdgeInsets
                                                          //               .only(
                                                          //         bottom:
                                                          //             14.0,
                                                          //       ),
                                                          //       child:
                                                          //           const Row(
                                                          //         children: <Widget>[
                                                          //           Text(
                                                          //               "Select Community"),
                                                          //         ],
                                                          //       ),
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                          formFieldLabel(width: size.width * .9, 
                                                              "Select Community"),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            0.50,
                                                                        color: const Color(
                                                                            0xFF000000)),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(10.0))),
                                                                // width: MediaQuery.of(context)
                                                                //         .size
                                                                //         .width /
                                                                //     1.09,
                                                                padding:
                                                                    const EdgeInsets
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
                                                                            .done) {
                                                                      return const CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(fPrimaryColour),
                                                                      );
                                                                    } else if (!snapshot
                                                                        .hasData) {
                                                                      return const Text(
                                                                          "Operation failed. Sync to get data.",
                                                                          style:
                                                                              TextStyle(color: fBackgroundColour));
                                                                    } else if (snapshot
                                                                        .hasData) {
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

                                                                                      debugPrint("Community"
                                                                                          "$_community");
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              }),
                                                                            )
                                                                          : Container(
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

                                                                                      debugPrint("Community"
                                                                                          "$_community");
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
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
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
                                            : const SizedBox(),
                                        CheckboxListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          // title: const Text(
                                          //   "Check box if community not found",
                                          //   style: TextStyle(
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          title: formFieldLabel(width: size.width * .9, 
                                              "Check box if community not found"),
                                          tileColor: secondaryColour2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          value: boxChecked,
                                          activeColor: fPrimaryColour,
                                          onChanged: (bool? value) {
                                            _onComChanged(value!);
                                          },
                                        ),
                                        boxChecked
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    left: 0.0,
                                                    right: 0.0,
                                                    bottom: 8.0),
                                                child: TextFieldWidget(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  // decoration: InputDecoration(
                                                  labelText:
                                                      "(Enter community if not found)",
                                                  // ),
                                                  controller: _communityName,
                                                  validator: (input) => input!
                                                          .trim()
                                                          .isEmpty
                                                      ? 'Please enter community'
                                                      : null,
                                                  readonly: boxChecked
                                                      ? false
                                                      : boxChecked,
                                                ),
                                              )
                                            : const SizedBox(),
                                        formFieldLabel(width: size.width * .9, "Name of farmer"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Name of farmer"),
                                          controller: farmerName,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter name of farmer';
                                            } else {
                                              setState(() {
                                                farmerName.text = input!;
                                              });
                                            }
                                            // return input;
                                          },
                                        ),
                                        formFieldLabel(width: size.width * .9, 
                                            "Farmer ID Number (Ghana card number)"),
                                        TextFieldWidget(
                                          keyboardType: TextInputType.text,
                                          maxLength: 13,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  "Farmer ID Number (Ghana card number)"),
                                          controller: farmerIDNumber,
                                          validator: (input) {
                                            if (input!.trim().length < 13) {
                                              return 'Number must be up to 13 characters';
                                            } else if (input.length > 13) {
                                              return 'Number is more than 13 characters';
                                            } else {
                                              setState(() {
                                                farmerIDNumber.text = input;
                                              });
                                            }

                                            // return input;
                                          },
                                        ),
                                        const SizedBox(height: 30.0),
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
                                                  backgroundColor:
                                                      fPrimaryColour,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      color: Colors.white),
                                                  // shadowColor: fPrimaryColour,
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: fPrimaryColour),
                                                ),
                                                child: const Text(
                                                  "Next",
                                                  style: TextStyle(
                                                      color: fPrimaryWhite,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                onPressed: () async {
                                                  await setSSR1ValuesT()
                                                      .then((value) {
                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        dateOfSurveyInString !=
                                                            null) {
                                                      debugPrint(
                                                          "Farmer detail ${surveyorName.text} and $_dateOfSurvey");
                                                      regSP?.setBool(
                                                          "ssr1_skipped",
                                                          false);
                                                      Navigator.of(context)
                                                          .push(
                                                        CupertinoPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              SeedlingMonitoringPlantingDetails(),
                                                        ),
                                                      );
                                                    } else if (dateOfSurveyInString ==
                                                        null) {
                                                      overlayNotification(
                                                          'Date of survey not selected',
                                                          "negative");
                                                    } else if (_community ==
                                                            null &&
                                                        !boxChecked) {
                                                      overlayNotification(
                                                          'Please select a community',
                                                          "negative");
                                                    }
                                                    //else if (kinBirthDateInString ==
                                                    //     null) {
                                                    //   overlayNotification(
                                                    //       'Kin Date of birth not selected',
                                                    //       "negative");
                                                    // } else if (_farmerGender !=
                                                    //         "male" &&
                                                    //     _farmerGender !=
                                                    //         "female") {
                                                    //   overlayNotification(
                                                    //       'Farmer gender not selected',
                                                    //       "negative");
                                                    // } else if (_kinGender !=
                                                    //         "male" &&
                                                    //     _kinGender !=
                                                    //         "female") {
                                                    //   overlayNotification(
                                                    //       'Kin gender not selected',
                                                    //       "negative");
                                                    // }
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
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
                                                      color: Colors.white),
                                                  // shadowColor: fPrimaryColour,
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: fPrimaryColour),
                                                ),
                                                child: const Text(
                                                  "Skip",
                                                  style: TextStyle(
                                                      color: fPrimaryWhite,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                onPressed: () async {
                                                  regSP?.setBool(
                                                      "ssr1_skipped", true);
                                                  // if (_speciesProvidedPlanted.isEmpty) {
                                                  //   overlayNotification(
                                                  //       'Please select type of establishment',
                                                  //       "negative");
                                                  // } else {
                                                  setSSR1ValuesT();
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SeedlingMonitoringPlantingDetails(),
                                                    ),
                                                  );

                                                  // debugPrint(
                                                  //     "Selected types are $_speciesProvidedPlanted");
                                                  // }
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
          ),
        ],
      ),
    );
  }
}
