import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/errorpages/mainerrordisplay.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewdetails.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewincompletedetails.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'components/newcard.dart';

class ViewReport extends StatefulWidget {
  static const routeName = '/view_page';

  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  var isConnected;
  String? foneID;

  @override
  void initState() {
    super.initState();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  void _submissionLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Container(
              // width: 5000,
              child: AlertDialog(
                title: new Text(
                  "Submitting Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF006633),
                      ),
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

  refresh() {
    setState(() {
      // global.isChecked = true;
    });
  }

  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => IndexPage()), (route) => false)
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw ("wrong here");
  }

  String? statusUpdate;
  // var k = DetailDisplayIncomplete();
  // k.route

  @override
  Widget build(BuildContext context) {
    // MapDetails mapDetails;
    // int i;

    Future<Null> refreshList() async {
      refreshKey.currentState?.show(atTop: false);
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        WillPopScope(
          onWillPop: _onbackPressed,
          child: Scaffold(
            appBar: AppBar( foregroundColor: fPrimaryWhite,
              backgroundColor: fPrimaryColour,
              title: Text("Registered Trees",
          style: TextStyle(color: fPrimaryWhite),),
              centerTitle: true,
            ),
            body: Container(
              child: Material(
                child: FutureBuilder(
                  future: Provider.of<PersonalFarmerProvider>(context,
                          listen: false)
                      .fetchAndSetPersonalFarmer(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Consumer<PersonalFarmerProvider>(
                              child: Center(
                                child: const Text('No trees registered yet.'),
                              ),
                              builder: (ctx, mapDetails, ch) => Container(
                                height: MediaQuery.of(context).size.height,
                                child: mapDetails.farmerLists.length <= 0
                                    ? ch
                                    : RefreshIndicator(
                                        key: refreshKey,
                                        onRefresh: refreshList,
                                        child: ListView.builder(
                                            physics: ScrollPhysics(
                                                parent:
                                                    AlwaysScrollableScrollPhysics()),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                mapDetails.farmerLists.length,
                                            itemBuilder: (ctx, i) {
                                              int itemCount =
                                                  mapDetails.farmerLists.length;
                                              int reversedIndex =
                                                  itemCount - 1 - i;

                                              // setState(() {
                                              //             _launched = _launchInWebViewWithJavaScript(toLaunch);
                                              //           });
                                              return SingleChildScrollView(
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(height: 10),
                                                    // Text(
                                                    //     "${mapDetails.farmerLists.length} registered trees"),
                                                    mapDetails
                                                                .farmerLists[
                                                                    reversedIndex]
                                                                .conStat ==
                                                            "incomplete"
                                                        ? Container(
                                                            height: 160,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .beneficiaryType ==
                                                                    "Individual"
                                                                ? InkWell(
                                                                    child:
                                                                        ViewCard(
                                                                      dateRecorded: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .timeDisplay,
                                                                      type: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .beneficiaryType,
                                                                      name:
                                                                          "${mapDetails.farmerLists[reversedIndex].farmerfirstName} "
                                                                          "${mapDetails.farmerLists[reversedIndex].farmersurName}",
                                                                      email: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .farmerMail,
                                                                      timeSent:
                                                                          "Tap to complete",
                                                                      color: Colors
                                                                          .black,
                                                                      image: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .farmerPic64,
                                                                      community: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .community,
                                                                      pressAction:
                                                                          () =>
                                                                              submissionOptions(
                                                                        context,
                                                                        "Select an option",
                                                                        "View/ Edit data",
                                                                        "Delete data",
                                                                        "Cancel",
                                                                        approvePress:
                                                                            () async {
                                                                          regSP?.setString(
                                                                              "farm",
                                                                              mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                          regSP?.setString(
                                                                              "c2",
                                                                              mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "c3",
                                                                              mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "fgender",
                                                                              mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                          regSP?.setString(
                                                                              "kgender",
                                                                              mapDetails.farmerLists[reversedIndex].kinGender);
                                                                          regSP?.setString(
                                                                              "fdob",
                                                                              mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                          regSP?.setString(
                                                                              "kdob",
                                                                              mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                          Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                        },
                                                                        editPress:
                                                                            () {
                                                                          submissionOptions(
                                                                              context,
                                                                              "Are you sure you want to delete?",
                                                                              "Yes",
                                                                              "",
                                                                              "No",
                                                                              approvePress:
                                                                                  () {
                                                                            DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                            Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                          },
                                                                              editPress: () {},
                                                                              disapprovePress: () {});
                                                                        },
                                                                        disapprovePress:
                                                                            () =>
                                                                                null,
                                                                      ),
                                                                      conState: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .conStat,
                                                                    ),
                                                                    onTap: () =>
                                                                        submissionOptions(
                                                                      context,
                                                                      "Select an option",
                                                                      "View/ Edit data",
                                                                      "Delete data",
                                                                      "Cancel",
                                                                      approvePress:
                                                                          () async {
                                                                        regSP?.setString(
                                                                            "farm",
                                                                            mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                        regSP?.setString(
                                                                            "c2",
                                                                            mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                        regSP?.setString(
                                                                            "c3",
                                                                            mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                        regSP?.setString(
                                                                            "fgender",
                                                                            mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                        regSP?.setString(
                                                                            "kgender",
                                                                            mapDetails.farmerLists[reversedIndex].kinGender);
                                                                        regSP?.setString(
                                                                            "fdob",
                                                                            mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                        regSP?.setString(
                                                                            "kdob",
                                                                            mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                        Navigator.of(context).pushNamed(
                                                                            DetailDisplayIncomplete
                                                                                .routeName,
                                                                            arguments:
                                                                                mapDetails.farmerLists[reversedIndex].id);
                                                                      },
                                                                      editPress:
                                                                          () {
                                                                        submissionOptions(
                                                                            context,
                                                                            "Are you sure you want to delete?",
                                                                            "Yes",
                                                                            "",
                                                                            "No",
                                                                            approvePress:
                                                                                () {
                                                                          DBHelper.delete(mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id);

                                                                          Provider.of<PersonalFarmerProvider>(context, listen: false)
                                                                              .fetchAndSetPersonalFarmer();
                                                                        },
                                                                            editPress:
                                                                                () {},
                                                                            disapprovePress:
                                                                                () {});
                                                                      },
                                                                      disapprovePress:
                                                                          () =>
                                                                              null,
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    child:
                                                                        ViewCard(
                                                                      dateRecorded: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .timeDisplay,
                                                                      type: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .beneficiaryType,
                                                                      name: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .groupName,
                                                                      email: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .groupEmail,
                                                                      timeSent:
                                                                          "Tap to complete",
                                                                      color: Colors
                                                                          .black,
                                                                      community: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .community,
                                                                      image: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .farmerPic64,
                                                                      pressAction:
                                                                          () =>
                                                                              submissionOptions(
                                                                        context,
                                                                        "Select an option",
                                                                        "View/ Edit data",
                                                                        "Delete data",
                                                                        "Cancel",
                                                                        approvePress:
                                                                            () async {
                                                                          regSP?.setString(
                                                                              "farm",
                                                                              mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                          regSP?.setString(
                                                                              "c2",
                                                                              mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "c3",
                                                                              mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "fgender",
                                                                              mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                          regSP?.setString(
                                                                              "kgender",
                                                                              mapDetails.farmerLists[reversedIndex].kinGender);
                                                                          regSP?.setString(
                                                                              "fdob",
                                                                              mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                          regSP?.setString(
                                                                              "kdob",
                                                                              mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                          Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                        },
                                                                        editPress:
                                                                            () {
                                                                          submissionOptions(
                                                                              context,
                                                                              "Are you sure you want to delete?",
                                                                              "Yes",
                                                                              "",
                                                                              "No",
                                                                              approvePress:
                                                                                  () {
                                                                            DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                            Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                          },
                                                                              editPress: () {},
                                                                              disapprovePress: () {});
                                                                        },
                                                                        disapprovePress:
                                                                            () =>
                                                                                null,
                                                                      ),
                                                                      conState: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .conStat,
                                                                    ),
                                                                    onTap: () =>
                                                                        submissionOptions(
                                                                      context,
                                                                      "Select an option",
                                                                      "View/ Edit data",
                                                                      "Delete data",
                                                                      "Cancel",
                                                                      approvePress:
                                                                          () async {
                                                                        regSP?.setString(
                                                                            "farm",
                                                                            mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                        regSP?.setString(
                                                                            "c2",
                                                                            mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                        regSP?.setString(
                                                                            "c3",
                                                                            mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                        regSP?.setString(
                                                                            "fgender",
                                                                            mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                        regSP?.setString(
                                                                            "kgender",
                                                                            mapDetails.farmerLists[reversedIndex].kinGender);
                                                                        regSP?.setString(
                                                                            "fdob",
                                                                            mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                        regSP?.setString(
                                                                            "kdob",
                                                                            mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                        Navigator.of(context).pushNamed(
                                                                            DetailDisplayIncomplete
                                                                                .routeName,
                                                                            arguments:
                                                                                mapDetails.farmerLists[reversedIndex].id);
                                                                      },
                                                                      editPress:
                                                                          () {
                                                                        submissionOptions(
                                                                            context,
                                                                            "Are you sure you want to delete?",
                                                                            "Yes",
                                                                            "",
                                                                            "No",
                                                                            approvePress:
                                                                                () {
                                                                          DBHelper.delete(mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id);

                                                                          Provider.of<PersonalFarmerProvider>(context, listen: false)
                                                                              .fetchAndSetPersonalFarmer();
                                                                        },
                                                                            editPress:
                                                                                () {},
                                                                            disapprovePress:
                                                                                () {});
                                                                      },
                                                                      disapprovePress:
                                                                          () =>
                                                                              null,
                                                                    ),
                                                                  ),
                                                          )
                                                        : mapDetails
                                                                    .farmerLists[
                                                                        reversedIndex]
                                                                    .conStat ==
                                                                "connected"
                                                            ? Container(
                                                                height: 160,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .beneficiaryType ==
                                                                        "Individual"
                                                                    ? ViewCard(
                                                                        dateRecorded: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .timeDisplay,
                                                                        type: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .beneficiaryType,
                                                                        name:
                                                                            "${mapDetails.farmerLists[reversedIndex].farmerfirstName} "
                                                                            "${mapDetails.farmerLists[reversedIndex].farmersurName}",
                                                                        email: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerMail,
                                                                        timeSent: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .timeDisplay,
                                                                        image: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerPic64,
                                                                        community: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .community,
                                                                        pressAction:
                                                                            () {
                                                                          submissionOptions(
                                                                            context,
                                                                            "Select an option",
                                                                            "View data",
                                                                            "Delete local data",
                                                                            "Cancel",
                                                                            approvePress:
                                                                                () async {
                                                                              regSP?.setString("farm", mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                              regSP?.setString("c2", mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                              regSP?.setString("c3", mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                              regSP?.setString("fgender", mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                              regSP?.setString("kgender", mapDetails.farmerLists[reversedIndex].kinGender);
                                                                              regSP?.setString("fdob", mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                              regSP?.setString("kdob", mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                              Navigator.of(context).pushNamed(DetailDisplayIncomplete.routeName, arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                            },
                                                                            editPress:
                                                                                () {
                                                                              submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                                Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                              }, editPress: () {}, disapprovePress: () {});
                                                                            },
                                                                            disapprovePress: () =>
                                                                                null,
                                                                          );
                                                                        },
                                                                        conState: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .conStat,
                                                                      )
                                                                    : ViewCard(
                                                                        dateRecorded: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .timeDisplay,
                                                                        type: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .beneficiaryType,
                                                                        name: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .groupName,
                                                                        email: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .groupEmail,
                                                                        timeSent: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .timeDisplay,
                                                                        community: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .community,
                                                                        image: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerPic64,
                                                                        pressAction:
                                                                            () {
                                                                          submissionOptions(
                                                                            context,
                                                                            "Select an option",
                                                                            "View data",
                                                                            "Delete local data",
                                                                            "Cancel",
                                                                            approvePress:
                                                                                () async {
                                                                              regSP?.setString("farm", mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                              regSP?.setString("c2", mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                              regSP?.setString("c3", mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                              regSP?.setString("fgender", mapDetails.farmerLists[reversedIndex].farmerGender);

                                                                              regSP?.setString("kgender", mapDetails.farmerLists[reversedIndex].kinGender);
                                                                              regSP?.setString("fdob", mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                              regSP?.setString("kdob", mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                              Navigator.of(context).pushNamed(DetailDisplayIncomplete.routeName, arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                            },
                                                                            editPress:
                                                                                () {
                                                                              submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                                Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                              }, editPress: () {}, disapprovePress: () {});
                                                                            },
                                                                            disapprovePress: () =>
                                                                                null,
                                                                          );
                                                                        },
                                                                        conState: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .conStat,
                                                                      ),
                                                              )
                                                            : Container(
                                                                height: 160,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .beneficiaryType ==
                                                                        "Individual"
                                                                    ? InkWell(
                                                                        child:
                                                                            ViewCard(
                                                                          dateRecorded: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .timeDisplay,
                                                                          type: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .beneficiaryType,
                                                                          name:
                                                                              "${mapDetails.farmerLists[reversedIndex].farmerfirstName} "
                                                                              "${mapDetails.farmerLists[reversedIndex].farmersurName}",
                                                                          email: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerMail,
                                                                          timeSent:
                                                                              "Please tap to resend",
                                                                          color:
                                                                              Colors.black,
                                                                          image: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerPic64,
                                                                          community: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .community,
                                                                          pressAction: () =>
                                                                              submissionOptions(
                                                                            context,
                                                                            "Select an option",
                                                                            "View/ Edit data",
                                                                            "Delete data",
                                                                            "Cancel",
                                                                            approvePress:
                                                                                () async {
                                                                              regSP?.setString("farm", mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                              regSP?.setString("c2", mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                              regSP?.setString("c3", mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                              regSP?.setString("fgender", mapDetails.farmerLists[reversedIndex].farmerGender);

                                                                              regSP?.setString("kgender", mapDetails.farmerLists[reversedIndex].kinGender);
                                                                              regSP?.setString("fdob", mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                              regSP?.setString("kdob", mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                              Navigator.of(context).pushNamed(DetailDisplayIncomplete.routeName, arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                            },
                                                                            editPress:
                                                                                () {
                                                                              submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                                Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                              }, editPress: () {}, disapprovePress: () {});
                                                                            },
                                                                            disapprovePress: () =>
                                                                                null,
                                                                          ),
                                                                          conState: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .conStat,
                                                                        ),
                                                                        onTap: () =>
                                                                            submissionOptions(
                                                                          context,
                                                                          "Select an option",
                                                                          "Resend data",
                                                                          "View/ Edit data before send",
                                                                          "Delete data",
                                                                          approvePress:
                                                                              () {
                                                                            return reUpload(
                                                                              context,
                                                                              mapDetails.farmerLists[reversedIndex].farmerId,
                                                                              mapDetails.farmerLists[reversedIndex].beneficiaryType,
                                                                              int.parse(mapDetails.farmerLists[reversedIndex].enumeratorValue),
                                                                              farmerDoB: mapDetails.farmerLists[reversedIndex].farmerDoB,
                                                                              farmerfirstName: mapDetails.farmerLists[reversedIndex].farmerfirstName,
                                                                              farmerGender: mapDetails.farmerLists[reversedIndex].farmerGender,
                                                                              kinDoB: mapDetails.farmerLists[reversedIndex].kinDoB,
                                                                              kinGender: mapDetails.farmerLists[reversedIndex].kinGender,
                                                                              kinName: mapDetails.farmerLists[reversedIndex].kinName,
                                                                              kinPhoneNum: mapDetails.farmerLists[reversedIndex].kinPhoneNum,
                                                                              kinAddress: mapDetails.farmerLists[reversedIndex].kinPostal,
                                                                              kinRelationShip: mapDetails.farmerLists[reversedIndex].kinRelationShip,
                                                                              farmerotherName: mapDetails.farmerLists[reversedIndex].farmerotherName,
                                                                              farmerPic64: mapDetails.farmerLists[reversedIndex].farmerPic64,
                                                                              farmersurName: mapDetails.farmerLists[reversedIndex].farmersurName,
                                                                              farmerPhoneNum: mapDetails.farmerLists[reversedIndex].farmerPhoneNum,
                                                                              farmerPostal: mapDetails.farmerLists[reversedIndex].farmerPostal,
                                                                              farmerMail: mapDetails.farmerLists[reversedIndex].farmerMail,
                                                                              declarationSig: mapDetails.farmerLists[reversedIndex].farmerdeclarationSig,
                                                                              witnessdeclarationSig: mapDetails.farmerLists[reversedIndex].witnessdeclarationSig,
                                                                              witnessName: mapDetails.farmerLists[reversedIndex].witnessName,
                                                                              witnessPhone: mapDetails.farmerLists[reversedIndex].witnessPhone,
                                                                              community: mapDetails.farmerLists[reversedIndex].community,
                                                                              family: mapDetails.farmerLists[reversedIndex].family,
                                                                              forestDistrict: mapDetails.farmerLists[reversedIndex].forestDistrict,
                                                                              mddas: int.parse(
                                                                                mapDetails.farmerLists[reversedIndex].mddas,
                                                                              ),
                                                                              region: mapDetails.farmerLists[reversedIndex].region,
                                                                              farmID: mapDetails.farmerLists[reversedIndex].farmID,
                                                                              farmCords: mapDetails.farmerLists[reversedIndex].pointsGet,
                                                                              farmArea: mapDetails.farmerLists[reversedIndex].farmArea,
                                                                              treeInfo0Option: mapDetails.farmerLists[reversedIndex].c2treePlantationDetail,
                                                                              treeInfo2Option: mapDetails.farmerLists[reversedIndex].c3treePlantationDetail,
                                                                              toEstablishment: mapDetails.farmerLists[reversedIndex].typeofEstablishment,
                                                                              itemID: mapDetails.farmerLists[reversedIndex].id,
                                                                            );
                                                                          },
                                                                          editPress: () => Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id),
                                                                          disapprovePress:
                                                                              () {
                                                                            submissionOptions(
                                                                                context,
                                                                                "Are you sure you want to delete?",
                                                                                "Yes",
                                                                                "",
                                                                                "No",
                                                                                approvePress: () {
                                                                              DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                              Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                            }, editPress: () {}, disapprovePress: () {});
                                                                          },
                                                                        ),
                                                                      )
                                                                    : InkWell(
                                                                        child:
                                                                            ViewCard(
                                                                          dateRecorded: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .timeDisplay,
                                                                          type: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .beneficiaryType,
                                                                          name: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupName,
                                                                          email: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupEmail,
                                                                          timeSent:
                                                                              "Please tap to resend",
                                                                          color:
                                                                              Colors.black,
                                                                          community: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .community,
                                                                          image: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerPic64,
                                                                          pressAction: () =>
                                                                              submissionOptions(
                                                                            context,
                                                                            "Select an option",
                                                                            "View/ Edit data",
                                                                            "Delete data",
                                                                            "Cancel",
                                                                            approvePress:
                                                                                () async {
                                                                              regSP?.setString("farm", mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                              regSP?.setString("c2", mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                              regSP?.setString("c3", mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                              regSP?.setString("fgender", mapDetails.farmerLists[reversedIndex].farmerGender);

                                                                              regSP?.setString("kgender", mapDetails.farmerLists[reversedIndex].kinGender);
                                                                              regSP?.setString("fdob", mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                              regSP?.setString("kdob", mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                              Navigator.of(context).pushNamed(DetailDisplayIncomplete.routeName, arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                            },
                                                                            editPress:
                                                                                () {
                                                                              submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                                Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                              }, editPress: () {}, disapprovePress: () {});
                                                                            },
                                                                            disapprovePress: () =>
                                                                                null,
                                                                          ),
                                                                          conState: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .conStat,
                                                                        ),
                                                                        onTap: () =>
                                                                            submissionOptions(
                                                                          context,
                                                                          "Select an option",
                                                                          "Resend data",
                                                                          "View/ Edit data before send",
                                                                          "Delete data",
                                                                          approvePress:
                                                                              () {
                                                                            return reUpload(
                                                                              context,
                                                                              mapDetails.farmerLists[reversedIndex].farmerId,
                                                                              mapDetails.farmerLists[reversedIndex].beneficiaryType,
                                                                              int.parse(mapDetails.farmerLists[reversedIndex].enumeratorValue),
                                                                              declarationSig: mapDetails.farmerLists[reversedIndex].farmerdeclarationSig,
                                                                              witnessdeclarationSig: mapDetails.farmerLists[reversedIndex].witnessdeclarationSig,
                                                                              witnessName: mapDetails.farmerLists[reversedIndex].witnessName,
                                                                              witnessPhone: mapDetails.farmerLists[reversedIndex].witnessPhone,
                                                                              community: mapDetails.farmerLists[reversedIndex].community,
                                                                              family: mapDetails.farmerLists[reversedIndex].family,
                                                                              forestDistrict: mapDetails.farmerLists[reversedIndex].forestDistrict,
                                                                              mddas: int.parse(
                                                                                mapDetails.farmerLists[reversedIndex].mddas,
                                                                              ),
                                                                              region: mapDetails.farmerLists[reversedIndex].region,
                                                                              farmID: mapDetails.farmerLists[reversedIndex].farmID,
                                                                              farmCords: mapDetails.farmerLists[reversedIndex].pointsGet,
                                                                              farmArea: mapDetails.farmerLists[reversedIndex].farmArea,
                                                                              treeInfo0Option: mapDetails.farmerLists[reversedIndex].c2treePlantationDetail,
                                                                              treeInfo2Option: mapDetails.farmerLists[reversedIndex].c3treePlantationDetail,
                                                                              toEstablishment: mapDetails.farmerLists[reversedIndex].typeofEstablishment,
                                                                              companyDirectors: mapDetails.farmerLists[reversedIndex].groupDirectors,
                                                                              groupName: mapDetails.farmerLists[reversedIndex].groupName,
                                                                              groupPresident: mapDetails.farmerLists[reversedIndex].groupPresident,
                                                                              groupSecretary: mapDetails.farmerLists[reversedIndex].groupSecretary,
                                                                              groupPhone: mapDetails.farmerLists[reversedIndex].groupphoneNumber,
                                                                              groupAddress: mapDetails.farmerLists[reversedIndex].groupAddress,
                                                                              groupEmail: mapDetails.farmerLists[reversedIndex].groupEmail,
                                                                              itemID: mapDetails.farmerLists[reversedIndex].id,
                                                                            );
                                                                          },
                                                                          editPress: () => Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id),
                                                                          disapprovePress:
                                                                              () {
                                                                            submissionOptions(
                                                                                context,
                                                                                "Are you sure you want to delete?",
                                                                                "Yes",
                                                                                "",
                                                                                "No",
                                                                                approvePress: () {
                                                                              DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                              Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                            }, editPress: () {}, disapprovePress: () {});
                                                                          },
                                                                        ),
                                                                      ),
                                                              ),
                                                    // Divider(
                                                    //   thickness: 2.0,
                                                    // )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                              ),
                            ),
                ),
              ),
            ),
          ),
        );
      });
    }

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar( foregroundColor: fPrimaryWhite,
          backgroundColor: fPrimaryColour,
          title: Text("Registered Trees",
          style: TextStyle(color: fPrimaryWhite),),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => refreshList(),
            )
          ],
        ),
        body: Container(
          child: Material(
            child: FutureBuilder(
              future:
                  Provider.of<PersonalFarmerProvider>(context, listen: false)
                      .fetchAndSetPersonalFarmer(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Consumer<PersonalFarmerProvider>(
                          child: Center(
                            child: const Text('No trees registered yet.'),
                          ),
                          builder: (ctx, mapDetails, ch) => Container(
                            height: MediaQuery.of(context).size.height,
                            child: mapDetails.farmerLists.length <= 0
                                ? ch
                                : RefreshIndicator(
                                    onRefresh: refreshList,
                                    key: refreshKey,
                                    child: ListView.builder(
                                        physics: ScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics()),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            mapDetails.farmerLists.length,
                                        itemBuilder: (ctx, i) {
                                          int itemCount =
                                              mapDetails.farmerLists.length;
                                          int reversedIndex = itemCount - 1 - i;
                                          // setState(() {
                                          //             _launched = _launchInWebViewWithJavaScript(toLaunch);
                                          //           });
                                          return SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(height: 10),
                                                // Text("${mapDetails.farmerLists.length} registered trees"),
                                                mapDetails
                                                            .farmerLists[
                                                                reversedIndex]
                                                            .conStat ==
                                                        "incomplete"
                                                    ? Container(
                                                        height: 160,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: mapDetails
                                                                    .farmerLists[
                                                                        reversedIndex]
                                                                    .beneficiaryType ==
                                                                "Individual"
                                                            ? InkWell(
                                                                child: ViewCard(
                                                                  dateRecorded: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .timeDisplay,
                                                                  type: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .beneficiaryType,
                                                                  name:
                                                                      "${mapDetails.farmerLists[reversedIndex].farmerfirstName} "
                                                                      "${mapDetails.farmerLists[reversedIndex].farmersurName}",
                                                                  email: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .farmerMail,
                                                                  timeSent:
                                                                      "Tap to complete",
                                                                  color: Colors
                                                                      .black,
                                                                  image: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .farmerPic64,
                                                                  community: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .community,
                                                                  pressAction: () =>
                                                                      submissionOptions(
                                                                    context,
                                                                    "Select an option",
                                                                    "View/ Edit data",
                                                                    "Delete data",
                                                                    "Cancel",
                                                                    approvePress:
                                                                        () async {
                                                                      regSP?.setString(
                                                                          "farm",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .pointsGet);
                                                                      regSP?.setString(
                                                                          "c2",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c2treePlantationDetail);
                                                                      regSP?.setString(
                                                                          "c3",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c3treePlantationDetail);
                                                                      regSP?.setString(
                                                                          "fgender",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerGender);
                                                                      regSP?.setString(
                                                                          "kgender",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinGender);
                                                                      regSP?.setString(
                                                                          "fdob",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerDoB);
                                                                      regSP?.setString(
                                                                          "kdob",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinDoB);
                                                                      Navigator.of(context).pushNamed(
                                                                          DetailDisplayIncomplete
                                                                              .routeName,
                                                                          arguments: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id);
                                                                    },
                                                                    editPress:
                                                                        () {
                                                                      submissionOptions(
                                                                          context,
                                                                          "Are you sure you want to delete?",
                                                                          "Yes",
                                                                          "",
                                                                          "No",
                                                                          approvePress:
                                                                              () {
                                                                        DBHelper.delete(mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .id);

                                                                        Provider.of<PersonalFarmerProvider>(context,
                                                                                listen: false)
                                                                            .fetchAndSetPersonalFarmer();
                                                                      },
                                                                          editPress:
                                                                              () {},
                                                                          disapprovePress:
                                                                              () {});
                                                                    },
                                                                    disapprovePress:
                                                                        () =>
                                                                            null,
                                                                  ),
                                                                  conState: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .conStat,
                                                                ),
                                                                onTap: () =>
                                                                    submissionOptions(
                                                                  context,
                                                                  "Select an option",
                                                                  "View/ Edit data",
                                                                  "Delete data",
                                                                  "Cancel",
                                                                  approvePress:
                                                                      () async {
                                                                    regSP?.setString(
                                                                        "farm",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .pointsGet);
                                                                    regSP?.setString(
                                                                        "c2",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .c2treePlantationDetail);
                                                                    regSP?.setString(
                                                                        "c3",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .c3treePlantationDetail);
                                                                    regSP?.setString(
                                                                        "fgender",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerGender);
                                                                    regSP?.setString(
                                                                        "kgender",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .kinGender);
                                                                    regSP?.setString(
                                                                        "fdob",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerDoB);
                                                                    regSP?.setString(
                                                                        "kdob",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .kinDoB);
                                                                    Navigator.of(context).pushNamed(
                                                                        DetailDisplayIncomplete
                                                                            .routeName,
                                                                        arguments: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .id);
                                                                  },
                                                                  editPress:
                                                                      () {
                                                                    submissionOptions(
                                                                        context,
                                                                        "Are you sure you want to delete?",
                                                                        "Yes",
                                                                        "",
                                                                        "No",
                                                                        approvePress:
                                                                            () {
                                                                      DBHelper.delete(mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .id);

                                                                      Provider.of<PersonalFarmerProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .fetchAndSetPersonalFarmer();
                                                                    },
                                                                        editPress:
                                                                            () {},
                                                                        disapprovePress:
                                                                            () {});
                                                                  },
                                                                  disapprovePress:
                                                                      () =>
                                                                          null,
                                                                ),
                                                              )
                                                            : InkWell(
                                                                child: ViewCard(
                                                                  dateRecorded: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .timeDisplay,
                                                                  type: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .beneficiaryType,
                                                                  name: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .groupName,
                                                                  email: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .groupEmail,
                                                                  timeSent:
                                                                      "Tap to complete",
                                                                  color: Colors
                                                                      .black,
                                                                  community: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .community,
                                                                  image: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .farmerPic64,
                                                                  pressAction: () =>
                                                                      submissionOptions(
                                                                    context,
                                                                    "Select an option",
                                                                    "View/ Edit data",
                                                                    "Delete data",
                                                                    "Cancel",
                                                                    approvePress:
                                                                        () async {
                                                                      regSP?.setString(
                                                                          "farm",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .pointsGet);
                                                                      regSP?.setString(
                                                                          "c2",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c2treePlantationDetail);
                                                                      regSP?.setString(
                                                                          "c3",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c3treePlantationDetail);
                                                                      regSP?.setString(
                                                                          "fgender",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerGender);
                                                                      regSP?.setString(
                                                                          "kgender",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinGender);
                                                                      regSP?.setString(
                                                                          "fdob",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerDoB);
                                                                      regSP?.setString(
                                                                          "kdob",
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinDoB);
                                                                      Navigator.of(context).pushNamed(
                                                                          DetailDisplayIncomplete
                                                                              .routeName,
                                                                          arguments: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id);
                                                                    },
                                                                    editPress:
                                                                        () {
                                                                      submissionOptions(
                                                                          context,
                                                                          "Are you sure you want to delete?",
                                                                          "Yes",
                                                                          "",
                                                                          "No",
                                                                          approvePress:
                                                                              () {
                                                                        DBHelper.delete(mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .id);

                                                                        Provider.of<PersonalFarmerProvider>(context,
                                                                                listen: false)
                                                                            .fetchAndSetPersonalFarmer();
                                                                      },
                                                                          editPress:
                                                                              () {},
                                                                          disapprovePress:
                                                                              () {});
                                                                    },
                                                                    disapprovePress:
                                                                        () =>
                                                                            null,
                                                                  ),
                                                                  conState: mapDetails
                                                                      .farmerLists[
                                                                          reversedIndex]
                                                                      .conStat,
                                                                ),
                                                                onTap: () =>
                                                                    submissionOptions(
                                                                  context,
                                                                  "Select an option",
                                                                  "View/ Edit data",
                                                                  "Delete data",
                                                                  "Cancel",
                                                                  approvePress:
                                                                      () async {
                                                                    regSP?.setString(
                                                                        "farm",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .pointsGet);
                                                                    regSP?.setString(
                                                                        "c2",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .c2treePlantationDetail);
                                                                    regSP?.setString(
                                                                        "c3",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .c3treePlantationDetail);
                                                                    regSP?.setString(
                                                                        "fgender",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerGender);
                                                                    regSP?.setString(
                                                                        "kgender",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .kinGender);
                                                                    regSP?.setString(
                                                                        "fdob",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .farmerDoB);
                                                                    regSP?.setString(
                                                                        "kdob",
                                                                        mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .kinDoB);
                                                                    Navigator.of(context).pushNamed(
                                                                        DetailDisplayIncomplete
                                                                            .routeName,
                                                                        arguments: mapDetails
                                                                            .farmerLists[reversedIndex]
                                                                            .id);
                                                                  },
                                                                  editPress:
                                                                      () {
                                                                    submissionOptions(
                                                                        context,
                                                                        "Are you sure you want to delete?",
                                                                        "Yes",
                                                                        "",
                                                                        "No",
                                                                        approvePress:
                                                                            () {
                                                                      DBHelper.delete(mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .id);

                                                                      Provider.of<PersonalFarmerProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .fetchAndSetPersonalFarmer();
                                                                    },
                                                                        editPress:
                                                                            () {},
                                                                        disapprovePress:
                                                                            () {});
                                                                  },
                                                                  disapprovePress:
                                                                      () =>
                                                                          null,
                                                                ),
                                                              ),
                                                      )
                                                    : mapDetails
                                                                .farmerLists[
                                                                    reversedIndex]
                                                                .conStat ==
                                                            "connected"
                                                        ? Container(
                                                            height: 160,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .beneficiaryType ==
                                                                    "Individual"
                                                                ? ViewCard(
                                                                    dateRecorded: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .timeDisplay,
                                                                    type: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .beneficiaryType,
                                                                    name:
                                                                        "${mapDetails.farmerLists[reversedIndex].farmerfirstName} "
                                                                        "${mapDetails.farmerLists[reversedIndex].farmersurName}",
                                                                    email: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .farmerMail,
                                                                    timeSent: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .timeDisplay,
                                                                    image: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .farmerPic64,
                                                                    community: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .community,
                                                                    pressAction:
                                                                        () {
                                                                      submissionOptions(
                                                                        context,
                                                                        "Select an option",
                                                                        "View data",
                                                                        "Delete local data",
                                                                        "Cancel",
                                                                        approvePress:
                                                                            () async {
                                                                          regSP?.setString(
                                                                              "farm",
                                                                              mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                          regSP?.setString(
                                                                              "c2",
                                                                              mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "c3",
                                                                              mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "fgender",
                                                                              mapDetails.farmerLists[reversedIndex].farmerGender);

                                                                          regSP?.setString(
                                                                              "kgender",
                                                                              mapDetails.farmerLists[reversedIndex].kinGender);
                                                                          regSP?.setString(
                                                                              "fdob",
                                                                              mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                          regSP?.setString(
                                                                              "kdob",
                                                                              mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                          Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                        },
                                                                        editPress:
                                                                            () {
                                                                          submissionOptions(
                                                                              context,
                                                                              "Are you sure you want to delete?",
                                                                              "Yes",
                                                                              "",
                                                                              "No",
                                                                              approvePress:
                                                                                  () {
                                                                            DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                            Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                          },
                                                                              editPress: () {},
                                                                              disapprovePress: () {});
                                                                        },
                                                                        disapprovePress:
                                                                            () =>
                                                                                null,
                                                                      );
                                                                    },
                                                                    conState: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .conStat,
                                                                  )
                                                                : ViewCard(
                                                                    dateRecorded: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .timeDisplay,
                                                                    type: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .beneficiaryType,
                                                                    name: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .groupName,
                                                                    email: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .groupEmail,
                                                                    timeSent: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .timeDisplay,
                                                                    community: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .community,
                                                                    image: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .farmerPic64,
                                                                    pressAction:
                                                                        () {
                                                                      submissionOptions(
                                                                        context,
                                                                        "Select an option",
                                                                        "View data",
                                                                        "Delete local data",
                                                                        "Cancel",
                                                                        approvePress:
                                                                            () async {
                                                                          regSP?.setString(
                                                                              "farm",
                                                                              mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                          regSP?.setString(
                                                                              "c2",
                                                                              mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "c3",
                                                                              mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "fgender",
                                                                              mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                          regSP?.setString(
                                                                              "kgender",
                                                                              mapDetails.farmerLists[reversedIndex].kinGender);
                                                                          regSP?.setString(
                                                                              "fdob",
                                                                              mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                          regSP?.setString(
                                                                              "kdob",
                                                                              mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                          Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                        },
                                                                        editPress:
                                                                            () {
                                                                          submissionOptions(
                                                                              context,
                                                                              "Are you sure you want to delete?",
                                                                              "Yes",
                                                                              "",
                                                                              "No",
                                                                              approvePress:
                                                                                  () {
                                                                            DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                            Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                          },
                                                                              editPress: () {},
                                                                              disapprovePress: () {});
                                                                        },
                                                                        disapprovePress:
                                                                            () =>
                                                                                null,
                                                                      );
                                                                    },
                                                                    conState: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .conStat,
                                                                  ),
                                                          )
                                                        : Container(
                                                            height: 160,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: mapDetails
                                                                        .farmerLists[
                                                                            reversedIndex]
                                                                        .beneficiaryType ==
                                                                    "Individual"
                                                                ? InkWell(
                                                                    child:
                                                                        ViewCard(
                                                                      dateRecorded: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .timeDisplay,
                                                                      type: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .beneficiaryType,
                                                                      name:
                                                                          "${mapDetails.farmerLists[reversedIndex].farmerfirstName} "
                                                                          "${mapDetails.farmerLists[reversedIndex].farmersurName}",
                                                                      email: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .farmerMail,
                                                                      timeSent:
                                                                          "Please tap to resend",
                                                                      color: Colors
                                                                          .black,
                                                                      image: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .farmerPic64,
                                                                      community: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .community,
                                                                      pressAction:
                                                                          () {
                                                                        submissionOptions(
                                                                          context,
                                                                          "Select an option",
                                                                          "View/ Edit data",
                                                                          "Delete data",
                                                                          "Cancel",
                                                                          approvePress:
                                                                              () async {
                                                                            regSP?.setString("farm",
                                                                                mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                            regSP?.setString("c2",
                                                                                mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                            regSP?.setString("c3",
                                                                                mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                            regSP?.setString("fgender",
                                                                                mapDetails.farmerLists[reversedIndex].farmerGender);

                                                                            regSP?.setString("kgender",
                                                                                mapDetails.farmerLists[reversedIndex].kinGender);
                                                                            regSP?.setString("fdob",
                                                                                mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                            regSP?.setString("kdob",
                                                                                mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                            Navigator.of(context).pushNamed(DetailDisplayIncomplete.routeName,
                                                                                arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                          },
                                                                          editPress:
                                                                              () {
                                                                            submissionOptions(
                                                                                context,
                                                                                "Are you sure you want to delete?",
                                                                                "Yes",
                                                                                "",
                                                                                "No",
                                                                                approvePress: () {
                                                                              DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                              Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                            }, editPress: () {}, disapprovePress: () {});
                                                                          },
                                                                          disapprovePress: () =>
                                                                              null,
                                                                        );
                                                                      },
                                                                      conState: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .conStat,
                                                                    ),
                                                                    onTap: () =>
                                                                        submissionOptions(
                                                                      context,
                                                                      "Select an option",
                                                                      "Resend data",
                                                                      "View/ Edit data before send",
                                                                      "Delete data",
                                                                      approvePress:
                                                                          () {
                                                                        return reUpload(
                                                                          context,
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerId,
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .beneficiaryType,
                                                                          int.parse(mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .enumeratorValue),
                                                                          farmerDoB: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerDoB,
                                                                          farmerfirstName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerfirstName,
                                                                          farmerGender: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerGender,
                                                                          kinDoB: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinDoB,
                                                                          kinGender: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinGender,
                                                                          kinName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinName,
                                                                          kinPhoneNum: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinPhoneNum,
                                                                          kinAddress: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinPostal,
                                                                          kinRelationShip: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .kinRelationShip,
                                                                          farmerotherName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerotherName,
                                                                          farmerPic64: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerPic64,
                                                                          farmersurName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmersurName,
                                                                          farmerPhoneNum: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerPhoneNum,
                                                                          farmerPostal: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerPostal,
                                                                          farmerMail: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerMail,
                                                                          declarationSig: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerdeclarationSig,
                                                                          witnessdeclarationSig: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .witnessdeclarationSig,
                                                                          witnessName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .witnessName,
                                                                          witnessPhone: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .witnessPhone,
                                                                          community: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .community,
                                                                          family: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .family,
                                                                          forestDistrict: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .forestDistrict,
                                                                          mddas:
                                                                              int.parse(
                                                                            mapDetails.farmerLists[reversedIndex].mddas,
                                                                          ),
                                                                          region: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .region,
                                                                          farmID: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmID,
                                                                          farmCords: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .pointsGet,
                                                                          farmArea: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmArea,
                                                                          treeInfo0Option: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c2treePlantationDetail,
                                                                          treeInfo2Option: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c3treePlantationDetail,
                                                                          toEstablishment: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .typeofEstablishment,
                                                                          itemID: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id,
                                                                        );
                                                                      },
                                                                      editPress: () => Navigator.of(context).pushNamed(
                                                                          DetailDisplayIncomplete
                                                                              .routeName,
                                                                          arguments: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id),
                                                                      disapprovePress:
                                                                          () {
                                                                        submissionOptions(
                                                                            context,
                                                                            "Are you sure you want to delete?",
                                                                            "Yes",
                                                                            "",
                                                                            "No",
                                                                            approvePress:
                                                                                () {
                                                                          DBHelper.delete(mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id);

                                                                          Provider.of<PersonalFarmerProvider>(context, listen: false)
                                                                              .fetchAndSetPersonalFarmer();
                                                                        },
                                                                            editPress:
                                                                                () {},
                                                                            disapprovePress:
                                                                                () {});
                                                                      },
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    child:
                                                                        ViewCard(
                                                                      dateRecorded: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .timeDisplay,
                                                                      type: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .beneficiaryType,
                                                                      name: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .groupName,
                                                                      email: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .groupEmail,
                                                                      timeSent:
                                                                          "Please tap to resend",
                                                                      color: Colors
                                                                          .black,
                                                                      community: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .community,
                                                                      image: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .farmerPic64,
                                                                      pressAction:
                                                                          () =>
                                                                              submissionOptions(
                                                                        context,
                                                                        "Select an option",
                                                                        "View/ Edit data",
                                                                        "Delete data",
                                                                        "Cancel",
                                                                        approvePress:
                                                                            () async {
                                                                          regSP?.setString(
                                                                              "farm",
                                                                              mapDetails.farmerLists[reversedIndex].pointsGet);
                                                                          regSP?.setString(
                                                                              "c2",
                                                                              mapDetails.farmerLists[reversedIndex].c2treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "c3",
                                                                              mapDetails.farmerLists[reversedIndex].c3treePlantationDetail);
                                                                          regSP?.setString(
                                                                              "fgender",
                                                                              mapDetails.farmerLists[reversedIndex].farmerGender);
                                                                          regSP?.setString(
                                                                              "kgender",
                                                                              mapDetails.farmerLists[reversedIndex].kinGender);
                                                                          regSP?.setString(
                                                                              "fdob",
                                                                              mapDetails.farmerLists[reversedIndex].farmerDoB);
                                                                          regSP?.setString(
                                                                              "kdob",
                                                                              mapDetails.farmerLists[reversedIndex].kinDoB);
                                                                          Navigator.of(context).pushNamed(
                                                                              DetailDisplayIncomplete.routeName,
                                                                              arguments: mapDetails.farmerLists[reversedIndex].id);
                                                                        },
                                                                        editPress:
                                                                            () {
                                                                          submissionOptions(
                                                                              context,
                                                                              "Are you sure you want to delete?",
                                                                              "Yes",
                                                                              "",
                                                                              "No",
                                                                              approvePress:
                                                                                  () {
                                                                            DBHelper.delete(mapDetails.farmerLists[reversedIndex].id);

                                                                            Provider.of<PersonalFarmerProvider>(context, listen: false).fetchAndSetPersonalFarmer();
                                                                          },
                                                                              editPress: () {},
                                                                              disapprovePress: () {});
                                                                        },
                                                                        disapprovePress:
                                                                            () =>
                                                                                null,
                                                                      ),
                                                                      conState: mapDetails
                                                                          .farmerLists[
                                                                              reversedIndex]
                                                                          .conStat,
                                                                    ),
                                                                    onTap: () =>
                                                                        submissionOptions(
                                                                      context,
                                                                      "Select an option",
                                                                      "Resend data",
                                                                      "View/ Edit data before send",
                                                                      "Delete data",
                                                                      approvePress:
                                                                          () {
                                                                        return reUpload(
                                                                          context,
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerId,
                                                                          mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .beneficiaryType,
                                                                          int.parse(mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .enumeratorValue),
                                                                          declarationSig: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmerdeclarationSig,
                                                                          witnessdeclarationSig: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .witnessdeclarationSig,
                                                                          witnessName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .witnessName,
                                                                          witnessPhone: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .witnessPhone,
                                                                          community: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .community,
                                                                          family: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .family,
                                                                          forestDistrict: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .forestDistrict,
                                                                          mddas:
                                                                              int.parse(
                                                                            mapDetails.farmerLists[reversedIndex].mddas,
                                                                          ),
                                                                          region: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .region,
                                                                          farmID: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmID,
                                                                          farmCords: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .pointsGet,
                                                                          farmArea: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .farmArea,
                                                                          treeInfo0Option: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c2treePlantationDetail,
                                                                          treeInfo2Option: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .c3treePlantationDetail,
                                                                          toEstablishment: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .typeofEstablishment,
                                                                          companyDirectors: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupDirectors,
                                                                          groupName: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupName,
                                                                          groupPresident: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupPresident,
                                                                          groupSecretary: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupSecretary,
                                                                          groupPhone: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupphoneNumber,
                                                                          groupAddress: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupAddress,
                                                                          groupEmail: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .groupEmail,
                                                                          itemID: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id,
                                                                        );
                                                                      },
                                                                      editPress: () => Navigator.of(context).pushNamed(
                                                                          DetailDisplayIncomplete
                                                                              .routeName,
                                                                          arguments: mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id),
                                                                      disapprovePress:
                                                                          () {
                                                                        submissionOptions(
                                                                            context,
                                                                            "Are you sure you want to delete?",
                                                                            "Yes",
                                                                            "",
                                                                            "No",
                                                                            approvePress:
                                                                                () {
                                                                          DBHelper.delete(mapDetails
                                                                              .farmerLists[reversedIndex]
                                                                              .id);

                                                                          Provider.of<PersonalFarmerProvider>(context, listen: false)
                                                                              .fetchAndSetPersonalFarmer();
                                                                        },
                                                                            editPress:
                                                                                () {},
                                                                            disapprovePress:
                                                                                () {});
                                                                      },
                                                                    ),
                                                                  ),
                                                          ),
                                                // Divider(
                                                //   thickness: 2.0,
                                                // )
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Future reUpload(
    BuildContext ctx,
    String farmerId,
    String beneficiaryType,
    int enumeratorvalue, {
    String? farmerDoB,
    String? farmerfirstName,
    String? farmerGender,
    kinDoB,
    kinGender,
    kinName,
    kinPhoneNum,
    kinAddress,
    kinRelationShip,
    farmerotherName,
    farmerPic64,
    farmersurName,
    farmerPhoneNum,
    farmerPostal,
    farmerMail,
    declarationSig,
    witnessdeclarationSig,
    witnessName,
    witnessPhone,
    community,
    family,
    forestDistrict,
    mddas,
    region,
    farmID,
    farmCords,
    farmArea,
    treeInfo0Option,
    treeInfo2Option,
    toEstablishment,
    companyDirectors,
    groupName,
    groupPresident,
    groupSecretary,
    groupPhone,
    groupAddress,
    groupEmail,
    itemID,
  }) async {
    _submissionLoading();

    List<FarmInformationArray> item;

    farmCords.isNotEmpty
        ? item = FarmInformationArray.decode(farmCords)
        : item = [];
    item.insert(item.length, item.first);

    final String encodedData = FarmInformationArray.encode(item);

    final pointsGet = farmCords.isNotEmpty
        ? json.decode(encodedData).cast<Map<String, dynamic>>()
        : Map();
    final c2treePlantationDetail = treeInfo0Option.isNotEmpty
        ? json.decode(treeInfo0Option).cast<Map<String, dynamic>>()
        : Map();
    final c3treePlantationDetail = treeInfo2Option.isNotEmpty
        ? json.decode(treeInfo2Option).cast<Map<String, dynamic>>()
        : Map();

    overlayNotification('Data re-uploading... Please wait.', "positive");
    try {
      var individualdata = {
        "beneficiaryDetails": {
          "farmerid": farmerId,
          "dateOfBirth": "$farmerDoB",
          "firstName": "$farmerfirstName",
          "enumerator": enumeratorvalue,
          "gender": "$farmerGender",
          "nextOfKin": {
            "dateOfBirth": "$kinDoB",
            "gender": "$kinGender",
            "name": "$kinName",
            "phoneNumber": "$kinPhoneNum",
            "relationship": "$kinRelationShip",
            "address": "$kinAddress"
          },
          "otherNames": "$farmerotherName",
          "passportImageBase64String": "$farmerPic64",
          "surname": "$farmersurName",
          "beneficiaryType": "$beneficiaryType",
          "phoneNumber": "$farmerPhoneNum",
          "address": "$farmerPostal",
          "email": "$farmerMail"
        },
        "declaration": {
          "signatureOrThumbprintBase64String": "$declarationSig",
          "witness": {
            "date": "${formattedDate.toString()}",
            "name": "$witnessName",
            "phoneNumber": "$witnessPhone",
            "witnessSignatureOrThumbprintBase64String": "$witnessdeclarationSig"
          }
        },
        "location": {
          "community": "$community",
          "family": "$family",
          "forestDistrict": "$forestDistrict",
          "mmdas": mddas,
          "region": "$region"
        },
        "treeFarmInformationArray": [
          {
            "farmId": "$farmID",
            "farmInformationArray": pointsGet,
            // "treeFarmArea": farmArea,
            "treeInformationOption1Array": c2treePlantationDetail,
            "treeInformationOption2Array": c3treePlantationDetail,
            "typeOfEstablishments": json.decode(toEstablishment)
          },
        ]
      };

      var groupdata = {
        "beneficiaryDetails": {
          "farmerid": farmerId,
          "enumerator": enumeratorvalue,
          "companyDirectors": ["$companyDirectors"],
          "groupName": "$groupName",
          "groupPresident": "$groupPresident",
          "groupSecretary": "$groupSecretary",
          "beneficiaryType": "$beneficiaryType",
          "phoneNumber": "$groupPhone",
          "address": "$groupAddress",
          "email": "$groupEmail",
          "passportImageBase64String": "$declarationSig"
        },
        "declaration": {
          "signatureOrThumbprintBase64String": "$declarationSig",
          "witness": {
            "date": "${formattedDate.toString()}",
            "name": "$witnessName",
            "phoneNumber": "$witnessPhone",
            "witnessSignatureOrThumbprintBase64String": "$witnessdeclarationSig"
          }
        },
        "location": {
          "community": "$community",
          "family": "$family",
          "forestDistrict": "$forestDistrict",
          "mmdas": mddas,
          "region": "$region"
        },
        "treeFarmInformationArray": [
          {
            "farmId": "$farmID",
            "farmInformationArray": pointsGet,
            // "treeFarmArea": farmArea,
            "treeInformationOption1Array": c2treePlantationDetail,
            "treeInformationOption2Array": c3treePlantationDetail,
            "typeOfEstablishments": json.decode(toEstablishment)
          }
        ]
      };

      var url = '$stageBaseUrl/saverecords/';

      var body = beneficiaryType == "Individual"
          ? json.encode(individualdata)
          : json.encode(groupdata);

      var bodyMap = jsonDecode(body);

      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);
      print("uploading... $body");
      print("Statuscode is ${res.statusCode}");

      try {
        final responseData = jsonDecode(res.body);
        print("Response in first try is $responseData");
        // return responseData ?? "failed on first try";

        Navigator.of(ctx).push(CupertinoPageRoute(
            builder: (BuildContext context) => MainErrorDisplay(
                errorMessage: res.body.toString(),
                statusCode: res.statusCode)));
      } catch (e) {
        Navigator.pop(ctx);
        Navigator.of(ctx).push(CupertinoPageRoute(
            builder: (BuildContext context) => MainErrorDisplay(
                errorMessage: res.body.toString(),
                statusCode: res.statusCode)));
      }

      print(res.body);
      final itemss = json.decode(res.body);

      print("itemss $body");
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "Done") {
        Navigator.pop(context);
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");
        regSP?.clear();
        // return res.statusCode;
        DBHelper.update("connected", itemID);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => this.widget));
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Data already: $status.', "positive");
        regSP?.clear();

        DBHelper.update("connected", itemID);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => this.widget));
      } else {
        overlayNotification(itemss["error"], "negative");
        print("${itemss["error"]}");
        Navigator.pop(context);
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again.',
          "negative");
      Navigator.pop(context);
    } catch (i) {
      overlayNotification(i, "negative");
      print(i);
      Navigator.of(context).pop();
    }
  }
}
