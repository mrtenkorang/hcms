import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiAlternativeprovider.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewalternatelivelihooddetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AlternativeLivelihoodView extends StatefulWidget {
  final String? filterdate;
  const AlternativeLivelihoodView({Key? key, this.filterdate})
      : super(key: key);

  @override
  _AlternativeLivelihoodViewState createState() =>
      _AlternativeLivelihoodViewState();
}

class _AlternativeLivelihoodViewState extends State<AlternativeLivelihoodView> {
  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(
            builder: (c) => ViewMonitoredTrees(
                  pageNum: 2,
                )))
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "error on going back";
  }

  @override
  Widget build(BuildContext context) {
    final assocProvider =
        Provider.of<AlternativeLivelihoodProvider>(context, listen: false)
            .fetchAndSetAlternativeLivelihoodWhere(
                "alVisitDate", widget.filterdate);

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar( foregroundColor: fPrimaryWhite,
          backgroundColor: fPrimaryColour,
          title: Text(widget.filterdate.toString() + " Records",
          style: TextStyle(color: fPrimaryWhite),),
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
                    Spacer(flex: 2),
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
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Consumer<AlternativeLivelihoodProvider>(
                                          child: Center(
                                            child: const Text(
                                              'No data.',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          builder: (ctx, alDetails, ch) =>
                                              Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.3,
                                            child: alDetails.alLists.length <= 0
                                                ? ch
                                                : ListView.builder(
                                                    physics: ScrollPhysics(
                                                        parent:
                                                            AlwaysScrollableScrollPhysics()),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: alDetails
                                                        .alLists.length,
                                                    itemBuilder: (ctx, i) {
                                                      int itemCount = alDetails
                                                          .alLists.length;
                                                      int reversedIndex =
                                                          itemCount - 1 - i;

                                                      return SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[
                                                            alDetails
                                                                        .alLists[
                                                                            reversedIndex]
                                                                        .alConStat ==
                                                                    "not connected"
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
                                                                                gradient: LinearGradient(colors: [
                                                                                  Color(0xff42E695),
                                                                                  Color(0xff3BB2B8)
                                                                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                                                boxShadow: [
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
                                                                                size: Size(50, 150),
                                                                                painter: alDetails.alLists[reversedIndex].alConStat == "not connected" ? CustomCardShapePainter(30, Colors.grey, Colors.grey) : CustomCardShapePainter(30, Colors.red, Colors.yellow),
                                                                              ),
                                                                            ),
                                                                            Positioned.fill(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: CircleAvatar(
                                                                                      radius: 20,
                                                                                      child: Text(alDetails.alLists[reversedIndex].alFarmerName[0]),
                                                                                    ),
                                                                                    flex: 2,
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
                                                                                              Text(
                                                                                                "Date: ",
                                                                                                style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                              Text(
                                                                                                alDetails.alLists[reversedIndex].alTimeDisplay,
                                                                                                style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            alDetails.alLists[reversedIndex].alFarmerName,
                                                                                            style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          alDetails.alLists[reversedIndex].alFarmerContact,
                                                                                          style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                        // Text(
                                                                                        //   alDetails.alLists[reversedIndex].alCommunityName,
                                                                                        //   style: TextStyle(
                                                                                        //     color: Colors.white,
                                                                                        //     fontFamily: 'Avenir',
                                                                                        //   ),
                                                                                        // ),
                                                                                        SizedBox(height: 16),
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            alDetails.alLists[reversedIndex].alConStat == "not connected"
                                                                                                ? Icon(
                                                                                                    Icons.error_outline,
                                                                                                    color: Colors.black,
                                                                                                    size: 25,
                                                                                                  )
                                                                                                : Icon(
                                                                                                    Icons.access_time,
                                                                                                    color: Colors.white,
                                                                                                    size: 16,
                                                                                                  ),
                                                                                            SizedBox(
                                                                                              width: 8,
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                alDetails.alLists[reversedIndex].alConStat == "not connected"
                                                                                                    ? ":: not sent"
                                                                                                    : alDetails.alLists[reversedIndex].alConStat == "farmer offline"
                                                                                                        ? "offline"
                                                                                                        : alDetails.alLists[reversedIndex].alTimeDisplay,
                                                                                                style: TextStyle(
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
                                                                                                return alDetails.alLists[reversedIndex].alConStat == "farmer offline"
                                                                                                    ? _asyncAddFarmer(
                                                                                                        context,
                                                                                                        alDetails.alLists[reversedIndex].alFarmerContact,
                                                                                                        int.parse(alDetails.alLists[reversedIndex].alEnumeratorValue),
                                                                                                        alCommunity: alDetails.alLists[reversedIndex].alCommunity,
                                                                                                        alVisitDate: alDetails.alLists[reversedIndex].alVisitDate,
                                                                                                        alFarmerId: alDetails.alLists[reversedIndex].alFarmerId,
                                                                                                        alFarmerName: alDetails.alLists[reversedIndex].alFarmerName,
                                                                                                        alBasline: alDetails.alLists[reversedIndex].alBasline,
                                                                                                        alFarmerContact: alDetails.alLists[reversedIndex].alFarmerContact,
                                                                                                        alAdditionalActivity: alDetails.alLists[reversedIndex].alAdditionalActivity,
                                                                                                        alTrainerOrg: alDetails.alLists[reversedIndex].alTrainerOrg,
                                                                                                        alOperationsStartDate: alDetails.alLists[reversedIndex].alOperationsStartDate,
                                                                                                        alInitialAmount: alDetails.alLists[reversedIndex].alInitialAmount,
                                                                                                        alAmountType: alDetails.alLists[reversedIndex].alAmountType,
                                                                                                        alAmount: alDetails.alLists[reversedIndex].alAmount,
                                                                                                        alAmountToLMB: alDetails.alLists[reversedIndex].alAmountToLMB,
                                                                                                        alActivitySupported: alDetails.alLists[reversedIndex].alActivitySupported,
                                                                                                        itemID: alDetails.alLists[reversedIndex].alId,
                                                                                                      )
                                                                                                    : reUpload(
                                                                                                        context,
                                                                                                        int.parse(alDetails.alLists[reversedIndex].alEnumeratorValue),
                                                                                                        alCommunity: alDetails.alLists[reversedIndex].alCommunity,
                                                                                                        alVisitDate: alDetails.alLists[reversedIndex].alVisitDate,
                                                                                                        alFarmerId: alDetails.alLists[reversedIndex].alFarmerId,
                                                                                                        alFarmerName: alDetails.alLists[reversedIndex].alFarmerName,
                                                                                                        alBasline: alDetails.alLists[reversedIndex].alBasline,
                                                                                                        alFarmerContact: alDetails.alLists[reversedIndex].alFarmerContact,
                                                                                                        alAdditionalActivity: alDetails.alLists[reversedIndex].alAdditionalActivity,
                                                                                                        alTrainerOrg: alDetails.alLists[reversedIndex].alTrainerOrg,
                                                                                                        alOperationsStartDate: alDetails.alLists[reversedIndex].alOperationsStartDate,
                                                                                                        alInitialAmount: alDetails.alLists[reversedIndex].alInitialAmount,
                                                                                                        alAmountType: alDetails.alLists[reversedIndex].alAmountType,
                                                                                                        alAmount: alDetails.alLists[reversedIndex].alAmount,
                                                                                                        alAmountToLMB: alDetails.alLists[reversedIndex].alAmountToLMB,
                                                                                                        alActivitySupported: alDetails.alLists[reversedIndex].alActivitySupported,
                                                                                                        itemID: alDetails.alLists[reversedIndex].alId,
                                                                                                      );
                                                                                              },
                                                                                              editPress: () {
                                                                                                Navigator.of(context).pushNamed(ViewAlternativeLivelihoodDetails.routeName, arguments: alDetails.alLists[reversedIndex].alId);
                                                                                              },
                                                                                              disapprovePress: () {
                                                                                                submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                                  DBHelper.deleteMV("alternative_livelihood", alDetails.alLists[reversedIndex].alId);

                                                                                                  Provider.of<AlternativeLivelihoodProvider>(context, listen: false).fetchAndSetAlternativeLivelihood();
                                                                                                }, editPress: () {}, disapprovePress: () {});
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                          icon: Icon(
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
                                                                                gradient: LinearGradient(colors: [
                                                                                  Color(0xff42E695),
                                                                                  Color(0xff3BB2B8)
                                                                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                                                boxShadow: [
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
                                                                                size: Size(50, 150),
                                                                                painter: CustomCardShapePainter(30, Colors.red, Colors.yellow),
                                                                              ),
                                                                            ),
                                                                            Positioned.fill(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: CircleAvatar(
                                                                                      radius: 20,
                                                                                      child: Text(alDetails.alLists[reversedIndex].alFarmerName.isNotEmpty ? alDetails.alLists[reversedIndex].alFarmerName[0] : ""),
                                                                                    ),
                                                                                    flex: 2,
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
                                                                                              Text(
                                                                                                "Date: ",
                                                                                                style: TextStyle(color: Colors.black, fontFamily: 'Avenir', fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                              Text(
                                                                                                alDetails.alLists[reversedIndex].alTimeDisplay,
                                                                                                style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            alDetails.alLists[reversedIndex].alFarmerName,
                                                                                            style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          alDetails.alLists[reversedIndex].alFarmerContact,
                                                                                          style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                        // Text(
                                                                                        //   alDetails.alLists[reversedIndex].alCommunityName,
                                                                                        //   style: TextStyle(
                                                                                        //     color: Colors.white,
                                                                                        //     fontFamily: 'Avenir',
                                                                                        //   ),
                                                                                        // ),
                                                                                        SizedBox(height: 16),
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            Icon(
                                                                                              Icons.access_time,
                                                                                              color: Colors.white,
                                                                                              size: 16,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 8,
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                alDetails.alLists[reversedIndex].alTimeDisplay,
                                                                                                style: TextStyle(
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
                                                                                                Navigator.of(context).pushNamed(ViewAlternativeLivelihoodDetails.routeName, arguments: alDetails.alLists[reversedIndex].alId);
                                                                                              },
                                                                                              editPress: () {
                                                                                                submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                                  DBHelper.deleteMV("alternative_livelihood", alDetails.alLists[reversedIndex].alId);

                                                                                                  Provider.of<AlternativeLivelihoodProvider>(context, listen: false).fetchAndSetAlternativeLivelihood();
                                                                                                }, editPress: () {}, disapprovePress: () {});
                                                                                              },
                                                                                              disapprovePress: () => null,
                                                                                            );
                                                                                          },
                                                                                          icon: Icon(
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

                    Spacer(
                      flex: 1,
                    ), // 1/6
                    Spacer(flex: 2), // it will take 2/6 spaces
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
    String? alCommunity,
    String? alVisitDate,
    String? alFarmerId,
    String? alFarmerName,
    String? alBasline,
    String? alFarmerContact,
    String? alAdditionalActivity,
    String? alTrainerOrg,
    String? alOperationsStartDate,
    String? alInitialAmount,
    String? alAmountType,
    String? alAmount,
    String? alAmountToLMB,
    String? alActivitySupported,
    itemID,
  }) async {
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");

    overlayNotification('Data re-uploading... Please wait.', "positive");

    try {
      var alternativeMonitoring = {
        "visitDetails": {
          "communityName": int.parse(alCommunity!),
          "enumerator": enumeratorvalue,
          "dateOfVisit": alVisitDate
        },
        "farmerDetails": {
          "farmerid": alFarmerId!.isNotEmpty ? int.parse(alFarmerId) : null,
          "baseline": alBasline == "true" ? "no" : "yes"
        },
        "activityDetails": {
          "additionalLivelihood": alAdditionalActivity,
          "trainerOrganisation": alTrainerOrg,
          "dateOperationsStarted": alOperationsStartDate,
          "amounts": {
            "invested": alInitialAmount!.isNotEmpty
                ? double.parse(alInitialAmount)
                : null,
            "duration": alAmountType,
            "amount": alAmount!.isNotEmpty ? double.parse(alAmount) : null,
            "lmbContrib":
                alAmountToLMB!.isNotEmpty ? double.parse(alAmountToLMB) : null
          },
          "activitiesSupported": alActivitySupported
        }
      };

      var url = '$stageBaseUrl/alternativemonitoringapi/';

      var body = json.encode(alternativeMonitoring);

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
            "alternative_livelihood", "alConStat", "connected", itemID);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ViewMonitoredTrees(
              pageNum: 2,
            ),
          ),
        );
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Data already: $status.', "positive");

        regSP?.clear();

        DBHelper.updateMView(
            "alternative_livelihood", "alConStat", "connected", itemID);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ViewMonitoredTrees(pageNum: 2)));
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
    String? alCommunity,
    String? alVisitDate,
    String? alFarmerId,
    String? alFarmerName,
    String? alBasline,
    String? alFarmerContact,
    String? alAdditionalActivity,
    String? alTrainerOrg,
    String? alOperationsStartDate,
    String? alInitialAmount,
    String? alAmountType,
    String? alAmount,
    String? alAmountToLMB,
    String? alActivitySupported,
    itemID,
  }) async {
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");

    overlayNotification('Data re-uploading... Please wait.', "positive");

    try {
      var alternativeMonitoring = {
        "visitDetails": {
          "communityName": int.parse(alCommunity!),
          "enumerator": enumeratorvalue,
          "dateOfVisit": alVisitDate
        },
        "farmerDetails": {
          "farmerid": alFarmerId!.isNotEmpty ? int.parse(alFarmerId) : null,
          "baseline": alBasline == "true" ? "no" : "yes"
        },
        "activityDetails": {
          "additionalLivelihood": alAdditionalActivity,
          "trainerOrganisation": alTrainerOrg,
          "dateOperationsStarted": alOperationsStartDate,
          "amounts": {
            "invested": alInitialAmount!.isNotEmpty
                ? double.parse(alInitialAmount)
                : null,
            "duration": alAmountType,
            "amount": alAmount!.isNotEmpty ? double.parse(alAmount) : null,
            "lmbContrib":
                alAmountToLMB!.isNotEmpty ? double.parse(alAmountToLMB) : null
          },
          "activitiesSupported": alActivitySupported
        }
      };

      var url = '$stageBaseUrl/alternativemonitoringapi/';

      var body = json.encode(alternativeMonitoring);

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
            "alternative_livelihood", "alConStat", "connected", itemID);
        await getFarmersApiListAlternative(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ViewMonitoredTrees(
              pageNum: 2,
            ),
          ),
        );
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Data already: $status.', "positive");

        regSP?.clear();

        DBHelper.updateMView(
            "alternative_livelihood", "alConStat", "connected", itemID);

        await getFarmersApiListAlternative(context);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ViewMonitoredTrees(pageNum: 2)));
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
    //     .rawQuery('SELECT * '
    //         ' FROM farmer_offline WHERE foContact'
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
    String? alCommunity,
    String? alVisitDate,
    String? alFarmerId,
    String? alFarmerName,
    String? alBasline,
    String? alFarmerContact,
    String? alAdditionalActivity,
    String? alTrainerOrg,
    String? alOperationsStartDate,
    String? alInitialAmount,
    String? alAmountType,
    String? alAmount,
    String? alAmountToLMB,
    String? alActivitySupported,
    itemID,
  }) async {
    submissionLoader(ctx, "Retrieving account", "Please wait a minute...");
    var newVibe;
    try {
      // print(_phonenum.text);

      final response = await http.get(Uri.parse(
          "$stageBaseUrl/searchfarmer/?contact=$alFarmerContact&form=alternative"));

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
            alCommunity: alCommunity,
            alVisitDate: alVisitDate,
            alFarmerId: newVibe,
            alFarmerName: alFarmerName,
            alBasline: alBasline,
            alFarmerContact: alFarmerContact,
            alAdditionalActivity: alAdditionalActivity,
            alTrainerOrg: alTrainerOrg,
            alOperationsStartDate: alOperationsStartDate,
            alInitialAmount: alInitialAmount,
            alAmountType: alAmountType,
            alAmount: alAmount,
            alAmountToLMB: alAmountToLMB,
            alActivitySupported: alActivitySupported,
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

// update local db of farmer api list
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
                  "Updating local database",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    ),
                    new Text(
                      "Please wait a minute...",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void saveToLocalDBAlternative(
    id,
    falFarmerName,
    falCommunityName,
    falCommunityId,
    falContact,
    falBaseline,
  ) {
    Provider.of<RegisteredFarmerListApiAlternativeApiProvider>(context,
            listen: false)
        .addRegisteredFarmerListApiAlternative(
      id,
      falFarmerName,
      falCommunityName,
      falCommunityId,
      falContact,
      falBaseline,
    );

    // print("Successfully saved to local DB");
  }

  Future<dynamic> savetoFarmerApiListAlternative(
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
    //         'SELECT falAContact FROM farmer_api_list_alternative WHERE falAContact'
    //         ' LIKE $farmercontact')
    var count = await db.query("farmer_api_list_alternative",
        where: "falAContact = ?", whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        print("need to save");
        saveToLocalDBAlternative(
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

  Future getFarmersApiListAlternative(BuildContext ctx) async {
    _submissionLoading(ctx);

    overlayNotification('Data loading', "positive");
    try {
      var url = '$stageBaseUrl/farmerlist/?form=alternative';

      var res = await http.get(Uri.parse(url));

      final itemss = json.decode(res.body);

      print("itemss $itemss");

      if (res.statusCode == 200) {
        overlayNotification('Data loaded successfully', "positive");

        var farmerdata = itemss as List;
        for (var a in farmerdata) {
          // print("Farmer id ${index + index++}")
          // ;
          savetoFarmerApiListAlternative(
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

//final function which runs all others
  _asyncAddFarmer(
    BuildContext ctx,
    farmercontact,
    int enumeratorvalue, {
    String? alCommunity,
    String? alVisitDate,
    String? alFarmerId,
    String? alFarmerName,
    String? alBasline,
    String? alFarmerContact,
    String? alAdditionalActivity,
    String? alTrainerOrg,
    String? alOperationsStartDate,
    String? alInitialAmount,
    String? alAmountType,
    String? alAmount,
    String? alAmountToLMB,
    String? alActivitySupported,
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
          alCommunity: alCommunity,
          alVisitDate: alVisitDate,
          alFarmerId: alFarmerId,
          alFarmerName: alFarmerName,
          alBasline: alBasline,
          alFarmerContact: alFarmerContact,
          alAdditionalActivity: alAdditionalActivity,
          alTrainerOrg: alTrainerOrg,
          alOperationsStartDate: alOperationsStartDate,
          alInitialAmount: alInitialAmount,
          alAmountType: alAmountType,
          alAmount: alAmount,
          alAmountToLMB: alAmountToLMB,
          alActivitySupported: alActivitySupported,
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
          alCommunity: alCommunity,
          alVisitDate: alVisitDate,
          alFarmerId: alFarmerId,
          alFarmerName: alFarmerName,
          alBasline: alBasline,
          alFarmerContact: alFarmerContact,
          alAdditionalActivity: alAdditionalActivity,
          alTrainerOrg: alTrainerOrg,
          alOperationsStartDate: alOperationsStartDate,
          alInitialAmount: alInitialAmount,
          alAmountType: alAmountType,
          alAmount: alAmount,
          alAmountToLMB: alAmountToLMB,
          alActivitySupported: alActivitySupported,
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
