import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/providers/deforestationprovider.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/declaration.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/dropdowns/community_selector.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/datamodels.dart';
import 'package:hcms_revived2/services/locationservice.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class DeforestationQuestions extends StatefulWidget {
  final String? pageTitle;

  const DeforestationQuestions({Key? key, this.pageTitle}) : super(key: key);
  @override
  _DeforestationQuestionsState createState() => _DeforestationQuestionsState();
}

class _DeforestationQuestionsState extends State<DeforestationQuestions> {
  final _formKey = GlobalKey<FormState>();

  int? enumeratorvalue;

  Future<dynamic> getEnumeratorValue(String? table) async {
    final db = await DBHelper.database();
    var count =
        await db.rawQuery('SELECT enumeratorValue FROM first_time_user');

    var list = count.toList();

    setState(() {
      enumeratorvalue = int.parse(list[0]['enumeratorValue'].toString());
    });
    print("Enummem - $enumeratorvalue");

    return db;
  }

  void _submissionLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Container(
              // width: 5000,
              child: const AlertDialog(
                title: Text(
                  "Reporting Deforestation",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    ),
                    Text(
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

  File? commjsonFile;
  Directory? dir;
  String commfileName = "community.json";
  bool commfileExists = false;
  var commfileContent;
  // bool confileContent = false;
  List<CommunityJson> _newcommValues = [];
  List<CommunityJson> _commValues = [];

  final _pn = TextEditingController();
  final _species = TextEditingController();
  final _whyAction = TextEditingController();
  final _communityName = TextEditingController();

  String? _gfwDirection;
  int? selectedGFWRadio;

  String? _seeDeforestation;
  int? selectedSeeDeforestationRadio;

  String? _actionRequired;
  int? selectedActionRequiredRadio;

  bool _isBBChecked = false;
  bool _isMChecked = false;
  bool _isLChecked = false;
  bool _isCPChecked = false;
  // bool _isCPChecked = false;
  bool _isOchecked = false;

  int index = 0;

  String? p_nValue;
  List<String> p_nValues = [];

  bool sort = false;

  String? _community;
  int? _communityVal;

  File? _pickedImage;
  String _speciesbase64Image = "";

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  PlaceLocation? _pickedLocation;

  void createCommFile(var content, Directory dir, String fileName) {
    print("Creating Community file!");
    File file = File("${dir.path}/$fileName");
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<CommunityJson>> getLocalCommValues(BuildContext context) async {
    print("doing clocal comm");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/community.json');
    final body = json.decode(data);

    _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();

    return _newcommValues;
  }

  var commUrl = "$stageBaseUrl/communityapi/";

  Future<List<CommunityJson>> writeToCommFile(BuildContext ctx) async {
    print("Writing to community file! $commfileExists");
    if (commfileExists) {
      print("Community File exists $commfileExists");

      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Community");

          print("content $items");
          print("object");

          // var content = {key: items};

          var commjsonFileContent =
              await json.decode(await commjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile?.writeAsString(json.encode(commjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is first community");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      debugPrint("Community File does not exist! $commfileExists");
      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Community");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createCommFile(items, dir!, commfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
          getLocalCommValues(ctx);
        }
      } on SocketException {
        debugPrint("Error is second comm");
        getLocalCommValues(ctx);
      }
    }
    commfileExists
        ? commfileContent =
            await json.decode(await commjsonFile!.readAsString())
        : null;
    debugPrint(commfileContent.toString());

    return commfileExists
        ? _commValues =
            commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList()
        : _commValues = _newcommValues;
  }

  commFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      commjsonFile = File("${dir!.path}/$commfileName");
      commfileExists = commjsonFile!.existsSync();
      if (commfileExists) {
        commfileContent = await json.decode(await commjsonFile!.readAsString());
      }
    });

    return commfileContent;
  }

  void _oncommChanged(String commVal) {
    setState(() {
      _community = commVal;
    });
  }

  void _selectLatLng(double lat, double lng, double alt, double acc) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      altitude: alt,
      accuracy: acc,
    );
  }

  // List<String> _specFound;
  bool boxChecked = false;

  // oncSelectedRow(bool selected, String selectedEst) async {
  //   setState(() {
  //     if (selected) {
  //       _commFound.add(selectedEst);
  //     } else {
  //       _commFound.remove(selectedEst);
  //     }
  //   });
  // }

  void _onComChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  List<String> _deforestationCause = [];
  onSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _deforestationCause.add(selectedEst);
      } else {
        _deforestationCause.remove(selectedEst);
      }
    });
  }

  void _onBBChanged(bool val) {
    setState(() {
      _isBBChecked = val;
      onSelectedRow(val, "Bush_Burning");
    });
  }

  void _onMChanged(bool val) {
    setState(() {
      _isMChecked = val;
      onSelectedRow(val, "Mining");
    });
  }

  void _onOChanged(bool val) {
    setState(() {
      _isOchecked = val;
      onSelectedRow(val, "Other");
    });
  }

  void _onLChanged(bool val) {
    setState(() {
      _isLChecked = val;
      onSelectedRow(val, "Logging");
    });
  }

  void _onFChanged(bool val) {
    setState(() {
      _isCPChecked = val;
      onSelectedRow(val, "Farming");
    });
  }

  void _onCPChanged(bool val) {
    setState(() {
      _isCPChecked = val;
      onSelectedRow(val, "Charcoal");
    });
  }

  getspeciesbase64Img() async {
    _speciesbase64Image = regSP?.getString('speciesbase64Image') ?? "";
    _communityVal = int.tryParse(regSP?.getString("communitycode") ?? "0");
  }

  Future<List<CommunityJson>>? myCFuture;

  @override
  void initState() {
    super.initState();
    selectedGFWRadio = 0;
    selectedSeeDeforestationRadio = 0;

    commFileInit();

    myCFuture = writeToCommFile(this.context);

    p_nValues.addAll([
      "Planted",
      "Natural",
    ]);

    _deforestationCause = [];
  }

  setGFWSelectedRadio(val) {
    setState(() {
      selectedGFWRadio = val;
    });
  }

  setDeforestationSelectedRadio(val) {
    setState(() {
      selectedSeeDeforestationRadio = val;
    });
  }

  void _onPNChanged(String? iTValue) {
    setState(() {
      p_nValue = iTValue;
    });
  }

  var _lat, _lng, _acc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColour,
      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: const Text(
      //     "Deforestation Information",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: const Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == Constants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => const IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.load) {
      //           writeToCommFile(context);

      //           Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => this.widget));
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return Constants.exceptiondownChoices.map((String _downChoice) {
      //           return PopupMenuItem<String>(
      //             value: _downChoice,
      //             child: Container(
      //               margin: const EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: const TextStyle(color: Color(0xFFFFFFFF)),
      //               ),
      //             ),
      //           );
      //         }).toList();
      //       },
      //     ),
      //   ],
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  elevation: 0.0,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: primaryColour,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: primaryWhite,
                        size: 40.0,
                      )),
                ),
                Text(
                  "Deforestation".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                PopupMenuButton<String>(
                  offset: const Offset(2.00, 3.00),
                  color: Colors.black,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: primaryWhite,
                    size: 40.0,
                  ),
                  onSelected: (String _downChoice) {
                    if (_downChoice == Constants.home) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      );
                    } else if (_downChoice == Constants.load) {
                      writeToCommFile(context);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => this.widget));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.exceptiondownChoices
                        .map((String _downChoice) {
                      return PopupMenuItem<String>(
                        value: _downChoice,
                        child: Container(
                          margin: const EdgeInsets.only(right: 0),
                          child: Text(
                            _downChoice,
                            style: const TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .83,
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NewLocationService(
                          onSelectLatLng: _selectLatLng,
                          // show: true,
                        ),
                        _lng != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // width: 100,
                                    child: const Text(
                                      // 'location: ',
                                      'Picked longitude: ',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    // width: 70.00,
                                    child: Text(
                                      "$_lng",
                                      style: const TextStyle(
                                          color: fPrimaryColour),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        _lat != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // width: 100,
                                    child: const Text(
                                      // 'location: ',
                                      'Picked latitude: ',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    // width: 70.00,
                                    child: Text(
                                      "$_lat",
                                      style: const TextStyle(
                                          color: fPrimaryColour),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            // width: 170.0,
                            padding: const EdgeInsets.all(5.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    // color: Color(0xFFFFFFFF),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 10.0,
                                            right: .0,
                                            bottom: 18.0,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: const EdgeInsets.only(
                                              //         bottom: 14.0,
                                              //       ),
                                              //       child: const Row(
                                              //         children: <Widget>[
                                              //           Text(
                                              //               "Name of Community (Please use previous)."),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              formFieldLabel(width: size.width * .9, 
                                                  "Name of Community (Please use previous)."),

                                              // const CommunitySelector(),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceBetween,
                                              //   children: <Widget>[
                                              //     Container(
                                              //       decoration: BoxDecoration(
                                              //           border: Border.all(
                                              //               width: 0.50,
                                              //               color: const Color(
                                              //                   0xFF000000)),
                                              //           borderRadius:
                                              //               const BorderRadius
                                              //                   .all(
                                              //                   Radius.circular(
                                              //                       10.0))),
                                              //       // width: MediaQuery.of(context)
                                              //       //         .size
                                              //       //         .width /
                                              //       //     1.09,
                                              //       padding:
                                              //           const EdgeInsets.all(
                                              //               6.0),
                                              //       child: FutureBuilder<
                                              //           List<CommunityJson>>(
                                              //         future: myCFuture,
                                              //         builder: (context,
                                              //             AsyncSnapshot<
                                              //                     List<
                                              //                         CommunityJson>>
                                              //                 snapshot) {
                                              //           if (snapshot
                                              //                   .connectionState !=
                                              //               ConnectionState
                                              //                   .done) {
                                              //             return const CircularProgressIndicator(
                                              //               valueColor:
                                              //                   AlwaysStoppedAnimation<
                                              //                           Color>(
                                              //                       fPrimaryColour),
                                              //             );
                                              //           } else if (!snapshot
                                              //               .hasData) {
                                              //             return const Text(
                                              //                 "No data. Please try again.",
                                              //                 softWrap: true,
                                              //                 overflow:
                                              //                     TextOverflow
                                              //                         .clip,
                                              //                 style: TextStyle(
                                              //                     color:
                                              //                         primaryError));
                                              //           } else if (snapshot
                                              //               .hasError) {
                                              //             debugPrint(
                                              //                 "here here 2 list working");
                                              //             return const Text(
                                              //                 "Error. Sync to get data.",
                                              //                 style: TextStyle(
                                              //                     color:
                                              //                         fBackgroundColour));
                                              //           } else if (snapshot
                                              //               .hasData) {
                                              //             debugPrint(
                                              //                 "here here list working");
                                              //             return commfileExists
                                              //                 ? Container(
                                              //                     // width: MediaQuery.of(context).size.width / 1.09,
                                              //                     child: StatefulBuilder(
                                              //                         builder:
                                              //                             (context,
                                              //                                 state) {
                                              //                       return DropdownButtonHideUnderline(
                                              //                         child: DropdownButton<
                                              //                             String>(
                                              //                           value:
                                              //                               _community,
                                              //                           items: _commValues.map((CommunityJson
                                              //                               dvalue) {
                                              //                             // fD = dvalue;
                                              //                             return DropdownMenuItem<
                                              //                                 String>(
                                              //                               value:
                                              //                                   dvalue.name,
                                              //                               child:
                                              //                                   Row(
                                              //                                 children: <Widget>[
                                              //                                   Padding(
                                              //                                     padding: const EdgeInsets.all(10.0),
                                              //                                     child: Text(
                                              //                                       "${dvalue.name}",
                                              //                                     ),
                                              //                                   )
                                              //                                 ],
                                              //                               ),
                                              //                             );
                                              //                           }).toList(),
                                              //                           onChanged:
                                              //                               (String?
                                              //                                   value) {
                                              //                             _community =
                                              //                                 value;
                                              //                             _oncommChanged(
                                              //                                 value!);

                                              //                             print(
                                              //                                 "Community"
                                              //                                 "$_community");

                                              //                             _commValues.map((CommunityJson
                                              //                                 ccvalue) {
                                              //                               if (ccvalue.name ==
                                              //                                   value) {
                                              //                                 print(ccvalue.comcode);

                                              //                                 setState(() {
                                              //                                   _communityVal = ccvalue.comcode;

                                              //                                   // opdagSP.setString(
                                              //                                   //     'corptown',
                                              //                                   //     _communityValue);

                                              //                                   print("Com COm COm $_communityVal");

                                              //                                   // opdagSP.setString(
                                              //                                   //     'communityvalue',
                                              //                                   //     _communityValue);
                                              //                                 });
                                              //                               }
                                              //                             }).toString();
                                              //                           },
                                              //                         ),
                                              //                       );
                                              //                     }),
                                              //                   )
                                              //                 : Container(
                                              //                     width: MediaQuery.of(
                                              //                                 context)
                                              //                             .size
                                              //                             .width /
                                              //                         1.09,
                                              //                     child: StatefulBuilder(
                                              //                         builder:
                                              //                             (context,
                                              //                                 state) {
                                              //                       return DropdownButtonHideUnderline(
                                              //                         child: DropdownButton<
                                              //                             String>(
                                              //                           value:
                                              //                               _community,
                                              //                           items: _newcommValues.map((CommunityJson
                                              //                               dvalue) {
                                              //                             // fD = dvalue;
                                              //                             return DropdownMenuItem<
                                              //                                 String>(
                                              //                               value:
                                              //                                   dvalue.name,
                                              //                               child:
                                              //                                   Row(
                                              //                                 children: <Widget>[
                                              //                                   Padding(
                                              //                                     padding: const EdgeInsets.all(10.0),
                                              //                                     child: Text(
                                              //                                       "${dvalue.name}",
                                              //                                     ),
                                              //                                   )
                                              //                                 ],
                                              //                               ),
                                              //                             );
                                              //                           }).toList(),
                                              //                           onChanged:
                                              //                               (String?
                                              //                                   value) {
                                              //                             _community =
                                              //                                 value;
                                              //                             _oncommChanged(
                                              //                                 value!);

                                              //                             print(
                                              //                                 "Community"
                                              //                                 "$_community");

                                              //                             _newcommValues.map((CommunityJson
                                              //                                 ccvalue) {
                                              //                               if (ccvalue.name ==
                                              //                                   value) {
                                              //                                 print(ccvalue.comcode);

                                              //                                 setState(() {
                                              //                                   _communityVal = ccvalue.comcode;

                                              //                                   // opdagSP.setString(
                                              //                                   //     'corptown',
                                              //                                   //     _communityValue);

                                              //                                   print("Com COm COm $_communityVal");

                                              //                                   // opdagSP.setString(
                                              //                                   //     'communityvalue',
                                              //                                   //     _communityValue);
                                              //                                 });
                                              //                               }
                                              //                             }).toString();
                                              //                           },
                                              //                         ),
                                              //                       );
                                              //                     }),
                                              //                   );
                                              //           } else {
                                              //             return const Text(
                                              //               "Please sync data",
                                              //             );
                                              //           }
                                              //         },
                                              //       ),
                                              //     ),
                                              //     IconButton(
                                              //       icon: const Icon(
                                              //           Icons.replay),
                                              //       onPressed: () async {
                                              //         setState(() {
                                              //           myCFuture =
                                              //               writeToCommFile(
                                              //                   this.context);
                                              //         });
                                              //       },
                                              //     )
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(0.0),
                                        //       child: SizedBox(
                                        //         width: MediaQuery.of(context)
                                        //                 .size
                                        //                 .width *
                                        //             .8,
                                        //         child: const Text(
                                        //           "Were you directed to the place by Global Forest Watch (GFW)?",
                                        //           softWrap: true,
                                        //           overflow: TextOverflow.clip,
                                        //           style: TextStyle(
                                        //             color: Colors.black,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, 
                                            "Were you directed to the place by Global Forest Watch (GFW)?"),
                                        // ButtonBar(
                                        //   alignment: MainAxisAlignment.start,
                                        //   children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 1,
                                              group: selectedGFWRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedGFWRadio = val;
                                                  _gfwDirection = "yes";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Yes",
                                              // style: TextStyle(
                                              //     color: Color(0xFFf9f9f9)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 2,
                                              group: selectedGFWRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedGFWRadio = val;
                                                  _gfwDirection = "no";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "No",
                                              // style: TextStyle(
                                              //     color:
                                              //         Color(0xFFf9f9f9))
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //   ],
                                    // ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // const Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: EdgeInsets.all(0.0),
                                        //       child: Text(
                                        //         "Do you see deforestation?",
                                        //         style: TextStyle(
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // ButtonBar(
                                        //   alignment: MainAxisAlignment.start,
                                        // children: <Widget>[
                                        formFieldLabel(width: size.width * .9, 
                                            "Do you see deforestation?"),
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 1,
                                              group:
                                                  selectedSeeDeforestationRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedSeeDeforestationRadio =
                                                      val;
                                                  _seeDeforestation = "yes";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Yes",
                                              // style: TextStyle(
                                              //     color: Color(0xFFf9f9f9)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 2,
                                              group:
                                                  selectedSeeDeforestationRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedSeeDeforestationRadio =
                                                      val;
                                                  _seeDeforestation = "no";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "No",
                                              // style: TextStyle(
                                              //     color:
                                              //         Color(0xFFf9f9f9))
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 3,
                                              group:
                                                  selectedSeeDeforestationRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedSeeDeforestationRadio =
                                                      val;
                                                  _seeDeforestation = "unsure";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Unsure",
                                              // style: TextStyle(
                                              //     color:
                                              //         Color(0xFFf9f9f9))
                                            ),
                                          ],
                                        ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  _seeDeforestation == "yes"
                                      ? Container(
                                          margin: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: const EdgeInsets.only(
                                              //         bottom: 14.0,
                                              //       ),
                                              //       child: const Row(
                                              //         children: <Widget>[
                                              //           Text(
                                              //               "What is the cause of the deforestation?"),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              formFieldLabel(width: size.width * .9, 
                                                  "What is the cause of the deforestation?"),
                                              CheckboxListTile(
                                                title: const Text(
                                                  "Bush Burning",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                value: _isBBChecked,
                                                activeColor: fPrimaryColour,
                                                onChanged: (bool? value) {
                                                  _onBBChanged(value!);
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  "Mining",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                value: _isMChecked,
                                                activeColor: fPrimaryColour,
                                                onChanged: (bool? value) {
                                                  _onMChanged(value!);
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  "Logging",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                value: _isLChecked,
                                                activeColor: fPrimaryColour,
                                                onChanged: (bool? value) {
                                                  _onLChanged(value!);
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  "Farming",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                value: _isCPChecked,
                                                activeColor: fPrimaryColour,
                                                onChanged: (bool? value) {
                                                  _onFChanged(value!);
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  "Charcoal Production",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                value: _isCPChecked,
                                                activeColor: fPrimaryColour,
                                                onChanged: (bool? value) {
                                                  _onCPChanged(value!);
                                                },
                                              ),
                                              Column(
                                                children: [
                                                  CheckboxListTile(
                                                    title: const Text(
                                                      "Other",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    value: _isOchecked,
                                                    activeColor: fPrimaryColour,
                                                    onChanged: (bool? value) {
                                                      _onOChanged(value!);
                                                    },
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10.0,
                                                            bottom: 8.0),
                                                    child: TextFieldWidget(
                                                      readonly:
                                                          _isOchecked == true
                                                              ? false
                                                              : true,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "(Specify)",
                                                        hintStyle: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                      controller:
                                                          TextEditingController(),
                                                      validator: (input) =>
                                                          _deforestationCause
                                                                  .contains(
                                                                      "Other")
                                                              ? input!
                                                                      .trim()
                                                                      .isEmpty
                                                                  ? 'Please specify type of establishment'
                                                                  : null
                                                              : null,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // const Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: EdgeInsets.all(0.0),
                                        //       child: Text(
                                        //         "Do you think further action should be taken?",
                                        //         style: TextStyle(
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, 
                                            "Do you think further action should be taken?"),
                                        // ButtonBar(
                                        //   alignment: MainAxisAlignment.start,
                                        //   children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 1,
                                              group:
                                                  selectedActionRequiredRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedActionRequiredRadio =
                                                      val;
                                                  _actionRequired = "yes";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Yes",
                                              // style: TextStyle(
                                              //     color: Color(0xFFf9f9f9)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            GenderRadioButton(
                                              value: 2,
                                              group:
                                                  selectedActionRequiredRadio,
                                              selected: (val) {
                                                print(val);
                                                setState(() {
                                                  selectedActionRequiredRadio =
                                                      val;
                                                  _actionRequired = "no";
                                                });
                                              },
                                            ),
                                            const Text(
                                              "No",
                                              // style: TextStyle(
                                              //     color:
                                              //         Color(0xFFf9f9f9))
                                            ),
                                          ],
                                        ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  _actionRequired == "yes"
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //         top: 0.0,
                                              //       ),
                                              //       child: Row(
                                              //         children: <Widget>[
                                              //           Text("Why?"),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              formFieldLabel(width: size.width * .9, "Why?"),
                                              TextFieldWidget(
                                                // maxLines: 5,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: const InputDecoration(
                                                    labelText: '',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        0.5)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0))),
                                                controller: _whyAction,
                                                validator: (input) =>
                                                    input!.trim().isEmpty
                                                        ? 'Please enter a value'
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // const Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //       padding: EdgeInsets.all(0.0),
                                        //       child: Text(
                                        //         "Take picture of area",
                                        //         style: TextStyle(
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        formFieldLabel(width: size.width * .9, "Take picture of area"),
                                        Row(
                                          children: [
                                            SpeciesImage(_selectedImage),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // RaisedButton(
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(15.0),
                                        //   ),
                                        //   textColor: Colors.white,
                                        //   color: fPrimaryColour,
                                        //   child: Text("Pick Cordinates"),
                                        //   onPressed: () async {
                                        //     if (_pickedLocation != null) {
                                        //       print(
                                        //           "Picked is ${_pickedLocation?.latitude}");
                                        //       print(
                                        //           "Picked is ${_pickedLocation?.longitude}");
                                        //       setState(() {
                                        //         _lat = _pickedLocation?.latitude;
                                        //         _lng = _pickedLocation?.longitude;
                                        //         _acc = _pickedLocation?.accuracy;
                                        //       });
                                        //       overlayNotification(
                                        //           'Cordinates saved!', "positive",
                                        //           position: NotificationPosition.top);
                                        //     } else {
                                        //       overlayNotification(
                                        //           'GPS Accuracy must be 5m or below!',
                                        //           "negative");
                                        //     }
                                        //   },
                                        // ),

                                        // _pickedLocation != null ?
                                        // {setState(() {
                                        //         _lat = _pickedLocation?.latitude;
                                        //         _lng = _pickedLocation?.longitude;
                                        //         _acc = _pickedLocation?.accuracy;
                                        //       });} : SizedBox(),

                                        SizedBox(
                                          height: 10,
                                          // child: Divider(),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // new TextButton(
                      //   onPressed: () async {
                      //     getspeciesbase64Img();

                      //     if (!boxChecked && _community == null) {
                      //       overlayNotification(
                      //           'Please select a community', "negative");
                      //     } else if (_speciesbase64Image.isEmpty) {
                      //       overlayNotification(
                      //           'Please take picture of species', "negative");
                      //     } else if (_lat == null && _lng == null) {
                      //       overlayNotification('Please pick cordinates', "negative");
                      //     } else if (_formKey.currentState!.validate()) {
                      //       Timer(
                      //         Duration(seconds: 1),
                      //         () {
                      //           setState(() {
                      //             _lat = null;
                      //             _lng = null;
                      //           });
                      //         },
                      //       );
                      //     }
                      //   },
                      //   child: new Icon(
                      //     Icons.add,
                      //     color: fPrimaryColour,
                      //     size: 40,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50.00,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              elevation: 0.0,
                              backgroundColor: fPrimaryColour,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              textStyle: const TextStyle(color: Colors.white),
                              // shadowColor: fPrimaryColour,
                              side: const BorderSide(
                                  width: 1.0, color: fPrimaryColour),
                            ),
                            child: const Text(
                              "Report",
                              style: TextStyle(
                                  color: fPrimaryWhite,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () async {
                              await getspeciesbase64Img();

                              if (_communityVal == null) {
                                overlayNotification(
                                    'Please select a community', "negative");
                              } else if (_speciesbase64Image.isEmpty) {
                                overlayNotification(
                                    'Please take picture of area', "negative");
                              } else if (_pickedLocation == null) {
                                overlayNotification(
                                    'GPS accuracy must be 5m or lower',
                                    "negative");
                              } else if (_formKey.currentState!.validate()) {
                                submissionOptions(
                                  context,
                                  "Do you have internet data?",
                                  "Send with internet",
                                  "Send later",
                                  "Cancel",
                                  approvePress: () => attemptSignup(context),
                                  editPress: () {
                                    Navigator.pop(context);
                                    saveToLocalDB("not connected");
                                    overlayNotification(
                                        'Successfully saved. Please go to "View Reports" to send data',
                                        "negative");
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const IndexPage(),
                                      ),
                                    );
                                    regSP?.clear();
                                  },
                                  disapprovePress: () => null,
                                );
                                Timer(
                                  const Duration(seconds: 1),
                                  () {
                                    setState(() {
                                      _lat = null;
                                      _lng = null;
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveToLocalDB(String? con) {
    // this saves the entire record being sent
    Provider.of<DeforestationProvider>(context, listen: false).addDeforestation(
      _communityVal.toString(),
      _gfwDirection ?? '',
      _seeDeforestation ?? "",
      json.encode(_deforestationCause),
      _actionRequired ?? "",
      _whyAction.text,
      _pickedLocation?.latitude.toString() ?? "",
      _pickedLocation?.longitude.toString() ?? "",
      _speciesbase64Image,
      con.toString(),
    );
    print("Successfully saved to local DB");
  }

  attemptSignup(BuildContext ctx) async {
    _submissionLoading();
    getEnumeratorValue('first_time_user');

    overlayNotification('Data uploading... Please wait.', "positive");
    try {
      var deforestationdata = {
        "community": _communityVal,
        "directed_by_gfw": _gfwDirection,
        "do_u_see_deforestation": _seeDeforestation,
        "cause_deforestation": _deforestationCause
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "further_action_taken": _actionRequired,
        "reason_further_action_taken": _whyAction.text,
        "latitude": _pickedLocation?.latitude,
        "longitude": _pickedLocation?.longitude,
        "photos": _speciesbase64Image
      };

      var url = '$stageBaseUrl/deforestationapi/';

      var body = json.encode(deforestationdata);

//here jsonEncode(data) return String? bt in http body you are passing Map value

//So you have to convert String? to Map
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
        saveToLocalDB("connected");
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const IndexPage(),
          ),
        );
        // return res.statusCode;
      } else if (status == "exist") {
        overlayNotification('Data already: $status.', "positive");
        Navigator.pop(context);
      } else {
        overlayNotification(
            'Error occured with error: ${itemss.toString()}', "negative");
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      saveToLocalDB("not connected");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again from "View Reports".',
          "negative");
      regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const IndexPage(),
        ),
      );
    } catch (i) {
      print("i ===> ${i.toString()}");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }
}
