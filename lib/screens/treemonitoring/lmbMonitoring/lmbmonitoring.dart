// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/private_sector_engagement_screen.dart';
// import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
// import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
//
// class LmbMonitoring extends StatefulWidget {
//   const LmbMonitoring({Key? key}) : super(key: key);
//
//   @override
//   _LmbMonitoringState createState() => _LmbMonitoringState();
// }
//
// class _LmbMonitoringState extends State<LmbMonitoring> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _lmbName = TextEditingController();
//
//   String? _visitDateYear;
//   String? _sectorType;
//
//   bool isVisitDate = false;
//   String? visitDateYearInString;
//
//   bool errorMessage = false;
//
//   int? selectedVisitRadio;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: fPrimaryWhite,
//         backgroundColor: fPrimaryColour,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Private Sector Engagement",
//           style: TextStyle(color: fPrimaryWhite),
//         ),
//         actions: [
//           Tooltip(
//             message: "Takes you back to homepage",
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: InkWell(
//                 child: Icon(Icons.home, color: fPrimaryWhite),
//                 onTap: () => Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => IndexPage(),
//                   ),
//                 ),
//               ),
//             ),
//           )
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
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Material(
//                             elevation: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 20.0),
//                               child: Column(
//                                 children: [
//                                   titleOne("Engagement Type"),
//                                   SizedBox(height: 15.0),
//                                   formFieldLabel(width: size.width * .9, "LMB name"),
//                                   TextFieldWidget(
//                                     keyboardType: TextInputType.text,
//                                     decoration: InputDecoration(
//                                         labelText: "LMB name"),
//                                     controller: _lmbName,
//                                     validator: (input) =>
//                                         input!.trim().isEmpty
//                                             ? 'Please enter LMB name'
//                                             : null,
//                                   ),
//
//                                   Container(
//                                     margin: EdgeInsets.only(
//                                         top: 20.0, bottom: 5.0),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(
//                                                           0.0),
//                                                   child: Text(
//                                                     "Engagement type",
//                                                     style: TextStyle(
//                                                         fontSize: 17,
//                                                         color:
//                                                             Colors.black54),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         OverflowBar(
//                                           alignment: MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 GenderRadioButton(
//                                                   value: 1,
//                                                   group: selectedVisitRadio,
//                                                   selected: (val) {
//                                                     debugPrint(val);
//                                                     setState(() {
//                                                       selectedVisitRadio =
//                                                           val;
//                                                       debugPrint(val);
//                                                       _sectorType = "Private";
//                                                     });
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   "Private sector engagement",
//                                                   // style: TextStyle(
//                                                   //     color: Color(0xFFf9f9f9)),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         OverflowBar(
//                                           alignment: MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 GenderRadioButton(
//                                                   value: 2,
//                                                   group: selectedVisitRadio,
//                                                   selected: (val) {
//                                                     debugPrint(val);
//                                                     setState(() {
//                                                       selectedVisitRadio =
//                                                           val;
//                                                       _sectorType =
//                                                           "Financial";
//                                                     });
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   "Financial sector engagement",
//                                                   // style: TextStyle(
//                                                   //     color:
//                                                   //         Color(0xFFf9f9f9))
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 40,
//                                     // child: Divider(),
//                                   ),
//                                   // SizedBox(height: 30.0),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                             3,
//                                         height: 50.00,
//                                         child: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             elevation: 0.0,
//                                             backgroundColor: fPrimaryColour,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                             ),
//                                             textStyle: const TextStyle(
//                                                 color: fPrimaryWhite),
//                                             // shadowColor: fPrimaryColour,
//                                           ),
//                                           child: Text(
//                                             "Next",
//                                             style: TextStyle(
//                                                 color: fPrimaryWhite,
//                                                 fontSize: 17.0,
//                                                 fontWeight:
//                                                     FontWeight.normal),
//                                           ),
//                                           onPressed: () async {
//                                             if (_sectorType == null) {
//                                               overlayNotification(
//                                                   'Please select engagement type',
//                                                   "negative");
//                                             } else if (_formKey.currentState!
//                                                 .validate()) {
//                                               // setGDValuesT();
//                                               // regSP.setBool(
//                                               //     "farmerskipped", false);
//                                               Navigator.of(context).push(
//                                                 CupertinoPageRoute(
//                                                   builder: (BuildContext
//                                                           context) =>
//                                                       PrivateSectorEngagementScreen(
//                                                     lmbName: _lmbName.text,
//                                                     // dateYear: _visitDateYear,
//                                                     sector: _sectorType!,
//                                                   ),
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
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
