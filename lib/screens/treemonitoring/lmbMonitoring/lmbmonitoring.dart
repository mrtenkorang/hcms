import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/lmbprivfin.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

class LmbMonitoring extends StatefulWidget {
  const LmbMonitoring({Key? key}) : super(key: key);

  @override
  _LmbMonitoringState createState() => _LmbMonitoringState();
}

class _LmbMonitoringState extends State<LmbMonitoring> {
  final _formKey = GlobalKey<FormState>();

  final _lmbName = TextEditingController();

  String? _visitDateYear;
  String? _sectorType;

  bool isVisitDate = false;
  String? visitDateYearInString;

  bool errorMessage = false;

  int? selectedVisitRadio;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: fPrimaryWhite,
        backgroundColor: fPrimaryColour,
        automaticallyImplyLeading: false,
        title: Text(
          "Private Sector Engagement",
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
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     Text(
                                    //       "Engagement Type",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 24.0),
                                    //     ),
                                    //   ],
                                    // ),
                                    titleOne("Engagement Type"),
                                    SizedBox(height: 15.0),
                                    formFieldLabel(width: size.width * .9, "LMB name"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: "LMB name"),
                                      controller: _lmbName,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter LMB name'
                                              : null,
                                    ),
                                    // Container(
                                    //   margin:
                                    //       EdgeInsets.symmetric(vertical: 20),
                                    //   child: new Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: <Widget>[
                                    //       Row(
                                    //         children: <Widget>[
                                    //           Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(0.0),
                                    //             child: Text(
                                    //               "Year",
                                    //               style: TextStyle(
                                    //                   fontSize: 17,
                                    //                   color: Colors.black54),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       Padding(
                                    //         padding: const EdgeInsets.all(10.0),
                                    //         child: GestureDetector(
                                    //           child: isVisitDate == true
                                    //               ? Container(
                                    //                   decoration: BoxDecoration(
                                    //                     color: fPrimaryColour,
                                    //                     borderRadius:
                                    //                         BorderRadius
                                    //                             .circular(30),
                                    //                   ),
                                    //                   height: 40.0,
                                    //                   width:
                                    //                       MediaQuery.of(context)
                                    //                               .size
                                    //                               .width /
                                    //                           2.5,
                                    //                   child: Padding(
                                    //                     padding:
                                    //                         const EdgeInsets
                                    //                                 .symmetric(
                                    //                             horizontal:
                                    //                                 8.0),
                                    //                     child: Row(
                                    //                       children: <Widget>[
                                    //                         Icon(
                                    //                           Icons
                                    //                               .arrow_drop_down_circle,
                                    //                           size: 22,
                                    //                           color: Color(
                                    //                               0xFFffe423),
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets
                                    //                                   .symmetric(
                                    //                               horizontal:
                                    //                                   8.0),
                                    //                           child: Text(
                                    //                             visitDateYearInString,
                                    //                             style:
                                    //                                 TextStyle(
                                    //                               color: Color(
                                    //                                   0xFFf9f9f9),
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 )
                                    //               : Row(
                                    //                   children: <Widget>[
                                    //                     Icon(
                                    //                       Icons
                                    //                           .arrow_drop_down_circle,
                                    //                       size: 18,
                                    //                       color: fPrimaryColour,
                                    //                     ),
                                    //                     Icon(
                                    //                       Icons.calendar_today,
                                    //                       // size: 34,
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 20,
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //           onTap: () {
                                    //             DatePicker.showDatePicker(
                                    //                 context,
                                    //                 theme: DatePickerTheme(
                                    //                   backgroundColor:
                                    //                       fPrimaryColour,
                                    //                   itemStyle: TextStyle(
                                    //                       color: Color(
                                    //                           0xFFf9f9f9)),
                                    //                   cancelStyle: TextStyle(
                                    //                       color: Color(
                                    //                           0xFFffe423)),
                                    //                   doneStyle: TextStyle(
                                    //                       color: Color(
                                    //                           0xFFf9f9f9)),
                                    //                   containerHeight: 210.0,
                                    //                 ),
                                    //                 showTitleActions: true,
                                    //                 minTime: DateTime(1800),
                                    //                 maxTime: DateTime.now(),
                                    //                 onConfirm: (date) {
                                    //               print('confirm $date');
                                    //               isVisitDate = true;
                                    //               visitDateYearInString =
                                    //                   '${date.year}';
                                    //               setState(() {
                                    //                 _visitDateYear =
                                    //                     '${date.year}-${date.month}-${date.day}';
                                    //                 print(
                                    //                     "DOOB $_visitDateYear");
                                    //               });
                                    //             },
                                    //                 // currentTime: DateTime.now(),
                                    //                 locale: LocaleType.en);
                                    //           },
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 20.0, bottom: 5.0),
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
                                                      "Engagement type",
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
                                                        _sectorType = "Private";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Private sector engagement",
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
                                                        _sectorType =
                                                            "Financial";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Financial sector engagement",
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
                                    SizedBox(
                                      height: 40,
                                      // child: Divider(),
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
                                              if (_sectorType == null) {
                                                overlayNotification(
                                                    'Please select engagement type',
                                                    "negative");
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                // setGDValuesT();
                                                // regSP.setBool(
                                                //     "farmerskipped", false);
                                                Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LmbPrivFinPage(
                                                      lmbName: _lmbName.text,
                                                      // dateYear: _visitDateYear,
                                                      sector: _sectorType!,
                                                    ),
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
