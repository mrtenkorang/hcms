// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/screens/Notice%20Board/components/news_articles.dart';
// import 'package:hcms_revived2/screens/Notice%20Board/components/workshops.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
//
// class NoticeBoard extends StatefulWidget {
//   // const NoticeBoard({Key key}) : super(key: key);
//   final int? pageNum;
//
//   const NoticeBoard({Key? key, this.pageNum}) : super(key: key);
//
//   @override
//   NoticeBoardState createState() => NoticeBoardState();
// }
//
// class NoticeBoardState extends State<NoticeBoard>
//     with SingleTickerProviderStateMixin {
//   Future<bool> _onbackPressed() {
//     return Navigator.of(context)
//         .pushAndRemoveUntil(
//             CupertinoPageRoute(builder: (c) => IndexPage()), (route) => false)
//         .then((value) => value);
//     // Navigator.popUntil(context, true);
//
//     // throw "onback error printed- noticeboard";
//   }
//
//   int? _tabIndex;
//   final List<Tab> myTabs = <Tab>[
//     new Tab(
//       child: NewsArticles(),
//     ),
//     new Tab(
//       child: WorkShops(),
//     ),
//   ];
//
//   static TabController? _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(initialIndex: 0, vsync: this, length: 2);
//     widget.pageNum != null ? activate() : null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onbackPressed,
//       child: Scaffold(
//         appBar: AppBar( foregroundColor: fPrimaryWhite,
//           title: Text("Notice Board"),
//           elevation: 0.0,
//           backgroundColor: fPrimaryColour,
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             color: Colors.white,
//             onPressed: () => Navigator.pop(context),
//           ),
//           bottom: TabBar(
//             labelPadding: EdgeInsets.all(8.0),
//             labelColor: Color(0xFFFFFFFF),
//             indicatorColor: Color(0xFFFFFFFF),
//             unselectedLabelColor: Colors.white54,
//             controller: _tabController,
//             tabs: [
//               Text(
//                 "News and Articles",
//                 softWrap: true,
//                 overflow: TextOverflow.clip,
//               ),
//               Text(
//                 "Training/ Workshops",
//                 softWrap: true,
//                 overflow: TextOverflow.clip,
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: myTabs,
//         ),
//       ),
//     );
//   }
//
//   void toggleTab() {
//     _tabIndex = _tabController!.index + 1;
//     _tabController?.animateTo(_tabIndex!);
//   }
//
//   activate() {
//     _tabController?.animateTo(widget.pageNum!);
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
// }
//
// class Constants {
//   static const String about = "About App";
//   static const String exit = "Exit";
//
//   static const List<String> _topChoices = <String>[about, exit];
// }
