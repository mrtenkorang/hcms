import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoringprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/monitoredspecieslist.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UpdateSeedlingVisit extends StatefulWidget {
  final String? name, contact, speciesID;
  const UpdateSeedlingVisit({Key? key, this.name, this.contact, this.speciesID})
      : super(key: key);

  @override
  _UpdateSeedlingVisitState createState() => _UpdateSeedlingVisitState();
}

class _UpdateSeedlingVisitState extends State<UpdateSeedlingVisit> {
  final _formKey = GlobalKey<FormState>();

  final _quantitySurvived = TextEditingController();
  final _quantityRegistered = TextEditingController();

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

    print("Getting worked shared preference worked");
  }

  void saveToLocalDB(String con) {
    Provider.of<SeedlingMonitoringProvider>(context, listen: false)
        .addSeedlingMonitoring(
      _community.toString(),
      _visitDateYear ?? "",
      enumeratorvalue.toString(),
      widget.speciesID ??
          "", // _farmerid.toString(), I was using this all the while. seems it's the farmerid attached to the tree species instead
      _farmerName ?? "",
      _baseline.toString(),
      widget.contact ?? "",
      _species!,
      _receivedDateYear ?? "",
      _plantedDateYear ?? "",
      _quantityReceived ?? "",
      _quantityPlanted ?? "",
      _quantitySurvived.text,
      _plantingArea ?? "",
      "",
      _quantityRegistered.text,
      "",
      con,
    );

    print("Successfully saved to local DB");
  }

  attemptSignup(BuildContext ctx) async {
    // getSPValues();
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");
    getEnumeratorValue('first_time_user');
    overlayNotification('Data uploading... Please wait.', "positive");

    try {
      var seedlingMonitoring = {
        "visitDetails": {
          "communityName": int.parse(_community!),
          "dateOfVisit": _visitDateYear,
          "enumerator": enumeratorvalue.toString()
        },
        "farmerDetails": {
          "farmerid": int.parse(widget.speciesID!),
          "baseline": "no"
        },
        "treeFarmInformation": {
          "treeSpecies": _species,
          "dateReceived": null,
          "datePlanted": null,
          "qntyReceived": null,
          "qntyPlanted": null,
          "qntySurvived": _quantitySurvived.text,
          "plantingAreaType": null,
          "areaSize": null,
          "noOfTreesRegistered": _quantityRegistered.text,
          "farmLocation": null
        }
      };

      var url = '$stageBaseUrl/seedlingsmonitoringapi/';
      // {}
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
        saveToLocalDB("connected");
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        // regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => MonitoredSpeciesList(
              contact: widget.contact,
            ),
          ),
        );
        // return res.statusCode;
      } else if (status == "exist") {
        overlayNotification('Data already: $status.', "positive");

        Navigator.pop(context);
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      saveToLocalDB("not connected");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again from "View Monitoring Data".',
          "negative");

      // regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => MonitoredSpeciesList(
            contact: widget.contact,
          ),
        ),
      );
    } catch (i) {
      print("i ===> ${i.toString()}");
      // setState(() {
      //   _quantitySurvived.text = i.toString();
      // });
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
            TextSpan(text: "Welcome back, ${widget.name ?? ""}"),
          ]),
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
                                          "Progress Data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ],
                                    ),
                                    titleOne("Progress Data"),
                                    formFieldLabel(width: size.width * .9, 
                                        "Quantity of trees survived"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Quantity of trees survived"),
                                      controller: _quantitySurvived,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter quantity'
                                              : null,
                                    ),
                                    formFieldLabel(width: size.width * .9, 
                                        "Number of trees registered"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Number of trees registered"),
                                      controller: _quantityRegistered,
                                      validator: (input) {
                                        if (input!.trim().isNotEmpty) {
                                          if (int.parse(input) >
                                              int.parse(
                                                  _quantitySurvived.text)) {
                                            return "Value cannot be more than trees survived.";
                                          }
                                        } else {
                                          return 'Please enter quantity';
                                        }
                                        return null;
                                      },
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
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                submissionOptions(
                                                  context,
                                                  "Do you have internet data?",
                                                  "Send with internet",
                                                  "Send later",
                                                  "Cancel",
                                                  approvePress: () =>
                                                      attemptSignup(context),
                                                  editPress: () {
                                                    Navigator.pop(context);
                                                    saveToLocalDB(
                                                        "not connected");
                                                    overlayNotification(
                                                        'Successfully saved. Please go to "View Monitoring Data" to send data',
                                                        "negative");
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MonitoredSpeciesList(
                                                          contact:
                                                              widget.contact,
                                                        ),
                                                      ),
                                                    );
                                                    // regSP?.clear();
                                                  },
                                                  disapprovePress: () => null,
                                                );
                                              }
                                              // convertr();
                                              // convertc2();
                                              // convertc3();
                                              // saveToLocalDB("not connected");
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
