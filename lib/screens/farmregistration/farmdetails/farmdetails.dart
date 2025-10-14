import 'dart:convert';
import 'dart:io';

import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/forestdistrict.dart';
import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
import 'package:hcms_revived2/models/apimodels/stool.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/apimodels/districtmodel.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmcordinates.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import '../../../main.dart';

class FarmDetails extends StatefulWidget {
  @override
  _FarmDetailsState createState() => _FarmDetailsState();
}

class _FarmDetailsState extends State<FarmDetails> {
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
    debugPrint("Creating district file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    districtfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createForestDistrictFile(var content, Directory dir, String fileName) {
    debugPrint("Creating forest district file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    forestdistrictfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createStoolFile(var content, Directory dir, String fileName) {
    debugPrint("Creating stool file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    stoolfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createCommFile(var content, Directory dir, String fileName) {
    debugPrint("Creating Community file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createRegionFile(var content, Directory dir, String fileName) {
    debugPrint("Creating Region file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    regionfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<DistrictsJson>> writeToDistrictFile(BuildContext ctx) async {
    debugPrint("Writing to district file!");
    if (districtfileExists) {
      debugPrint("District File exists $districtfileExists");

      try {
        var response = await http.get(Uri.parse(districtsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("district");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var districtjsonFileContent =
              await json.decode(await districtjsonFile!.readAsString());
          districtjsonFileContent.clear();
          districtjsonFileContent.addAll(items);
          districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is first district");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      debugPrint("District File does not exist! $districtfileExists");
      try {
        var response = await http.get(Uri.parse(districtsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("District");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createDistrictFile(items, dir!, districtfileName);

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
          getLocalDistricts(ctx);
        }
      } on SocketException {
        debugPrint("Error is second district");
        getLocalDistricts(ctx);
      }
    }
    districtfileExists
        ? districtfileContent =
            await json.decode(await districtjsonFile!.readAsString())
        : null;
    debugPrint(districtfileContent);

    return districtfileExists
        ? _districtValues = districtfileContent
            .map<DistrictsJson>(DistrictsJson.fromJson)
            .toList()
        : _newdistrictValues;
  }

  Future<List<ForestDistrictsJson>> writeToForestDistrictFile(
      BuildContext ctx) async {
    debugPrint("Writing to forest file! $forestdistrictfileExists");
    if (forestdistrictfileExists) {
      debugPrint("Forest file exists $forestdistrictfileExists");

      try {
        var response = await http.get(Uri.parse(forestdistrictsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Forest");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var forestdistrictjsonFileContent =
              await json.decode(await forestdistrictjsonFile!.readAsString());
          forestdistrictjsonFileContent.clear();
          forestdistrictjsonFileContent.addAll(items);
          forestdistrictjsonFile
              ?.writeAsString(json.encode(forestdistrictjsonFileContent));

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is ");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      debugPrint("Forest File does not exist! $forestdistrictfileExists");
      try {
        var response = await http.get(Uri.parse(forestdistrictsUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Forest");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createForestDistrictFile(items, dir!, forestdistrictfileName);

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
          getLocalForestDistricts(ctx);
        }
      } on SocketException {
        debugPrint("Error is ");
        getLocalForestDistricts(ctx);
      }
    }
    forestdistrictfileExists
        ? forestdistrictfileContent =
            await json.decode(await forestdistrictjsonFile!.readAsString())
        : null;
    debugPrint(forestdistrictfileContent);

    return forestdistrictfileExists
        ? _forestdistrictValues = forestdistrictfileContent
            .map<ForestDistrictsJson>(ForestDistrictsJson.fromJson)
            .toList()
        : _newforestdistrictValues;
  }

  Future<List<StoolJson>> writeToStoolFile(BuildContext ctx) async {
    debugPrint("Writing to stool file! $stoolfileExists");
    if (stoolfileExists) {
      debugPrint("Stool File exists $stoolfileExists");

      try {
        var response = await http.get(Uri.parse(stoolUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Stool");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var stooljsonFileContent =
              await json.decode(await stooljsonFile!.readAsString());
          stooljsonFileContent.clear();
          stooljsonFileContent.addAll(items);
          stooljsonFile?.writeAsString(json.encode(stooljsonFileContent));

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is first stool");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      debugPrint("Stool File does not exist! $stoolfileExists");
      try {
        var response = await http.get(Uri.parse(stoolUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("stool");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createStoolFile(items, dir!, stoolfileName);

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
          getLocalStoolValues(ctx);
        }
      } on SocketException {
        debugPrint("Error is second stool");
        getLocalStoolValues(ctx);
      }
    }
    stoolfileExists
        ? stoolfileContent =
            await json.decode(await stooljsonFile!.readAsString())
        : null;
    debugPrint(stoolfileContent);

    return stoolfileExists
        ? _stoolValues =
            stoolfileContent.map<StoolJson>(StoolJson.fromJson).toList()
        : _newstoolValues;
  }

  Future<List<CommunityJson>> writeToCommFile(BuildContext ctx) async {
    debugPrint("Writing to community file! $commfileExists");
    if (commfileExists) {
      debugPrint("Community File exists $commfileExists");

      try {
        var response = await http.get(Uri.parse(commUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Community");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var commjsonFileContent =
              await json.decode(await commjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile?.writeAsString(json.encode(commjsonFileContent));

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
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

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
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
    debugPrint(commfileContent);

    return commfileExists
        ? _commValues =
            commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList()
        : _newcommValues;
  }

  Future<List<RegionJson>> writeToRegionFile(BuildContext ctx) async {
    debugPrint("Writing to region file! $regionfileExists");
    if (regionfileExists) {
      debugPrint("Region File exists $regionfileExists");

      try {
        var response = await http.get(Uri.parse(regionUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Region");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          var regionjsonFileContent =
              await json.decode(await regionjsonFile!.readAsString());
          regionjsonFileContent.clear();
          regionjsonFileContent.addAll(items);
          regionjsonFile?.writeAsString(json.encode(regionjsonFileContent));

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
        }
      } on SocketException {
        debugPrint("Error is first region");
      }

      // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
      // districtjsonFileContent.addAll(content);
      // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

      // createFile(content, dir, districtfileName);
    } else {
      debugPrint("Region File does not exist! $regionfileExists");
      try {
        var response = await http.get(Uri.parse(regionUrl));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          debugPrint("Region");

          debugPrint("content $items");
          debugPrint("object");

          // var content = {key: items};

          // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
          // districtjsonFileContent.clear();
          // districtjsonFileContent.addAll(items);
          // districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));

          createRegionFile(items, dir!, regionfileName);

          // debugPrint("contennttss ${listOfRegions.runtimeType}");
        } else {
          debugPrint("didn't work here");
          getLocalRegionValues(ctx);
        }
      } on SocketException {
        debugPrint("Error is second region");
        getLocalRegionValues(ctx);
      }
    }
    regionfileExists
        ? regionfileContent =
            await json.decode(await regionjsonFile!.readAsString())
        : null;
    debugPrint(regionfileContent);

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
    debugPrint("doing clocal comm");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/community.json');
    final body = json.decode(data);

    _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();

    return _newcommValues;
  }

  Future<List<RegionJson>> getLocalRegionValues(BuildContext context) async {
    debugPrint("doing local region");
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/region.json');
    final body = json.decode(data);

    _newregionValues = body.map<RegionJson>(RegionJson.fromRegionJson).toList();

    return _newregionValues;
  }

  final _formKey = GlobalKey<FormState>();

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

  void setFDValuesT() {
    regSP?.setString('region', _regionValue ?? "");
    regSP?.setString('forestDistrict', _districtValue ?? "");
    regSP?.setString('family', _family ?? "");
    regSP?.setInt('mddas', _mmdV ?? 0);
    regSP?.setString('mddasName', _disV ?? "");
    regSP?.setString(
        'community', !boxChecked ? _community ?? "" : _communityName.text);
    regSP?.setStringList("est", _establishment);

    debugPrint("Tree Information values gotten!");
  }

  void _onRegionChanged(String regVal) {
    setState(() {
      _regionValue = regVal;
    });
  }

  void _onDistrictChanged(String disVal) {
    setState(() {
      _districtValue = disVal;
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
    });
  }

  void _oncommChanged(String commVal) {
    setState(() {
      _community = commVal;
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
      debugPrint("Val be $val");

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
      districtjsonFile = File(dir!.path + "/" + districtfileName);
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
      forestdistrictjsonFile = File(dir!.path + "/" + forestdistrictfileName);
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
      stooljsonFile = File(dir!.path + "/" + stoolfileName);
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
      commjsonFile = File(dir!.path + "/" + commfileName);
      commfileExists = commjsonFile!.existsSync();
      if (commfileExists)
        commfileContent = await json.decode(await commjsonFile!.readAsString());
    });

    return commfileContent;
  }

  regionFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      regionjsonFile = File(dir!.path + "/" + regionfileName);
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

    // _mmdas = 96;
    reg = "Western Region";
    fD = "First";

    _establishment = [];
  }

  final _communityName = TextEditingController();
  List<String> _commFound = [];
  bool boxChecked = false;

  oncSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _commFound.add(selectedEst);
      } else {
        _commFound.remove(selectedEst);
      }
    });
  }

  void _onComChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColour,
      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: Text(
      //     "Registration of Planted Trees",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == Constants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.load) {
      //           writeToStoolFile(context);
      //           writeToForestDistrictFile(context);
      //           writeToDistrictFile(context);
      //           writeToCommFile(context);
      //           writeToRegionFile(context);

      //           Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => this.widget));
      //           // setState(() {
      //           //   getApplicationDocumentsDirectory().then(
      //           //     (Directory directory) async {
      //           //       dir = directory;
      //           //       districtjsonFile =
      //           //           new File(dir!.path + "/" + districtfileName);
      //           //       districtfileExists = await districtjsonFile.exists();
      //           //       forestdistrictjsonFile =
      //           //           new File(dir!.path + "/" + forestdistrictfileName);
      //           //       forestdistrictfileExists =
      //           //           await forestdistrictjsonFile.exists();
      //           //       stooljsonFile = new File(dir!.path + "/" + stoolfileName);
      //           //       stoolfileExists = await stooljsonFile.exists();

      //           //       if (forestdistrictfileExists &&
      //           //           districtfileExists &&
      //           //           stoolfileExists) {
      //           //         forestdistrictfileContent = await json.decode(
      //           //             await forestdistrictjsonFile!.readAsString());

      //           //         districtfileContent = await json
      //           //             .decode(await districtjsonFile!.readAsString());

      //           //         stoolfileContent = await json
      //           //             .decode(await stooljsonFile!.readAsString());
      //           //       }
      //           //       //else {}
      //           //       // if (districtfileExists) {
      //           //       //   districtfileContent =
      //           //       //       await json.decode(await districtjsonFile!.readAsString());
      //           //       // } else {}
      //           //       // if (stoolfileExists) {
      //           //       //   stoolfileContent =
      //           //       //       await json.decode(await stooljsonFile!.readAsString());
      //           //       // } else {}
      //           //     },
      //           //   );
      //           // });
      //         } else if (_downChoice == Constants.saveskip) {
      //           regSP?.setBool("farmdetskipped", true);
      //           if (_establishment.isEmpty) {
      //             overlayNotification(
      //                 'Please select type of establishment', "negative");
      //           } else {
      //             setFDValuesT();
      //             Navigator.of(context).push(
      //               CupertinoPageRoute(
      //                 builder: (BuildContext context) => FarmCordinates(),
      //               ),
      //             );

      //             debugPrint("Selected types are $_establishment");
      //           }
      //         } else if (_downChoice == Constants.saveclose) {
      //           // regSP?.setBool("closed", true);
      //           // setFDValuesT();
      //           // Navigator.of(context).push(
      //           //   CupertinoPageRoute(
      //           //     builder: (BuildContext context) => FarmCordinates(),
      //           //   ),
      //           // );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return Constants.downChoices.map((String _downChoice) {
      //           return PopupMenuItem<String>(
      //             value: _downChoice,
      //             child: Container(
      //               margin: EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: TextStyle(color: Color(0xFFFFFFFF)),
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
                  "Farm Details".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                PopupMenuButton<String>(
                  offset: const Offset(2.00, 3.00),
                  color: Colors.black,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: primaryWhite,
                    size: 40.0,
                  ),
                  onSelected: (String downChoice) {
                    if (downChoice == Constants.home) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      );
                    } else if (downChoice == Constants.load) {
                      writeToStoolFile(context);
                      writeToForestDistrictFile(context);
                      writeToDistrictFile(context);
                      writeToCommFile(context);
                      writeToRegionFile(context);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => widget));
                    } else if (downChoice == Constants.saveskip) {
                      regSP?.setBool("farmdetskipped", true);
                      if (_establishment.isEmpty) {
                        overlayNotification(
                            'Please select type of establishment', "negative");
                      } else {
                        setFDValuesT();
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (BuildContext context) => FarmCordinates(),
                          ),
                        );

                        debugPrint("Selected types are $_establishment");
                      }
                    } else if (downChoice == Constants.saveclose) {
                      // regSP?.setBool("closed", true);
                      // setFDValuesT();
                      // Navigator.of(context).push(
                      //   CupertinoPageRoute(
                      //     builder: (BuildContext context) => FarmCordinates(),
                      //   ),
                      // );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.downChoices.map((String downChoice) {
                      return PopupMenuItem<String>(
                        value: downChoice,
                        child: Container(
                          margin: const EdgeInsets.only(right: 0),
                          child: Text(
                            downChoice,
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
              height: size.height * .85,
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              child: SingleChildScrollView(
                child: Container(
                  // height: size.height,
                  margin: const EdgeInsets.all(0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: fDefaultPadding),
                                child: Center(
                                  child: Text(
                                    "Tree Farm Information",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                color: const Color(0xFFFFFFFF),
                                child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Row(
                                          //   children: <Widget>[
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //         bottom: 14.0,
                                          //       ),
                                          //       child: Row(
                                          //         children: <Widget>[
                                          //           Text("Select Region"),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

                                          formFieldLabel(width: size.width * .9, "Select region"),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.50,
                                                      color: const Color(
                                                          0xFF000000)),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                                // width:
                                                //     MediaQuery.of(context).size.width /
                                                //         1.09,
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: FutureBuilder<
                                                    List<RegionJson>>(
                                                  future: mounted
                                                      ? myRFuture
                                                      : null,
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              List<RegionJson>>
                                                          snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                fPrimaryColour),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      return regionfileExists
                                                          ? SizedBox(
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
                                                                      DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        _regionValue,
                                                                    items: _regionValues.map(
                                                                        (RegionJson
                                                                            dvalue) {
                                                                      // fD = dvalue;
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: dvalue
                                                                            .name,
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Text(
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
                                                                      _onRegionChanged(
                                                                          value!);
                                                                      // fD = value;
                                                                      // debugPrint(_districtValues
                                                                      //     .elementAt(_districtValues
                                                                      //         .indexOf(value))
                                                                      //     .districtcode);
                                                                      // _districtValues.map(
                                                                      //     (DistrictsJson
                                                                      //         ddvalue) {
                                                                      //   if (ddvalue.district ==
                                                                      //       value) {
                                                                      //     debugPrint(ddvalue
                                                                      //         .districtcode);
                                                                      //   }
                                                                      // }).toString();
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            )
                                                          : SizedBox(
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
                                                                      DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        _regionValue,
                                                                    items: _newregionValues.map(
                                                                        (RegionJson
                                                                            dvalue) {
                                                                      // fD = dvalue;
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: dvalue
                                                                            .name,
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Text(
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
                                                                      _onRegionChanged(
                                                                          value!);
                                                                      // fD = value;
                                                                      // debugPrint(_districtValues
                                                                      //     .elementAt(_districtValues
                                                                      //         .indexOf(value))
                                                                      //     .districtcode);
                                                                      // _districtValues.map(
                                                                      //     (DistrictsJson
                                                                      //         ddvalue) {
                                                                      //   if (ddvalue.district ==
                                                                      //       value) {
                                                                      //     debugPrint(ddvalue
                                                                      //         .districtcode);
                                                                      //   }
                                                                      // }).toString();
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                    } else {
                                                      return const Text(
                                                        "Please sync data",
                                                      );
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ])),
                              ),
                              Container(
                                color: const Color(0xFFFFFFFF),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 8.0,
                                        right: 8.0,
                                        bottom: 18.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Row(
                                          //   children: <Widget>[
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //         bottom: 14.0,
                                          //       ),
                                          //       child: Row(
                                          //         children: <Widget>[
                                          //           Text("Select Forest District"),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          formFieldLabel(width: size.width * .9, 
                                              "Select Forest District"),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.50,
                                                      color: const Color(
                                                          0xFF000000)),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                                // width:
                                                //     MediaQuery.of(context).size.width /
                                                //         1.09,
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: FutureBuilder<
                                                    List<ForestDistrictsJson>>(
                                                  future: mounted
                                                      ? myFDFuture
                                                      : null,
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              List<
                                                                  ForestDistrictsJson>>
                                                          snapshot) {
                                                    if (!snapshot.hasData)
                                                      return const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                fPrimaryColour),
                                                      );
                                                    else if (snapshot.hasData)
                                                      return forestdistrictfileExists
                                                          ? SizedBox(
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
                                                                      DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        _fdisV,
                                                                    items: _forestdistrictValues.map(
                                                                        (ForestDistrictsJson
                                                                            dvalue) {
                                                                      // fD = dvalue;
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: dvalue
                                                                            .name,
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Text(
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
                                                                      _fdisV =
                                                                          value;
                                                                      _onDistrictChanged(
                                                                          value!);
                                                                      // fD = value;
                                                                      // debugPrint(_districtValues
                                                                      //     .elementAt(_districtValues
                                                                      //         .indexOf(value))
                                                                      //     .districtcode);
                                                                      // _districtValues.map(
                                                                      //     (DistrictsJson
                                                                      //         ddvalue) {
                                                                      //   if (ddvalue.district ==
                                                                      //       value) {
                                                                      //     debugPrint(ddvalue
                                                                      //         .districtcode);
                                                                      //   }
                                                                      // }).toString();
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            )
                                                          : SizedBox(
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
                                                                      DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        _fdisV,
                                                                    items: _newforestdistrictValues.map(
                                                                        (ForestDistrictsJson
                                                                            dvalue) {
                                                                      // fD = dvalue;
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: dvalue
                                                                            .name,
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Text(
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
                                                                      _fdisV =
                                                                          value;
                                                                      _onDistrictChanged(
                                                                          value!);
                                                                      // fD = value;
                                                                      // debugPrint(_districtValues
                                                                      //     .elementAt(_districtValues
                                                                      //         .indexOf(value))
                                                                      //     .districtcode);
                                                                      // _districtValues.map(
                                                                      //     (DistrictsJson
                                                                      //         ddvalue) {
                                                                      //   if (ddvalue.district ==
                                                                      //       value) {
                                                                      //     debugPrint(ddvalue
                                                                      //         .districtcode);
                                                                      //   }
                                                                      // }).toString();
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                    else
                                                      return const Text(
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
                              const SizedBox(
                                height: 30,
                                child: Divider(
                                  color: Colors.transparent,
                                ),
                              ),
                              Container(
                                color: const Color(0xFFFFFFFF),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   children: <Widget>[
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //         bottom: 14.0,
                                          //       ),
                                          //       child: Row(
                                          //         children: <Widget>[
                                          //           Text("TA/Stool/Skin/Family"),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

                                          formFieldLabel(width: size.width * .9, 
                                              "TA/Stool/Skin/Family"),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.50,
                                                      color: const Color(
                                                          0xFF000000)),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width /
                                                //     1.09,
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: FutureBuilder<
                                                    List<StoolJson>>(
                                                  future: mounted
                                                      ? mySFuture
                                                      : null,
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData)
                                                      return const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                fPrimaryColour),
                                                      );
                                                    else if (snapshot.hasData)
                                                      return stoolfileExists
                                                          ? SizedBox(
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
                                                                      DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        _stoolV,
                                                                    items: _stoolValues.map(
                                                                        (StoolJson
                                                                            dvalue) {
                                                                      // fD = dvalue;
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: dvalue
                                                                            .name,
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Text(
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
                                                                      _stoolV =
                                                                          value;
                                                                      _onstoolChanged(
                                                                          value!);
                                                                      // fD = value;
                                                                      // debugPrint(_districtValues
                                                                      //     .elementAt(_districtValues
                                                                      //         .indexOf(value))
                                                                      //     .districtcode);
                                                                      // _districtValues.map(
                                                                      //     (DistrictsJson
                                                                      //         ddvalue) {
                                                                      //   if (ddvalue.district ==
                                                                      //       value) {
                                                                      //     debugPrint(ddvalue
                                                                      //         .districtcode);
                                                                      //   }
                                                                      // }).toString();
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            )
                                                          : SizedBox(
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
                                                                      DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        _stoolV,
                                                                    items: _newstoolValues.map(
                                                                        (StoolJson
                                                                            dvalue) {
                                                                      // fD = dvalue;
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: dvalue
                                                                            .name,
                                                                        child:
                                                                            Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Text(
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
                                                                      _stoolV =
                                                                          value;
                                                                      _onstoolChanged(
                                                                          value!);
                                                                      // fD = value;
                                                                      // debugPrint(_districtValues
                                                                      //     .elementAt(_districtValues
                                                                      //         .indexOf(value))
                                                                      //     .districtcode);
                                                                      // _districtValues.map(
                                                                      //     (DistrictsJson
                                                                      //         ddvalue) {
                                                                      //   if (ddvalue.district ==
                                                                      //       value) {
                                                                      //     debugPrint(ddvalue
                                                                      //         .districtcode);
                                                                      //   }
                                                                      // }).toString();
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                    else
                                                      return const Text(
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
                                      color: const Color(0xFFFFFFFF),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 18.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // Row(
                                                //   children: <Widget>[
                                                //     Container(
                                                //       margin: EdgeInsets.only(
                                                //         bottom: 14.0,
                                                //       ),
                                                //       child: Row(
                                                //         children: <Widget>[
                                                //           Text("Select MMDAs"),
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                formFieldLabel(width: size.width * .9, "Select MMDAs"),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.50,
                                                            color: const Color(
                                                                0xFF000000)),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15.0)),
                                                      ),
                                                      // width: MediaQuery.of(context)
                                                      //         .size
                                                      //         .width /
                                                      //     1.09,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: FutureBuilder<
                                                          List<DistrictsJson>>(
                                                        future: mounted
                                                            ? myDFuture
                                                            : null,
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    List<
                                                                        DistrictsJson>>
                                                                snapshot) {
                                                          if (!snapshot.hasData)
                                                            return const CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      fPrimaryColour),
                                                            );
                                                          else if (snapshot
                                                              .hasData)
                                                            return districtfileExists
                                                                ? SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.09,
                                                                    child: StatefulBuilder(builder:
                                                                        (context,
                                                                            state) {
                                                                      return DropdownButtonHideUnderline(
                                                                        child: DropdownButton<
                                                                            String>(
                                                                          value:
                                                                              _disV,
                                                                          items:
                                                                              _districtValues.map((DistrictsJson dvalue) {
                                                                            // fD = dvalue;
                                                                            return DropdownMenuItem<String>(
                                                                              value: dvalue.district,
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                    child: Text(
                                                                                      "${dvalue.district}",
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                          onChanged:
                                                                              (String? value) {
                                                                            _disV =
                                                                                value;
                                                                            _onmmdasChanged(value!);
                                                                            fD =
                                                                                value;
                                                                            _districtValues.map((DistrictsJson
                                                                                ddvalue) {
                                                                              if (ddvalue.district == value) {
                                                                                setState(() {
                                                                                  _mmdV = ddvalue.districtcode;
                                                                                });
                                                                              }
                                                                              debugPrint("MV"
                                                                                  "$_mmdV");
                                                                            }).toString();

                                                                            debugPrint("MVVV"
                                                                                "$_mmdV");
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  )
                                                                : SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.09,
                                                                    child: StatefulBuilder(builder:
                                                                        (context,
                                                                            state) {
                                                                      return DropdownButtonHideUnderline(
                                                                        child: DropdownButton<
                                                                            String>(
                                                                          value:
                                                                              _disV,
                                                                          items:
                                                                              _newdistrictValues.map((DistrictsJson dvalue) {
                                                                            // fD = dvalue;
                                                                            return DropdownMenuItem<String>(
                                                                              value: dvalue.district,
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                    child: Text(
                                                                                      "${dvalue.district}",
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                          onChanged:
                                                                              (String? value) {
                                                                            _disV =
                                                                                value;
                                                                            _onmmdasChanged(value!);

                                                                            _newdistrictValues.map((DistrictsJson
                                                                                ddvalue) {
                                                                              if (ddvalue.district == value) {
                                                                                setState(() {
                                                                                  _mmdV = ddvalue.districtcode;
                                                                                });
                                                                              }
                                                                              debugPrint("MV"
                                                                                  "$_mmdV");
                                                                            }).toString();

                                                                            debugPrint("MVVV"
                                                                                "$_mmdV");
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                          else
                                                            return const Text(
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
                                    !boxChecked
                                        ? Container(
                                            color: const Color(0xFFFFFFFF),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 8.0,
                                                    right: 8.0,
                                                    bottom: 18.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      // Row(
                                                      //   children: <Widget>[
                                                      //     Container(
                                                      //       margin: EdgeInsets.only(
                                                      //         bottom: 14.0,
                                                      //       ),
                                                      //       child: Row(
                                                      //         children: <Widget>[
                                                      //           Text(
                                                      //               "Select Community"),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      formFieldLabel(width: size.width * .9, 
                                                          "Select community"),
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 0.50,
                                                                  color: const Color(
                                                                      0xFF000000)),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          15.0)),
                                                            ),
                                                            // width: MediaQuery.of(context)
                                                            //         .size
                                                            //         .width /
                                                            //     1.09,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6.0),
                                                            child: FutureBuilder<
                                                                List<
                                                                    CommunityJson>>(
                                                              future: mounted
                                                                  ? myCFuture
                                                                  : null,
                                                              builder: (context,
                                                                  AsyncSnapshot<
                                                                          List<
                                                                              CommunityJson>>
                                                                      snapshot) {
                                                                if (!snapshot
                                                                    .hasData)
                                                                  return const CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<Color>(
                                                                            fPrimaryColour),
                                                                  );
                                                                else if (snapshot
                                                                    .hasData)
                                                                  return commfileExists
                                                                      ? SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 1.09,
                                                                          child:
                                                                              StatefulBuilder(builder: (context, state) {
                                                                            return DropdownButtonHideUnderline(
                                                                              child: DropdownButton<String>(
                                                                                value: _community,
                                                                                items: _commValues.map((CommunityJson dvalue) {
                                                                                  // fD = dvalue;
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: dvalue.name,
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: Text(
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

                                                                                  debugPrint("Community"
                                                                                      "$_community");
                                                                                },
                                                                              ),
                                                                            );
                                                                          }),
                                                                        )
                                                                      : SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 1.09,
                                                                          child:
                                                                              StatefulBuilder(builder: (context, state) {
                                                                            return DropdownButtonHideUnderline(
                                                                              child: DropdownButton<String>(
                                                                                value: _community,
                                                                                items: _newcommValues.map((CommunityJson dvalue) {
                                                                                  // fD = dvalue;
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: dvalue.name,
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: Text(
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

                                                                                  debugPrint("Community"
                                                                                      "$_community");
                                                                                },
                                                                              ),
                                                                            );
                                                                          }),
                                                                        );
                                                                else
                                                                  return const Text(
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
                                          )
                                        : const SizedBox(),
                                    CheckboxListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8),
                                      title: const Text(
                                        "Check box if community not found",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: boxChecked,
                                      activeColor: fPrimaryColour,
                                      onChanged: (bool? value) {
                                        _onComChanged(value!);
                                      },
                                    ),
                                    boxChecked
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 8.0),
                                            child: TextFieldWidget(
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  labelText:
                                                      "(Enter community if not found)"),
                                              controller: _communityName,
                                              validator: (input) =>
                                                  input!.trim().isEmpty
                                                      ? 'Please enter community'
                                                      : null,
                                              readonly: boxChecked
                                                  ? false
                                                  : boxChecked,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                                child: Divider(
                                  color: Colors.transparent,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: const Color(0xFFFFFFFF),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      bottom: 14.0,
                                                    ),
                                                    child: const Row(
                                                      children: <Widget>[
                                                        Text(
                                                            "Type of Establishment"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
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
                                              CheckboxListTile(
                                                title: const Text(
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
                                              CheckboxListTile(
                                                title: const Text(
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
                                              CheckboxListTile(
                                                title: const Text(
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
                                              CheckboxListTile(
                                                title: const Text(
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
                                              CheckboxListTile(
                                                title: const Text(
                                                  "Sacred Grove",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                value: _isSGchecked,
                                                activeColor: fPrimaryColour,
                                                onChanged: (bool? value) {
                                                  _onSGChanged(value!);
                                                  debugPrint("Val be $value");
                                                },
                                              ),
                                              Column(
                                                children: [
                                                  CheckboxListTile(
                                                    title: const Text(
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
                                                      labelText: "(Specify)",
                                                      controller:
                                                          TextEditingController(),
                                                      validator: (input) =>
                                                          _establishment
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
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 50.00,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      fPrimaryColour,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      color: Colors.white),
                                                  // shadowColor: fPrimaryColour,
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: fPrimaryColour),
                                                ),
                                                child: const Text(
                                                  "Next",
                                                  style: TextStyle(
                                                      color: fPrimaryWhite,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                onPressed: () async {
                                                  if (_regionValue == null) {
                                                    overlayNotification(
                                                        'Please select a region',
                                                        "negative");
                                                  } else if (_districtValue ==
                                                      null) {
                                                    overlayNotification(
                                                        'Please select a forest district',
                                                        "negative");
                                                  } else if (_family == null) {
                                                    overlayNotification(
                                                        'Please select a family',
                                                        "negative");
                                                  } else if (_mmdas == null) {
                                                    overlayNotification(
                                                        'Please select an MMDA',
                                                        "negative");
                                                  } else if (_community ==
                                                          null &&
                                                      !boxChecked) {
                                                    overlayNotification(
                                                        'Please select a community',
                                                        "negative");
                                                  } else if (_establishment
                                                      .isEmpty) {
                                                    overlayNotification(
                                                        'Please select type of establishment',
                                                        "negative");
                                                  } else if (_formKey
                                                      .currentState!
                                                      .validate()) {
                                                    regSP?.setBool(
                                                        "farmdetskipped",
                                                        false);
                                                    setFDValuesT();
                                                    Navigator.of(context).push(
                                                      CupertinoPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            FarmCordinates(),
                                                      ),
                                                    );
                                                    debugPrint(
                                                        "Selected types are $_establishment");

                                                    debugPrint(
                                                        "Selected types are ${_establishment.contains("Woodlot")}");
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 50.00,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      fPrimaryColour,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  textStyle: const TextStyle(
                                                      color: Colors.white),
                                                  // shadowColor: fPrimaryColour,
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: fPrimaryColour),
                                                ),
                                                child: const Text(
                                                  "Skip",
                                                  style: TextStyle(
                                                      color: fPrimaryWhite,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                onPressed: () async {
                                                  regSP?.setBool(
                                                      "farmdetskipped", true);
                                                  if (_establishment.isEmpty) {
                                                    overlayNotification(
                                                        'Please select type of establishment',
                                                        "negative");
                                                  } else {
                                                    setFDValuesT();
                                                    Navigator.of(context).push(
                                                      CupertinoPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            FarmCordinates(),
                                                      ),
                                                    );

                                                    debugPrint(
                                                        "Selected types are $_establishment");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
