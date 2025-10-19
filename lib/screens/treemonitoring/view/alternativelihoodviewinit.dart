// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
// import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiAlternativeprovider.dart';
// import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/alternativelivelihoodview.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewalternatelivelihooddetails.dart';
// import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';
// import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// class AlternativeLivelihoodViewInit extends StatefulWidget {
//   const AlternativeLivelihoodViewInit({Key? key}) : super(key: key);
//
//   @override
//   _AlternativeLivelihoodViewInitState createState() =>
//       _AlternativeLivelihoodViewInitState();
// }
//
// class _AlternativeLivelihoodViewInitState
//     extends State<AlternativeLivelihoodViewInit> {
//   Future<bool> _onbackPressed() {
//     return Navigator.of(context)
//         .pushAndRemoveUntil(
//             CupertinoPageRoute(builder: (c) => TreeMonitoringDecider()),
//             (route) => true)
//         .then((value) => value);
//     // Navigator.popUntil(context, true);
//
//     // throw "error on going back";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final assocProvider =
//         Provider.of<AlternativeLivelihoodProvider>(context, listen: false)
//             .fetchAndSetAlternativeLivelihood2("alVisitDate");
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
//                                 : Consumer<AlternativeLivelihoodProvider>(
//                                     child: Center(
//                                       child: const Text(
//                                         'No data.',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     builder: (ctx, alDetails, ch) => Container(
//                                       height:
//                                           MediaQuery.of(context).size.height /
//                                               1.3,
//                                       child: alDetails.alLists.length <= 0
//                                           ? ch
//                                           : ListView.builder(
//                                               physics: ScrollPhysics(
//                                                   parent:
//                                                       AlwaysScrollableScrollPhysics()),
//                                               scrollDirection: Axis.vertical,
//                                               shrinkWrap: true,
//                                               itemCount:
//                                                   alDetails.alLists.length,
//                                               itemBuilder: (ctx, i) {
//                                                 int itemCount =
//                                                     alDetails.alLists.length;
//                                                 int reversedIndex =
//                                                     itemCount - 1 - i;
//
//                                                 return SingleChildScrollView(
//                                                   child: Column(
//                                                     children: <Widget>[
//                                                       alDetails
//                                                                   .alLists[
//                                                                       reversedIndex]
//                                                                   .alConStat ==
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
//                                                                           painter: alDetails.alLists[reversedIndex].alConStat == "not connected"
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
//                                                                                 child: Text(alDetails.alLists[reversedIndex].alFarmerName[0]),
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
//                                                                                           "Date of visit: ",
//                                                                                           style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Container(
//                                                                                     // width: 50,
//                                                                                     child: Text(
//                                                                                       alDetails.alLists[reversedIndex].alVisitDate,
//                                                                                       softWrap: true,
//                                                                                       overflow: TextOverflow.clip,
//                                                                                       style: TextStyle(color: fPrimaryBlackColour, fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
//                                                                                     ),
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
//                                                                                       Navigator.of(context).push(CupertinoPageRoute(
//                                                                                           builder: (BuildContext context) => AlternativeLivelihoodView(
//                                                                                                 filterdate: alDetails.alLists[reversedIndex].alVisitDate,
//                                                                                               )));
//                                                                                     },
//                                                                                     icon: Icon(
//                                                                                       Icons.arrow_forward_ios,
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
//                                                                                 child: Text(alDetails.alLists[reversedIndex].alFarmerName.isNotEmpty ? alDetails.alLists[reversedIndex].alFarmerName[0] : ""),
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
//                                                                                           "Date of visit: ",
//                                                                                           style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Container(
//                                                                                     // width: 50,
//                                                                                     child: Text(
//                                                                                       alDetails.alLists[reversedIndex].alVisitDate,
//                                                                                       softWrap: true,
//                                                                                       overflow: TextOverflow.clip,
//                                                                                       style: TextStyle(color: fPrimaryBlackColour, fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
//                                                                                     ),
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
//                                                                                       Navigator.of(context).push(CupertinoPageRoute(
//                                                                                           builder: (BuildContext context) => AlternativeLivelihoodView(
//                                                                                                 filterdate: alDetails.alLists[reversedIndex].alVisitDate,
//                                                                                               )));
//                                                                                     },
//                                                                                     icon: Icon(
//                                                                                       Icons.arrow_forward_ios,
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
// }
