import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/farmerlistmodel.dart';
import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/components/participantsModel.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TrainingParticipantDetails extends StatefulWidget {
  final String? pageTitle;
  final int? comVal;

  const TrainingParticipantDetails({Key? key, this.pageTitle, this.comVal})
      : super(key: key);
  @override
  _TrainingParticipantDetailsState createState() =>
      new _TrainingParticipantDetailsState();
}

class _TrainingParticipantDetailsState
    extends State<TrainingParticipantDetails> {
  final _formKey = GlobalKey<FormState>();

  List<ParticipantsModelArray> items = [];
  List<ParticipantsModelArray> selectedPoints = [];
  String? _encodedKeep;

  String? _communityName;
  int? _communityId;
  String? _topic;
  String? _durHours;
  String? _durMins;
  String? _trainerName;
  String? _trainerOrg;
  String? _eventDate;

  int? _communityVal;

  final _farmerName = TextEditingController();
  // final _community = TextEditingController();
  final _phoneNum = TextEditingController();
  bool sort = false;

  String? _gender;
  String? _farmerGender;
  int? selectedFarmerRadioGender;

  String? _thumbSig;
  File? _farmerSig;

  void _farmerSign(File pickedImage) {
    _farmerSig = pickedImage;
  }

  void setTDValues() async {
    await regSP?.setString("c2treeplantationDetail", _encodedKeep!);
    print("Reg 2 shared preference worked");
  }

  convertu() {
    final String encodedData = ParticipantsModelArray.encode(items);
    _encodedKeep = encodedData;
    final List<ParticipantsModelArray> decodedData =
        ParticipantsModelArray.decode(encodedData);

    setTDValues();
    print("Items Plantation data $items");
    print("Decoded Plantation data $decodedData");
  }

  onSelectedRow(bool selected, ParticipantsModelArray user) async {
    setState(() {
      if (selected) {
        selectedPoints.add(user);
      } else {
        selectedPoints.remove(user);
      }
    });
  }

  void getTLValues() async {
    _thumbSig = (regSP?.getString('base64signature') ?? "");

    _communityId = (regSP?.getInt("tLcommunityValue") ?? null);
    _communityName = (regSP?.getString('tLComName') ?? "");
    _topic = (regSP?.getString('tLTopic') ?? "");
    _durHours = (regSP?.getString('tLDurationHour') ?? "");
    _durMins = (regSP?.getString('tLDurationMins') ?? "");
    _trainerName = (regSP?.getString('tLTrainerName') ?? "");
    _trainerOrg = (regSP?.getString('tLTrainerOrg') ?? "");
    _eventDate = (regSP?.getString('tLVisitDate') ?? "");
    print("Getting worked shared preference worked");
  }

  deleteSelected() async {
    print("Delete working now");
    submissionOptions(
        context, "Are you sure you want to delete?", "Yes", "", "No",
        approvePress: () {
      setState(() {
        if (selectedPoints.isNotEmpty) {
          List<ParticipantsModelArray> temp = [];
          temp.addAll(selectedPoints);
          for (ParticipantsModelArray points in temp) {
            items.remove(points);
            selectedPoints.remove(points);
          }
        }
      });
    }, editPress: () {}, disapprovePress: () {});
  }

  _onDone() {
    convertu();
  }

  int? enumeratorvalue;

  Future<dynamic> getEnumeratorValue(String table) async {
    final db = await DBHelper.database();
    var count =
        await db.rawQuery('SELECT enumeratorValue FROM first_time_user');

    var list = count.toList();

    setState(() {
      enumeratorvalue = int.parse(list[0]['enumeratorValue'].toString());
    });
    print("Enummem - $enumeratorvalue");
  }

  void saveToLocalDB(String con) {
    Provider.of<TrainingLogProvider>(context, listen: false).addTrainingLog(
      _communityId.toString(),
      _topic!,
      _eventDate!,
      _durHours! + " hours : " + _durMins! + " minutes",
      _trainerName!,
      _trainerOrg!,
      enumeratorvalue.toString(),
      _encodedKeep!,
      con,
    );

    print("Successfully saved Training Log to local DB");
  }

  attemptSignup(BuildContext ctx) async {
    getTLValues();
    submissionLoader(ctx, "Uploading data", "Please wait a minute...");
    getEnumeratorValue('first_time_user');

    final String encodedData = ParticipantsModelArray.encode(items);

    final participantDetails = items.isNotEmpty
        ? json.decode(encodedData).cast<Map<String, dynamic>>()
        : Map();

    final List<ParticipantsModelArray> decodedData =
        ParticipantsModelArray.decode(encodedData);

    print("Part part $participantDetails");
    overlayNotification('Data uploading... Please wait.', "positive");

    try {
      var trainingLog = {
        "trainingDetails": {
          "communityName": _communityId,
          "trainingTopic": _topic,
          "dateEventBegan": _eventDate,
          "eventDuration": _durHours! + " hours : " + _durMins! + " minutes",
          "trainerName": _trainerName,
          "trainerOrganisation": _trainerOrg,
          "enumerator": enumeratorvalue
        },
        "participantDetails": participantDetails
      };

      var url = '$stageBaseUrl/trainingapi/';

      var body = json.encode(trainingLog);

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

      print("Body $body");
      print(itemss);
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "done") {
        saveToLocalDB("connected");
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => TreeMonitoringDecider(),
          ),
        );
        // return res.statusCode;
      } else if (status == "exist") {
        overlayNotification('Data already: $status.', "positive");

        Navigator.pop(context);
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      saveToLocalDB("not connected");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again from "View Monitoring Data".',
          "negative");

      regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TreeMonitoringDecider(),
        ),
      );
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  File? farmerjsonFile;
  // File regionjsonFile;
  Directory? dir;
  String farmerfileName = "farmerlist.json";
  bool farmerfileExists = false;
  var farmerfileContent;
  List<FarmerListJson> _newfarmerValues = [];
  List<FarmerListJson> _farmerValues = [];

  void createFarmerListFile(var content, Directory dir, String fileName) {
    print("Creating Farmer file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    farmerfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<FarmerListJson>> writeToFarmerListFile(
      BuildContext ctx, val) async {
    var farmerlistUrl = "$stageBaseUrl/farmerlist/?community=$val";

    print("Writing to Farmer file! $farmerfileExists");
    if (farmerfileExists) {
      print("Farmer File exists $farmerfileExists");

      try {
        var response = await http.get(Uri.parse(farmerlistUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Farmer");

          print("content $items");
          print("object");

          // var content = {key: items};

          var commjsonFileContent =
              await json.decode(await farmerjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          farmerjsonFile!.writeAsString(json.encode(commjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is first Farmer");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("Farmer File does not exist! $farmerfileExists");
      try {
        var response = await http.get(Uri.parse(farmerlistUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Farmer");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          createFarmerListFile(items, dir!, farmerfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          // getLocalCommValues(ctx);
        }
      } on SocketException {
        print("Error is second comm");
        // getLocalCommValues(ctx);
      }
    }
    farmerfileExists
        ? farmerfileContent =
            await json.decode(await farmerjsonFile!.readAsString())
        : null;
    print(farmerfileContent);

    return farmerfileExists
        ? _farmerValues = farmerfileContent
            .map<FarmerListJson>(FarmerListJson.fromJson)
            .toList()
        : _newfarmerValues;
  }

  // Future<List<FarmerListJson>> getLocalCommValues(BuildContext context) async {
  //   print("doing clocal comm");
  //   final assetBundle = DefaultAssetBundle.of(context);
  //   final data = await assetBundle.loadString('assets/Farmer.json');
  //   final body = json.decode(data);

  //   _newfarmerValues = body.map<FarmerListJson>(FarmerListJson.fromJson).toList();

  //   return _newfarmerValues;
  // }

  String? _ffarmerlist;

  void _onfarmerlistChanged(String farmerListVal) {
    setState(() {
      _ffarmerlist = farmerListVal;
    });
  }

   farmerFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      farmerjsonFile = new File(dir!.path + "/" + farmerfileName);
      farmerfileExists = farmerjsonFile!.existsSync();
      if (farmerfileExists)
        farmerfileContent =
            await json.decode(await farmerjsonFile!.readAsString());
    });

    return farmerfileContent;
  }

  Future<List<FarmerListJson>>? myFlFuture;

  List<String> _farmerlistFound = [];
  bool boxChecked = false;

  onCSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _farmerlistFound.add(selectedEst);
      } else {
        _farmerlistFound.remove(selectedEst);
      }
    });
  }

  void _onWLChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  var commUrl = "$stageBaseUrl/communityapi/";

  File? commjsonFile;
  File? regionjsonFile;
  // Directory dir;
  String commfileName = "community.json";
  bool commfileExists = false;
  var commfileContent;
  List<CommunityJson> _newcommValues = [];
  List<CommunityJson> _commValues = [];

  void createCommFile(var content, Directory dir, String fileName) {
    print("Creating Community file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

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
          commjsonFile!.writeAsString(json.encode(commjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is first community");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("Community File does not exist! $commfileExists");
      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Community");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          createCommFile(items, dir!, commfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          getLocalCommValues(ctx);
        }
      } on SocketException {
        print("Error is second comm");
        getLocalCommValues(ctx);
      }
    }
    commfileExists
        ? commfileContent =
            await json.decode(await commjsonFile!.readAsString())
        : null;
    print(commfileContent);

    return commfileExists
        ? _commValues =
            commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList()
        : _newcommValues;
  }

  Future<List<CommunityJson>> getLocalCommValues(BuildContext context) async {
    print("doing clocal comm");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/community.json');
    final body = json.decode(data);

    _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();

    return _newcommValues;
  }

  String? _community;
  String? tempHolder;

  void _oncommChanged(String commVal, ctx, val) {
    setState(() {
      _community = commVal;
      _farmerValues = [];

      _ffarmerlist = tempHolder;

      myFlFuture = writeToFarmerListFile(this.context, val);
    });
  }

   commFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      commjsonFile = new File(dir!.path + "/" + commfileName);
      commfileExists = commjsonFile!.existsSync();
      if (commfileExists)
        commfileContent = await json.decode(await commjsonFile!.readAsString());
    });

    return commfileContent;
  }

  Future<List<CommunityJson>>? myCFuture;

  @override
  void initState() {
    super.initState();
    selectedFarmerRadioGender = 0;

    farmerFileInit();
    myFlFuture = writeToFarmerListFile(this.context, _communityVal);

    commFileInit();
    myCFuture = writeToCommFile(this.context);

    items = [];
    selectedPoints = [];
    getEnumeratorValue('first_time_user');
  }

  setFarmerSelectedGender(val) {
    setState(() {
      selectedFarmerRadioGender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Training Log",
          style: TextStyle(color: fPrimaryWhite),
        ),
        actions: [
          Tooltip(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                child: Icon(Icons.home,  color: fPrimaryWhite),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => IndexPage(),
                  ),
                ),
              ),
            ),
            message: "Takes you back to homepage",
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  "Participant Information",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        // width: 170.0,
                        padding: new EdgeInsets.all(5.0),
                        child: new Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 8.0),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         children: <Widget>[
                            //           Container(
                            //             margin: EdgeInsets.only(
                            //               top: 14.0,
                            //             ),
                            //             child: Row(
                            //               children: <Widget>[
                            //                 Text("Name of farmer"),
                            //               ],
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       new TextFieldWidget(
                            //         // maxLines: 5,
                            //         keyboardType: TextInputType.text,
                            //         decoration: new InputDecoration(
                            //             labelText: '',
                            //             focusedBorder: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                     color: Colors.black,
                            //                     width: 0.5)),
                            //             border: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                     color: Colors.black,
                            //                     width: 2.0))),
                            //         controller: _farmerName,
                            //         validator: (input) => input.trim().isEmpty
                            //             ? 'Please enter a value'
                            //             : null,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              // color: Color(0xFFFFFFFF),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 8.0,
                                      left: .0,
                                      right: .0,
                                      bottom: 18.0,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: 14.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text("Select Community"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.50,
                                                    color: Color(0xFF000000)),
                                              ),
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              padding: EdgeInsets.all(6.0),
                                              child: FutureBuilder<
                                                  List<CommunityJson>>(
                                                future:
                                                    mounted ? myCFuture : null,
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<CommunityJson>>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState !=
                                                      ConnectionState.done)
                                                    return CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              fPrimaryColour),
                                                    );
                                                  else if (!snapshot.hasData)
                                                    return Text(
                                                        "Operation failed. Sync to get data.",
                                                        style: TextStyle(
                                                            color:
                                                                fBackgroundColour));
                                                  else if (snapshot.hasData)
                                                    return commfileExists
                                                        ? Container(
                                                            // width: MediaQuery.of(context).size.width / 1.09,
                                                            child: StatefulBuilder(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return DropdownButtonHideUnderline(
                                                                child:
                                                                    new DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      _community,
                                                                  items: _commValues.map(
                                                                      (CommunityJson
                                                                          dvalue) {
                                                                    // fD = dvalue;
                                                                    return new DropdownMenuItem<
                                                                        String>(
                                                                      value: dvalue
                                                                          .name,
                                                                      child:
                                                                          new Row(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                new Text(
                                                                              "${dvalue.name}",
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    _community =
                                                                        value;
                                                                    // _oncommChanged(
                                                                    //     value,
                                                                    //     context);

                                                                    print(
                                                                        "Community"
                                                                        "$_community");

                                                                    _commValues.map(
                                                                        (CommunityJson
                                                                            ccvalue) {
                                                                      if (ccvalue
                                                                              .name ==
                                                                          value) {
                                                                        print(ccvalue
                                                                            .comcode);

                                                                        setState(
                                                                            () {
                                                                          _communityVal =
                                                                              ccvalue.comcode;

                                                                          // opdagSP.setString(
                                                                          //     'corptown',
                                                                          //     _communityValue);

                                                                          print(
                                                                              "Com COm COm $_communityVal");

                                                                          // regSP?.setInt(
                                                                          //     'communityValue',
                                                                          //     _communityVal);
                                                                          _oncommChanged(
                                                                              value!,
                                                                              context,
                                                                              _communityVal);
                                                                        });
                                                                      }
                                                                    }).toString();
                                                                  },
                                                                ),
                                                              );
                                                            }),
                                                          )
                                                        : Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.09,
                                                            child: StatefulBuilder(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return DropdownButtonHideUnderline(
                                                                child:
                                                                    new DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      _community,
                                                                  items: _newcommValues.map(
                                                                      (CommunityJson
                                                                          dvalue) {
                                                                    // fD = dvalue;
                                                                    return new DropdownMenuItem<
                                                                        String>(
                                                                      value: dvalue
                                                                          .name,
                                                                      child:
                                                                          new Row(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                new Text(
                                                                              "${dvalue.name}",
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    _community =
                                                                        value;

                                                                    print(
                                                                        "Community"
                                                                        "$_community");

                                                                    _commValues.map(
                                                                        (CommunityJson
                                                                            ccvalue) {
                                                                      if (ccvalue
                                                                              .name ==
                                                                          value) {
                                                                        print(ccvalue
                                                                            .comcode);

                                                                        setState(
                                                                            () {
                                                                          _communityVal =
                                                                              ccvalue.comcode;

                                                                          // opdagSP.setString(
                                                                          //     'corptown',
                                                                          //     _communityValue);

                                                                          print(
                                                                              "Com COm COm $_communityVal");

                                                                          // regSP?.setInt(
                                                                          //     'communityValue',
                                                                          //     _communityVal);

                                                                          _oncommChanged(
                                                                              value!,
                                                                              context,
                                                                              _communityVal);
                                                                        });
                                                                      }
                                                                    }).toString();
                                                                  },
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                  else
                                                    return Text(
                                                      "Please sync data",
                                                    );
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.replay),
                                              onPressed: () async {
                                                setState(() {
                                                  myCFuture = writeToCommFile(
                                                      this.context);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // !boxChecked
                            //     ?
                            Container(
                              // color: Color(0xFFFFFFFF),
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 8.0,
                                      left: .0,
                                      right: .0,
                                      bottom: 18.0,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: 14.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text("Select Farmer"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.50,
                                                    color: Color(0xFF000000)),
                                              ),
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              padding: EdgeInsets.all(6.0),
                                              child: FutureBuilder<
                                                  List<FarmerListJson>>(
                                                future:
                                                    mounted ? myFlFuture : null,
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                FarmerListJson>>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState !=
                                                      ConnectionState.done)
                                                    return CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              fPrimaryColour),
                                                    );
                                                  else if (!snapshot.hasData)
                                                    return Text(
                                                        "Operation failed. Sync to get data.",
                                                        style: TextStyle(
                                                            color:
                                                                fBackgroundColour));
                                                  else if (snapshot.hasData)
                                                    return farmerfileExists
                                                        ? Container(
                                                            // width: MediaQuery.of(context).size.width / 1.09,
                                                            child: StatefulBuilder(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return DropdownButtonHideUnderline(
                                                                child:
                                                                    new DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      _ffarmerlist,
                                                                  items: _farmerValues.map(
                                                                      (FarmerListJson
                                                                          dvalue) {
                                                                    // fD = dvalue;
                                                                    return new DropdownMenuItem<
                                                                        String>(
                                                                      value: dvalue
                                                                          .farmerid
                                                                          .toString(),
                                                                      child:
                                                                          new Row(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                new Text(
                                                                              "${dvalue.farmername}",
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    _ffarmerlist =
                                                                        value;
                                                                    _onfarmerlistChanged(
                                                                        value!);

                                                                    print(
                                                                        "Farmer"
                                                                        "$_ffarmerlist");

                                                                    _farmerValues.map(
                                                                        (FarmerListJson
                                                                            ffvalue) {
                                                                      if (ffvalue
                                                                              .farmerid
                                                                              .toString() ==
                                                                          value) {
                                                                        print(ffvalue
                                                                            .communityname);

                                                                        setState(
                                                                            () {
                                                                          items
                                                                              .add(
                                                                            ParticipantsModelArray(
                                                                              farmerid: ffvalue.farmerid.toString(),
                                                                              farmerName: ffvalue.farmername,
                                                                              communityName: ffvalue.communityname,
                                                                              // gender: _farmerGender,
                                                                              // phoneNumber: _phoneNum.text,
                                                                              // sigThumb: _thumbSig
                                                                            ),
                                                                          );
                                                                        });
                                                                      }
                                                                    }).toString();
                                                                  },
                                                                ),
                                                              );
                                                            }),
                                                          )
                                                        : Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.09,
                                                            child: StatefulBuilder(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                              return DropdownButtonHideUnderline(
                                                                child:
                                                                    new DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      _ffarmerlist,
                                                                  items: _newfarmerValues.map(
                                                                      (FarmerListJson
                                                                          dvalue) {
                                                                    // fD = dvalue;
                                                                    return new DropdownMenuItem<
                                                                        String>(
                                                                      value: dvalue
                                                                          .farmerid
                                                                          .toString(),
                                                                      child:
                                                                          new Row(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                new Text(
                                                                              "${dvalue.farmername}",
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    _ffarmerlist =
                                                                        value;
                                                                    _onfarmerlistChanged(
                                                                        value!);

                                                                    print(
                                                                        "Farmer"
                                                                        "$_ffarmerlist");

                                                                    _farmerValues.map(
                                                                        (FarmerListJson
                                                                            ffvalue) {
                                                                      if (ffvalue
                                                                              .farmerid
                                                                              .toString() ==
                                                                          value) {
                                                                        print(ffvalue
                                                                            .communityname);

                                                                        setState(
                                                                            () {
                                                                          items
                                                                              .add(
                                                                            ParticipantsModelArray(
                                                                              farmerid: ffvalue.farmerid.toString(),
                                                                              farmerName: ffvalue.farmername,
                                                                              communityName: ffvalue.communityname,
                                                                              // gender: _farmerGender,
                                                                              // phoneNumber: _phoneNum.text,
                                                                              // sigThumb: _thumbSig
                                                                            ),
                                                                          );
                                                                        });
                                                                      }
                                                                    }).toString();
                                                                  },
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                  else
                                                    return Text(
                                                      "Please sync data",
                                                    );
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.replay),
                                              onPressed: () async {
                                                setState(() {
                                                  myFlFuture =
                                                      writeToFarmerListFile(
                                                          this.context,
                                                          _communityVal);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // : SizedBox(),
                            // new CheckboxListTile(
                            //   contentPadding:
                            //       EdgeInsets.symmetric(horizontal: 08),
                            //   title: Text(
                            //     "Check box if Farmer not found",
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            //   value: boxChecked,
                            //   activeColor: fPrimaryColour,
                            //   onChanged: (bool value) {
                            //     _onWLChanged(value);
                            //   },
                            // ),
                            // boxChecked
                            //     ? Container(
                            //         margin:
                            //             EdgeInsets.symmetric(horizontal: 8.0),
                            //         child: Column(
                            //           children: [
                            //             Row(
                            //               children: <Widget>[
                            //                 Container(
                            //                   margin: EdgeInsets.only(
                            //                     top: 14.0,
                            //                   ),
                            //                   child: Row(
                            //                     children: <Widget>[
                            //                       Text("Name of Farmer"),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //             new TextFieldWidget(
                            //               // maxLines: 5,
                            //               keyboardType: TextInputType.text,
                            //               decoration: new InputDecoration(
                            //                   labelText: '',
                            //                   focusedBorder: OutlineInputBorder(
                            //                       borderSide: BorderSide(
                            //                           color: Colors.black,
                            //                           width: 0.5)),
                            //                   border: OutlineInputBorder(
                            //                       borderSide: BorderSide(
                            //                           color: Colors.black,
                            //                           width: 2.0))),
                            //               controller: _community,
                            //               validator: (input) =>
                            //                   input.trim().isEmpty
                            //                       ? 'Please enter a value'
                            //                       : null,
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     : SizedBox(),
                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 8.0),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: <Widget>[
                            //       Row(
                            //         children: <Widget>[
                            //           Padding(
                            //             padding: const EdgeInsets.all(0.0),
                            //             child: Text(
                            //               "Gender",
                            //               style: TextStyle(
                            //                 fontSize: 17,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       ButtonBar(
                            //         alignment: MainAxisAlignment.start,
                            //         children: <Widget>[
                            //           Row(
                            //             children: <Widget>[
                            //               GenderRadioButton(
                            //                 value: 1,
                            //                 group: selectedFarmerRadioGender,
                            //                 selected: (val) {
                            //                   print(val);
                            //                   setState(() {
                            //                     selectedFarmerRadioGender = val;
                            //                     print(val);
                            //                     _farmerGender = "male";
                            //                   });
                            //                 },
                            //               ),
                            //               Text(
                            //                 "Male",
                            //                 // style: TextStyle(
                            //                 //     color: Color(0xFFf9f9f9)),
                            //               ),
                            //             ],
                            //           ),
                            //           Row(
                            //             children: <Widget>[
                            //               GenderRadioButton(
                            //                 value: 2,
                            //                 group: selectedFarmerRadioGender,
                            //                 selected: (val) {
                            //                   print(val);
                            //                   setState(() {
                            //                     selectedFarmerRadioGender = val;
                            //                     _farmerGender = "female";
                            //                   });
                            //                 },
                            //               ),
                            //               Text(
                            //                 "Female",
                            //                 // style: TextStyle(
                            //                 //     color:
                            //                 //         Color(0xFFf9f9f9))
                            //               ),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 8.0),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         children: <Widget>[
                            //           Container(
                            //             margin: EdgeInsets.only(
                            //               top: 0.0,
                            //             ),
                            //             child: Row(
                            //               children: <Widget>[
                            //                 Text("Phone number"),
                            //               ],
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       new TextFieldWidget(
                            //         // maxLines: 5,
                            //         keyboardType: TextInputType.phone,
                            //         decoration: new InputDecoration(
                            //             labelText: '',
                            //             focusedBorder: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                     color: Colors.black,
                            //                     width: 0.5)),
                            //             border: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                     color: Colors.black,
                            //                     width: 2.0))),
                            //         controller: _phoneNum,
                            //         validator: (input) => input.trim().isEmpty
                            //             ? 'Please enter a value'
                            //             : null,
                            //       ),
                            // Container(
                            //   margin: EdgeInsets.symmetric(vertical: 8.0),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         "Signature/ Thumbprint",
                            //         style: TextStyle(
                            //             // fontWeight: FontWeight.bold,
                            //             fontSize: 16.0),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SignatureOptions(
                            //   _farmerSign,
                            //   alreadyVal: "",
                            // )
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                              // child: Divider(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "List of Participants".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortColumnIndex: 1,
                        sortAscending: sort,
                        showCheckboxColumn: true,
                        columnSpacing: 30.0,
                        columns: [
                          DataColumn(
                            label: Text('Farmer Name'),
                          ),
                          DataColumn(
                            label: Text('Community'),
                          ),
                          // DataColumn(
                          //   label: Text('Gender'),
                          // ),
                          // DataColumn(
                          //   label: Text('Contact'),
                          // ),
                          // DataColumn(
                          //   label: Text('Signature'),
                          // ),
                        ],
                        rows: mapItemToDataRows(items).toList(),
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
                //     getTLValues();
                //     if (_farmerGender != "male" && _farmerGender != "female") {
                //       Alert.showSnackBar(
                //         context,
                //         text: 'Participant gender not selected',
                //         color: Colors.red,
                //       );
                //     }
                //     // else if (_thumbSig.isEmpty) {
                //     //   Alert.showSnackBar(
                //     //     context,
                //     //     text: 'Please add a signature',
                //     //     color: Colors.red,
                //     //   );
                //     // }
                //     else if (_farmerGender != null &&
                //         // _thumbSig != null &&
                //         _formKey.currentState.validate()) {
                //       items.add(
                //         ParticipantsModelArray(
                //           farmerName: _farmerName.text,
                //           communityName:
                //               boxChecked ? _community.text : _ffarmerlist,
                //           gender: _farmerGender,
                //           phoneNumber: _phoneNum.text,
                //           // sigThumb: _thumbSig
                //         ),
                //       );

                //       print("Added items ${items.length} --- $items");
                //       setState(() {
                //         // _thumbSig = null;
                //         // regSP?.setString("base64signature", "");
                //       });
                //     }
                //   },
                //   child: new Icon(
                //     Icons.add,
                //     color: fPrimaryColour,
                //     size: 40,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50.00,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: fPrimaryColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          textStyle: const TextStyle(color: fPrimaryWhite),
                          // shadowColor: fPrimaryColour,
                        ),
                        child: Text(
                          "Finish",
                          style: TextStyle(
          color: fPrimaryWhite,
                              fontSize: 17.0, fontWeight: FontWeight.normal),
                        ),
                        onPressed: () async {
                          getTLValues();
                          // if (items.length < 1) {
                          //   Alert.showSnackBar(
                          //     context,
                          //     text: 'Please add some data!',
                          //     color: Colors.red,
                          //   );
                          // } else if (_formKey.currentState.validate()) {
                          _onDone();
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
                                  'Successfully saved. Please go to "View Monitoring Data" to send data',
                                  "negative");
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TreeMonitoringDecider(),
                                ),
                              );
                              regSP?.clear();
                            },
                            disapprovePress: () => null,
                          );
                        }
                        // convertr();
                        // convertc2();
                        // convertc3();
                        // saveToLocalDB("not connected");
                        // },
                        ),
                  ),
                ),
                new TextButton(
                  onPressed: deleteSelected,
                  child: new Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _priceController.dispose();
    // _itemController.dispose();
  }

  Iterable<DataRow> mapItemToDataRows(List<ParticipantsModelArray> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      return DataRow(
          selected: selectedPoints.contains(item),
          onSelectChanged: (t) {
            print("Onselect");
            onSelectedRow(t!, item);
          },
          cells: [
            DataCell(
              Text(item.farmerName.toString()),
              // onTap: () {
              //   print('Selected ${item.latitude.toString()}');
              // },
            ),
            DataCell(
              Text(
                item.communityName ?? "not found",
              ),
            ),
            // DataCell(
            //   Text(item.gender ?? "not found"),
            // ),
            // DataCell(
            //   Text(item.phoneNumber ?? "not found"),
            // ),
            // DataCell(
            //   item.sigThumb != null
            //       ? CircleAvatar(
            //           radius: 30.0,
            //           child: Image.memory(
            //             base64.decode(item.sigThumb),
            //             // repeat: ImageRepeat.repeat,
            //             height: 64,
            //             width: 64,
            //             fit: BoxFit.fill,
            //           ),
            //         )
            //       : CircleAvatar(
            //           radius: 30.0,
            //           child: Image.asset(
            //             "lib/libassets/images/newUser.png",
            //             // repeat: ImageRepeat.repeat,
            //             height: 64,
            //             width: 64,
            //             fit: BoxFit.contain,
            //           ),
            //         ),
            // )
          ]);
    });
    return dataRows;
  }
}
