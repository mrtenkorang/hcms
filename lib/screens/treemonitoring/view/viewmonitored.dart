import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/alternativelihoodviewinit.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/alternativelivelihoodview.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/lmbmonitoringview.dart';
// import 'package:hcms_revived2/screens/seedlingmonitoring/history/seedling_monitoring_history';
import 'package:hcms_revived2/screens/treemonitoring/view/traininglogview.dart';

class ViewMonitoredTrees extends StatefulWidget {
  // const ViewMonitoredTrees({Key key}) : super(key: key);
  final int? pageNum;

  const ViewMonitoredTrees({Key? key, this.pageNum}) : super(key: key);

  @override
  ViewMonitoredTreesState createState() => ViewMonitoredTreesState();
}

class ViewMonitoredTreesState extends State<ViewMonitoredTrees>
    with SingleTickerProviderStateMixin {
  Future<bool> _onbackPressed() {
    print("herest working");

    return Navigator.of(context)
        .pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => TreeMonitoringDecider()),
            (route) => true)
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "onback error printed";
  }

  int? _tabIndex;
  final List<Tab> myTabs = <Tab>[
    // new Tab(
    //   child: SeedlingMonitoringViewInit(),
    // ),
    new Tab(
      child: LMBMonitoringView(),
    ),
    // new Tab(
    //   child: AlternativeLivelihoodViewInit(),
    // ),
    new Tab(
      child: TrainingLogView(),
    ),
  ];

  static TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, vsync: this, length: 4);
    widget.pageNum != null ? activate() : null;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar( foregroundColor: fPrimaryWhite,
          elevation: 0.0,
          backgroundColor: fPrimaryColour,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => _onbackPressed(),
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(8.0),
            labelColor: Color(0xFFFFFFFF),
            indicatorColor: Color(0xFFFFFFFF),
            unselectedLabelColor: Colors.white54,
            controller: _tabController,
            tabs: [
              Text(
                "Seedling Monitoring",
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
              Text(
                "LMB Monitoring",
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
              Text(
                "Alternative Livelihood",
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
              Text(
                "Training Log",
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: myTabs,
        ),
      ),
    );
  }

  void toggleTab() {
    _tabIndex = _tabController!.index + 1;
    _tabController?.animateTo(_tabIndex!);
  }

  activate() {
    _tabController?.animateTo(widget.pageNum!);
  }
}

class Constants {
  static const String about = "About App";
  static const String exit = "Exit";

  static const List<String> _topChoices = <String>[about, exit];
}
