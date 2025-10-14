// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/screens/seedlingmonitoring/1general_information.dart';
// import 'package:hcms_revived2/screens/seedlingmonitoring/combined_seedling_monitoring.dart';
// import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
// import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/monitoredspecieslist.dart';
// import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/treedetails.dart';
// import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/updateseedVisit.dart';
// import 'package:hcms_revived2/services/serverurls.dart';
// import 'package:hcms_revived2/utils/constants/colours.dart';
// import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
// import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
//
// import 'package:http/http.dart' as http;
// import 'package:sqflite/sqflite.dart';
//
// class SeedlingSurvivalRateFirstPage extends StatefulWidget {
//   const SeedlingSurvivalRateFirstPage({Key? key}) : super(key: key);
//
//   @override
//   _SeedlingSurvivalRateFirstPageState createState() =>
//       _SeedlingSurvivalRateFirstPageState();
// }
//
// class _SeedlingSurvivalRateFirstPageState
//     extends State<SeedlingSurvivalRateFirstPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // "$stageBaseUrl/searchfarmer/?contact=0248823823&form=alternative
//
//   final _farmerContact = TextEditingController();
//
//   String? _visitDateYear;
//   String? _visitNumber;
//
//   bool isVisitDate = false;
//   String? visitDateYearInString;
//
//   bool errorMessage = false;
//
//   int? selectedVisitRadio;
//
//   Future<dynamic> getFarmerFromFarmerOfflineLocalDB(farmercontact) async {
//     print("traversing offline farmer instead");
//     final db = await DBHelper.database();
//     // var count = await db
//     //     .rawQuery('SELECT *'
//     //         ' FROM farmer_offline WHERE foContact'
//     //         ' LIKE $farmercontact')
//     //     .then((value) {
//     var count = await db
//         .query(
//           "farmer_offline",
//           where: "foContact = ?",
//           whereArgs: [farmercontact],
//         )
//         .then((value) {
//           if (value.isNotEmpty) {
//             print("eyo ${value[0]['foContact']}");
//
//             regSP?.setString('smcommunity', value[0]['foCommunity'].toString());
//             regSP?.setString(
//               'smfarmername',
//               value[0]['foFarmerName'].toString(),
//             );
//             regSP?.setString(
//               'smfarmerContact',
//               value[0]['foContact'].toString(),
//             );
//             regSP?.setString('smfoGender', value[0]['foGender'].toString());
//             regSP?.setString('smfoDoB', value[0]['foDoB'].toString());
//             regSP?.setString(
//               'smfoHolderCategory',
//               value[0]['foHolderCategory'].toString(),
//             );
//             regSP?.setString('smfoFarmSize', value[0]['foFarmSize'].toString());
//             regSP?.setBool('unsavedlocal', true);
//
//             print("Name is ${value}");
//             Navigator.of(context).push(
//               CupertinoPageRoute(builder: (context) => const TreeDetails()),
//             );
//             overlayNotification('Local record found.', "positive");
//           } else {
//             overlayNotification('No record found.', "negative");
//           }
//         });
//
//     // var list = count.toList();
//     return count;
//   }
//
//   static int countos = 0;
//
//   static Future<int> getFarmerApiListSeedlingNumber() async {
//     final db = await DBHelper.database();
//     countos = Sqflite.firstIntValue(
//       await db.rawQuery('SELECT COUNT (*) FROM farmer_api_list_seedling'),
//     )!;
//     print("Countos counted was $countos");
//     return countos;
//   }
//
//   Future<dynamic> getFarmerFromFarmerApiListLocalDB(farmercontact) async {
//     print("traversing local farmer api list with $farmercontact");
//     getFarmerApiListSeedlingNumber();
//     final db = await DBHelper.database();
//     // var count = await db
//     //     .rawQuery('SELECT * FROM'
//     //         ' farmer_api_list_seedling WHERE falSContact LIKE ${farmercontact.toString()}')
//     var count = await db
//         .query(
//           "farmer_api_list_seedling",
//           where: "falSContact = ?",
//           whereArgs: [farmercontact],
//         )
//         .then((value) {
//           if (value.isEmpty) {
//             print("doing the then bit $value");
//             getFarmerFromFarmerOfflineLocalDB(farmercontact);
//           } else {
//             print("It isn't empty $value");
//
//             regSP?.setString('smfarmerID', value[0]['id'].toString());
//             regSP?.setBool(
//               'smbaseline',
//               value[0]['falSBaseline'] == "true" ? true : false,
//             );
//             regSP?.setString(
//               'smfarmername',
//               value[0]['falSFarmerName'].toString(),
//             );
//             regSP?.setString(
//               'smcommunity',
//               value[0]['falSCommunityId'].toString(),
//             );
//             regSP?.setString(
//               'smfarmerContact',
//               value[0]['falSContact'].toString(),
//             );
//             regSP?.setBool('unsavedlocal', false);
//
//             value[0]['falSBaseline'] == true
//                 ? Navigator.of(context).push(
//                     CupertinoPageRoute(
//                       builder: (context) => UpdateSeedlingVisit(
//                         name: value[0]['falSFarmerName'].toString(),
//                         contact: value[0]['falSContact'].toString(),
//                       ),
//                     ),
//                   )
//                 : Navigator.of(context).push(
//                     CupertinoPageRoute(
//                       builder: (context) => const TreeDetails(),
//                     ),
//                   );
//             overlayNotification('Record found.', "positive");
//           }
//         });
//
//     // var list = count.toList();
//     return count;
//   }
//
//   _asyncSearchFarmerOnline(BuildContext ctx) async {
//     submissionLoader(ctx, "Retrieving account", "Please wait a minute...");
//     var newVibe;
//     try {
//       // print(_phonenum.text);
//
//       final response = await http.get(
//         Uri.parse(
//           "$stageBaseUrl/searchfarmer/?contact=${_farmerContact.text}&form=seedling",
//         ),
//       );
//
//       final items = json.decode(response.body);
//
//       print(response.body);
//       print(items);
//       print(items["farmer_name"]);
//       newVibe = items["farmerid"];
//
//       // if (newVibe == "success") {
//       //   print("Scale 0");
//       //   return items;
//       // }
//
//       try {
//         if (newVibe != null) {
//           Navigator.of(context).pop();
//           regSP?.setString('smfarmerID', items["farmerid"]);
//           regSP?.setBool('smbaseline', items["baseline"]);
//           regSP?.setString('smfarmername', items["farmer_name"]);
//           regSP?.setString('smcommunity', items["community_id"]);
//           regSP?.setString('smfarmerContact', items["contact"]);
//           items["baseline"] == true
//               // ? Navigator.of(context).push(
//               //     CupertinoPageRoute(
//               //       builder: (context) => UpdateSeedlingVisit(
//               //         name: items["farmer_name"],
//               //         contact: _farmerContact.text,
//               //       ),
//               //     ),
//               //   )
//               ? Navigator.push(
//                   context,
//                   CupertinoPageRoute(
//                     builder: (context) => CombinedSeedlingMonitoringScreen(),
//                   ),
//                 )
//               // Navigator.of(context).push(
//               //         CupertinoPageRoute(
//               //           builder: (context) => SeedlingMonitoringGeneralInformation(
//               //             name: items["farmer_name"],
//               //             contact: _farmerContact.text,
//               //           ),
//               //         ),
//               //       )
//               : Navigator.of(context).push(
//                   CupertinoPageRoute(builder: (context) => const TreeDetails()),
//                 );
//           overlayNotification('Record found.', "positive");
//           print("Scale 2");
//
//           // return items;
//           // _savePlace();
//         }
//         // else if (newVibe == "not_found") {
//         //   Navigator.of(context).pop();
//         //   Alert.showSnackBar(
//         //     ctx,
//         //     text: 'No record found',
//         //     color: Colors.red,
//         //   );
//         //   print("Scale 3");
//         // }
//         else {
//           Navigator.of(context).pop();
//
//           overlayNotification('No record found.', "negative");
//           print("Exception part caught");
//           print("Scale 5");
//         }
//       } on SocketException catch (_) {
//         getFarmerFromFarmerApiListLocalDB("${_farmerContact.text}");
//
//         Navigator.of(context).pop();
//         overlayNotification(
//           'Validation failed! Please check internet connection and try again',
//           "negative",
//         );
//         print("Fireabse Notification failed");
//         print("Scale 6");
//       }
//
//       return response;
//     } on SocketException {
//       getFarmerFromFarmerApiListLocalDB("${_farmerContact.text}").onError((
//         error,
//         stackTrace,
//       ) {
//         print("Error in exception");
//         // getFarmerFromFarmerOfflineLocalDB("${_farmerContact.text}");
//       });
//       Navigator.of(context).pop();
//       overlayNotification(
//         'Validation failed! Please check internet connection and try again',
//         "negative",
//       );
//       print("Scale 7");
//     }
//   }
//
//   void setSMValuesT() {
//     // regSP?.setString('smEnumeratorName', _enumeratorName.text);
//     // regSP?.setString('smVisitNum', _visitNumber);
//     // regSP?.setString('smVisitDate', _visitDateYear!);
//     print("done setting");
//   }
//
//   Future<bool> _onbackPressed() {
//     return Navigator.of(context)
//         .pushReplacement(
//           CupertinoPageRoute(builder: (c) => const TreeMonitoringDecider()),
//         )
//         .then((value) => value);
//     // Navigator.popUntil(context, true);
//
//     // throw "error on going back";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return WillPopScope(
//       onWillPop: _onbackPressed,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: primaryColour,
//
//         // appBar: AppBar(
//         //   foregroundColor: fPrimaryWhite,
//         //   automaticallyImplyLeading: false,
//         //   backgroundColor: fPrimaryColour,
//         //   title: const Text(
//         //     "Seedling Survival Rate Survey",
//         //     style: TextStyle(color: fPrimaryWhite),
//         //   ),
//         //   actions: [
//         //     Tooltip(
//         //       message: "Takes you back to homepage",
//         //       child: Padding(
//         //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//         //         child: InkWell(
//         //           child: const Icon(Icons.home, color: fPrimaryWhite),
//         //           onTap: () => Navigator.of(context).pushReplacement(
//         //             MaterialPageRoute(
//         //               builder: (BuildContext context) => const IndexPage(),
//         //             ),
//         //           ),
//         //         ),
//         //       ),
//         //     )
//         //   ],
//         // ),
//         body: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8.0,
//                 vertical: 10.0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Material(
//                     elevation: 0.0,
//                     borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//                     color: primaryColour,
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(
//                         Icons.arrow_back,
//                         color: primaryWhite,
//                         size: 40.0,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "Seedling Monitoring".toUpperCase(),
//                     style: const TextStyle(color: primaryWhite, fontSize: 20.0),
//                   ),
//                   Tooltip(
//                     message: "Takes you back to homepage",
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                       child: InkWell(
//                         child: const Icon(Icons.home, color: fPrimaryWhite),
//                         onTap: () => Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 const IndexPage(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: size.height * .86,
//                 decoration: const BoxDecoration(
//                   color: primaryWhite,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25.0),
//                     topRight: Radius.circular(25.0),
//                   ),
//                 ),
//                 margin: const EdgeInsets.all(0.0),
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(height: 100),
//                     Form(
//                       key: _formKey,
//                       child: Material(
//                         elevation: 0,
//                         color: primaryWhite,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(25.0),
//                           topRight: Radius.circular(25.0),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8.0,
//                             vertical: 20.0,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               formFieldLabel(
//                                 width: size.width * .9,
//                                 "Enter ID of registered farmer",
//                               ),
//                               TextFieldWidget(
//                                 keyboardType: TextInputType.phone,
//                                 maxLength: 10,
//                                 decoration: const InputDecoration(
//                                   labelText:
//                                       "Enter contact of registered farmer",
//                                 ),
//                                 controller: _farmerContact,
//                                 validator: (input) => input!.trim().isEmpty
//                                     ? 'Please enter a contact number'
//                                     : null,
//                               ),
//                               const SizedBox(height: 30.0),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / .5,
//                                 height: 50.00,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     elevation: 0.0,
//                                     backgroundColor: fPrimaryColour,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     textStyle: const TextStyle(
//                                       color: fPrimaryWhite,
//                                     ),
//                                     // shadowColor: fPrimaryColour,
//                                   ),
//                                   child: const Text(
//                                     "Search for farmer",
//                                     style: TextStyle(
//                                       color: fPrimaryWhite,
//                                       fontSize: 17.0,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     // if (_visitNumber == null) {
//                                     //   Alert.showSnackBar(
//                                     //     context,
//                                     //     text:
//                                     //         'Please select an order of visit',
//                                     //     color: Colors.red,
//                                     //   );
//                                     // } else
//                                     // if (_visitDateYear == null) {
//                                     //   overlayNotification(
//                                     //       'Please select date',
//                                     //       "negative");
//                                     // } else
//                                     if (_formKey.currentState!.validate()) {
//                                       setSMValuesT();
//                                       // regSP?.setBool(
//                                       //     "farmerskipped", false);
//                                       _asyncSearchFarmerOnline(context);
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Container(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
