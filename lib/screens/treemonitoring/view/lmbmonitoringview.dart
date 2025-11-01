// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
// import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewlmbmonitoring.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';
// import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
// import 'package:hcms_revived2/services/serverurls.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// class LMBMonitoringView extends StatefulWidget {
//   const LMBMonitoringView({Key? key}) : super(key: key);
//
//   @override
//   _LMBMonitoringViewState createState() => _LMBMonitoringViewState();
// }
//
// class _LMBMonitoringViewState extends State<LMBMonitoringView> {
//   Future<bool> _onbackPressed() {
//     return Navigator.of(context)
//         .pushAndRemoveUntil(
//             CupertinoPageRoute(builder: (c) => TreeMonitoringDecider()),
//             (route) => false)
//         .then((value) => value);
//     // Navigator.popUntil(context, true);
//
//     // throw "back press error print";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final assocProvider =
//         Provider.of<LMBMonitoringProvider>(context, listen: false)
//             .fetchAndSetLMBMonitoring();
//
//     return WillPopScope(
//       onWillPop: _onbackPressed,
//       child: Stack(
//         children: [
//           // WebsafeSvg.asset(
//           //   "lib/libassets/icons/bg.svg",
//           //   fit: BoxFit.cover,
//           //   width: double.infinity,
//           // ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Spacer(flex: 2),
//                   Container(
//                     child: Container(
//                       // decoration: BoxDecoration(
//                       //   border: Border.all(
//                       //     color: fPrimaryColour,
//                       //   ),
//                       // ),
//                       child: FutureBuilder(
//                         future: assocProvider,
//                         builder: (ctx, snapshot) =>
//                             snapshot.connectionState == ConnectionState.waiting
//                                 ? Center(
//                                     child: CircularProgressIndicator(),
//                                   )
//                                 : Consumer<LMBMonitoringProvider>(
//                                     child: Center(
//                                       child: const Text(
//                                         'No data.',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     builder: (ctx, lmbDetails, ch) => Container(
//                                       height:
//                                           MediaQuery.of(context).size.height /
//                                               1.3,
//                                       child: lmbDetails.lmbLists.length <= 0
//                                           ? ch
//                                           : ListView.builder(
//                                               physics: ScrollPhysics(
//                                                   parent:
//                                                       AlwaysScrollableScrollPhysics()),
//                                               scrollDirection: Axis.vertical,
//                                               shrinkWrap: true,
//                                               itemCount:
//                                                   lmbDetails.lmbLists.length,
//                                               itemBuilder: (ctx, i) {
//                                                 int itemCount =
//                                                     lmbDetails.lmbLists.length;
//                                                 int reversedIndex =
//                                                     itemCount - 1 - i;
//
//                                                 return SingleChildScrollView(
//                                                   child: Column(
//                                                     children: <Widget>[
//                                                       lmbDetails
//                                                                   .lmbLists[
//                                                                       reversedIndex]
//                                                                   .lmbConStat ==
//                                                               "not connected"
//                                                           ? InkWell(
//                                                               child: Center(
//                                                                 child: Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                           .symmetric(
//                                                                     vertical:
//                                                                         10.0,
//                                                                     horizontal:
//                                                                         16.0,
//                                                                   ),
//                                                                   child: Stack(
//                                                                     children: <Widget>[
//                                                                       Container(
//                                                                         height:
//                                                                             120,
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(30),
//                                                                           gradient: LinearGradient(
//                                                                               colors: [
//                                                                                 Color(0xff42E695),
//                                                                                 Color(0xff3BB2B8)
//                                                                               ],
//                                                                               begin: Alignment.topLeft,
//                                                                               end: Alignment.bottomRight),
//                                                                           boxShadow: [
//                                                                             BoxShadow(
//                                                                               color: Colors.blue,
//                                                                               blurRadius: 12,
//                                                                               offset: Offset(0, 6),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Positioned(
//                                                                         right:
//                                                                             0,
//                                                                         bottom:
//                                                                             0,
//                                                                         top: 0,
//                                                                         child:
//                                                                             CustomPaint(
//                                                                           size: Size(
//                                                                               50,
//                                                                               150),
//                                                                           painter: lmbDetails.lmbLists[reversedIndex].lmbConStat == "not connected"
//                                                                               ? CustomCardShapePainter(30, Colors.grey, Colors.grey)
//                                                                               : CustomCardShapePainter(30, Colors.red, Colors.yellow),
//                                                                         ),
//                                                                       ),
//                                                                       Positioned
//                                                                           .fill(
//                                                                         child:
//                                                                             Row(
//                                                                           children: <Widget>[
//                                                                             Expanded(
//                                                                               child: CircleAvatar(
//                                                                                 radius: 20,
//                                                                                 child: Text(lmbDetails.lmbLists[reversedIndex].lmbSector[0]),
//                                                                               ),
//                                                                               flex: 2,
//                                                                             ),
//                                                                             Expanded(
//                                                                               flex: 4,
//                                                                               child: Column(
//                                                                                 mainAxisSize: MainAxisSize.min,
//                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                 children: <Widget>[
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(bottom: 10),
//                                                                                     child: Row(
//                                                                                       children: [
//                                                                                         Text(
//                                                                                           "Date: ",
//                                                                                           style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
//                                                                                         ),
//                                                                                         Text(
//                                                                                           lmbDetails.lmbLists[reversedIndex].lmbTimeDisplay,
//                                                                                           style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(bottom: 10),
//                                                                                     child: Text(
//                                                                                       lmbDetails.lmbLists[reversedIndex].lmbName,
//                                                                                       style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     lmbDetails.lmbLists[reversedIndex].lmbSector == "Private" ? lmbDetails.lmbLists[reversedIndex].lmbPrivateName : lmbDetails.lmbLists[reversedIndex].lmbFinancialName,
//                                                                                     style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     lmbDetails.lmbLists[reversedIndex].lmbSector == "Private" ? lmbDetails.lmbLists[reversedIndex].lmbPartnershipType : lmbDetails.lmbLists[reversedIndex].lmbTypeLoanService,
//                                                                                     style: TextStyle(
//                                                                                       color: Colors.white,
//                                                                                       fontFamily: 'Avenir',
//                                                                                     ),
//                                                                                   ),
//                                                                                   SizedBox(height: 16),
//                                                                                   Row(
//                                                                                     children: <Widget>[
//                                                                                       lmbDetails.lmbLists[reversedIndex].lmbConStat == "not connected"
//                                                                                           ? Icon(
//                                                                                               Icons.error_outline,
//                                                                                               color: Colors.black,
//                                                                                               size: 25,
//                                                                                             )
//                                                                                           : Icon(
//                                                                                               Icons.access_time,
//                                                                                               color: Colors.white,
//                                                                                               size: 16,
//                                                                                             ),
//                                                                                       SizedBox(
//                                                                                         width: 8,
//                                                                                       ),
//                                                                                       Flexible(
//                                                                                         child: Text(
//                                                                                           lmbDetails.lmbLists[reversedIndex].lmbConStat == "not connected" ? ":: not sent" : lmbDetails.lmbLists[reversedIndex].lmbTimeDisplay,
//                                                                                           style: TextStyle(
//                                                                                             color: Colors.white,
//                                                                                             fontFamily: 'Avenir',
//                                                                                             fontWeight: FontWeight.bold,
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ],
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                             Expanded(
//                                                                               flex: 2,
//                                                                               child: Column(
//                                                                                 mainAxisSize: MainAxisSize.min,
//                                                                                 children: <Widget>[
//                                                                                   IconButton(
//                                                                                     onPressed: () {
//                                                                                       submissionOptions(
//                                                                                         context,
//                                                                                         "Select an option",
//                                                                                         "Resend data",
//                                                                                         "View data",
//                                                                                         "Delete data",
//                                                                                         approvePress: () async {
//                                                                                           return reUpload(
//                                                                                             context,
//                                                                                             int.parse(lmbDetails.lmbLists[reversedIndex].lmbEnumeratorValue),
//                                                                                             lmbName: lmbDetails.lmbLists[reversedIndex].lmbName,
//                                                                                             sector: lmbDetails.lmbLists[reversedIndex].lmbSector,
//                                                                                             firstEngagement: lmbDetails.lmbLists[reversedIndex].lmbFirstEngagement,
//                                                                                             privateName: lmbDetails.lmbLists[reversedIndex].lmbPrivateName,
//                                                                                             partnershipType: lmbDetails.lmbLists[reversedIndex].lmbPartnershipType,
//                                                                                             partnershipDuration: lmbDetails.lmbLists[reversedIndex].lmbPartnershipDuration,
//                                                                                             mouSigned: lmbDetails.lmbLists[reversedIndex].lmbMou,
//                                                                                             financialName: lmbDetails.lmbLists[reversedIndex].lmbFinancialName,
//                                                                                             typeLoanService: lmbDetails.lmbLists[reversedIndex].lmbTypeLoanService,
//                                                                                             loanDuration: lmbDetails.lmbLists[reversedIndex].lmbLoanDuration,
//                                                                                             loanInterest: lmbDetails.lmbLists[reversedIndex].lmbLoanInterest,
//                                                                                             maleBenefitting: lmbDetails.lmbLists[reversedIndex].lmbMaleBenefit,
//                                                                                             femaleBenefitting: lmbDetails.lmbLists[reversedIndex].lmbFemaleBenefit,
//                                                                                             youthBenefitting: lmbDetails.lmbLists[reversedIndex].lmbYouthBenefit,
//                                                                                             itemID: lmbDetails.lmbLists[reversedIndex].lmbId,
//                                                                                           );
//                                                                                         },
//                                                                                         editPress: () {
//                                                                                           Navigator.of(context).pushNamed(ViewLMBMonitoringDetails.routeName, arguments: lmbDetails.lmbLists[reversedIndex].lmbId);
//                                                                                         },
//                                                                                         disapprovePress: () {
//                                                                                           submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
//                                                                                             DBHelper.deleteMV("lmb_monitoring", lmbDetails.lmbLists[reversedIndex].lmbId);
//
//                                                                                             Provider.of<LMBMonitoringProvider>(context, listen: false).fetchAndSetLMBMonitoring();
//                                                                                           }, editPress: () {}, disapprovePress: () {});
//                                                                                         },
//                                                                                       );
//                                                                                     },
//                                                                                     icon: Icon(
//                                                                                       Icons.more_vert,
//                                                                                       size: 30.0,
//                                                                                       color: fPrimaryColour,
//                                                                                     ),
//                                                                                     // child: Text("Next")),
//                                                                                   )
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               onTap: () {},
//                                                             )
//                                                           : InkWell(
//                                                               child: Center(
//                                                                 child: Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                           .symmetric(
//                                                                     vertical:
//                                                                         10.0,
//                                                                     horizontal:
//                                                                         16.0,
//                                                                   ),
//                                                                   child: Stack(
//                                                                     children: <Widget>[
//                                                                       Container(
//                                                                         height:
//                                                                             120,
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(30),
//                                                                           gradient: LinearGradient(
//                                                                               colors: [
//                                                                                 Color(0xff42E695),
//                                                                                 Color(0xff3BB2B8)
//                                                                               ],
//                                                                               begin: Alignment.topLeft,
//                                                                               end: Alignment.bottomRight),
//                                                                           boxShadow: [
//                                                                             BoxShadow(
//                                                                               color: Colors.blue,
//                                                                               blurRadius: 12,
//                                                                               offset: Offset(0, 6),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Positioned(
//                                                                         right:
//                                                                             0,
//                                                                         bottom:
//                                                                             0,
//                                                                         top: 0,
//                                                                         child:
//                                                                             CustomPaint(
//                                                                           size: Size(
//                                                                               50,
//                                                                               150),
//                                                                           painter: CustomCardShapePainter(
//                                                                               30,
//                                                                               Colors.red,
//                                                                               Colors.yellow),
//                                                                         ),
//                                                                       ),
//                                                                       Positioned
//                                                                           .fill(
//                                                                         child:
//                                                                             Row(
//                                                                           children: <Widget>[
//                                                                             Expanded(
//                                                                               child: CircleAvatar(
//                                                                                 radius: 20,
//                                                                                 child: Text(lmbDetails.lmbLists[reversedIndex].lmbSector[0]),
//                                                                               ),
//                                                                               flex: 2,
//                                                                             ),
//                                                                             Expanded(
//                                                                               flex: 4,
//                                                                               child: Column(
//                                                                                 mainAxisSize: MainAxisSize.min,
//                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                 children: <Widget>[
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(bottom: 10),
//                                                                                     child: Row(
//                                                                                       children: [
//                                                                                         Text(
//                                                                                           "Date: ",
//                                                                                           style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
//                                                                                         ),
//                                                                                         Text(
//                                                                                           lmbDetails.lmbLists[reversedIndex].lmbTimeDisplay,
//                                                                                           style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(bottom: 10),
//                                                                                     child: Text(
//                                                                                       lmbDetails.lmbLists[reversedIndex].lmbName,
//                                                                                       style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     lmbDetails.lmbLists[reversedIndex].lmbSector == "Private" ? lmbDetails.lmbLists[reversedIndex].lmbPrivateName : lmbDetails.lmbLists[reversedIndex].lmbFinancialName,
//                                                                                     style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     lmbDetails.lmbLists[reversedIndex].lmbSector == "Private" ? lmbDetails.lmbLists[reversedIndex].lmbPartnershipType : lmbDetails.lmbLists[reversedIndex].lmbTypeLoanService,
//                                                                                     style: TextStyle(
//                                                                                       color: Colors.white,
//                                                                                       fontFamily: 'Avenir',
//                                                                                     ),
//                                                                                   ),
//                                                                                   SizedBox(height: 16),
//                                                                                   Row(
//                                                                                     children: <Widget>[
//                                                                                       Icon(
//                                                                                         Icons.access_time,
//                                                                                         color: Colors.white,
//                                                                                         size: 16,
//                                                                                       ),
//                                                                                       SizedBox(
//                                                                                         width: 8,
//                                                                                       ),
//                                                                                       Flexible(
//                                                                                         child: Text(
//                                                                                           lmbDetails.lmbLists[reversedIndex].lmbTimeDisplay,
//                                                                                           style: TextStyle(
//                                                                                             color: Colors.white,
//                                                                                             fontFamily: 'Avenir',
//                                                                                             fontWeight: FontWeight.bold,
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ],
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                             Expanded(
//                                                                               flex: 2,
//                                                                               child: Column(
//                                                                                 mainAxisSize: MainAxisSize.min,
//                                                                                 children: <Widget>[
//                                                                                   IconButton(
//                                                                                     onPressed: () {
//                                                                                       submissionOptions(
//                                                                                         context,
//                                                                                         "Select an option",
//                                                                                         "View data",
//                                                                                         "Delete data",
//                                                                                         "Cancel",
//                                                                                         approvePress: () async {
//                                                                                           Navigator.of(context).pushNamed(ViewLMBMonitoringDetails.routeName, arguments: lmbDetails.lmbLists[reversedIndex].lmbId);
//                                                                                         },
//                                                                                         editPress: () {
//                                                                                           submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
//                                                                                             DBHelper.deleteMV("lmb_monitoring", lmbDetails.lmbLists[reversedIndex].lmbId);
//
//                                                                                             Provider.of<LMBMonitoringProvider>(context, listen: false).fetchAndSetLMBMonitoring();
//                                                                                           }, editPress: () {}, disapprovePress: () {});
//                                                                                         },
//                                                                                         disapprovePress: () => null,
//                                                                                       );
//                                                                                     },
//                                                                                     icon: Icon(
//                                                                                       Icons.more_vert,
//                                                                                       size: 30.0,
//                                                                                       color: fPrimaryColour,
//                                                                                     ),
//                                                                                     // child: Text("Next")),
//                                                                                   )
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               onTap: () {},
//                                                             )
//                                                     ],
//                                                   ),
//                                                 );
//                                               }),
//                                     ),
//                                   ),
//                       ),
//                     ),
//                   ),
//
//                   Spacer(
//                     flex: 1,
//                   ), // 1/6
//                   Spacer(flex: 2), // it will take 2/6 spaces
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future reUpload(
//     BuildContext ctx,
//     int enumeratorvalue, {
//     String? lmbName,
//     String? sector,
//     String? firstEngagement,
//     String? privateName,
//     String? partnershipType,
//     String? partnershipDuration,
//     String? mouSigned,
//     String? financialName,
//     String? typeLoanService,
//     String? loanDuration,
//     String? loanInterest,
//     String? maleBenefitting,
//     String? femaleBenefitting,
//     String? youthBenefitting,
//     itemID,
//   }) async {
//     int male =
//         maleBenefitting!.isEmpty ? int.parse("0") : int.parse(maleBenefitting);
//     int female = femaleBenefitting!.isEmpty
//         ? int.parse("0")
//         : int.parse(femaleBenefitting);
//     int youth = youthBenefitting!.isEmpty
//         ? int.parse("0")
//         : int.parse(youthBenefitting);
//     double loanDur =
//         loanDuration!.isEmpty ? double.parse("0") : double.parse(loanDuration);
//     double loanInt =
//         loanInterest!.isEmpty ? double.parse("0") : double.parse(loanInterest);
//
//     submissionLoader(ctx, "Uploading data", "Please wait a minute...");
//
//     overlayNotification('Data re-uploading... Please wait.', "positive");
//
//     try {
//       var lmbMonitoring = {
//         "enumeratorDetails": {
//           "enumerator": enumeratorvalue,
//           "lmbName": lmbName,
//           "lmbType": sector! + " Sector Engagement"
//         },
//         "engagementDetails": {
//           "privateSectorName": privateName,
//           "dateOfFirstEng": firstEngagement,
//           "partnershipType": partnershipType,
//           "partnershipDuration": partnershipDuration,
//           "mouSigned": mouSigned,
//           "finServiceName": financialName,
//           "finServiceType": typeLoanService,
//           "loanDuration": loanDur,
//           "interestRate": loanInt,
//           "numOfFarmersBenfitting": {
//             "female": female,
//             "male": male,
//             "youth": youth
//           }
//         }
//       };
//
//       var url = '$stageBaseUrl/lmbmonitoringapi/';
//
//       var body = json.encode(lmbMonitoring);
//
// //here jsonEncode(data) return String bt in http body you are passing Map value
//
// //So you have to convert String to Map
//       var bodyMap = jsonDecode(body);
//       print(body);
//
// // your nested json data
//       var bodyData = bodyMap;
//
//       var res = await http.post(Uri.parse(url), body: body);
//       print("uploading...");
//       print("Statuscode is ${res.statusCode}");
//
//       final itemss = json.decode(res.body);
//
//       print("itemss $body");
//       print(itemss["status"]);
//       var status = itemss["status"];
//
//       if (status == "done") {
//         Navigator.pop(context);
//         overlayNotification(
//             'Data sent successfully with status: $status.', "positive");
//
//         regSP?.clear();
//         // return res.statusCode;
//         DBHelper.updateMView(
//             "lmb_monitoring", "lmbConStat", "connected", itemID);
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (BuildContext context) => ViewMonitoredTrees(),
//           ),
//         );
//       } else if (status == "exist") {
//         Navigator.pop(context);
//         overlayNotification('Data already: $status.', "positive");
//
//         regSP?.clear();
//
//         DBHelper.updateMView(
//             "lmb_monitoring", "lmbConStat", "connected", itemID);
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => ViewMonitoredTrees(
//                       pageNum: 1,
//                     )));
//       } else {
//         overlayNotification(
//             'Error occured with error: ${itemss["error"]}', "negative");
//         print("${itemss["error"]}");
//         Navigator.pop(context);
//         // return res.statusCode;
//       }
//       // newVibe = items[0]["status"];
//     } on SocketException catch (e) {
//       print("e === $e");
//       overlayNotification(
//           'Oops! Internet error. Please make sure you\'re connected to the internet and try again.',
//           "negative");
//       Navigator.pop(context);
//     } catch (i) {
//       overlayNotification(i, "negative");
//       print("i ===> $i");
//       Navigator.of(context).pop();
//     }
//   }
// }
//
// class Constants {
//   static const String delete = "Delete";
//   static const String view = "View";
//   static const String synco = "Resend";
//
//   static const List<String> _onlineChoices = <String>[delete, view];
//
//   static const List<String> _offlineChoices = <String>[delete, view, synco];
// }
