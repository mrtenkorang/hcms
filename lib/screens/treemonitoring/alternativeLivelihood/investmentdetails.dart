import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InvestmentDetails extends StatefulWidget {
  const InvestmentDetails({Key? key}) : super(key: key);

  @override
  _InvestmentDetailsState createState() => _InvestmentDetailsState();
}

class _InvestmentDetailsState extends State<InvestmentDetails> {
  final _formKey = GlobalKey<FormState>();

  final _initAmnt = TextEditingController();
  final _amount = TextEditingController();
  final _afterSixm = TextEditingController();
  final _afterOney = TextEditingController();
  final _afterTwoy = TextEditingController();
  final _amntToLmb = TextEditingController();

  String? _activitySupport;

  int? selectedVisitRadio;

  String? _activityIncomeSupports;
  bool isVisitDate = false;
  String? visitDateYearInString;

  String? _community;
  int? enumeratorvalue;
  String? _visitDateYear;
  String? _farmerid;
  String? _farmerName;
  bool? _baseline = false;
  String? _farmerPhoneNum;
  String? _trainerorganisation;
  String? _additionalActivity;
  String? _operationsStartDate;
  bool? _unsavedlocal;

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

  void getAMValues() async {
// farmer record level
    _unsavedlocal = (regSP?.getBool('unsavedlocal'));

    _community = (regSP?.getString('aLcommunity') ?? "");
    _trainerorganisation = (regSP?.getString('aLtrainerorganisation') ?? "");
    _additionalActivity = (regSP?.getString('aLadditionalActivity') ?? "");
    _farmerName = (regSP?.getString('aLfarmername') ?? "");
    _baseline = (regSP?.getBool('aLbaseline'));
    _farmerPhoneNum = (regSP?.getString('aLfarmerContact') ?? "");
    _operationsStartDate = (regSP?.getString('aLoperationsStartDate') ?? "");
    _visitDateYear = (regSP?.getString("aLVisitDate") ?? "");

    _farmerid = (regSP?.getString('aLfarmerID') ?? null);

    print("Getting worked shared preference worked");
  }

  void saveToLocalDB(String con) {
    Provider.of<AlternativeLivelihoodProvider>(context, listen: false)
        .addAlternativeLivelihood(
      _community!,
      enumeratorvalue.toString(),
      _visitDateYear!,
      _farmerid!,
      _farmerName!,
      _baseline == true ? "true" : "false",
      _farmerPhoneNum!,
      _additionalActivity!,
      _trainerorganisation!,
      _operationsStartDate!,
      _initAmnt.text,
      _amountType!,
      _amount.text,
      _amntToLmb.text,
      _activitySupport!,
      con,
    );

    print("Successfully saved to local DB");
  }

  void saveToLocalDB2(String con) {
    Provider.of<AlternativeLivelihoodProvider>(context, listen: false)
        .addAlternativeLivelihood(
      _community!,
      enumeratorvalue.toString(),
      _visitDateYear!,
      "0",
      _farmerName!,
      _baseline == true ? "true" : "false",
      _farmerPhoneNum!,
      _additionalActivity!,
      _trainerorganisation!,
      _operationsStartDate!,
      _initAmnt.text,
      _amountType!,
      _amount.text,
      _amntToLmb.text,
      _activitySupport!,
      con,
    );

    print("Successfully saved Seedling Monitoring to local DB offline");
  }

  attemptAlternativeUpload(BuildContext ctx) async {
    // getSPValues();
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");
    getEnumeratorValue('first_time_user');
    overlayNotification('Data uploading... Please wait.', "positive");

    try {
      var alternativeMonitoring = {
        "visitDetails": {
          "communityName": int.parse(_community!),
          "enumerator": enumeratorvalue,
          "dateOfVisit": _visitDateYear
        },
        "farmerDetails": {
          "farmerid": int.parse(_farmerid!),
          "baseline": "yes",
        },
        "activityDetails": {
          "additionalLivelihood": _additionalActivity,
          "trainerOrganisation": _trainerorganisation,
          "dateOperationsStarted": _operationsStartDate,
          "amounts": {
            "invested":
                _initAmnt.text.isNotEmpty ? double.parse(_initAmnt.text) : null,
            "duration": _amountType,
            "amount":
                _amount.text.isNotEmpty ? double.parse(_amount.text) : null,
            "lmbContrib": _amntToLmb.text.isNotEmpty
                ? double.parse(_amntToLmb.text)
                : null
          },
          "activitiesSupported": _activitySupport
        }
      };

      var url = '$stageBaseUrl/alternativemonitoringapi/';

      var body = json.encode(alternativeMonitoring);

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

        regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => TreeMonitoringDecider(),
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

      regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TreeMonitoringDecider(),
        ),
      );
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  attemptAlternativeUpload2(BuildContext ctx) async {
    // getSPValues();
    submissionLoader(ctx, "Saving data", "Please wait a minute...");
    await getEnumeratorValue('first_time_user');
    overlayNotification('Saving data... Please wait.', "positive");

    try {
      print("Saving off");

      saveToLocalDB2("farmer offline");
      overlayNotification(
          'Please make sure you\'re connected to the internet and try again from "View Monitoring Data".',
          "negative");
      Navigator.of(context).pop();
      regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TreeMonitoringDecider(),
        ),
      );
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  String? _amountType;
  List<String> _amountTypeValues = [];

  @override
  void initState() {
    super.initState();
    getEnumeratorValue("first_time_user");

    _amountTypeValues.addAll(["6 months", "year 1", "year 2"]);
  }

  void _onIdTypeChanged(String _aTValue) {
    setState(() {
      _amountType = _aTValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Alternative Livelihood",
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
        child: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Investment Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                              ],
                            ),
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
                                        // Text(
                                        //   "Group/ Company Details",
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 24.0),
                                        // ),
                                      ],
                                    ),
                                    formFieldLabel(width: size.width * .9, "Initial amount invested"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: "Initial amount invested"),
                                      controller: _initAmnt,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter an amount'
                                              : null,
                                    ),

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0.0, right: .0, top: 15.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      //   borderRadius:
                                                      //       BorderRadius.circular(10),
                                                      //   border: Border.all(),
                                                      ),
                                                  width: size.width * .95,
                                                  padding: EdgeInsets.all(.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "Fill data for amount raised after:",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        60),
                                                            width:
                                                                size.width * .4,
                                                            child:
                                                                new DropdownButton(
                                                              focusColor:
                                                                  fPrimaryColour,
                                                              isExpanded: true,
                                                              underline:
                                                                  Divider(
                                                                color:
                                                                    fPrimaryColour,
                                                                thickness: 1,
                                                              ),
                                                              iconEnabledColor:
                                                                  fPrimaryColour,
                                                              value:
                                                                  _amountType,
                                                              items: _amountTypeValues
                                                                  .map((String
                                                                      _aTValue) {
                                                                return new DropdownMenuItem(
                                                                  value:
                                                                      _aTValue,
                                                                  child:
                                                                      new Row(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                        child:
                                                                            new Text(
                                                                          "$_aTValue",
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
                                                                _onIdTypeChanged(
                                                                    value!);
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
                                    ),
                                    // TextFieldWidget(
                                    //   keyboardType: TextInputType.number,
                                    //   decoration: InputDecoration(
                                    //       labelText:
                                    //           "Quantity of trees survived"),
                                    //   controller: _quantitySurvived,
                                    //   validator: (input) => input.trim().isEmpty
                                    //       ? 'Please enter quantity'
                                    //       : null,
                                    // ),
                                    formFieldLabel(width: size.width * .9, _amountType == "6 months" ||
                                            _amountType == null
                                        ? "Amount raised after 6 months"
                                        : _amountType == "year 1"
                                            ? "Amount raised after year 1"
                                            : _amountType == "year 2"
                                                ? "Amount raised after year 2"
                                                : ""),
                                    _amountType == "6 months" ||
                                            _amountType == null
                                        ? TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Amount raised after 6 months"),
                                            controller: _amount,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter an amount'
                                                    : null,
                                          )
                                        : Container(),
                                    _amountType == "year 1"
                                        ? TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Amount raised after year 1"),
                                            controller: _amount,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter an amount'
                                                    : null,
                                          )
                                        : Container(),
                                    _amountType == "year 2"
                                        ? TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Amount raised after year 2"),
                                            controller: _amount,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter an amount'
                                                    : null,
                                          )
                                        : Container(),
                                        formFieldLabel(width: size.width * .9, "Amount contributed to LMB"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Amount contributed to LMB"),
                                      controller: _amntToLmb,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter an amount'
                                              : null,
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
                                                      "Activity that income supports",
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
                                                        _activitySupport =
                                                            "School_Fees";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "School fees",
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
                                                        _activitySupport =
                                                            "Home_Appliances";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Home appliances - TV, radio, decorder",
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
                                                        _activitySupport =
                                                            "Medical_Bills";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Medical bills",
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
                                                        _activitySupport =
                                                            "Buy_Farm_Inputs";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Buy farm inputs",
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
                                    SizedBox(height: 30.0),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
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
                                              fontWeight: FontWeight.normal),
                                        ),
                                        onPressed: () async {
                                          getAMValues();
                                          if (_activitySupport == null) {
                                            overlayNotification(
                                                'Please select an activity',
                                                "negative");
                                          } else if (_formKey.currentState!
                                              .validate()) {
                                            submissionOptions(
                                              context,
                                              "Do you have internet data?",
                                              "Send with internet",
                                              "Send later",
                                              "Cancel",
                                              approvePress: () => _unsavedlocal ==
                                                      true
                                                  ? attemptAlternativeUpload2(
                                                      context)
                                                  : attemptAlternativeUpload(
                                                      context),
                                              editPress: () {
                                                Navigator.pop(context);
                                                _unsavedlocal == true
                                                    ? saveToLocalDB2(
                                                        "farmer offline")
                                                    : saveToLocalDB(
                                                        "not connected");
                                                overlayNotification(
                                                    'Successfully saved. Please go to "View Monitoring Data" to send data',
                                                    "negative");
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        TreeMonitoringDecider(),
                                                  ),
                                                );
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
