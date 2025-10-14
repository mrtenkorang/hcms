import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiSeedlingprovider.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoring2provider.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewseedlingmonitoringdetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SeedlingMonitoringView extends StatefulWidget {
  final String? filterdate;
  final BuildContext? contextt;

  const SeedlingMonitoringView({Key? key, this.filterdate, this.contextt}) : super(key: key);

  @override
  _SeedlingMonitoringViewState createState() => _SeedlingMonitoringViewState();
}

class _SeedlingMonitoringViewState extends State<SeedlingMonitoringView> {
  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(
            builder: (c) => const ViewMonitoredTrees(
                  pageNum: 0,
                )))
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "error here";
  }

  @override
  Widget build(BuildContext context) {
    final assocProvider = Provider.of<SeedlingMonitoring2Provider>(widget.contextt ?? context,
            listen: false)
        .fetchAndSetSeedlingMonitoring2Where("smVisitDate", widget.filterdate);

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar( foregroundColor: fPrimaryWhite,
          backgroundColor: fPrimaryColour,
          title: Text(widget.filterdate.toString() + " Records",
          style: const TextStyle(color: fPrimaryWhite),),
        ),
        body: Stack(
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
                          builder:
                              (ctx, snapshot) =>
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
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
                                          builder: (ctx, smDetails, ch) =>
                                              Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.3,
                                            child: smDetails.smLists.length <= 0
                                                ? ch
                                                : ListView.builder(
                                                    physics: const ScrollPhysics(
                                                        parent:
                                                            AlwaysScrollableScrollPhysics()),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: smDetails
                                                        .smLists.length,
                                                    itemBuilder: (ctx, i) {
                                                      int itemCount = smDetails
                                                          .smLists.length;
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
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10.0,
                                                                          horizontal:
                                                                              16.0,
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              height: 120,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(30),
                                                                                gradient: const LinearGradient(colors: [
                                                                                  Color(0xff42E695),
                                                                                  Color(0xff3BB2B8)
                                                                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Colors.blue,
                                                                                    blurRadius: 12,
                                                                                    offset: Offset(0, 6),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              top: 0,
                                                                              child: CustomPaint(
                                                                                size: const Size(50, 150),
                                                                                painter: CustomCardShapePainter(30, Colors.red, Colors.yellow),
                                                                              ),
                                                                            ),
                                                                            Positioned.fill(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: CircleAvatar(
                                                                                      radius: 20,
                                                                                      child: Text(smDetails.smLists[reversedIndex].farmerName[0]),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              const Text(
                                                                                                "Date: ",
                                                                                                style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                              Text(
                                                                                                smDetails.smLists[reversedIndex].smTimeDisplay,
                                                                                                style: const TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            smDetails.smLists[reversedIndex].farmerName,
                                                                                            style: const TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          smDetails.smLists[reversedIndex].farmerIDNumber,
                                                                                          style: const TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                        // Text(
                                                                                        //   smDetails.smLists[reversedIndex].smCommunity,
                                                                                        //   style: TextStyle(
                                                                                        //     color: Colors.white,
                                                                                        //     fontFamily: 'Avenir',
                                                                                        //   ),
                                                                                        // ),
                                                                                        const SizedBox(height: 16),
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            const Icon(
                                                                                              Icons.access_time,
                                                                                              color: Colors.white,
                                                                                              size: 16,
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 8,
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                smDetails.smLists[reversedIndex].smTimeDisplay,
                                                                                                style: const TextStyle(
                                                                                                  color: Colors.white,
                                                                                                  fontFamily: 'Avenir',
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
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
                                                                                            submissionOptions(
                                                                                              context,
                                                                                              "Select an option",
                                                                                              "View data",
                                                                                              "Delete data",
                                                                                              "Cancel",
                                                                                              approvePress: () async {
                                                                                                Navigator.of(context).pushNamed(ViewSeedlingMonitoringDetails.routeName, arguments: smDetails.smLists[reversedIndex].smId);
                                                                                              },
                                                                                              editPress: () {
                                                                                                submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                                  DBHelper.deleteMV("seedling_monitoring", smDetails.smLists[reversedIndex].smId);

                                                                                                  Provider.of<SeedlingMonitoring2Provider>(context, listen: false).fetchAndSetSeedlingMonitoring2();
                                                                                                }, editPress: () {}, disapprovePress: () {});
                                                                                              },
                                                                                              disapprovePress: () => null,
                                                                                            );
                                                                                          },
                                                                                          icon: const Icon(
                                                                                            Icons.more_vert,
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
                                                                    onTap:
                                                                        () {},
                                                                  )
                                                                : InkWell(
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10.0,
                                                                          horizontal:
                                                                              16.0,
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              height: 120,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(30),
                                                                                gradient: const LinearGradient(colors: [
                                                                                  Color(0xff42E695),
                                                                                  Color(0xff3BB2B8)
                                                                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Colors.blue,
                                                                                    blurRadius: 12,
                                                                                    offset: Offset(0, 6),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              top: 0,
                                                                              child: CustomPaint(
                                                                                size: const Size(50, 150),
                                                                                painter: smDetails.smLists[reversedIndex].conStat == "connected" ? CustomCardShapePainter(30, Colors.red, Colors.yellow) : CustomCardShapePainter(30, Colors.grey, Colors.grey),
                                                                              ),
                                                                            ),
                                                                            Positioned.fill(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: CircleAvatar(
                                                                                      radius: 20,
                                                                                      child: Text(smDetails.smLists[reversedIndex].farmerName[0]),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              const Text(
                                                                                                "Date: ",
                                                                                                style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                              Text(
                                                                                                smDetails.smLists[reversedIndex].smTimeDisplay,
                                                                                                style: const TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            smDetails.smLists[reversedIndex].farmerName,
                                                                                            style: const TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          smDetails.smLists[reversedIndex].farmerName,
                                                                                          style: const TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                        // Text(
                                                                                        //   smDetails.smLists[reversedIndex].smCommunity,
                                                                                        //   style: TextStyle(
                                                                                        //     color: Colors.white,
                                                                                        //     fontFamily: 'Avenir',
                                                                                        //   ),
                                                                                        // ),
                                                                                        const SizedBox(height: 16),
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            smDetails.smLists[reversedIndex].conStat == "not connected"
                                                                                                ? const Icon(
                                                                                                    Icons.error_outline,
                                                                                                    color: Colors.black,
                                                                                                    size: 25,
                                                                                                  )
                                                                                                : smDetails.smLists[reversedIndex].conStat == "farmer offline"
                                                                                                    ? const Icon(
                                                                                                        Icons.error_rounded,
                                                                                                        color: Colors.red,
                                                                                                        size: 16,
                                                                                                      )
                                                                                                    : const Icon(
                                                                                                        Icons.access_time,
                                                                                                        color: Colors.white,
                                                                                                        size: 16,
                                                                                                      ),
                                                                                            const SizedBox(
                                                                                              width: 8,
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                smDetails.smLists[reversedIndex].conStat == "not connected"
                                                                                                    ? ":: not sent"
                                                                                                    : smDetails.smLists[reversedIndex].conStat == "farmer offline"
                                                                                                        ? "offline"
                                                                                                        : smDetails.smLists[reversedIndex].smTimeDisplay,
                                                                                                style: const TextStyle(
                                                                                                  color: Colors.white,
                                                                                                  fontFamily: 'Avenir',
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
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
                                                                                            submissionOptions(
                                                                                              context,
                                                                                              "Select an option",
                                                                                              "Resend data",
                                                                                              "View data",
                                                                                              "Delete data",
                                                                                              approvePress: () async {
                                                                                                // return smDetails.smLists[reversedIndex].farmerName == "farmer offline"
                                                                                                //     ? _asyncAddFarmer(
                                                                                                //         context,
                                                                                                //         smDetails.smLists[reversedIndex].smFarmerContact,
                                                                                                //         int.parse(smDetails.smLists[reversedIndex].smEnumeratorValue),
                                                                                                //         smCommunity: smDetails.smLists[reversedIndex].smCommunity,
                                                                                                //         smVisitDate: smDetails.smLists[reversedIndex].smVisitDate,
                                                                                                //         smFarmerId: smDetails.smLists[reversedIndex].smFarmerId,
                                                                                                //         smFarmerName: smDetails.smLists[reversedIndex].smFarmerName,
                                                                                                //         smBaseline: smDetails.smLists[reversedIndex].smBaseline,
                                                                                                //         smFarmerContact: smDetails.smLists[reversedIndex].smFarmerContact,
                                                                                                //         smSpecies: smDetails.smLists[reversedIndex].smSpecies,
                                                                                                //         smReceivedDate: smDetails.smLists[reversedIndex].smReceivedDate,
                                                                                                //         smPlantedDate: smDetails.smLists[reversedIndex].smPlantedDate,
                                                                                                //         smQuantityReceived: smDetails.smLists[reversedIndex].smQuantityReceived,
                                                                                                //         smQuantityPlanted: smDetails.smLists[reversedIndex].smQuantityPlanted,
                                                                                                //         smQuantitySurvived: smDetails.smLists[reversedIndex].smQuantitySurvived,
                                                                                                //         smPlantingArea: smDetails.smLists[reversedIndex].smPlantingArea,
                                                                                                //         smAreaSize: smDetails.smLists[reversedIndex].smAreaSize,
                                                                                                //         smRegisteredTrees: smDetails.smLists[reversedIndex].smRegisteredTrees,
                                                                                                //         smFarmLocation: smDetails.smLists[reversedIndex].smFarmLocation,
                                                                                                //         itemID: smDetails.smLists[reversedIndex].smId,
                                                                                                //       )
                                                                                                //     : reUpload(
                                                                                                //         context,
                                                                                                //         int.parse(smDetails.smLists[reversedIndex].smEnumeratorValue),
                                                                                                //         smCommunity: smDetails.smLists[reversedIndex].smCommunity,
                                                                                                //         smVisitDate: smDetails.smLists[reversedIndex].smVisitDate,
                                                                                                //         smFarmerId: smDetails.smLists[reversedIndex].smFarmerId,
                                                                                                //         smFarmerName: smDetails.smLists[reversedIndex].smFarmerName,
                                                                                                //         smBaseline: smDetails.smLists[reversedIndex].smBaseline,
                                                                                                //         smFarmerContact: smDetails.smLists[reversedIndex].smFarmerContact,
                                                                                                //         smSpecies: smDetails.smLists[reversedIndex].smSpecies,
                                                                                                //         smReceivedDate: smDetails.smLists[reversedIndex].smReceivedDate,
                                                                                                //         smPlantedDate: smDetails.smLists[reversedIndex].smPlantedDate,
                                                                                                //         smQuantityReceived: smDetails.smLists[reversedIndex].smQuantityReceived,
                                                                                                //         smQuantityPlanted: smDetails.smLists[reversedIndex].smQuantityPlanted,
                                                                                                //         smQuantitySurvived: smDetails.smLists[reversedIndex].smQuantitySurvived,
                                                                                                //         smPlantingArea: smDetails.smLists[reversedIndex].smPlantingArea,
                                                                                                //         smAreaSize: smDetails.smLists[reversedIndex].smAreaSize,
                                                                                                //         smRegisteredTrees: smDetails.smLists[reversedIndex].smRegisteredTrees,
                                                                                                //         smFarmLocation: smDetails.smLists[reversedIndex].smFarmLocation,
                                                                                                //         itemID: smDetails.smLists[reversedIndex].smId,
                                                                                                //       );
                                                                                              },
                                                                                              editPress: () {
                                                                                                Navigator.of(context).pushNamed(ViewSeedlingMonitoringDetails.routeName, arguments: smDetails.smLists[reversedIndex].smId);
                                                                                              },
                                                                                              disapprovePress: () {
                                                                                                submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                                  DBHelper.deleteMV("seedling_monitoring", smDetails.smLists[reversedIndex].smId);

                                                                                                  Provider.of<SeedlingMonitoring2Provider>(context, listen: false).fetchAndSetSeedlingMonitoring2();
                                                                                                }, editPress: () {}, disapprovePress: () {});
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                          icon: const Icon(
                                                                                            Icons.more_vert,
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
                                                                    onTap:
                                                                        () {},
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
      ),
    );
  }

  Future reUpload(
    BuildContext ctx,
    int enumeratorvalue, {
    String? smCommunity,
    String? smVisitDate,
    String? smFarmerId,
    String? smFarmerName,
    String? smBaseline,
    String? smFarmerContact,
    String? smSpecies,
    String? smReceivedDate,
    String? smPlantedDate,
    String? smQuantityReceived,
    String? smQuantityPlanted,
    String? smQuantitySurvived,
    String? smPlantingArea,
    String? smAreaSize,
    String? smRegisteredTrees,
    String? smFarmLocation,
    String? conStat,
    itemID,
  }) async {
    debugPrint("Baseline is $smBaseline");

    submissionLoader(ctx, "Uploading data", "Please wait a minute...");

    overlayNotification('Data re-uploading... Please wait.', "positive");

    try {
      var seedlingMonitoring = {
        "visitDetails": {
          "communityName": int.parse(smCommunity!),
          "dateOfVisit": smVisitDate,
          "enumerator": enumeratorvalue
        },
        "farmerDetails": {
          "farmerid": smFarmerId!.isNotEmpty ? int.parse(smFarmerId) : null,
          "baseline": smBaseline == "true" ? "no" : "yes"
        },
        "treeFarmInformation": {
          "treeSpecies": smSpecies,
          "dateReceived": smReceivedDate == "" ? null : smReceivedDate,
          "datePlanted": smPlantedDate == "" ? null : smPlantedDate,
          "qntyReceived": smQuantityReceived == null || smQuantityReceived == ""
              ? null
              : int.parse(smQuantityReceived),
          "qntyPlanted": smQuantityPlanted == null || smQuantityPlanted == ""
              ? null
              : int.parse(smQuantityPlanted),
          "qntySurvived": smQuantitySurvived == null || smQuantitySurvived == ""
              ? null
              : int.parse(smQuantitySurvived),
          "plantingAreaType": smPlantingArea == "" ? null : smPlantingArea,
          "areaSize": smAreaSize == null || smAreaSize == ""
              ? null
              : int.parse(smAreaSize),
          "noOfTreesRegistered":
              smRegisteredTrees == null || smRegisteredTrees == ""
                  ? null
                  : int.parse(smRegisteredTrees),
          "farmLocation": smFarmLocation == "" ? null : smFarmLocation
        }
      };

      var url = '$stageBaseUrl/seedlingsmonitoringapi/';

      var body = json.encode(seedlingMonitoring);

//here jsonEncode(data) return String bt in http body you are passing Map value

//So you have to convert String to Map
      var bodyMap = jsonDecode(body);
      print("Body " + body);

// your nested json data
      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);
      print("uploading...");
      print("Statuscode is ${res.statusCode}");

      final itemss = json.decode(res.body);

      print("itemss $body");
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "done") {
        Navigator.pop(context);
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        regSP?.clear();
        // return res.statusCode;
        DBHelper.updateMView(
            "seedling_monitoring", "farmerName", "connected", itemID);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const ViewMonitoredTrees(
              pageNum: 0,
            ),
          ),
        );
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Data already: $status.', "positive");

        regSP?.clear();

        DBHelper.updateMView(
            "seedling_monitoring", "farmerName", "connected", itemID);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const ViewMonitoredTrees(
                      pageNum: 0,
                    )));
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        print("${itemss["error"]}");
        Navigator.pop(context);
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again.',
          "negative");
      Navigator.pop(context);
    } catch (i) {
      overlayNotification(i, "negative");
      print("i ===> $i");
      Navigator.of(context).pop();
    }
  }

  String? _focommunity;
  String? _fofarmerName;
  String? _fofarmerContact;
  String? _fofarmerGender;
  String? _fofarmerDoB;
  String? _fofarmerHolderCat;
  String? _fofarmerAreaSize;

  Future reUpload2(
    BuildContext ctx,
    int enumeratorvalue, {
    String? smCommunity,
    String? smVisitDate,
    String? smFarmerId,
    String? smFarmerName,
    String? smBaseline,
    String? smFarmerContact,
    String? smSpecies,
    String? smReceivedDate,
    String? smPlantedDate,
    String? smQuantityReceived,
    String? smQuantityPlanted,
    String? smQuantitySurvived,
    String? smPlantingArea,
    String? smAreaSize,
    String? smRegisteredTrees,
    String? smFarmLocation,
    String? conStat,
    itemID,
  }) async {
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");

    overlayNotification('Data re-uploading... Please wait.', "positive");

    try {
      var seedlingMonitoring = {
        "visitDetails": {
          "communityName": int.parse(smCommunity!),
          "dateOfVisit": smVisitDate,
          "enumerator": enumeratorvalue
        },
        "farmerDetails": {
          "farmerid": smFarmerId!.isNotEmpty ? int.parse(smFarmerId) : null,
          "baseline": smBaseline == "true" ? "no" : "yes"
        },
        "treeFarmInformation": {
          "treeSpecies": smSpecies,
          "dateReceived": smReceivedDate == "" ? null : smReceivedDate,
          "datePlanted": smPlantedDate == "" ? null : smPlantedDate,
          "qntyReceived": smQuantityReceived == null || smQuantityReceived == ""
              ? null
              : int.parse(smQuantityReceived),
          "qntyPlanted": smQuantityPlanted == null || smQuantityPlanted == ""
              ? null
              : int.parse(smQuantityPlanted),
          "qntySurvived": smQuantitySurvived == null || smQuantitySurvived == ""
              ? null
              : int.parse(smQuantitySurvived),
          "plantingAreaType": smPlantingArea == "" ? null : smPlantingArea,
          "areaSize": smAreaSize == null || smAreaSize == ""
              ? null
              : int.parse(smAreaSize),
          "noOfTreesRegistered":
              smRegisteredTrees == null || smRegisteredTrees == ""
                  ? null
                  : int.parse(smRegisteredTrees),
          "farmLocation": smFarmLocation == "" ? null : smFarmLocation
        }
      };

      var url = '$stageBaseUrl/seedlingsmonitoringapi/';

      var body = json.encode(seedlingMonitoring);

//here jsonEncode(data) return String bt in http body you are passing Map value

//So you have to convert String to Map
      var bodyMap = jsonDecode(body);
      print(body);

// your nested json data
      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);
      print("uploading...");
      print("Statuscode is ${res.statusCode}");

      final itemss = json.decode(res.body);

      print("itemss $body");
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "done") {
        Navigator.pop(context);
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        regSP?.clear();
        // return res.statusCode;
        DBHelper.updateMView(
            "seedling_monitoring", "farmerName", "connected", itemID);

        DBHelper.deleteLFD("farmer_offline", smFarmerContact!);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const ViewMonitoredTrees(
              pageNum: 0,
            ),
          ),
        );
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Data already: $status.', "positive");

        regSP?.clear();

        DBHelper.updateMView(
            "seedling_monitoring", "farmerName", "connected", itemID);
        DBHelper.deleteLFD("farmer_offline", smFarmerContact!);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const ViewMonitoredTrees(
                      pageNum: 0,
                    )));
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        print("${itemss["error"]}");
        Navigator.pop(context);
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again.',
          "negative");
      Navigator.pop(context);
    } catch (i) {
      overlayNotification(i, "negative");
      print("i ===> $i");
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> getFarmerFromFarmerOfflineLocalDB(farmercontact) async {
    print("traversing offline farmer instead");
    final db = await DBHelper.database();
    // var count = await db
    //     .rawQuery(
    //         'SELECT foCommunity, foFarmerName, foContact, foGender, foDoB,'
    //         ' foHolderCategory, foFarmSize  FROM farmer_offline WHERE foContact'
    //         ' LIKE $farmercontact')
    //     .then((value) {
    var count = await db.query("farmer_offline",
        where: "foContact = ?", whereArgs: [farmercontact]).then((value) {
      if (value.isNotEmpty) {
        print("offline db");
        setState(() {
          _focommunity = value[0]['foCommunity'] as String?;
          _fofarmerName = value[0]['foFarmerName'] as String?;
          _fofarmerContact = value[0]['foContact'] as String?;
          _fofarmerGender = value[0]['foGender'] as String?;
          _fofarmerDoB = value[0]['foDoB'] as String?;
          _fofarmerHolderCat = value[0]['foHolderCategory'] as String?;
          _fofarmerAreaSize = value[0]['foFarmSize'] as String?;
        });

        print("Please try agai");
      } else {
        print("Please try");
      }
    });

    // var list = count.toList();
    return count;
  }

  _asyncSearchFarmerOnline(
    BuildContext ctx,
    int enumeratorvalue, {
    String? smCommunity,
    String? smVisitDate,
    String? smFarmerId,
    String? smFarmerName,
    String? smBaseline,
    String? smFarmerContact,
    String? smSpecies,
    String? smReceivedDate,
    String? smPlantedDate,
    String? smQuantityReceived,
    String? smQuantityPlanted,
    String? smQuantitySurvived,
    String? smPlantingArea,
    String? smAreaSize,
    String? smRegisteredTrees,
    String? smFarmLocation,
    String? conStat,
    itemID,
  }) async {
    submissionLoader(ctx, "Retrieving account", "Please wait a minute...");
    var newVibe;
    try {
      // print(_phonenum.text);

      final response = await http.get(Uri.parse(
          "$stageBaseUrl/searchfarmer/?contact=$smFarmerContact&form=seedling"));

      final items = json.decode(response.body);

      print(response.body);
      print(items);
      print(items["farmer_name"]);
      newVibe = items["farmerid"];

      try {
        if (newVibe != null) {
          Navigator.of(context).pop();
          overlayNotification('Record found.', "positive");

          reUpload2(
            ctx,
            enumeratorvalue,
            smCommunity: smCommunity,
            smVisitDate: smVisitDate,
            smFarmerId: newVibe,
            smFarmerName: smFarmerName,
            smBaseline: smBaseline,
            smFarmerContact: smFarmerContact,
            smSpecies: smSpecies,
            smReceivedDate: smReceivedDate,
            smPlantedDate: smPlantedDate,
            smQuantityReceived: smQuantityReceived,
            smQuantityPlanted: smQuantityPlanted,
            smQuantitySurvived: smQuantitySurvived,
            smPlantingArea: smPlantingArea,
            smAreaSize: smAreaSize,
            smRegisteredTrees: smRegisteredTrees,
            smFarmLocation: smFarmLocation,
            itemID: itemID,
          );
          print("Scale 2");
        } else {
          Navigator.of(context).pop();

          overlayNotification('No record found.', "negative");
          print("Exception part caught");
          print("Scale 5");
        }
      } on SocketException catch (_) {
        Navigator.of(context).pop();
        overlayNotification(
            'Validation failed! Please check internet connection and try again',
            "negative");
        print("Fireabse Notification failed");
        print("Scale 6");
      }

      return response;
    } on SocketException {
      Navigator.of(context).pop();
      overlayNotification(
          'Validation failed! Please check internet connection and try again',
          "negative");
      print("Scale 7");
    }
  }

// update local farmer api list
  void _submissionLoading(ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Container(
              // width: 5000,
              child: AlertDialog(
                title: new Text(
                  "Loading data",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    ),
                    new Text(
                      "Please wait a minute...",
                      style:
                          const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void saveToLocalDBSeedling(
    id,
    falFarmerName,
    falCommunityName,
    falCommunityId,
    falContact,
    falBaseline,
  ) {
    Provider.of<RegisteredFarmerListApiSeedlingApiProvider>(context,
            listen: false)
        .addRegisteredFarmerListApiSeedling(
      id,
      falFarmerName,
      falCommunityName,
      falCommunityId,
      falContact,
      falBaseline,
    );

    // print("Successfully saved to local DB");
  }

  Future<dynamic> savetoFarmerApiListSeedling(
    farmercontact,
    id,
    falFarmerName,
    falCommunityName,
    falCommunityId,
    falContact,
    falBaseline,
  ) async {
    final db = await DBHelper.database();
    // var count = await db
    //     .rawQuery(
    //         'SELECT falSContact FROM farmer_api_list_seedling WHERE falSContact'
    //         ' LIKE $farmercontact')
    var count = await db.query("farmer_api_list_seedling",
        where: "falSContact = ?", whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        print("need to save");
        saveToLocalDBSeedling(
          id.toString(),
          falFarmerName,
          falCommunityName,
          falCommunityId.toString(),
          falContact,
          falBaseline.toString(),
        );
      } else {
        print("Done deal");
      }
    });
    return count;
  }

  int? index;
  Future getFarmersApiListSeedling(BuildContext ctx) async {
    _submissionLoading(ctx);

    overlayNotification('Data loading', "positive");
    try {
      var url = '$stageBaseUrl/farmerlist/?form=seedling';

      var res = await http.get(Uri.parse(url));

      final itemss = json.decode(res.body);

      print("itemss $itemss");

      if (res.statusCode == 200) {
        var farmerdata = itemss as List;
        for (var a in farmerdata) {
          // print("Farmer id ${index + index++}")
          // ;
          savetoFarmerApiListSeedling(
            a["contact"],
            a["farmerid"].toString(),
            a["farmer_name"],
            a["community_name"],
            a["community"],
            a["contact"],
            a["baseline"],
          );
          print("$a -- Farmer id ${a["farmer_name"]}");
        }
        Navigator.of(context).pop();
      } else {
        overlayNotification('Error occured with}', "negative");
        Navigator.pop(context);
        print('Error occured with error:');
        // return res.statusCode;
      }
    } on SocketException catch (e) {
      print("e === $e");
      overlayNotification(
          'Oops! Please connect to the internet to update local data.',
          "negative");
      Navigator.of(context).pop();
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

// final function which calls all other functions
  _asyncAddFarmer(
    BuildContext ctx,
    farmercontact,
    int enumeratorvalue, {
    String? smCommunity,
    String? smVisitDate,
    String? smFarmerId,
    String? smFarmerName,
    String? smBaseline,
    String? smFarmerContact,
    String? smSpecies,
    String? smReceivedDate,
    String? smPlantedDate,
    String? smQuantityReceived,
    String? smQuantityPlanted,
    String? smQuantitySurvived,
    String? smPlantingArea,
    String? smAreaSize,
    String? smRegisteredTrees,
    String? smFarmLocation,
    String? conStat,
    itemID,
  }) async {
    // getSPValues();
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");
    // getEnumeratorValue('first_time_user');
    overlayNotification('Adding farmer... Please wait.', "positive");

    try {
      await getFarmerFromFarmerOfflineLocalDB(farmercontact);

      print("Com $_focommunity");
      var farmerBioData = {
        "community": int.parse(_focommunity!),
        "farmer_name": _fofarmerName,
        "contact": _fofarmerContact,
        "gender": _fofarmerGender,
        "dob": _fofarmerDoB,
        "small_holder_category": _fofarmerHolderCat,
        "farm_size": double.parse(_fofarmerAreaSize!)
      };

      var url = '$stageBaseUrl/farmerapi/';

      var body = json.encode(farmerBioData);

//here jsonEncode(data) return String bt in http body you are passing Map value

//So you have to convert String to Map
      var bodyMap = jsonDecode(body);
      print(body);

// your nested json data
      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);

      print("uploading...");
      print("Statuscode is ${res.statusCode}");

      final itemss = json.decode(res.body);

      print("itemss $body");
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "done") {
        // saveToLocalDB("connected");
        overlayNotification(
            'Farmer saved successfully with status: $status.', "positive");

        regSP?.clear();
        Navigator.of(context).pop();

        _asyncSearchFarmerOnline(
          ctx,
          enumeratorvalue,
          smCommunity: smCommunity,
          smVisitDate: smVisitDate,
          smFarmerId: smFarmerId,
          smFarmerName: smFarmerName,
          smBaseline: smBaseline,
          smFarmerContact: smFarmerContact,
          smSpecies: smSpecies,
          smReceivedDate: smReceivedDate,
          smPlantedDate: smPlantedDate,
          smQuantityReceived: smQuantityReceived,
          smQuantityPlanted: smQuantityPlanted,
          smQuantitySurvived: smQuantitySurvived,
          smPlantingArea: smPlantingArea,
          smAreaSize: smAreaSize,
          smRegisteredTrees: smRegisteredTrees,
          smFarmLocation: smFarmLocation,
          itemID: itemID,
        );
        // return res.statusCode;
      } else if (status == "exist") {
        overlayNotification('Farmer already: $status.', "positive");

        regSP?.clear();
        Navigator.of(context).pop();

        _asyncSearchFarmerOnline(
          ctx,
          enumeratorvalue,
          smCommunity: smCommunity,
          smVisitDate: smVisitDate,
          smFarmerId: smFarmerId,
          smFarmerName: smFarmerName,
          smBaseline: smBaseline,
          smFarmerContact: smFarmerContact,
          smSpecies: smSpecies,
          smReceivedDate: smReceivedDate,
          smPlantedDate: smPlantedDate,
          smQuantityReceived: smQuantityReceived,
          smQuantityPlanted: smQuantityPlanted,
          smQuantitySurvived: smQuantitySurvived,
          smPlantingArea: smPlantingArea,
          smAreaSize: smAreaSize,
          smRegisteredTrees: smRegisteredTrees,
          smFarmLocation: smFarmLocation,
          itemID: itemID,
        );
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      overlayNotification(
          'Oops! No Internet connection. Please connect to the internet and try again.',
          "negative");
      print("e === $e");
      print("No internet section");

      regSP?.clear();
      Navigator.of(context).pop();
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
    // throw "caught exception here";
  }
}

class Constants {
  static const String delete = "Delete";
  static const String view = "View";
  static const String synco = "Resend";

  static const List<String> _onlineChoices = <String>[delete, view];

  static const List<String> _offlineChoices = <String>[delete, view, synco];
}
