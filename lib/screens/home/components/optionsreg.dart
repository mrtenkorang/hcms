// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
// import 'package:hcms_revived2/screens/farmregistration/farmerdetails/status.dart';
// import 'package:hcms_revived2/screens/home/components/options.dart';
// import 'package:hcms_revived2/screens/viewsubmissions/viewpage.dart';
//
// import 'middlesectiontitle.dart';
//
// // class TreeRegistraion extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           OptionsCard(
// //             icon: Icon(
// //               Icons.note_add,
// //               color: Colors.redAccent,
// //               size: 26,
// //             ),
// //             title: "Register Trees",
// //             description: "Click to register",
// //             pressHandler: () {
// //               Navigator.of(context).push(
// //                 CupertinoPageRoute(
// //                   builder: (BuildContext context) => BeneficiaryStatus(),
// //                 ),
// //               );
// //             },
// //           ),
// //           OptionsCard(
// //             icon: Icon(
// //               Icons.view_list,
// //               color: Colors.redAccent,
// //               size: 26,
// //             ),
// //             title: "View Registered Trees",
// //             description: "Click to view registered",
// //             pressHandler: () {
// //               Navigator.of(context).push(
// //                 CupertinoPageRoute(
// //                   builder: (BuildContext context) => ViewReport(),
// //                 ),
// //               );
// //             },
// //           ),
// //           OptionsCard(
// //             icon: Icon(
// //               Icons.view_list,
// //               color: Colors.redAccent,
// //               size: 26,
// //             ),
// //             title: "View Tree Species Gallery",
// //             description: "Click to view",
// //             pressHandler: () {
// //               Navigator.of(context).push(
// //                 CupertinoPageRoute(
// //                   builder: (BuildContext context) => SpeciesGallery(),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class TreeRegistration extends StatefulWidget {
//   const TreeRegistration({Key? key}) : super(key: key);
//
//   @override
//   _TreeRegistrationState createState() => _TreeRegistrationState();
// }
//
// class _TreeRegistrationState extends State<TreeRegistration> {
//   _onbackPressed() {
//     // Navigator.of(context).pushAndRemoveUntil(
//     //     CupertinoPageRoute(builder: (c) => IndexPage()), (route) => false);
//     // Navigator.popUntil(context, true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             height: MediaQuery.of(context).size.height / 1.3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 MiddleSectionTitle(
//                   text: "Select an option from below",
//                 ),
//                 SizedBox(
//                   height: 30.0,
//                 ),
//                 OptionsCard(
//                   icon: Icon(
//                     Icons.note_add,
//                     color: Colors.redAccent,
//                     size: 26,
//                   ),
//                   title: "Register Trees",
//                   description: "Click to register",
//                   pressHandler: () {
//                     Navigator.of(context).push(
//                       CupertinoPageRoute(
//                         builder: (BuildContext context) => BeneficiaryStatus(),
//                       ),
//                     );
//                   },
//                 ),
//                 OptionsCard(
//                   icon: Icon(
//                     Icons.view_list,
//                     color: Colors.redAccent,
//                     size: 26,
//                   ),
//                   title: "View Registered Trees",
//                   description: "Click to view registered",
//                   pressHandler: () {
//                     Navigator.of(context).push(
//                       CupertinoPageRoute(
//                         builder: (BuildContext context) => ViewReport(),
//                       ),
//                     );
//                   },
//                 ),
//                 OptionsCard(
//                   icon: Icon(
//                     Icons.image_rounded,
//                     color: Colors.redAccent,
//                     size: 26,
//                   ),
//                   title: "View Tree Species Gallery",
//                   description: "Click to view",
//                   pressHandler: () {
//                     Navigator.of(context).push(
//                       CupertinoPageRoute(
//                         builder: (BuildContext context) => SpeciesGallery(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
