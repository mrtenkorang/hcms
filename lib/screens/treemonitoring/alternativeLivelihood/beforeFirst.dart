import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/farmerdetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/updatealtvisit.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'activitydetails.dart';

class AlternativeLivingBeforeFirst extends StatefulWidget {
  const AlternativeLivingBeforeFirst({Key? key}) : super(key: key);

  @override
  _AlternativeLivingState createState() => _AlternativeLivingState();
}

class _AlternativeLivingState extends State<AlternativeLivingBeforeFirst> {
  final _formKey = GlobalKey<FormState>();

  final _farmerContact = TextEditingController();

  String? _visitDateYear;
  String? _visitNumber;

  // String initKinValue = "Select your Birth Date";
  bool isVisitDate = false;
  // DateTime kinBirthDate;
  String? visitDateYearInString;
  // bool hasKinBeenClicked;

  bool errorMessage = false;

  int? selectedVisitRadio;

  void setBFValuesT() {
    regSP?.setString('aLVisitNum', _visitNumber ?? "");
    regSP?.setString('aLVisitDate', _visitDateYear ?? "");
    print("done setting");
  }

  Future<dynamic> getFarmerFromFarmerOfflineLocalDB(farmercontact) async {
    print("traversing offline farmer instead");
    final db = await DBHelper.database();
    // var count = await db
    //     .rawQuery('SELECT *'
    //         '  FROM farmer_offline WHERE foContact'
    //         ' LIKE $farmercontact')
    // .then((value) {
    var count = await db.query("farmer_offline",
        where: "foContact = ?", whereArgs: [farmercontact]).then((value) {
      if (value.isNotEmpty) {
        print("eyo ${value[0]['foContact']}");

        regSP?.setString('aLcommunity', value[0]['foCommunity'].toString());
        regSP?.setString('aLfarmername', value[0]['foFarmerName'].toString());
        regSP?.setString('aLfarmerContact', value[0]['foContact'].toString());
        regSP?.setString('aLfoGender', value[0]['foGender'].toString());
        regSP?.setString('aLfoDoB', value[0]['foDoB'].toString());
        regSP?.setString(
            'aLfoHolderCategory', value[0]['foHolderCategory'].toString());
        regSP?.setString('aLfoFarmSize', value[0]['foFarmSize'].toString());
        regSP?.setBool('unsavedlocal', true);

        print("Name is ${value}");
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => AlternateActivityDetails(),
          ),
        );
        overlayNotification('Local record found.', "positive");
      } else {
        overlayNotification('No record found.', "negative");
      }
    });

    // var list = count.toList();
    return count;
  }

  static int? countos;

  static getFarmerApiListAlternativeNumber() async {
    final db = await DBHelper.database();
    countos = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM farmer_api_list_alternative'));
    print("Countos counted was $countos");
    return countos;
  }

  Future<dynamic> getFarmerFromFarmerApiListLocalDB(farmercontact) async {
    print("traversing local farmer api list with $farmercontact");
    getFarmerApiListAlternativeNumber();
    final db = await DBHelper.database();
    // var count = await db
    //     .rawQuery('SELECT * FROM'
    //         ' farmer_api_list_alternative WHERE falAContact LIKE ${farmercontact.toString()}')
    var count = await db.query("farmer_api_list_alternative",
        where: "falAContact = ?", whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        print("doing the then bit $value");
        getFarmerFromFarmerOfflineLocalDB(farmercontact);
      } else {
        print("It isn't empty $value");

        regSP?.setString('aLfarmerID', value[0]['id'].toString());
        regSP?.setBool(
            'aLbaseline', value[0]['falABaseline'] == "true" ? true : false);
        regSP?.setString('aLfarmername', value[0]['falAFarmerName'].toString());
        regSP?.setString('aLcommunity', value[0]['falACommunityId'].toString());
        regSP?.setString('aLfarmerContact', value[0]['falAContact'].toString());
        regSP?.setBool('unsavedlocal', false);

        value[0]['falABaseline'] == true
            ? Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => UpdateAlternativeVisit(
                    name: value[0]['falAFarmerName'].toString(),
                    contact: value[0]['falAContact'].toString(),
                  ),
                ),
              )
            : Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => AlternateActivityDetails(),
                ),
              );
        overlayNotification('Record found.', "positive");
      }
    });

    // var list = count.toList();
    return count;
  }

  _asyncSearchFarmerOnline(BuildContext ctx) async {
    submissionLoader(ctx, "Retrieving account", "Please wait a minute...");
    var newVibe;
    try {
      // print(_phonenum.text);

      final response = await http.get(Uri.parse(
          "$stageBaseUrl/searchfarmer/?contact=${_farmerContact.text}&form=alternative"));

      final items = json.decode(response.body);

      print(response.body);
      print(items);
      print(items["farmer_name"]);
      newVibe = items["farmerid"];

      // if (newVibe == "success") {
      //   print("Scale 0");
      //   return items;
      // }

      try {
        if (newVibe != null) {
          Navigator.of(context).pop();
          regSP?.setString('aLfarmerID', items["farmerid"]);
          regSP?.setBool('aLbaseline', items["baseline"]);
          regSP?.setString('aLfarmername', items["farmer_name"]);
          regSP?.setString('aLcommunity', items["community_id"]);
          regSP?.setString('aLfarmerContact', items["contact"]);
          items["baseline"] == true
              ? Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => UpdateAlternativeVisit(
                      name: items["farmer_name"],
                      contact: _farmerContact.text,
                    ),
                  ),
                )
              : Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => AlternateActivityDetails(),
                  ),
                );
          overlayNotification('Record found.', "positive");
          print("Scale 2");

          // return items;
          // _savePlace();
        }
        // else if (newVibe == "not_found") {
        //   Navigator.of(context).pop();

        //   Alert.showSnackBar(
        //     ctx,
        //     text: 'No record found',
        //     color: Colors.red,
        //   );
        //   print("Scale 3");
        // }
        else {
          Navigator.of(context).pop();

          overlayNotification('No record found.', "negative");
          print("Exception part caught");
          print("Scale 5");
        }
      } on SocketException catch (_) {
        getFarmerFromFarmerApiListLocalDB("${_farmerContact.text}");

        Navigator.of(context).pop();
        overlayNotification(
            'Validation failed! Please check internet connection and try again',
            "negative");
        print("Fireabse Notification failed");
        print("Scale 6");
      }

      return response;
    } on SocketException {
      getFarmerFromFarmerApiListLocalDB("${_farmerContact.text}")
          .onError((error, stackTrace) {
        print("Error in exception");
        // getFarmerFromFarmerOfflineLocalDB("${_farmerContact.text}");
      });
      Navigator.of(context).pop();
      overlayNotification(
          'Validation failed! Please check internet connection and try again',
          "negative");
      print("Scale 7");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
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
                                          "Visit Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 15.0),
                                    //   child: Column(
                                    //     children: [
                                    //       Row(
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.center,
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: <Widget>[
                                    //           Row(
                                    //             children: <Widget>[
                                    //               Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.all(
                                    //                         0.0),
                                    //                 child: Text(
                                    //                   "Visit Number",
                                    //                   style: TextStyle(
                                    //                       fontSize: 17,
                                    //                       color:
                                    //                           Colors.black54),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       ButtonBar(
                                    //         alignment: MainAxisAlignment.start,
                                    //         children: <Widget>[
                                    //           Row(
                                    //             children: <Widget>[
                                    //               GenderRadioButton(
                                    //                 value: 1,
                                    //                 group: selectedVisitRadio,
                                    //                 selected: (val) {
                                    //                   print(val);
                                    //                   setState(() {
                                    //                     selectedVisitRadio =
                                    //                         val;
                                    //                     print(val);
                                    //                     _visitNumber = "1";
                                    //                   });
                                    //                 },
                                    //               ),
                                    //               Text(
                                    //                 "1st visit",
                                    //                 // style: TextStyle(
                                    //                 //     color: Color(0xFFf9f9f9)),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       ButtonBar(
                                    //         alignment: MainAxisAlignment.start,
                                    //         children: <Widget>[
                                    //           Row(
                                    //             children: <Widget>[
                                    //               GenderRadioButton(
                                    //                 value: 2,
                                    //                 group: selectedVisitRadio,
                                    //                 selected: (val) {
                                    //                   print(val);
                                    //                   setState(() {
                                    //                     selectedVisitRadio =
                                    //                         val;
                                    //                     _visitNumber = "2";
                                    //                   });
                                    //                 },
                                    //               ),
                                    //               Text(
                                    //                 "2nd visit",
                                    //                 // style: TextStyle(
                                    //                 //     color:
                                    //                 //         Color(0xFFf9f9f9))
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       ButtonBar(
                                    //         alignment: MainAxisAlignment.start,
                                    //         children: <Widget>[
                                    //           Row(
                                    //             children: <Widget>[
                                    //               GenderRadioButton(
                                    //                 value: 3,
                                    //                 group: selectedVisitRadio,
                                    //                 selected: (val) {
                                    //                   print(val);
                                    //                   setState(() {
                                    //                     selectedVisitRadio =
                                    //                         val;
                                    //                     _visitNumber = "3";
                                    //                   });
                                    //                 },
                                    //               ),
                                    //               Text(
                                    //                 "3rd visit",
                                    //                 // style: TextStyle(
                                    //                 //     color:
                                    //                 //         Color(0xFFf9f9f9))
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       ButtonBar(
                                    //         alignment: MainAxisAlignment.start,
                                    //         children: <Widget>[
                                    //           Row(
                                    //             children: <Widget>[
                                    //               GenderRadioButton(
                                    //                 value: 4,
                                    //                 group: selectedVisitRadio,
                                    //                 selected: (val) {
                                    //                   print(val);
                                    //                   setState(() {
                                    //                     selectedVisitRadio =
                                    //                         val;
                                    //                     _visitNumber = "4";
                                    //                   });
                                    //                 },
                                    //               ),
                                    //               Text(
                                    //                 "4th visit",
                                    //                 // style: TextStyle(
                                    //                 //     color:
                                    //                 //         Color(0xFFf9f9f9))
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       ButtonBar(
                                    //         alignment: MainAxisAlignment.start,
                                    //         children: <Widget>[
                                    //           Row(
                                    //             children: <Widget>[
                                    //               GenderRadioButton(
                                    //                 value: 5,
                                    //                 group: selectedVisitRadio,
                                    //                 selected: (val) {
                                    //                   print(val);
                                    //                   setState(() {
                                    //                     selectedVisitRadio =
                                    //                         val;
                                    //                     _visitNumber = "5";
                                    //                   });
                                    //                 },
                                    //               ),
                                    //               Text(
                                    //                 "5th visit",
                                    //                 // style: TextStyle(
                                    //                 //     color:
                                    //                 //         Color(0xFFf9f9f9))
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
                                                  "Date of visit",
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
                                                    _visitDateYear =
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
                                    // _visitNumber == "1" || _visitNumber == null
                                    //     ? Container()
                                    //     :
                                    formFieldLabel(width: size.width * .9, "Enter contact used to register in the first visit"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Enter contact used to register in the first visit"),
                                      controller: _farmerContact,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter a contact number'
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
                                          child:
                                              // _visitNumber == "1" ||
                                              //         _visitNumber == null
                                              // ?
                                              // RaisedButton(
                                              //     elevation: 0,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               10.0),
                                              //     ),
                                              //     child: Text(
                                              //       "Next",
                                              //       style: TextStyle(
                                              //           fontSize: 17.0,
                                              //           fontWeight:
                                              //               FontWeight.normal),
                                              //     ),
                                              //     color: fPrimaryColour,
                                              //     textColor: Colors.white,
                                              //     onPressed: () async {
                                              //       if (_visitNumber == null) {
                                              //         Alert.showSnackBar(
                                              //           context,
                                              //           text:
                                              //               'Please select an order of visit',
                                              //           color: Colors.red,
                                              //         );
                                              //       } else if (_visitDateYear ==
                                              //           null) {
                                              //         Alert.showSnackBar(
                                              //           context,
                                              //           text:
                                              //               'Please select date year',
                                              //           color: Colors.red,
                                              //         );
                                              //       } else if (_formKey
                                              //           .currentState
                                              //           .validate()) {
                                              //         setBFValuesT();
                                              //         // regSP?.setBool(
                                              //         //     "farmerskipped", false);
                                              //         Navigator.of(context)
                                              //             .push(
                                              //           CupertinoPageRoute(
                                              //             builder: (BuildContext
                                              //                     context) =>
                                              //                 AlternativeFarmer(),
                                              //           ),
                                              //         );
                                              //       }
                                              //     },
                                              //   )
                                              // :
                                              ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
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
                                              // if (_visitNumber == null) {
                                              //   Alert.showSnackBar(
                                              //     context,
                                              //     text:
                                              //         'Please select an order of visit',
                                              //     color: Colors.red,
                                              //   );
                                              // } else
                                              if (_visitDateYear == null) {
                                                overlayNotification(
                                                    'Please select date year',
                                                    "negative");
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                setBFValuesT();
                                                // regSP?.setBool(
                                                //     "farmerskipped", false);
                                                _asyncSearchFarmerOnline(
                                                    context);
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
