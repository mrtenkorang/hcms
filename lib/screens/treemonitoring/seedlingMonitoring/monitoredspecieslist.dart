import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/getspeciesgallery.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/firstpage.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/treedetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/updateseedVisit.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

class MonitoredSpeciesList extends StatefulWidget {
  final String? name, contact;

  const MonitoredSpeciesList({Key? key, this.name, this.contact})
      : super(key: key);

  @override
  State<MonitoredSpeciesList> createState() => _MonitoredSpeciesListState();
}

class _MonitoredSpeciesListState extends State<MonitoredSpeciesList> {
  ScrollController _scrollController = new ScrollController();

  var rest;
  var filteredList;

  int loaderpage = 1;

  Future<List>? _asyncGetMonitoredSpeciesList(BuildContext ctx) async {
    // _submissionLoading("Requesting new token");

    String newVibe = "";
    String error = "";

    final Uri getdetailsurl = Uri.parse(
        "$stageBaseUrl/specieslist/?contact=${widget.contact}");

    try {
      var header = {"Accept": "application/json"};

      // var sendbody = jsonEncode(body);
      var res = await http.get(getdetailsurl, headers: header);

      print(res.statusCode);
      print(res.body);
      try {
        final itemss = json.decode(res.body);
      } catch (e) {
        print("Error on decoding response");
      }

      try {
        if (res.statusCode == 200) {
          final itemss = json.decode(res.body);
          print("Res is 200");
          print("All correct");
          final String responseString = res.body;

          // rest = itemss["data"] as List;

          print("Filter $filteredList");

          loaderpage++;
          return itemss;
          // speciesGalleryModelFromJson(responseString);
        } else {
          final String responseString = res.body;
          // speciesGalleryModelFromJson(responseString);
        }
      } on SocketException catch (_) {
        print("Socket exception non-200");
      }
    } on SocketException {
      Navigator.of(context).pop();
      print("Internet error");
    }
    // return Future_shopDetail;
    throw Exception('Something wrong on landing page');
  }

  Future<List>? _loader;

  @override
  void initState() {
    super.initState();

    _loader = _asyncGetMonitoredSpeciesList(
      this.context,
    );

    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          // _getAppointmentsFuture =
          _asyncGetMonitoredSpeciesList(context);
        });
      }
    });
  }

  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => SeedlingMonitoring()),
            (route) => false)
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw "error on going back";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar( foregroundColor: fPrimaryWhite,
          automaticallyImplyLeading: false,
          backgroundColor: fPrimaryColour,
          title: RichText(
            text: new TextSpan(children: [
              TextSpan(
                  text: "Tree Seedling Monitoring\n",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text:
                      "Welcome back, ${widget.name ?? regSP?.getString("smfarmername") ?? ""} "),
            ]),
          ),
          actions: [
            Tooltip(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: InkWell(
                  child: Icon(Icons.add),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => TreeDetails(
                        contact: widget.contact,
                      ),
                    ),
                  ),
                ),
              ),
              message: "Click to track new species",
            )
          ],
        ),
        body: grid(size),
      ),
    );
  }

  Widget grid(size) => Container(
        height: size.height * .85,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Column(
          children: [
            Expanded(
              // flex: 2,
              child: Container(
                // color: Colors.blue,
                // color: Colors.red,
                // height: size.height,
                margin: const EdgeInsets.only(top: 10),
                child: FutureBuilder<List>(
                    future: _loader,
                    builder: (context, snapshot) {
                      final _shopDetail = snapshot.data;
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: fPrimaryColour,
                          ),
                        );
                      }

                      if (_shopDetail!.isEmpty)
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Oops.. No such data",
                                style: TextStyle(color: fPrimaryColour),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        );

                      // if (snapshot.hasData)
                      return Column(
                        children: [
                          Text(
                            "Click to update",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                              physics: ScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _shopDetail.length,
                              itemBuilder: (ctx, i) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      // Container(
                                      //   height: 160,
                                      //   decoration: BoxDecoration(),
                                      // ),
                                      ListTile(
                                        leading: Text((i + 1).toString()),
                                        title: Text(_shopDetail[i]["species"]
                                            .toString()),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            color: fPrimaryColour),
                                        onTap: () {
                                          regSP?.setString(
                                              'tdSpecies',
                                              _shopDetail[i]["species"]
                                                  .toString());

                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    UpdateSeedlingVisit(
                                                      name: widget.name,
                                                      contact: widget.contact,
                                                      speciesID: _shopDetail[i]
                                                              ["farmerid"]
                                                          .toString(),
                                                    )),
                                          );
                                        },
                                      ),
                                      // Divider(
                                      //   thickness: 2.0,
                                      // )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      );
                    }),
              ),
            ),
            SizedBox(
              height: size.height * .1,
            ),
            // SizedBox(
            //   height: 40.0,
            // )
          ],
        ),
      );
}
