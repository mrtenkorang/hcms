// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/farmerdetails.dart';

// class AlternativeLiving extends StatefulWidget {
//   const AlternativeLiving({Key key}) : super(key: key);

//   @override
//   _AlternativeLivingState createState() => _AlternativeLivingState();
// }

// class _AlternativeLivingState extends State<AlternativeLiving> {
//   final _formKey = GlobalKey<FormState>();

//   String _visitDateYear;
//   String _visitNumber;

//   // String initKinValue = "Select your Birth Date";
//   bool isVisitDate = false;
//   // DateTime kinBirthDate;
//   String visitDateYearInString;
//   // bool hasKinBeenClicked;

//   bool errorMessage = false;

//   int selectedVisitRadio;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar( foregroundColor: fPrimaryWhite,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Alternative Livelihood",
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             offset: Offset(2.00, 3.00),
//             color: Colors.black,
//             onSelected: (String _downChoice) {
//               if (_downChoice == SkipConstants.home) {
//                 return Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => IndexPage(),
//                   ),
//                 );
//               } else if (_downChoice == SkipConstants.saveskip) {
//                 // setGDValuesT();
//                 // regSP.setBool("farmerskipped", true);
//                 Navigator.of(context).push(
//                   CupertinoPageRoute(
//                     builder: (BuildContext context) => FarmDetails(),
//                   ),
//                 );
//               } else if (_downChoice == SkipConstants.saveclose) {
//                 // regSP.setBool("closed", true);
//                 // Navigator.of(context).push(
//                 //   CupertinoPageRoute(
//                 //     builder: (BuildContext context) => FarmDetails(),
//                 //   ),
//                 // );
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return SkipConstants.downChoices.map((String _downChoice) {
//                 return PopupMenuItem<String>(
//                   value: _downChoice,
//                   child: Container(
//                     margin: EdgeInsets.only(right: 0),
//                     child: Text(
//                       _downChoice,
//                       style: TextStyle(color: Color(0xFFFFFFFF)),
//                     ),
//                   ),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             // height: MediaQuery.of(context).size.height,
//             margin: EdgeInsets.all(0.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   // height: MediaQuery.of(context).size.height / 2,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             Material(
//                               elevation: 0,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8.0, vertical: 20.0),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         // Text(
//                                         //   "Group/ Company Details",
//                                         //   style: TextStyle(
//                                         //       fontWeight: FontWeight.bold,
//                                         //       fontSize: 24.0),
//                                         // ),
//                                       ],
//                                     ),
//                                     TextFieldWidget(
//                                       keyboardType: TextInputType.text,
//                                       decoration: InputDecoration(
//                                           labelText: "Community name"),
//                                       // controller: _groupName,
//                                       validator: (input) => input.trim().isEmpty
//                                           ? 'Please enter Community name'
//                                           : null,
//                                     ),
//                                     Container(
//                                       margin: EdgeInsets.only(top: 15.0),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             0.0),
//                                                     child: Text(
//                                                       "Visit Number",
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black54),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           ButtonBar(
//                                             alignment: MainAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   GenderRadioButton(
//                                                     value: 1,
//                                                     group: selectedVisitRadio,
//                                                     selected: (val) {
//                                                       print(val);
//                                                       setState(() {
//                                                         selectedVisitRadio =
//                                                             val;
//                                                         print(val);
//                                                         _visitNumber = "1";
//                                                       });
//                                                     },
//                                                   ),
//                                                   Text(
//                                                     "1st visit",
//                                                     // style: TextStyle(
//                                                     //     color: Color(0xFFf9f9f9)),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           ButtonBar(
//                                             alignment: MainAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   GenderRadioButton(
//                                                     value: 2,
//                                                     group: selectedVisitRadio,
//                                                     selected: (val) {
//                                                       print(val);
//                                                       setState(() {
//                                                         selectedVisitRadio =
//                                                             val;
//                                                         _visitNumber = "2";
//                                                       });
//                                                     },
//                                                   ),
//                                                   Text(
//                                                     "2nd visit",
//                                                     // style: TextStyle(
//                                                     //     color:
//                                                     //         Color(0xFFf9f9f9))
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           ButtonBar(
//                                             alignment: MainAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   GenderRadioButton(
//                                                     value: 3,
//                                                     group: selectedVisitRadio,
//                                                     selected: (val) {
//                                                       print(val);
//                                                       setState(() {
//                                                         selectedVisitRadio =
//                                                             val;
//                                                         _visitNumber = "3";
//                                                       });
//                                                     },
//                                                   ),
//                                                   Text(
//                                                     "3rd visit",
//                                                     // style: TextStyle(
//                                                     //     color:
//                                                     //         Color(0xFFf9f9f9))
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           ButtonBar(
//                                             alignment: MainAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   GenderRadioButton(
//                                                     value: 4,
//                                                     group: selectedVisitRadio,
//                                                     selected: (val) {
//                                                       print(val);
//                                                       setState(() {
//                                                         selectedVisitRadio =
//                                                             val;
//                                                         _visitNumber = "4";
//                                                       });
//                                                     },
//                                                   ),
//                                                   Text(
//                                                     "4th visit",
//                                                     // style: TextStyle(
//                                                     //     color:
//                                                     //         Color(0xFFf9f9f9))
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           ButtonBar(
//                                             alignment: MainAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   GenderRadioButton(
//                                                     value: 5,
//                                                     group: selectedVisitRadio,
//                                                     selected: (val) {
//                                                       print(val);
//                                                       setState(() {
//                                                         selectedVisitRadio =
//                                                             val;
//                                                         _visitNumber = "5";
//                                                       });
//                                                     },
//                                                   ),
//                                                   Text(
//                                                     "5th visit",
//                                                     // style: TextStyle(
//                                                     //     color:
//                                                     //         Color(0xFFf9f9f9))
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.symmetric(vertical: 20),
//                                       child: new Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Row(
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(0.0),
//                                                 child: Text(
//                                                   "Date of visit",
//                                                   style: TextStyle(
//                                                       fontSize: 17,
//                                                       color: Colors.black54),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(10.0),
//                                             child: GestureDetector(
//                                               child: isVisitDate == true
//                                                   ? Container(
//                                                       decoration: BoxDecoration(
//                                                         color: fPrimaryColour,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(30),
//                                                       ),
//                                                       height: 40.0,
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               2.5,
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     8.0),
//                                                         child: Row(
//                                                           children: <Widget>[
//                                                             Icon(
//                                                               Icons
//                                                                   .arrow_drop_down_circle,
//                                                               size: 22,
//                                                               color: Color(
//                                                                   0xFFffe423),
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                   horizontal:
//                                                                       8.0),
//                                                               child: Text(
//                                                                 visitDateYearInString,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Color(
//                                                                       0xFFf9f9f9),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : Row(
//                                                       children: <Widget>[
//                                                         Icon(
//                                                           Icons
//                                                               .arrow_drop_down_circle,
//                                                           size: 18,
//                                                           color: fPrimaryColour,
//                                                         ),
//                                                         Icon(
//                                                           Icons.calendar_today,
//                                                           // size: 34,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                               onTap: () {
//                                                 DatePicker.showDatePicker(
//                                                     context,
//                                                     theme: DatePickerTheme(
//                                                       backgroundColor:
//                                                           fPrimaryColour,
//                                                       itemStyle: TextStyle(
//                                                           color: Color(
//                                                               0xFFf9f9f9)),
//                                                       cancelStyle: TextStyle(
//                                                           color: Color(
//                                                               0xFFffe423)),
//                                                       doneStyle: TextStyle(
//                                                           color: Color(
//                                                               0xFFf9f9f9)),
//                                                       containerHeight: 210.0,
//                                                     ),
//                                                     showTitleActions: true,
//                                                     minTime: DateTime(1800),
//                                                     maxTime: DateTime.now(),
//                                                     onConfirm: (date) {
//                                                   print('confirm $date');
//                                                   isVisitDate = true;
//                                                   visitDateYearInString =
//                                                       '${date.year}-${date.month}-${date.day}';
//                                                   setState(() {
//                                                     _visitDateYear =
//                                                         '${date.year}-${date.month}-${date.day}';
//                                                     print(
//                                                         "DOOB ${date.year}-${date.month}-${date.day}");
//                                                   });
//                                                 },
//                                                     // currentTime: DateTime.now(),
//                                                     locale: LocaleType.en);
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 30.0),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Container(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               3,
//                                           height: 50.00,
//                                           child: RaisedButton(
//                                             elevation: 0,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                             ),
//                                             child: Text(
//                                               "Next",
//                                               style: TextStyle(
//                                                   fontSize: 17.0,
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                             ),
//                                             color: fPrimaryColour,
//                                             textColor: Colors.white,
//                                             onPressed: () async {
//                                               if (_formKey.currentState
//                                                   .validate()) {
//                                                 // setGDValuesT();
//                                                 // regSP.setBool(
//                                                 //     "farmerskipped", false);
//                                                 Navigator.of(context).push(
//                                                   CupertinoPageRoute(
//                                                     builder: (BuildContext
//                                                             context) =>
//                                                         AlternativeFarmer(),
//                                                   ),
//                                                 );
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                         Container(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               3,
//                                           height: 50.00,
//                                           child: RaisedButton(
//                                             elevation: 0,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                             ),
//                                             child: Text(
//                                               "Skip",
//                                               style: TextStyle(
//                                                   fontSize: 17.0,
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                             ),
//                                             color: fPrimaryColour,
//                                             textColor: Colors.white,
//                                             onPressed: () async {
//                                               // setGDValuesT();
//                                               // regSP.setBool(
//                                               //     "farmerskipped", true);
//                                               Navigator.of(context).push(
//                                                 CupertinoPageRoute(
//                                                   builder: (BuildContext
//                                                           context) =>
//                                                       AlternativeFarmer(
//                                                           // p: _visitNumber,
//                                                           ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Container(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
