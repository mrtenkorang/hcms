import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoringprovider.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/monitoredspecieslist.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/treedetails.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PlantingArea extends StatefulWidget {
  final String? contact;

  const PlantingArea({Key? key, this.contact}) : super(key: key);

  @override
  _PlantingAreaState createState() => _PlantingAreaState();
}

class _PlantingAreaState extends State<PlantingArea> {
  final _formKey = GlobalKey<FormState>();

  final _farmLocation = TextEditingController();
  final _areaSize = TextEditingController();
  final _registeredTrees = TextEditingController();

  String? _plantingArea;

  bool isVisitDate = false;
  String? visitDateYearInString;

  bool errorMessage = false;

  int? selectedVisitRadio;

  int? enumeratorvalue;

  Future<dynamic> getEnumeratorValue(String table) async {
    final db = await DBHelper.database();
    var count =
        await db.rawQuery('SELECT enumeratorValue FROM first_time_user');

    var list = count.toList();

    
    print("Enummem first is - ${list.toString()}");

    setState(() {
      enumeratorvalue = int.parse(list[0]['enumeratorValue'].toString());
    });
    print("Enummem - $enumeratorvalue");
  }

//farmer Details
  // String _farmerRegNum;
  String? _farmerName;
  bool? _baseline;
  String? _farmerContact;
  // String _communityName;
  String? _community;
  String? _farmerid;
  // String _visitNumber;
  String? _visitDateYear;
  String? _species;
  String? _receivedDateYear;
  String? _plantedDateYear;
  String? _quantityReceived;
  String? _quantityPlanted;
  String? _quantitySurvived;
  bool? _unsavedlocal;

  void getSPValues() async {
// farmer record level
    _unsavedlocal = (regSP?.getBool('unsavedlocal'));

//beneficiary Type
    // _communityName = (regSP?.getString('smComName') ?? "");
    _community = (regSP?.getString('smcommunity') ?? null);
    // _visitNumber = (regSP?.getString('smVisitNum') ?? "");
    _visitDateYear = (regSP?.getString('smVisitDate') ?? "");

//farmer Details
    _farmerid = (regSP?.getString('smfarmerID') ?? null);
    _farmerName = (regSP?.getString('smfarmername') ?? "");
    _baseline = (regSP?.getBool('smbaseline'));
    _farmerContact = (regSP?.getString('smfarmerContact') ?? "");

//
    _species = (regSP?.getString('tdSpecies') ?? "");
    _receivedDateYear = (regSP?.getString('tdDateReceived') ?? "");
    _plantedDateYear = (regSP?.getString('tdDatePlanted') ?? "");
    _quantityReceived = (regSP?.getString("tdQuantityReceived") ?? "");
    _quantityPlanted = (regSP?.getString('tdQuantityPlanted') ?? "");
    _quantitySurvived = (regSP?.getString('tdQuantitySurvived') ?? "");

    print("Getting worked shared preference worked");
  }

  void saveToLocalDB(String con) {
    Provider.of<SeedlingMonitoringProvider>(context, listen: false)
        .addSeedlingMonitoring(
      _community.toString(),
      _visitDateYear!,
      enumeratorvalue.toString(),
      _farmerid.toString(),
      _farmerName!,
      _baseline == true ? "true" : "false",
      _farmerContact!,
      _species!,
      _receivedDateYear!,
      _plantedDateYear!,
      _quantityReceived!,
      _quantityPlanted!,
      _quantitySurvived!,
      _plantingArea!,
      _areaSize.text,
      _registeredTrees.text,
      _farmLocation.text,
      con,
    );

    print("Successfully saved Seedling Monitoring to local DB");

    submissionOptions(
      context,
      "Add data for new species?",
      "Yes",
      "No",
      "",
      approvePress: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TreeDetails(
            contact: widget.contact,
          ),
        ),
      ),
      editPress: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => TreeMonitoringDecider(),
          ),
        );
        // regSP?.clear();
      },
      disapprovePress: () => null,
    );
  }

  void saveToLocalDB2(String con) {
    Provider.of<SeedlingMonitoringProvider>(context, listen: false)
        .addSeedlingMonitoring(
      _community.toString(),
      _visitDateYear!,
      enumeratorvalue.toString(),
      "0",
      _farmerName!,
      _baseline == true ? "true" : "false",
      _farmerContact!,
      _species!,
      _receivedDateYear!,
      _plantedDateYear!,
      _quantityReceived!,
      _quantityPlanted!,
      _quantitySurvived!,
      _plantingArea!,
      _areaSize.text,
      _registeredTrees.text,
      _farmLocation.text,
      con,
    );

    print("Successfully saved Seedling Monitoring to local DB offline");

    submissionOptions(
      context,
      "Add data for new species?",
      "Yes",
      "No",
      "",
      approvePress: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TreeDetails(
            contact: widget.contact,
          ),
        ),
      ),
      editPress: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => TreeMonitoringDecider(),
          ),
        );
        // regSP?.clear();
      },
      disapprovePress: () => null,
    );
  }

  Future attemptSignup(BuildContext ctx) async {
    // getSPValues();
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");
    getEnumeratorValue('first_time_user');
    overlayNotification('Data uploading... Please wait.', "positive");

    try {
      var seedlingMonitoring = {
        "visitDetails": {
          "communityName": int.parse(_community!),
          "dateOfVisit": _visitDateYear,
          "enumerator": enumeratorvalue
        },
        "farmerDetails": {
          "farmerid": int.parse(_farmerid!),
          "baseline": "yes",
        },
        "treeFarmInformation": {
          "treeSpecies": _species,
          "dateReceived": _receivedDateYear,
          "datePlanted": _plantedDateYear,
          "qntyReceived": int.parse(_quantityReceived!),
          "qntyPlanted": int.parse(_quantityPlanted!),
          "qntySurvived": int.parse(_quantitySurvived!),
          "plantingAreaType": _plantingArea,
          "areaSize": double.parse(_areaSize.text),
          "noOfTreesRegistered": int.parse(_registeredTrees.text),
          "farmLocation": _farmLocation.text
        }
      };

      var url = '$stageBaseUrl/seedlingsmonitoringapi/';

      var body = json.encode(seedlingMonitoring);

//here jsonEncode(data) return String bt in http body you are passing Map value

//So you have to convert String to Map
      var bodyMap = jsonDecode(body);
      print(body);

// your nested json data
      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);
      print("uploading...");
      print("Statuscode is ${res.statusCode}");

      final itemss = json.decode(res.body);

      print("itemss $body");
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "done") {
        Navigator.pop(context);
        saveToLocalDB("connected");
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        // regSP?.clear();
        submissionOptions(
          context,
          "Add data for new species?",
          "Yes",
          "No",
          "",
          approvePress: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  TreeDetails(contact: widget.contact),
            ),
          ),
          editPress: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => TreeMonitoringDecider(),
              ),
            );
            // regSP?.clear();
          },
          disapprovePress: () => null,
        );
        // return res.statusCode;
      } else if (status == "exist") {
        overlayNotification('Data already: $status.', "positive");

        Navigator.pop(context);

        submissionOptions(
          context,
          "Add data for new species?",
          "Yes",
          "No",
          "",
          approvePress: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  TreeDetails(contact: widget.contact),
            ),
          ),
          editPress: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => TreeMonitoringDecider(),
              ),
            );
            // regSP?.clear();
          },
          disapprovePress: () => null,
        );
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
        // return res.statusCode;

        submissionOptions(
          context,
          "Add data for new species?",
          "Yes",
          "No",
          "",
          approvePress: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  TreeDetails(contact: widget.contact),
            ),
          ),
          editPress: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => TreeMonitoringDecider(),
              ),
            );
            // regSP?.clear();
          },
          disapprovePress: () => null,
        );
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      saveToLocalDB("not connected");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again from "View Monitoring Data".',
          "negative");

      // regSP?.clear();
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) => TreeMonitoringDecider()),
      // );
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  Future attemptSignup2(BuildContext ctx) async {
    getSPValues();
    submissionLoader(ctx, "Saving data", "Please wait a minute...");
    await getEnumeratorValue('first_time_user');
    overlayNotification('Saving data... Please wait.', "positive");

    try {
      // var seedlingMonitoring = {
      //   "visitDetails": {
      //     "communityName": int.parse(_community),
      //     "dateOfVisit": _visitDateYear,
      //     "enumerator": enumeratorvalue
      //   },
      //   "farmerDetails": {
      //     "farmerid": int.parse("0"),
      //     "baseline": "yes",
      //   },
      //   "treeFarmInformation": {
      //     "treeSpecies": [_species],
      //     "dateReceived": _receivedDateYear,
      //     "datePlanted": _plantedDateYear,
      //     "qntyReceived": int.parse(_quantityReceived),
      //     "qntyPlanted": int.parse(_quantityPlanted),
      //     "qntySurvived": int.parse(_quantitySurvived),
      //     "plantingAreaType": _plantingArea,
      //     "areaSize": int.parse(_areaSize.text),
      //     "noOfTreesRegistered": int.parse(_registeredTrees.text),
      //     "farmLocation": _farmLocation.text
      //   }
      // };

      // var url = '$stageBaseUrl/seedlingsmonitoringapi/';

      // var body = json.encode(seedlingMonitoring);

      // print(body);
      print("Saving off");

      saveToLocalDB2("farmer offline");
      overlayNotification(
          'Please make sure you\'re connected to the internet and try again from "View Monitoring Data".',
          "negative");
      Navigator.of(context).pop();
      // regSP?.clear();
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => TreeMonitoringDecider(),
      //   ),
      // );
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    getEnumeratorValue("first_time_user");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
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
                child: Icon(Icons.home,  color: fPrimaryWhite),
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
                                          "Planting Area",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
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
                                                      "Planting area type",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 1,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        print(val);
                                                        _plantingArea =
                                                            "Fallow_Land";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Fallow land",
                                                    // style: TextStyle(
                                                    //     color: Color(0xFFf9f9f9)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 2,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _plantingArea =
                                                            "Communal_Land";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Communal land",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 3,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _plantingArea =
                                                            "Cocoa_Farm";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Cocoa Farm",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 4,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _plantingArea =
                                                            "Tree_Plantation";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Tree plantation",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 5,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _plantingArea = "Other";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Other",
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
                                    formFieldLabel(width: size.width * .9, "Location of the farm"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: "Location of the farm"),
                                      controller: _farmLocation,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter location of farm'
                                              : null,
                                    ),
                                    formFieldLabel(width: size.width * .9, "Area size or farm size (Acre)"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Area size or farm size (Acre)"),
                                      controller: _areaSize,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter farm size'
                                              : null,
                                    ),
                                    formFieldLabel(width: size.width * .9, "How many trees have been registered?"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText:
                                              "How many trees have been registered?"),
                                      controller: _registeredTrees,
                                      validator: (input) => input!
                                              .trim()
                                              .isEmpty
                                          ? 'Please enter number of trees registered'
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
                                              "Finish",
                                              style: TextStyle(
          color: fPrimaryWhite,
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            onPressed: () async {
                                              getSPValues();
                                              if (_plantingArea == null) {
                                                overlayNotification(
                                                    'Please select planting area',
                                                    "negative");
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                submissionOptions(
                                                  context,
                                                  "Do you have internet data?",
                                                  "Send with internet",
                                                  "Send later",
                                                  "Cancel",
                                                  approvePress: () =>
                                                      _unsavedlocal == true
                                                          ? attemptSignup2(
                                                                  context)
                                                              .then((value) =>
                                                                  submissionOptions(
                                                                    context,
                                                                    "Add data for new species?",
                                                                    "Yes",
                                                                    "No",
                                                                    "",
                                                                    approvePress: () =>
                                                                        Navigator.of(context)
                                                                            .pushReplacement(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                TreeDetails(contact: widget.contact),
                                                                      ),
                                                                    ),
                                                                    editPress:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pushReplacement(
                                                                        MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              TreeMonitoringDecider(),
                                                                        ),
                                                                      );
                                                                      regSP
                                                                          ?.clear();
                                                                    },
                                                                    disapprovePress:
                                                                        () =>
                                                                            null,
                                                                  ))
                                                          : attemptSignup(
                                                              context),
                                                  editPress: () {
                                                    // Navigator.pop(context);
                                                    _unsavedlocal == true
                                                        ? saveToLocalDB2(
                                                            "farmer offline")
                                                        : saveToLocalDB(
                                                            "not connected");
                                                    overlayNotification(
                                                        'Successfully saved. Please go to "View Monitoring Data" to send data',
                                                        "negative");
                                                    // Navigator.of(context)
                                                    //     .pushReplacement(
                                                    //   MaterialPageRoute(
                                                    //     builder: (BuildContext
                                                    //             context) =>
                                                    //         TreeMonitoringDecider(),
                                                    // ),
                                                    // );
                                                    // regSP?.clear();
                                                  },
                                                  disapprovePress: () => null,
                                                );
                                              }
                                            },
                                          ),
                                        )
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
