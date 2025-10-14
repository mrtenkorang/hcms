import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/deforestationprovider.dart';
import 'package:hcms_revived2/screens/Deforestation/viewdetailsdef.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/newcard.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ViewDeforestationReports extends StatefulWidget {
  final String? filterdate;
  const ViewDeforestationReports({Key? key, this.filterdate}) : super(key: key);

  @override
  _ViewDeforestationReportsState createState() =>
      _ViewDeforestationReportsState();
}

class _ViewDeforestationReportsState extends State<ViewDeforestationReports> {
  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (c) => IndexPage()))
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "error on going back";
  }

  @override
  Widget build(BuildContext context) {
    final assocProvider =
        Provider.of<DeforestationProvider>(context, listen: false)
            .fetchAndSetDeforestationModel();

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: fPrimaryWhite,
          backgroundColor: fPrimaryColour,
          title: Text(
            "Deforestation Records",
            style: TextStyle(color: fPrimaryWhite),
          ),
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
                                      : Consumer<DeforestationProvider>(
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
                                            child: alDetails.deforestationLists
                                                        .length <=
                                                    0
                                                ? ch
                                                : ListView.builder(
                                                    physics: ScrollPhysics(
                                                        parent:
                                                            AlwaysScrollableScrollPhysics()),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: alDetails
                                                        .deforestationLists
                                                        .length,
                                                    itemBuilder: (ctx, i) {
                                                      int itemCount = alDetails
                                                          .deforestationLists
                                                          .length;
                                                      int reversedIndex =
                                                          itemCount - 1 - i;

                                                      return SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[
                                                            alDetails
                                                                        .deforestationLists[
                                                                            reversedIndex]
                                                                        .conStat ==
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
                                                                                painter: alDetails.deforestationLists[reversedIndex].conStat == "not connected" ? CustomCardShapePainter(30, Colors.grey, Colors.grey) : CustomCardShapePainter(30, Colors.red, Colors.yellow),
                                                                              ),
                                                                            ),
                                                                            Positioned.fill(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: alDetails.deforestationLists[reversedIndex].image.isNotEmpty
                                                                                        ? CircleAvatar(
                                                                                            radius: 30.0,
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(30.0),
                                                                                              child: Image.memory(
                                                                                                base64Decode(
                                                                                                  alDetails.deforestationLists[reversedIndex].image,
                                                                                                ),
                                                                                                height: 64,
                                                                                                width: 64,
                                                                                                fit: BoxFit.fill,
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : CircleAvatar(
                                                                                            radius: 20,
                                                                                            child: Text(alDetails.deforestationLists[reversedIndex].community[0]),
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
                                                                                                alDetails.deforestationLists[reversedIndex].timeDisplay,
                                                                                                style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            alDetails.deforestationLists[reversedIndex].community,
                                                                                            style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          "GFW: ${alDetails.deforestationLists[reversedIndex].gfwDirected}",
                                                                                          style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                        // Text(
                                                                                        //   alDetails.deforestationLists[reversedIndex].alCommunityName,
                                                                                        //   style: TextStyle(
                                                                                        //     color: Colors.white,
                                                                                        //     fontFamily: 'Avenir',
                                                                                        //   ),
                                                                                        // ),
                                                                                        SizedBox(height: 16),
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            alDetails.deforestationLists[reversedIndex].conStat == "not connected"
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
                                                                                                alDetails.deforestationLists[reversedIndex].conStat == "not connected" ? ":: not sent" : alDetails.deforestationLists[reversedIndex].timeDisplay,
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
                                                                                                return reUpload(
                                                                                                  context,
                                                                                                  communityVal: alDetails.deforestationLists[reversedIndex].community,
                                                                                                  gfwDirection: alDetails.deforestationLists[reversedIndex].gfwDirected,
                                                                                                  seeDeforestation: alDetails.deforestationLists[reversedIndex].seeDeforestation,
                                                                                                  deforestationCause: alDetails.deforestationLists[reversedIndex].deforestationCause,
                                                                                                  actionRequired: alDetails.deforestationLists[reversedIndex].takeAction,
                                                                                                  whyAction: alDetails.deforestationLists[reversedIndex].actionReason,
                                                                                                  latitude: alDetails.deforestationLists[reversedIndex].latitude,
                                                                                                  longitude: alDetails.deforestationLists[reversedIndex].longitude,
                                                                                                  speciesbase64Image: alDetails.deforestationLists[reversedIndex].image,
                                                                                                  itemID: alDetails.deforestationLists[reversedIndex].id,
                                                                                                );
                                                                                              },
                                                                                              editPress: () {
                                                                                                Navigator.of(context).pushNamed(ViewDeforestationReportDetails.routeName, arguments: alDetails.deforestationLists[reversedIndex].id);
                                                                                              },
                                                                                              disapprovePress: () {
                                                                                                submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                                  DBHelper.deleteMV("deforestation", alDetails.deforestationLists[reversedIndex].id);

                                                                                                  Provider.of<DeforestationProvider>(context, listen: false).fetchAndSetDeforestationModel();
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
                                                                                    child: alDetails.deforestationLists[reversedIndex].image.isNotEmpty
                                                                                        ? CircleAvatar(
                                                                                            radius: 30.0,
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(30.0),
                                                                                              child: Image.memory(
                                                                                                base64Decode(
                                                                                                  alDetails.deforestationLists[reversedIndex].image,
                                                                                                ),
                                                                                                height: 64,
                                                                                                width: 64,
                                                                                                fit: BoxFit.fill,
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : CircleAvatar(
                                                                                            radius: 20,
                                                                                            child: Text(alDetails.deforestationLists[reversedIndex].community[0]),
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
                                                                                                alDetails.deforestationLists[reversedIndex].timeDisplay,
                                                                                                style: TextStyle(color: fPrimaryBlackColour, fontFamily: 'Avenir', fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            alDetails.deforestationLists[reversedIndex].community,
                                                                                            style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          "GFW: ${alDetails.deforestationLists[reversedIndex].gfwDirected}",
                                                                                          style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                        // Text(
                                                                                        //   alDetails.deforestationLists[reversedIndex].alCommunityName,
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
                                                                                                alDetails.deforestationLists[reversedIndex].timeDisplay,
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
                                                                                                Navigator.of(context).pushNamed(ViewDeforestationReportDetails.routeName, arguments: alDetails.deforestationLists[reversedIndex].id);
                                                                                              },
                                                                                              editPress: () {
                                                                                                submissionOptions(context, "Are you sure you want to delete?", "Yes", "", "No", approvePress: () {
                                                                                                  DBHelper.deleteMV("deforestation", alDetails.deforestationLists[reversedIndex].id);

                                                                                                  Provider.of<DeforestationProvider>(context, listen: false).fetchAndSetDeforestationModel();
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
    BuildContext ctx, {
    String? communityVal,
    String? gfwDirection,
    String? seeDeforestation,
    String? deforestationCause,
    String? actionRequired,
    String? whyAction,
    String? latitude,
    String? longitude,
    String? speciesbase64Image,
    itemID,
  }) async {
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");

    overlayNotification('Data re-uploading... Please wait.', "positive");

    try {
      var deforestationdata = {
        "community": int.parse(communityVal!),
        "directed_by_gfw": gfwDirection,
        "do_u_see_deforestation": seeDeforestation,
        "cause_deforestation": deforestationCause
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "further_action_taken": actionRequired,
        "reason_further_action_taken": whyAction,
        "latitude": double.parse(latitude ?? "0.0"),
        "longitude": double.parse(longitude ?? "0.0"),
        "photos": speciesbase64Image
      };

      var url = '$stageBaseUrl/deforestationapi/';

      var body = json.encode(deforestationdata);

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
        DBHelper.updateMView("deforestation", "conStat", "connected", itemID);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => IndexPage(),
          ),
        );
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Data already: $status.', "positive");

        regSP?.clear();

        DBHelper.updateMView("deforestation", "conStat", "connected", itemID);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => IndexPage()));
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

  // void saveToLocalDBAlternative(
  //   id,
  //   falFarmerName,
  //   falCommunityName,
  //   falCommunityId,
  //   falContact,
  //   falBaseline,
  // ) {
  //   Provider.of<RegisteredFarmerListApiAlternativeApiProvider>(context,
  //           listen: false)
  //       .addRegisteredFarmerListApiAlternative(
  //     id,
  //     falFarmerName,
  //     falCommunityName,
  //     falCommunityId,
  //     falContact,
  //     falBaseline,
  //   );

  //   // print("Successfully saved to local DB");
  // }
}

class Constants {
  static const String delete = "Delete";
  static const String view = "View";
  static const String synco = "Resend";

  static const List<String> _onlineChoices = <String>[delete, view];

  static const List<String> _offlineChoices = <String>[delete, view, synco];
}
