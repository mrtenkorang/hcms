// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
// import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewtraininglogdetails.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';
// import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
// import 'package:hcms_revived2/services/serverurls.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// class TrainingLogView extends StatefulWidget {
//   const TrainingLogView({Key? key}) : super(key: key);
//
//   @override
//   TrainingLogViewState createState() => TrainingLogViewState();
// }
//
// class TrainingLogViewState extends State<TrainingLogView> {
//   Future<bool> _onbackPressed() {
//     return Navigator.of(context)
//         .pushAndRemoveUntil(
//             CupertinoPageRoute(builder: (c) => TreeMonitoringDecider()),
//             (route) => false)
//         .then((value) => value);
//     // Navigator.popUntil(context, true);
//
//     // throw "back pressed pop scope error";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final assocProvider =
//         Provider.of<TrainingLogProvider>(context, listen: false)
//             .fetchAndSetTrainingLog();
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
//                                 : Consumer<TrainingLogProvider>(
//                                     child: Center(
//                                       child: const Text(
//                                         'No data.',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     builder: (ctx, tlDetails, ch) => Container(
//                                       height:
//                                           MediaQuery.of(context).size.height /
//                                               1.3,
//                                       child: tlDetails.tlLists.length <= 0
//                                           ? ch
//                                           : ListView.builder(
//                                               physics: ScrollPhysics(
//                                                   parent:
//                                                       AlwaysScrollableScrollPhysics()),
//                                               scrollDirection: Axis.vertical,
//                                               shrinkWrap: true,
//                                               itemCount:
//                                                   tlDetails.tlLists.length,
//                                               itemBuilder: (ctx, i) {
//                                                 int itemCount =
//                                                     tlDetails.tlLists.length;
//                                                 int reversedIndex =
//                                                     itemCount - 1 - i;
//
//                                                 return SingleChildScrollView(
//                                                   child: Column(
//                                                     children: <Widget>[
//                                                       tlDetails
//                                                                   .tlLists[
//                                                                       reversedIndex]
//                                                                   .tlConStat ==
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
//                                                                           painter: tlDetails.tlLists[reversedIndex].tlConStat == "not connected"
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
//                                                                                 child: Text(tlDetails.tlLists[reversedIndex].tlCommunityName?[0] ?? "comm name"),
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
//                                                                                           tlDetails.tlLists[reversedIndex].tlTimeDisplay ?? "",
//                                                                                           style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(bottom: 10),
//                                                                                     child: Text(
//                                                                                       tlDetails.tlLists[reversedIndex].tlTopic ?? "training topic",
//                                                                                       style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     tlDetails.tlLists[reversedIndex].tlTrainerName ?? "trainer name",
//                                                                                     style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     tlDetails.tlLists[reversedIndex].tlTrainerOrg ?? "trainer org",
//                                                                                     style: TextStyle(
//                                                                                       color: Colors.white,
//                                                                                       fontFamily: 'Avenir',
//                                                                                     ),
//                                                                                   ),
//                                                                                   SizedBox(height: 16),
//                                                                                   Row(
//                                                                                     children: <Widget>[
//                                                                                       tlDetails.tlLists[reversedIndex].tlConStat == "not connected"
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
//                                                                                           tlDetails.tlLists[reversedIndex].tlConStat == "not connected" ? ":: not sent" : tlDetails.tlLists[reversedIndex].tlTimeDisplay ?? "time stamp",
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
//                                                                                             int.parse(tlDetails.tlLists[reversedIndex].tlEnumeratorValue!),
//                                                                                             communityName: tlDetails.tlLists[reversedIndex].tlCommunityName!,
//                                                                                             topic: tlDetails.tlLists[reversedIndex].tlTopic!,
//                                                                                             duration: tlDetails.tlLists[reversedIndex].tlDuration!,
//                                                                                             trainerName: tlDetails.tlLists[reversedIndex].tlTrainerName!,
//                                                                                             trainerOrg: tlDetails.tlLists[reversedIndex].tlTrainerOrg!,
//                                                                                             eventDate: tlDetails.tlLists[reversedIndex].tlEventDate!,
//                                                                                             participantDet: tlDetails.tlLists[reversedIndex].tlParticipantDetails!,
//                                                                                             itemID: tlDetails.tlLists[reversedIndex].tlId,
//                                                                                           );
//                                                                                         },
//                                                                                         editPress: () {
//                                                                                           regSP?.setString("loadPartDet", tlDetails.tlLists[reversedIndex].tlParticipantDetails!);
//                                                                                           Navigator.of(context).pushNamed(ViewTrainingLogDetails.routeName, arguments: tlDetails.tlLists[reversedIndex].tlId);
//                                                                                         },
//                                                                                         disapprovePress: () {
//                                                                                           submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
//                                                                                             DBHelper.deleteMV("training_log", tlDetails.tlLists[reversedIndex].tlId!);
//
//                                                                                             Provider.of<TrainingLogProvider>(context, listen: false).fetchAndSetTrainingLog();
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
//                                                                                 child: Text(tlDetails.tlLists[reversedIndex].tlCommunityName?[0] ?? "comm namee"),
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
//                                                                                           tlDetails.tlLists[reversedIndex].tlTimeDisplay ?? "",
//                                                                                           style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(bottom: 10),
//                                                                                     child: Text(
//                                                                                       tlDetails.tlLists[reversedIndex].tlTopic ?? "training topicc",
//                                                                                       style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     tlDetails.tlLists[reversedIndex].tlTrainerName ?? "trainer namee",
//                                                                                     style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     tlDetails.tlLists[reversedIndex].tlTrainerOrg ?? "trainer orgg",
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
//                                                                                           tlDetails.tlLists[reversedIndex].tlTimeDisplay ?? "time stampp",
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
//                                                                                           regSP?.setString("loadPartDet", tlDetails.tlLists[reversedIndex].tlParticipantDetails!);
//                                                                                           Navigator.of(context).pushNamed(ViewTrainingLogDetails.routeName, arguments: tlDetails.tlLists[reversedIndex].tlId);
//                                                                                         },
//                                                                                         editPress: () {
//                                                                                           submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
//                                                                                             DBHelper.deleteMV("training_log", tlDetails.tlLists[reversedIndex].tlId!);
//
//                                                                                             Provider.of<TrainingLogProvider>(context, listen: false).fetchAndSetTrainingLog();
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
//     int? enumeratorvalue, {
//     String? communityName,
//     String? topic,
//     String? duration,
//     String? trainerName,
//     String? trainerOrg,
//     String? eventDate,
//     String? participantDet,
//     itemID,
//   }) async {
//     submissionLoader(ctx, "Uploading data", "Please wait a minute...");
//
//     final participantDetails = participantDet!.isNotEmpty
//         ? json.decode(participantDet).cast<Map<String, dynamic>>()
//         : Map();
//
//     overlayNotification('Data re-uploading... Please wait.', "positive");
//
//     try {
//       var trainingLog = {
//         "trainingDetails": {
//           "communityName": communityName,
//           "trainingTopic": topic,
//           "dateEventBegan": eventDate,
//           "eventDuration": duration,
//           "trainerName": trainerName,
//           "trainerOrganisation": trainerOrg,
//           "enumerator": enumeratorvalue
//         },
//         "participantDetails": participantDetails
//       };
//
//       var url = '$stageBaseUrl/trainingapi/';
//
//       var body = json.encode(trainingLog);
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
//       print("Body $body");
//       print(itemss);
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
//         DBHelper.updateMView("training_log", "tlConStat", "connected", itemID);
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (BuildContext context) => ViewMonitoredTrees(pageNum: 3),
//           ),
//         );
//       } else if (status == "exist") {
//         Navigator.pop(context);
//         overlayNotification('Data already: $status.', "positive");
//
//         regSP?.clear();
//
//         DBHelper.updateMView("training_log", "tlConStat", "connected", itemID);
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => ViewMonitoredTrees(
//                       pageNum: 3,
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
