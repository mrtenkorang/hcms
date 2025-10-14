import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LmbPrivFinPage extends StatefulWidget {
  final String? lmbName;
  final String? dateYear;
  final String? sector;

  const LmbPrivFinPage({
    Key? key,
    this.lmbName,
    this.dateYear,
    this.sector,
  }) : super(key: key);

  @override
  _LmbPrivFinPageState createState() => _LmbPrivFinPageState();
}

class _LmbPrivFinPageState extends State<LmbPrivFinPage> {
  final _formKey = GlobalKey<FormState>();

  String? _firstEngagement;
  bool isVisitDate = false;
  String? visitDateYearInString;

//private
  final _privateName = TextEditingController();
  final _partnershipType = TextEditingController();
  final _partnershipDuration = TextEditingController();
  final _mouSigned = TextEditingController();
//financial
  final _financialName = TextEditingController();
  final _typeLoanService = TextEditingController();
  final _loanDuration = TextEditingController();
  final _loanInterest = TextEditingController();
  final _maleBenefitting = TextEditingController();
  final _femaleBenefitting = TextEditingController();
  final _youthBenefitting = TextEditingController();

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

  void saveToLocalDB(String con) {
    Provider.of<LMBMonitoringProvider>(context, listen: false).addLMBMonitoring(
      enumeratorvalue.toString(),
      widget.lmbName ?? "",
      widget.sector ?? "",
      _privateName.text,
      _firstEngagement ?? "",
      _partnershipType.text,
      _partnershipDuration.text,
      _mouSigned.text,
      _financialName.text,
      _typeLoanService.text,
      _loanDuration.text,
      _loanInterest.text,
      _femaleBenefitting.text,
      _maleBenefitting.text,
      _youthBenefitting.text,
      con,
    );

    print("Successfully saved Training Log to local DB");
  }

  attemptLMBUpload(BuildContext ctx) async {
    int male = _maleBenefitting.text.isEmpty
        ? int.parse("0")
        : int.parse(_maleBenefitting.text);
    int female = _femaleBenefitting.text.isEmpty
        ? int.parse("0")
        : int.parse(_femaleBenefitting.text);
    int youth = _youthBenefitting.text.isEmpty
        ? int.parse("0")
        : int.parse(_youthBenefitting.text);
    double loanDur = _loanDuration.text.isEmpty
        ? double.parse("0")
        : double.parse(_loanDuration.text);
    double loanInt = _loanInterest.text.isEmpty
        ? double.parse("0")
        : double.parse(_loanInterest.text);

    // getSPValues();
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");
    getEnumeratorValue('first_time_user');
    overlayNotification('Data uploading... Please wait.', "positive");

    try {
      var lmbMonitoring = {
        "enumeratorDetails": {
          "enumerator": enumeratorvalue,
          "lmbName": widget.lmbName,
          "lmbType": widget.sector! + " Sector Engagement"
        },
        "engagementDetails": {
          "privateSectorName": _privateName.text,
          "dateOfFirstEng": _firstEngagement,
          "partnershipType": _partnershipType.text,
          "partnershipDuration": _partnershipDuration.text,
          "mouSigned": _mouSigned.text,
          "finServiceName": _financialName.text,
          "finServiceType": _typeLoanService.text,
          "loanDuration": loanDur,
          "interestRate": loanInt,
          "numOfFarmersBenfitting": {
            "female": female,
            "male": male,
            "youth": youth
          }
        }
      };

      var url = '$stageBaseUrl/lmbmonitoringapi/';

      var body = json.encode(lmbMonitoring);

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
        backgroundColor: fPrimaryColour,
        automaticallyImplyLeading: false,
        title: Text(
          "Sector Engagement",
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
                widget.sector == "Private"
                    ? Container(
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
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          //   children: [
                                          //     Text(
                                          //       "Engagement Details",
                                          //       style: TextStyle(
                                          //           fontWeight: FontWeight.bold,
                                          //           fontSize: 24.0),
                                          //     ),
                                          //   ],
                                          // ),
                                          titleOne("Engagement Details"),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Name of private sector"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Name of private sector"),
                                            controller: _privateName,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a name'
                                                    : null,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Text(
                                                        "Date of first engagement",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GestureDetector(
                                                    child: isVisitDate == true
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
                                                                  Icon(
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
                                                              DatePickerTheme(
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
                                                          showTitleActions:
                                                              true,
                                                          minTime:
                                                              DateTime(1800),
                                                          maxTime:
                                                              DateTime.now(),
                                                          onConfirm: (date) {
                                                        print('confirm $date');
                                                        isVisitDate = true;
                                                        visitDateYearInString =
                                                            '${date.year}-${date.month}-${date.day}';
                                                        setState(() {
                                                          _firstEngagement =
                                                              '${date.year}-${date.month}-${date.day}';
                                                          print(
                                                              "DOOB ${date.year}-${date.month}-${date.day}");
                                                        });
                                                      },
                                                          // currentTime: DateTime.now(),
                                                          locale:
                                                              LocaleType.en);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          formFieldLabel(width: size.width * .9, "Type of partnership"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Type of partnership"),
                                            controller: _partnershipType,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Field cannot be empty'
                                                    : null,
                                          ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Duration of partnership"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Duration of partnership"),
                                            controller: _partnershipDuration,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Field cannot be empty'
                                                    : null,
                                          ),
                                          formFieldLabel(width: size.width * .9, "Any MoU signed?"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText: "Any MoU signed?"),
                                            controller: _mouSigned,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Field cannot be empty'
                                                    : null,
                                          ),
                                          SizedBox(height: 30.0),
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
                                                      BorderRadius.circular(
                                                          10.0),
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
                                                // getSPValues();
                                                if (_firstEngagement == null) {
                                                  overlayNotification(
                                                      'Please select date year',
                                                      "negative");
                                                } else if (_formKey
                                                    .currentState!
                                                    .validate()) {
                                                  submissionOptions(
                                                    context,
                                                    "Do you have internet data?",
                                                    "Send with internet",
                                                    "Send later",
                                                    "Cancel",
                                                    approvePress: () =>
                                                        attemptLMBUpload(
                                                            context),
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
                                                              TreeMonitoringDecider(),
                                                        ),
                                                      );
                                                      // regSP.clear();
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
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
                                              // Text(
                                              //   "Group/ Company Details",
                                              //   style: TextStyle(
                                              //       fontWeight: FontWeight.bold,
                                              //       fontSize: 24.0),
                                              // ),
                                            ],
                                          ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Name of financial sector"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Name of financial sector"),
                                            controller: _financialName,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a name'
                                                    : null,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Text(
                                                        "Date of first engagement",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GestureDetector(
                                                    child: isVisitDate == true
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
                                                                  Icon(
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
                                                              DatePickerTheme(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF272791),
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
                                                          showTitleActions:
                                                              true,
                                                          minTime:
                                                              DateTime(1800),
                                                          maxTime:
                                                              DateTime.now(),
                                                          onConfirm: (date) {
                                                        print('confirm $date');
                                                        isVisitDate = true;
                                                        visitDateYearInString =
                                                            '${date.year}-${date.month}-${date.day}';
                                                        setState(() {
                                                          _firstEngagement =
                                                              '${date.year}-${date.month}-${date.day}';
                                                          print(
                                                              "DOOB ${date.year}-${date.month}-${date.day}");
                                                        });
                                                      },
                                                          // currentTime: DateTime.now(),
                                                          locale:
                                                              LocaleType.en);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Type of loan/ financial service"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Type of loan/ financial service"),
                                            controller: _typeLoanService,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a value'
                                                    : null,
                                          ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Duration of loans (in years)"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Duration of loans (in years)"),
                                            controller: _loanDuration,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a value'
                                                    : null,
                                          ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Interest rate on the loan (%)"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Interest rate on the loan (%)"),
                                            controller: _loanInterest,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a value'
                                                    : null,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20),
                                            // child: Row(
                                            //   children: <Widget>[
                                            //     Padding(
                                            //       padding:
                                            //           const EdgeInsets.all(0.0),
                                            //       child: Text(
                                            //         "Number of farmers"
                                            //         " benefitting",
                                            //         style: TextStyle(
                                            //             fontSize: 17,
                                            //             color: Colors.black),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            child: titleOne(
                                              "Number of farmers"
                                              " benefitting",
                                            ),
                                          ),
                                          formFieldLabel(width: size.width * .9, "Male"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Male"),
                                            controller: _maleBenefitting,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a number'
                                                    : null,
                                          ),
                                          formFieldLabel(width: size.width * .9, "Female"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Female"),
                                            controller: _femaleBenefitting,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a number'
                                                    : null,
                                          ),
                                          formFieldLabel(width: size.width * .9, "Youth"),
                                          TextFieldWidget(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Youth"),
                                            controller: _youthBenefitting,
                                            validator: (input) =>
                                                input!.trim().isEmpty
                                                    ? 'Please enter a number'
                                                    : null,
                                          ),
                                          SizedBox(height: 30.0),
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
                                                      BorderRadius.circular(
                                                          10.0),
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
                                                // getSPValues();
                                                if (_firstEngagement == null) {
                                                  overlayNotification(
                                                      'Please select date year',
                                                      "negative");
                                                }
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  submissionOptions(
                                                    context,
                                                    "Do you have internet data?",
                                                    "Send with internet",
                                                    "Send later",
                                                    "Cancel",
                                                    approvePress: () =>
                                                        attemptLMBUpload(
                                                            context),
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
                                                              TreeMonitoringDecider(),
                                                        ),
                                                      );
                                                      // regSP.clear();
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
