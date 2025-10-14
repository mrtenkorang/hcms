import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoring2provider.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/seedlingmonitoringview.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SeedlingMonitoringViewInit extends StatefulWidget {
  final String? filterdate;
  const SeedlingMonitoringViewInit({Key? key, this.filterdate})
      : super(key: key);

  @override
  _SeedlingMonitoringViewInitState createState() =>
      _SeedlingMonitoringViewInitState();
}

class _SeedlingMonitoringViewInitState
    extends State<SeedlingMonitoringViewInit> {
  Future<bool> _onbackPressed() {
    print("working herer");

    return Navigator.of(context)
        .pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => const TreeMonitoringDecider()),
            (route) => false)
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "error here";
  }

  @override
  Widget build(BuildContext context) {
    final assocProvider =
        Provider.of<SeedlingMonitoring2Provider>(context, listen: false)
            .fetchAndSetSeedlingMonitoring2ByFieldName("smVisitDate");

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Stack(
        children: [
          // WebsafeSvg.asset(
          //   "lib/libassets/icons/bg.svg",
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          // ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Container(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: fPrimaryColour,
                      //   ),
                      // ),
                      child: FutureBuilder(
                        future: assocProvider,
                        builder: (ctx, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Consumer<SeedlingMonitoring2Provider>(
                                    child: const Center(
                                      child: Text(
                                        'No data.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    builder: (ctx, smDetails, ch) => Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.3,
                                      child: smDetails.smLists.length <= 0
                                          ? ch
                                          : ListView.builder(
                                              physics: const ScrollPhysics(
                                                  parent:
                                                      AlwaysScrollableScrollPhysics()),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount:
                                                  smDetails.smLists.length,
                                              itemBuilder: (ctx, i) {
                                                int itemCount =
                                                    smDetails.smLists.length;
                                                int reversedIndex =
                                                    itemCount - 1 - i;

                                                return SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      smDetails
                                                                  .smLists[
                                                                      reversedIndex]
                                                                  .conStat ==
                                                              "connected"
                                                          ? InkWell(
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        16.0,
                                                                  ),
                                                                  child: Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        height:
                                                                            120,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                          gradient: const LinearGradient(
                                                                              colors: [
                                                                                Color(0xff42E695),
                                                                                Color(0xff3BB2B8)
                                                                              ],
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight),
                                                                          boxShadow: [
                                                                            const BoxShadow(
                                                                              color: Colors.blue,
                                                                              blurRadius: 12,
                                                                              offset: Offset(0, 6),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        top: 0,
                                                                        child:
                                                                            CustomPaint(
                                                                          size: const Size(
                                                                              50,
                                                                              150),
                                                                          painter: CustomCardShapePainter(
                                                                              30,
                                                                              Colors.red,
                                                                              Colors.yellow),
                                                                        ),
                                                                      ),
                                                                      Positioned
                                                                          .fill(
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              child: CircleAvatar(
                                                                                radius: 20,
                                                                                child: Text(smDetails.smLists[reversedIndex].farmerName[0]),
                                                                              ),
                                                                              flex: 2,
                                                                            ),
                                                                            Expanded(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  const Padding(
                                                                                    padding: EdgeInsets.only(bottom: 10),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Date of visit: ",
                                                                                          style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    // width: 50,
                                                                                    child: Text(
                                                                                      smDetails.smLists[reversedIndex].smVisitDate,
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.clip,
                                                                                      style: const TextStyle(color: fPrimaryBlackColour, fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  IconButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).push(CupertinoPageRoute(
                                                                                          builder: (BuildContext context) => SeedlingMonitoringView(
                                                                                                filterdate: smDetails.smLists[reversedIndex].smVisitDate,
                                                                                                contextt: context,
                                                                                              )));
                                                                                    },
                                                                                    icon: const Icon(
                                                                                      Icons.arrow_forward_ios,
                                                                                      size: 30.0,
                                                                                      color: fPrimaryColour,
                                                                                    ),
                                                                                    // child: Text("Next")),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {},
                                                            )
                                                          : InkWell(
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        16.0,
                                                                  ),
                                                                  child: Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        height:
                                                                            120,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                          gradient: const LinearGradient(
                                                                              colors: [
                                                                                Color(0xff42E695),
                                                                                Color(0xff3BB2B8)
                                                                              ],
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight),
                                                                          boxShadow: [
                                                                            const BoxShadow(
                                                                              color: Colors.blue,
                                                                              blurRadius: 12,
                                                                              offset: Offset(0, 6),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        top: 0,
                                                                        child:
                                                                            CustomPaint(
                                                                          size: const Size(
                                                                              50,
                                                                              150),
                                                                          painter: CustomCardShapePainter(30, Colors.grey, Colors.grey),
                                                                        ),
                                                                      ),
                                                                      Positioned
                                                                          .fill(
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              child: CircleAvatar(
                                                                                radius: 20,
                                                                                // child: Text(smDetails.smLists[reversedIndex].farmerName[0]),
                                                                              ),
                                                                              flex: 2,
                                                                            ),
                                                                            Expanded(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  const Padding(
                                                                                    padding: EdgeInsets.only(bottom: 10),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Date of visit: ",
                                                                                          style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    // width: 50,
                                                                                    child: Text(
                                                                                      smDetails.smLists[reversedIndex].smVisitDate,
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.clip,
                                                                                      style: const TextStyle(color: fPrimaryBlackColour, fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  IconButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).push(CupertinoPageRoute(
                                                                                          builder: (BuildContext context) => SeedlingMonitoringView(
                                                                                                filterdate: smDetails.smLists[reversedIndex].smVisitDate,
                                                                                                contextt: context,
                                                                                              )));
                                                                                    },
                                                                                    icon: const Icon(
                                                                                      Icons.arrow_forward_ios,
                                                                                      size: 30.0,
                                                                                      color: fPrimaryColour,
                                                                                    ),
                                                                                    // child: Text("Next")),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {},
                                                            )
                                                    ],
                                                  ),
                                                );
                                              }),
                                    ),
                                  ),
                      ),
                    ),
                  ),

                  const Spacer(
                    flex: 1,
                  ), // 1/6
                  const Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
