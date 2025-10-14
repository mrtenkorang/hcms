import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/districtmodel.dart';
import 'package:hcms_revived2/models/apimodels/forestdistrict.dart';
import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
import 'package:hcms_revived2/models/apimodels/stool.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TreeFarmInfo extends StatefulWidget {
  final String? typeofEstablishment;
  final String? community;
  final String? mddasName;
  final String? family;
  final String? forestDistrict;
  final String? region;

  const TreeFarmInfo(
      {Key? key,
      this.typeofEstablishment,
      this.community,
      this.mddasName,
      this.family,
      this.forestDistrict,
      this.region})
      : super(key: key);

  @override
  _TreeFarmInfoState createState() => _TreeFarmInfoState();
}

class _TreeFarmInfoState extends State<TreeFarmInfo> {
//farmdetails data
  var districtsUrl = "$stageBaseUrl/districtapi/";
  var forestdistrictsUrl = "$stageBaseUrl/forestdistapi/";
  var stoolUrl = "$stageBaseUrl/stoolapi/";
  var commUrl = "$stageBaseUrl/communityapi/";
  var regionUrl = "$stageBaseUrl/regionapi/";

  File? districtjsonFile;
  File? forestdistrictjsonFile;
  File? stooljsonFile;
  File? commjsonFile;
  File? regionjsonFile;
  Directory? dir;
  String districtfileName = "districts.json";
  String forestdistrictfileName = "forestdistrict.json";
  String stoolfileName = "stool.json";
  String commfileName = "community.json";
  String regionfileName = "regions.json";
  bool districtfileExists = false;
  bool forestdistrictfileExists = false;
  bool stoolfileExists = false;
  bool commfileExists = false;
  bool regionfileExists = false;
  var districtfileContent;
  var forestdistrictfileContent;
  var stoolfileContent;
  var commfileContent;
  var regionfileContent;
  // bool confileContent = false;

  List<DistrictsJson> _newdistrictValues = [];
  List<DistrictsJson> _districtValues = [];
  List<ForestDistrictsJson> _newforestdistrictValues = [];
  List<ForestDistrictsJson> _forestdistrictValues = [];
  List<StoolJson> _newstoolValues = [];
  List<StoolJson> _stoolValues = [];
  List<CommunityJson> _newcommValues = [];
  List<CommunityJson> _commValues = [];
  List<RegionJson> _newregionValues = [];
  List<RegionJson> _regionValues = [];

  void createDistrictFile(var content, Directory dir, String fileName) {
    print("Creating district file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    districtfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createForestDistrictFile(var content, Directory dir, String fileName) {
    print("Creating forest district file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    forestdistrictfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createStoolFile(var content, Directory dir, String fileName) {
    print("Creating stool file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    stoolfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createCommFile(var content, Directory dir, String fileName) {
    print("Creating Community file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createRegionFile(var content, Directory dir, String fileName) {
    print("Creating Region file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    regionfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<DistrictsJson>> writeToDistrictFile(BuildContext ctx) async {
    print("Writing to district file!");
    if (districtfileExists) {
      print("District File exists $districtfileExists");

      try {
        var response = await http.get(Uri.parse(districtsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("district");

          print("content $items");
          print("object");

          // var content = {key: items};

          var districtjsonFileContent =
              await json.decode(await districtjsonFile!.readAsString());
          districtjsonFileContent.clear();
          districtjsonFileContent.addAll(items);
          districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is first district");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("District File does not exist! $districtfileExists");
      try {
        var response = await http.get(Uri.parse(districtsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("District");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          createDistrictFile(items, dir!, districtfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          getLocalDistricts(ctx);
        }
      } on SocketException {
        print("Error is second district");
        getLocalDistricts(ctx);
      }
    }
    districtfileExists
        ? districtfileContent =
            await json.decode(await districtjsonFile!.readAsString())
        : null;
    print(districtfileContent);

    return districtfileExists
        ? _districtValues = districtfileContent
            .map<DistrictsJson>(DistrictsJson.fromJson)
            .toList()
        : _newdistrictValues;
  }

  Future<List<ForestDistrictsJson>> writeToForestDistrictFile(
      BuildContext ctx) async {
    print("Writing to forest file! $forestdistrictfileExists");
    if (forestdistrictfileExists) {
      print("Forest file exists $forestdistrictfileExists");

      try {
        var response = await http.get(Uri.parse(forestdistrictsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Forest");

          print("content $items");
          print("object");

          // var content = {key: items};

          var forestdistrictjsonFileContent =
              await json.decode(await forestdistrictjsonFile!.readAsString());
          forestdistrictjsonFileContent.clear();
          forestdistrictjsonFileContent.addAll(items);
          forestdistrictjsonFile!
              .writeAsString(json.encode(forestdistrictjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is ");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("Forest File does not exist! $forestdistrictfileExists");
      try {
        var response = await http.get(Uri.parse(forestdistrictsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Forest");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          createForestDistrictFile(items, dir!, forestdistrictfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          getLocalForestDistricts(ctx);
        }
      } on SocketException {
        print("Error is ");
        getLocalForestDistricts(ctx);
      }
    }
    forestdistrictfileExists
        ? forestdistrictfileContent =
            await json.decode(await forestdistrictjsonFile!.readAsString())
        : null;
    print(forestdistrictfileContent);

    return forestdistrictfileExists
        ? _forestdistrictValues = forestdistrictfileContent
            .map<ForestDistrictsJson>(ForestDistrictsJson.fromJson)
            .toList()
        : _newforestdistrictValues;
  }

  Future<List<StoolJson>> writeToStoolFile(BuildContext ctx) async {
    print("Writing to stool file! $stoolfileExists");
    if (stoolfileExists) {
      print("Stool File exists $stoolfileExists");

      try {
        var response = await http.get(Uri.parse(stoolUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Stool");

          print("content $items");
          print("object");

          // var content = {key: items};

          var stooljsonFileContent =
              await json.decode(await stooljsonFile!.readAsString());
          stooljsonFileContent.clear();
          stooljsonFileContent.addAll(items);
          stooljsonFile!.writeAsString(json.encode(stooljsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is first stool");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("Stool File does not exist! $stoolfileExists");
      try {
        var response = await http.get(Uri.parse(stoolUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("stool");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          createStoolFile(items, dir!, stoolfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          getLocalStoolValues(ctx);
        }
      } on SocketException {
        print("Error is second stool");
        getLocalStoolValues(ctx);
      }
    }
    stoolfileExists
        ? stoolfileContent =
            await json.decode(await stooljsonFile!.readAsString())
        : null;
    print(stoolfileContent);

    return stoolfileExists
        ? _stoolValues =
            stoolfileContent.map<StoolJson>(StoolJson.fromJson).toList()
        : _newstoolValues;
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

  Future<List<RegionJson>> writeToRegionFile(BuildContext ctx) async {
    print("Writing to region file! $regionfileExists");
    if (regionfileExists) {
      print("Region File exists $regionfileExists");

      try {
        var response = await http.get(Uri.parse(regionUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Region");

          print("content $items");
          print("object");

          // var content = {key: items};

          var regionjsonFileContent =
              await json.decode(await regionjsonFile!.readAsString());
          regionjsonFileContent.clear();
          regionjsonFileContent.addAll(items);
          regionjsonFile!.writeAsString(json.encode(regionjsonFileContent));

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
        }
      } on SocketException {
        print("Error is first region");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      print("Region File does not exist! $regionfileExists");
      try {
        var response = await http.get(Uri.parse(regionUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          print("Region");

          print("content $items");
          print("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile!.writeAsString(json.encode(districtjsonFileContent));

          createRegionFile(items, dir!, regionfileName);

          // print("contennttss ${listOfRegions.runtimeType}");
        } else {
          print("didn't work here");
          getLocalRegionValues(ctx);
        }
      } on SocketException {
        print("Error is second region");
        getLocalRegionValues(ctx);
      }
    }
    regionfileExists
        ? regionfileContent =
            await json.decode(await regionjsonFile!.readAsString())
        : null;
    print(regionfileContent);

    return regionfileExists
        ? _regionValues = regionfileContent
            .map<RegionJson>(RegionJson.fromRegionJson)
            .toList()
        : _newregionValues;
  }

  String? _disV;
  int? _mmdV;
  String? _fdisV;
  String? _stoolV;

  Future<List<DistrictsJson>> getLocalDistricts(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/districts.json');
    final body = json.decode(data);

    _newdistrictValues =
        body.map<DistrictsJson>(DistrictsJson.fromJson).toList();

    // writeToFile(body);

    // _disV = _districtValues[0].districtName;
    return _newdistrictValues;
  }

  Future<List<ForestDistrictsJson>> getLocalForestDistricts(
      BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/forestdistrict.json');
    final body = json.decode(data);

    _newforestdistrictValues =
        body.map<ForestDistrictsJson>(ForestDistrictsJson.fromJson).toList();

    // writeToFile(body);

    // _disV = _districtValues[0].districtName;
    return _newforestdistrictValues;
  }

  Future<List<StoolJson>> getLocalStoolValues(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/stool.json');
    final body = json.decode(data);

    _newstoolValues = body.map<StoolJson>(StoolJson.fromJson).toList();

    // writeToFile(body);

    // _disV = _districtValues[0].districtName;
    return _newstoolValues;
  }

  Future<List<CommunityJson>> getLocalCommValues(BuildContext context) async {
    print("doing clocal comm");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/community.json');
    final body = json.decode(data);

    _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();

    return _newcommValues;
  }

  Future<List<RegionJson>> getLocalRegionValues(BuildContext context) async {
    print("doing local region");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/region.json');
    final body = json.decode(data);

    _newregionValues = body.map<RegionJson>(RegionJson.fromRegionJson).toList();

    return _newregionValues;
  }

  String? _family;
  String? _community;

// for form validation
  String? _mmdas;
  String reg = "";
  String fD = "";

  bool _isWLchecked = false;
  bool _isCPchecked = false;
  bool _isPTchecked = false;
  bool _isNOchecked = false;
  bool _isFchecked = false;
  bool _isSGchecked = false;
  bool _isOchecked = false;

  String? _regionValue;
  String? _districtValue;
  String? _mmdasValue;

  List<String> _establishment = [];
  // List<String> _regionValues = new List<String>();
  // List<String> _districtValues = new List<String>();
  List<String> _mmdasValues = [];

  void _onRegionChanged(String regVal) {
    setState(() {
      _regionValue = regVal;
      regSP?.setString('regionR', _regionValue!);
    });
  }

  void _onDistrictChanged(String disVal) {
    setState(() {
      _districtValue = disVal;
      regSP?.setString('forestDistrictR', _districtValue!);
    });
  }

  void _onmmdasChanged(String mmdasVal) {
    setState(() {
      _mmdas = mmdasVal;
    });
  }

  void _onstoolChanged(String familyVal) {
    setState(() {
      _family = familyVal;
      regSP?.setString('familyR', _family!);
    });
  }

  void _oncommChanged(String commVal) {
    setState(() {
      _community = commVal;
      regSP?.setString('communityR', _community!);
    });
  }

  onSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _establishment.add(selectedEst);
      } else {
        _establishment.remove(selectedEst);
      }
    });

    regSP?.setStringList("estR", _establishment);
  }

  void _onWLChanged(bool val) {
    setState(() {
      _isWLchecked = val;
      onSelectedRow(val, "Woodlot");

      if (val) {
        _isCPchecked = _isCPchecked;
        _isOchecked = _isOchecked;
        _isPTchecked = !val;
        _isNOchecked = !val;
        _isFchecked = !val;
        _isSGchecked = !val;

        onSelectedRow(!val, "Sacred_Grove");
        onSelectedRow(!val, "Fallow");
        onSelectedRow(!val, "Naturally_Occurring_trees");
        onSelectedRow(!val, "Planted_trees_on_farm");
      }
    });
  }

  void _onCPChanged(bool val) {
    setState(() {
      _isCPchecked = val;
      onSelectedRow(val, "Commercial_Plantation");

      if (val) {
        _isWLchecked = _isWLchecked;
        _isOchecked = _isOchecked;
        _isPTchecked = !val;
        _isNOchecked = !val;
        _isFchecked = !val;
        _isSGchecked = !val;

        onSelectedRow(!val, "Sacred_Grove");
        onSelectedRow(!val, "Fallow");
        onSelectedRow(!val, "Naturally_Occurring_trees");
        onSelectedRow(!val, "Planted_trees_on_farm");
      }
    });
  }

  void _onOChanged(bool val) {
    setState(() {
      _isOchecked = val;
      onSelectedRow(val, "Other");

      if (val) {
        _isWLchecked = _isWLchecked;
        _isCPchecked = _isCPchecked;
        _isPTchecked = !val;
        _isNOchecked = !val;
        _isFchecked = !val;
        _isSGchecked = !val;

        onSelectedRow(!val, "Sacred_Grove");
        onSelectedRow(!val, "Fallow");
        onSelectedRow(!val, "Naturally_Occurring_trees");
        onSelectedRow(!val, "Planted_trees_on_farm");
      }
    });
  }

  void _onPTChanged(bool val) {
    setState(() {
      _isPTchecked = val;
      onSelectedRow(val, "Planted_trees_on_farm");

      if (val) {
        _isWLchecked = !val;
        _isCPchecked = !val;
        _isOchecked = !val;
        _isNOchecked = _isNOchecked;
        _isFchecked = _isFchecked;
        _isSGchecked = _isSGchecked;

        onSelectedRow(!val, "Woodlot");
        onSelectedRow(!val, "Commercial_Plantation");
        onSelectedRow(!val, "Other");
      }
    });
  }

  void _onNOChanged(bool val) {
    setState(() {
      _isNOchecked = val;
      onSelectedRow(val, "Naturally_Occurring_trees");

      if (val) {
        _isWLchecked = !val;
        _isCPchecked = !val;
        _isOchecked = !val;
        _isPTchecked = _isPTchecked;
        _isFchecked = _isFchecked;
        _isSGchecked = _isSGchecked;

        onSelectedRow(!val, "Woodlot");
        onSelectedRow(!val, "Commercial_Plantation");
        onSelectedRow(!val, "Other");
      }
    });
  }

  void _onFChanged(bool val) {
    setState(() {
      _isFchecked = val;
      onSelectedRow(val, "Fallow");

      if (val) {
        _isWLchecked = !val;
        _isCPchecked = !val;
        _isOchecked = !val;
        _isPTchecked = _isPTchecked;
        _isNOchecked = _isNOchecked;
        _isSGchecked = _isSGchecked;

        onSelectedRow(!val, "Woodlot");
        onSelectedRow(!val, "Commercial_Plantation");
        onSelectedRow(!val, "Other");
      }
    });
  }

  void _onSGChanged(bool val) {
    setState(() {
      _isSGchecked = val;
      onSelectedRow(val, "Sacred_Grove");
      print("Val be $val");

      if (val) {
        _isWLchecked = !val;
        _isCPchecked = !val;
        _isOchecked = !val;
        _isPTchecked = _isPTchecked;
        _isNOchecked = _isNOchecked;
        _isFchecked = _isFchecked;

        onSelectedRow(!val, "Woodlot");
        onSelectedRow(!val, "Commercial_Plantation");
        onSelectedRow(!val, "Other");
      }
    });
  }

   districtFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      districtjsonFile = new File(dir!.path + "/" + districtfileName);
      districtfileExists = districtjsonFile!.existsSync();
      if (districtfileExists)
        districtfileContent =
            await json.decode(await districtjsonFile!.readAsString());
    });

    return districtfileContent;
  }

   forestdistrictFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      forestdistrictjsonFile =
          new File(dir!.path + "/" + forestdistrictfileName);
      forestdistrictfileExists = forestdistrictjsonFile!.existsSync();
      if (forestdistrictfileExists)
        forestdistrictfileContent =
            await json.decode(await forestdistrictjsonFile!.readAsString());
    });

    return forestdistrictfileContent;
  }

   stoolFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      stooljsonFile = new File(dir!.path + "/" + stoolfileName);
      stoolfileExists = stooljsonFile!.existsSync();
      if (stoolfileExists)
        stoolfileContent =
            await json.decode(await stooljsonFile!.readAsString());
    });

    return stoolfileContent;
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

   regionFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      regionjsonFile = new File(dir!.path + "/" + regionfileName);
      regionfileExists = regionjsonFile!.existsSync();
      if (regionfileExists)
        regionfileContent =
            await json.decode(await regionjsonFile!.readAsString());
    });

    return regionfileContent;
  }

  Future<List<DistrictsJson>>? myDFuture;
  Future<List<ForestDistrictsJson>>? myFDFuture;
  Future<List<StoolJson>>? mySFuture;
  Future<List<CommunityJson>>? myCFuture;
  Future<List<RegionJson>>? myRFuture;

  @override
  void initState() {
    super.initState();
    //
    forestdistrictFileInit();
    stoolFileInit();
    districtFileInit();
    commFileInit();
    regionFileInit();

    myDFuture = writeToDistrictFile(this.context);
    myFDFuture = writeToForestDistrictFile(this.context);
    mySFuture = writeToStoolFile(this.context);
    myCFuture = writeToCommFile(this.context);
    myRFuture = writeToRegionFile(this.context);

    if (widget.typeofEstablishment!.contains("Woodlot")) {
      setState(() {
        _isWLchecked = true;
        onSelectedRow(true, "Woodlot");
      });
    } else {}
    if (widget.typeofEstablishment!.contains("Commercial_Plantation")) {
      setState(() {
        _isCPchecked = true;
        onSelectedRow(true, "Commercial_Plantation");
      });
    } else {}
    if (widget.typeofEstablishment!.contains("Other")) {
      setState(() {
        _isOchecked = true;
        onSelectedRow(true, "Other");
      });
    } else {}
    if (widget.typeofEstablishment!.contains("Sacred_Grove")) {
      setState(() {
        _isSGchecked = true;
        onSelectedRow(true, "Sacred_Grove");
      });
    } else {}
    if (widget.typeofEstablishment!.contains("Fallow")) {
      setState(() {
        _isFchecked = true;
        onSelectedRow(true, "Fallow");
      });
    } else {}
    if (widget.typeofEstablishment!.contains("Naturally_Occurring_trees")) {
      setState(() {
        _isNOchecked = true;
        onSelectedRow(true, "Naturally_Occurring_trees");
      });
    } else {}
    if (widget.typeofEstablishment!.contains("Planted_trees_on_farm")) {
      setState(() {
        _isPTchecked = true;
        onSelectedRow(true, "Planted_trees_on_farm");
      });
    } else {}

    _establishment = [];
  }

  //   void setFDValuesT() {
  //   regSP?.setString('region', _regionValue);
  //   regSP?.setString('forestDistrict', _districtValue);
  //   regSP?.setString('family', _family);
  //   regSP?.setInt('mddas', _mmdV);
  //   regSP?.setString('mddasName', _disV);
  //   regSP?.setString('community', _community);
  //   regSP?.setStringList("est", _establishment);

  //   print("Tree Information values gotten!");
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Tree Farm Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 14.0),
                          child: Row(
                            children: <Widget>[
                              Text("Region"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.50, color: Color(0xFF000000))),
                          // width:
                          //     MediaQuery.of(context).size.width /
                          //         1.09,
                          padding: EdgeInsets.all(6.0),
                          child: FutureBuilder<List<RegionJson>>(
                            future: mounted ? myRFuture : null,
                            builder: (context,
                                AsyncSnapshot<List<RegionJson>> snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      fPrimaryColour),
                                );
                              else if (snapshot.hasData)
                                return regionfileExists
                                    ? Container(
                                        // width: MediaQuery.of(
                                        //             context)
                                        //         .size
                                        //         .width /
                                        //     1.09,
                                        child: StatefulBuilder(
                                            builder: (context, state) {
                                          return DropdownButtonHideUnderline(
                                            child: new DropdownButton<String>(
                                              hint: Text(
                                                  widget.region ?? "region",
                                                  style: TextStyle(
                                                    color: Color(0xFFfc1d20),
                                                    fontSize: 14,
                                                  )),
                                              value: _regionValue,
                                              items: _regionValues
                                                  .map((RegionJson dvalue) {
                                                // fD = dvalue;
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: dvalue.name,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: new Text(
                                                          "${dvalue.name}",
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                _onRegionChanged(value!);
                                                // fD = value;
                                                // print(_districtValues
                                                //     .elementAt(_districtValues
                                                //         .indexOf(value))
                                                //     .districtcode);
                                                // _districtValues.map(
                                                //     (DistrictsJson
                                                //         ddvalue) {
                                                //   if (ddvalue.district ==
                                                //       value) {
                                                //     print(ddvalue
                                                //         .districtcode);
                                                //   }
                                                // }).toString();
                                              },
                                            ),
                                          );
                                        }),
                                      )
                                    : Container(
                                        // width: MediaQuery.of(
                                        //             context)
                                        //         .size
                                        //         .width /
                                        //     1.09,
                                        child: StatefulBuilder(
                                            builder: (context, state) {
                                          return DropdownButtonHideUnderline(
                                            child: new DropdownButton<String>(
                                              hint: Text(
                                                  widget.region ?? "regionn",
                                                  style: TextStyle(
                                                    color: Color(0xFFfc1d20),
                                                    fontSize: 14,
                                                  )),
                                              value: _regionValue,
                                              items: _newregionValues
                                                  .map((RegionJson dvalue) {
                                                // fD = dvalue;
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: dvalue.name,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: new Text(
                                                          "${dvalue.name}",
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                _onRegionChanged(value!);
                                                // fD = value;
                                                // print(_districtValues
                                                //     .elementAt(_districtValues
                                                //         .indexOf(value))
                                                //     .districtcode);
                                                // _districtValues.map(
                                                //     (DistrictsJson
                                                //         ddvalue) {
                                                //   if (ddvalue.district ==
                                                //       value) {
                                                //     print(ddvalue
                                                //         .districtcode);
                                                //   }
                                                // }).toString();
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFFFFFFF),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text("Forest District"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.50, color: Color(0xFF000000)),
                                ),
                                // width:
                                //     MediaQuery.of(context).size.width /
                                //         1.09,
                                padding: EdgeInsets.all(6.0),
                                child: FutureBuilder<List<ForestDistrictsJson>>(
                                  future: mounted ? myFDFuture : null,
                                  builder: (context,
                                      AsyncSnapshot<List<ForestDistrictsJson>>
                                          snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                fPrimaryColour),
                                      );
                                    else if (snapshot.hasData)
                                      return forestdistrictfileExists
                                          ? Container(
                                              // width: MediaQuery.of(
                                              //             context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              child: StatefulBuilder(
                                                  builder: (context, state) {
                                                return DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                                    hint: Text(
                                                        widget.forestDistrict ??
                                                            "forest district",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFfc1d20),
                                                          fontSize: 14,
                                                        )),
                                                    value: _fdisV,
                                                    items: _forestdistrictValues
                                                        .map(
                                                            (ForestDistrictsJson
                                                                dvalue) {
                                                      // fD = dvalue;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: dvalue.name,
                                                        child: new Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: new Text(
                                                                "${dvalue.name}",
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      _fdisV = value;
                                                      _onDistrictChanged(
                                                          value!);
                                                      // fD = value;
                                                      // print(_districtValues
                                                      //     .elementAt(_districtValues
                                                      //         .indexOf(value))
                                                      //     .districtcode);
                                                      // _districtValues.map(
                                                      //     (DistrictsJson
                                                      //         ddvalue) {
                                                      //   if (ddvalue.district ==
                                                      //       value) {
                                                      //     print(ddvalue
                                                      //         .districtcode);
                                                      //   }
                                                      // }).toString();
                                                    },
                                                  ),
                                                );
                                              }),
                                            )
                                          : Container(
                                              // width: MediaQuery.of(
                                              //             context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              child: StatefulBuilder(
                                                  builder: (context, state) {
                                                return DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                                    hint: Text(
                                                        widget.forestDistrict ??
                                                            "forest districtt",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFfc1d20),
                                                          fontSize: 14,
                                                        )),
                                                    value: _fdisV,
                                                    items: _newforestdistrictValues
                                                        .map(
                                                            (ForestDistrictsJson
                                                                dvalue) {
                                                      // fD = dvalue;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: dvalue.name,
                                                        child: new Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: new Text(
                                                                "${dvalue.name}",
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      _fdisV = value;
                                                      _onDistrictChanged(
                                                          value!);
                                                      // fD = value;
                                                      // print(_districtValues
                                                      //     .elementAt(_districtValues
                                                      //         .indexOf(value))
                                                      //     .districtcode);
                                                      // _districtValues.map(
                                                      //     (DistrictsJson
                                                      //         ddvalue) {
                                                      //   if (ddvalue.district ==
                                                      //       value) {
                                                      //     print(ddvalue
                                                      //         .districtcode);
                                                      //   }
                                                      // }).toString();
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
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 14.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text("TA/Stool/Skin/Family"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.50, color: Color(0xFF000000)),
                          ),
                          // width: MediaQuery.of(context)
                          //         .size
                          //         .width /
                          //     1.09,
                          padding: EdgeInsets.all(6.0),
                          child: FutureBuilder<List<StoolJson>>(
                            future: mounted ? mySFuture : null,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      fPrimaryColour),
                                );
                              else if (snapshot.hasData)
                                return stoolfileExists
                                    ? Container(
                                        // width: MediaQuery.of(
                                        //             context)
                                        //         .size
                                        //         .width /
                                        //     1.09,
                                        child: StatefulBuilder(
                                            builder: (context, state) {
                                          return DropdownButtonHideUnderline(
                                            child: new DropdownButton<String>(
                                              hint: Text(
                                                  widget.family ?? "family",
                                                  style: TextStyle(
                                                    color: Color(0xFFfc1d20),
                                                    fontSize: 14,
                                                  )),
                                              value: _stoolV,
                                              items: _stoolValues
                                                  .map((StoolJson dvalue) {
                                                // fD = dvalue;
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: dvalue.name,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: new Text(
                                                          "${dvalue.name}",
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                _stoolV = value;
                                                _onstoolChanged(value!);
                                                // fD = value;
                                                // print(_districtValues
                                                //     .elementAt(_districtValues
                                                //         .indexOf(value))
                                                //     .districtcode);
                                                // _districtValues.map(
                                                //     (DistrictsJson
                                                //         ddvalue) {
                                                //   if (ddvalue.district ==
                                                //       value) {
                                                //     print(ddvalue
                                                //         .districtcode);
                                                //   }
                                                // }).toString();
                                              },
                                            ),
                                          );
                                        }),
                                      )
                                    : Container(
                                        // width: MediaQuery.of(
                                        //             context)
                                        //         .size
                                        //         .width /
                                        //     1.09,
                                        child: StatefulBuilder(
                                            builder: (context, state) {
                                          return DropdownButtonHideUnderline(
                                            child: new DropdownButton<String>(
                                              hint: Text(
                                                  widget.family ?? "familyy",
                                                  style: TextStyle(
                                                    color: Color(0xFFfc1d20),
                                                    fontSize: 14,
                                                  )),
                                              value: _stoolV,
                                              items: _newstoolValues
                                                  .map((StoolJson dvalue) {
                                                // fD = dvalue;
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: dvalue.name,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: new Text(
                                                          "${dvalue.name}",
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                _stoolV = value;
                                                _onstoolChanged(value!);
                                                // fD = value;
                                                // print(_districtValues
                                                //     .elementAt(_districtValues
                                                //         .indexOf(value))
                                                //     .districtcode);
                                                // _districtValues.map(
                                                //     (DistrictsJson
                                                //         ddvalue) {
                                                //   if (ddvalue.district ==
                                                //       value) {
                                                //     print(ddvalue
                                                //         .districtcode);
                                                //   }
                                                // }).toString();
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
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFFFFFFF),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text("MMDAS"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.50, color: Color(0xFF000000)),
                                ),
                                // width: MediaQuery.of(context)
                                //         .size
                                //         .width /
                                //     1.09,
                                padding: EdgeInsets.all(6.0),
                                child: FutureBuilder<List<DistrictsJson>>(
                                  future: mounted ? myDFuture : null,
                                  builder: (context,
                                      AsyncSnapshot<List<DistrictsJson>>
                                          snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                fPrimaryColour),
                                      );
                                    else if (snapshot.hasData)
                                      return districtfileExists
                                          ? Container(
                                              // width: MediaQuery.of(
                                              //             context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              child: StatefulBuilder(
                                                  builder: (context, state) {
                                                return DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                                    hint: Text(
                                                        widget.mddasName ??
                                                            "mmdas",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFfc1d20),
                                                          fontSize: 14,
                                                        )),
                                                    value: _disV,
                                                    items: _districtValues.map(
                                                        (DistrictsJson dvalue) {
                                                      // fD = dvalue;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: dvalue.district,
                                                        child: new Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: new Text(
                                                                "${dvalue.district}",
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      _disV = value;
                                                      _onmmdasChanged(value!);
                                                      fD = value;
                                                      _districtValues.map(
                                                          (DistrictsJson
                                                              ddvalue) {
                                                        if (ddvalue.district ==
                                                            value) {
                                                          setState(() {
                                                            _mmdV = ddvalue
                                                                .districtcode;
                                                            regSP?.setInt(
                                                                'mddasR',
                                                                _mmdV!);
                                                            regSP?.setString(
                                                                'mddasNameR',
                                                                _disV!);
                                                          });
                                                        }
                                                        print("MV"
                                                            "$_mmdV");
                                                      }).toString();

                                                      print("MVVV"
                                                          "$_mmdV");
                                                    },
                                                  ),
                                                );
                                              }),
                                            )
                                          : Container(
                                              // width: MediaQuery.of(
                                              //             context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              child: StatefulBuilder(
                                                  builder: (context, state) {
                                                return DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                                    hint: Text(
                                                        widget.mddasName ??
                                                            "mmdass",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFfc1d20),
                                                          fontSize: 14,
                                                        )),
                                                    value: _disV,
                                                    items: _newdistrictValues
                                                        .map((DistrictsJson
                                                            dvalue) {
                                                      // fD = dvalue;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: dvalue.district,
                                                        child: new Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: new Text(
                                                                "${dvalue.district}",
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      _disV = value;
                                                      _onmmdasChanged(value!);

                                                      _newdistrictValues.map(
                                                          (DistrictsJson
                                                              ddvalue) {
                                                        if (ddvalue.district ==
                                                            value) {
                                                          setState(() {
                                                            _mmdV = ddvalue
                                                                .districtcode;
                                                            regSP?.setInt(
                                                                'mddasR',
                                                                _mmdV!);
                                                            regSP?.setString(
                                                                'mddasNameR',
                                                                _disV!);
                                                          });
                                                        }
                                                        print("MV"
                                                            "$_mmdV");
                                                      }).toString();

                                                      print("MVVV"
                                                          "$_mmdV");
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFFFFFFF),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text("Community"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.50, color: Color(0xFF000000)),
                                ),
                                // width: MediaQuery.of(context)
                                //         .size
                                //         .width /
                                //     1.09,
                                padding: EdgeInsets.all(6.0),
                                child: FutureBuilder<List<CommunityJson>>(
                                  future: mounted ? myCFuture : null,
                                  builder: (context,
                                      AsyncSnapshot<List<CommunityJson>>
                                          snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                fPrimaryColour),
                                      );
                                    else if (snapshot.hasData)
                                      return commfileExists
                                          ? Container(
                                              // width: MediaQuery.of(
                                              //             context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              child: StatefulBuilder(
                                                  builder: (context, state) {
                                                return DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                                    hint: Text(
                                                        widget.community ??
                                                            "community",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFfc1d20),
                                                          fontSize: 14,
                                                        )),
                                                    value: _community,
                                                    items: _commValues.map(
                                                        (CommunityJson dvalue) {
                                                      // fD = dvalue;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: dvalue.name,
                                                        child: new Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: new Text(
                                                                "${dvalue.name}",
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      _community = value;
                                                      _oncommChanged(value!);

                                                      print("Community"
                                                          "$_community");
                                                    },
                                                  ),
                                                );
                                              }),
                                            )
                                          : Container(
                                              // width: MediaQuery.of(
                                              //             context)
                                              //         .size
                                              //         .width /
                                              //     1.09,
                                              child: StatefulBuilder(
                                                  builder: (context, state) {
                                                return DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                                    hint: Text(
                                                        widget.community ??
                                                            "communityy",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFfc1d20),
                                                          fontSize: 14,
                                                        )),
                                                    value: _community,
                                                    items: _newcommValues.map(
                                                        (CommunityJson dvalue) {
                                                      // fD = dvalue;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: dvalue.name,
                                                        child: new Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: new Text(
                                                                "${dvalue.name}",
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      _community = value;
                                                      _oncommChanged(value!);

                                                      print("Community"
                                                          "$_community");
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 14.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type of Establishment"),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Text(
                                        widget.typeofEstablishment ??
                                            "typeOfEstablishment",
                                        style: TextStyle(
                                          color: Color(0xFFfc1d20),
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    new CheckboxListTile(
                      title: Text(
                        "Woodlot",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: _isWLchecked,
                      activeColor: fPrimaryColour,
                      onChanged: (bool? value) {
                        _onWLChanged(value!);
                      },
                    ),
                    new CheckboxListTile(
                      title: Text(
                        "Commercial plantation",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: _isCPchecked,
                      activeColor: fPrimaryColour,
                      onChanged: (bool? value) {
                        _onCPChanged(value!);
                      },
                    ),
                    new CheckboxListTile(
                      title: Text(
                        "Planted trees on farm",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: _isPTchecked,
                      activeColor: fPrimaryColour,
                      onChanged: (bool? value) {
                        _onPTChanged(value!);
                      },
                    ),
                    new CheckboxListTile(
                      title: Text(
                        "Naturally Occurring Trees",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: _isNOchecked,
                      activeColor: fPrimaryColour,
                      onChanged: (bool? value) {
                        _onNOChanged(value!);
                      },
                    ),
                    new CheckboxListTile(
                      title: Text(
                        "Fallow",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: _isFchecked,
                      activeColor: fPrimaryColour,
                      onChanged: (bool? value) {
                        _onFChanged(value!);
                      },
                    ),
                    new CheckboxListTile(
                      title: Text(
                        "Sacred Grove",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: _isSGchecked,
                      activeColor: fPrimaryColour,
                      onChanged: (bool? value) {
                        _onSGChanged(value!);
                        print("Val be $value");
                      },
                    ),
                    Column(
                      children: [
                        new CheckboxListTile(
                          title: Text(
                            "Others",
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
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 8.0),
                          child: TextFieldWidget(
                            readonly: _isOchecked == true ? false : true,
                            decoration: InputDecoration(
                              hintText: "(Specify)",
                              hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            ),labelText: "(Specify)",
                            controller: TextEditingController(),
                            validator: (input) =>
                                _establishment.contains("Other")
                                    ? input!.trim().isEmpty
                                        ? 'Please specify type of establishment'
                                        : null
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
