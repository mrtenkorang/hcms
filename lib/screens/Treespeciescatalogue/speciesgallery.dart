import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/models/apimodels/getspeciesgallery.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

class SpeciesGallery extends StatefulWidget {
  const SpeciesGallery({Key? key}) : super(key: key);

  @override
  State<SpeciesGallery> createState() => _SpeciesGalleryState();
}

class _SpeciesGalleryState extends State<SpeciesGallery> {
  ScrollController _scrollController = new ScrollController();

  var rest;
  var filteredList;

  int loaderpage = 1;

  Future<List>? _asyncGetSpeciesGallery(BuildContext ctx) async {
    // _submissionLoading("Requesting new token");

    String newVibe = "";
    String error = "";

    final Uri getdetailsurl = Uri.parse("$stageBaseUrl/treespecieslist/");

    try {
      var header = {"Accept": "application/json"};

      // var sendbody = jsonEncode(body);
      var res = await http.get(getdetailsurl, headers: header);

      print(res.statusCode);
      print(res.body);
      try {
        final itemss = json.decode(res.body);
        // print(itemss["message"]);
        newVibe = itemss["message"];
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

    _loader = _asyncGetSpeciesGallery(
      this.context,
    );

    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          // _getAppointmentsFuture =
          _asyncGetSpeciesGallery(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Tree Species",
          style: TextStyle(color: fPrimaryWhite),
        ),
      ),
      body: grid(size),
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

                      if (!snapshot.hasData)
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
                      if (snapshot.hasData)
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: .6),
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(8.0),
                            itemCount: _shopDetail?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  // height: 700,
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _shopDetail?[index]["image"]
                                                        .isNotEmpty
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 15),
                                                        height:
                                                            size.height * 0.12,
                                                        width: size.width * 0.5,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    "http://${_shopDetail?[index]["image"].toString()}"),
                                                                fit: BoxFit
                                                                    .cover,
                                                                scale: 5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      )
                                                    : Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 15),
                                                        height:
                                                            size.height * 0.17,
                                                        width: size.width * 0.5,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "lib/libassets/logos/hcmslogo.png"),
                                                                fit: BoxFit
                                                                    .cover,
                                                                scale: 5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                              ]),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              _shopDetail![index]["species"]
                                                  .toString(),
                                              textAlign: TextAlign.justify,
                                            ),
                                          )
                                        ],
                                      ),
                                      onTapUp: (t) {
                                        return popOutImage(
                                            _shopDetail[index]["species"]
                                                .toString(),
                                            "http://${_shopDetail?[index]["image"].toString()}",
                                            size);
                                      }));
                            });

                      throw "exception caught here";
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

  popOutImage(speciesName, speciesImage, size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: fPrimaryWhite),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: AlertDialog(
                      title: Text("Species: " + speciesName),
                      content: Container(
                        // margin: const EdgeInsets.only(right: 1),
                        height: size.height * 0.6,
                        width: size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(speciesImage),
                                fit: BoxFit.cover,
                                scale: 5),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.all(10.0)),
                ),
                Container(
                  // height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFd81a60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(color: fPrimaryWhite),
                        // shadowColor: fPrimaryColour,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Icon(
                          //   Icons.arrow_back_ios_new_sharp,
                          //   color: Color(0xFFFFFFFF),
                          // ),
                          Text(
                            "Dismiss",
                            style: TextStyle(color: fPrimaryWhite),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          );
        });
  }
}
