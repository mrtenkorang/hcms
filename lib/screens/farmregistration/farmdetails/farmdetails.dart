import 'dart:convert';
import 'dart:io';

import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/forestdistrict.dart';
import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
import 'package:hcms_revived2/models/apimodels/stool.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
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
  // URLs
  var districtsUrl = "$stageBaseUrl/districtapi/";
  var forestdistrictsUrl = "$stageBaseUrl/forestdistapi/";
  var stoolUrl = "$stageBaseUrl/stoolapi/";
  var commUrl = "$stageBaseUrl/communityapi/";
  var regionUrl = "$stageBaseUrl/regionapi/";

  // File management variables
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

  // Data lists
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

  // Form state variables
  final _formKey = GlobalKey<FormState>();
  final _communityName = TextEditingController();
  final _otherEstablishmentController = TextEditingController();

  String? _regionValue;
  String? _districtValue;
  String? _fdisV;
  String? _stoolV;
  String? _family;
  String? _disV;
  String? _community;
  int? _mmdV;

  bool boxChecked = false;
  List<String> _establishment = [];
  List<String> _commFound = [];

  // Establishment options with icons
  final List<Map<String, dynamic>> _establishmentOptions = [
    {
      'value': 'Woodlot',
      'label': 'Woodlot',
      'icon': Icons.forest,
      'color': Colors.green,
    },
    {
      'value': 'Commercial_Plantation',
      'label': 'Commercial Plantation',
      'icon': Icons.business_center,
      'color': Colors.blue,
    },
    {
      'value': 'Planted_trees_on_farm',
      'label': 'Planted Trees on Farm',
      'icon': Icons.agriculture,
      'color': Colors.orange,
    },
    {
      'value': 'Naturally_Occurring_trees',
      'label': 'Natural Trees',
      'icon': Icons.park,
      'color': Colors.teal,
    },
    {
      'value': 'Fallow',
      'label': 'Fallow Land',
      'icon': Icons.grass,
      'color': Colors.brown,
    },
    {
      'value': 'Sacred_Grove',
      'label': 'Sacred Grove',
      'icon': Icons.architecture,
      'color': Colors.purple,
    },
    {
      'value': 'Other',
      'label': 'Other',
      'icon': Icons.more_horiz,
      'color': Colors.grey,
    },
  ];

  // Exclusive establishment groups
  final List<String> _exclusiveGroup1 = ['Woodlot', 'Commercial_Plantation', 'Other'];
  final List<String> _exclusiveGroup2 = ['Planted_trees_on_farm', 'Naturally_Occurring_trees', 'Fallow', 'Sacred_Grove'];

  // File creation methods
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

  // File writing methods
  Future<List<DistrictsJson>> writeToDistrictFile(BuildContext ctx) async {
    debugPrint("Writing to district file!");
    if (districtfileExists) {
      debugPrint("District File exists $districtfileExists");
      try {
        var response = await http.get(Uri.parse(districtsUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var districtjsonFileContent = await json.decode(await districtjsonFile!.readAsString());
          districtjsonFileContent.clear();
          districtjsonFileContent.addAll(items);
          districtjsonFile?.writeAsString(json.encode(districtjsonFileContent));
        }
      } on SocketException {
        debugPrint("Error is first district");
      }
    } else {
      debugPrint("District File does not exist! $districtfileExists");
      try {
        var response = await http.get(Uri.parse(districtsUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createDistrictFile(items, dir!, districtfileName);
        } else {
          getLocalDistricts(ctx);
        }
      } on SocketException {
        getLocalDistricts(ctx);
      }
    }
    districtfileExists ? districtfileContent = await json.decode(await districtjsonFile!.readAsString()) : null;
    return districtfileExists ? _districtValues = districtfileContent.map<DistrictsJson>(DistrictsJson.fromJson).toList() : _newdistrictValues;
  }

  Future<List<ForestDistrictsJson>> writeToForestDistrictFile(BuildContext ctx) async {
    debugPrint("Writing to forest file! $forestdistrictfileExists");
    if (forestdistrictfileExists) {
      debugPrint("Forest file exists $forestdistrictfileExists");
      try {
        var response = await http.get(Uri.parse(forestdistrictsUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var forestdistrictjsonFileContent = await json.decode(await forestdistrictjsonFile!.readAsString());
          forestdistrictjsonFileContent.clear();
          forestdistrictjsonFileContent.addAll(items);
          forestdistrictjsonFile?.writeAsString(json.encode(forestdistrictjsonFileContent));
        }
      } on SocketException {
        debugPrint("Error is ");
      }
    } else {
      debugPrint("Forest File does not exist! $forestdistrictfileExists");
      try {
        var response = await http.get(Uri.parse(forestdistrictsUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createForestDistrictFile(items, dir!, forestdistrictfileName);
        } else {
          getLocalForestDistricts(ctx);
        }
      } on SocketException {
        getLocalForestDistricts(ctx);
      }
    }
    forestdistrictfileExists ? forestdistrictfileContent = await json.decode(await forestdistrictjsonFile!.readAsString()) : null;
    return forestdistrictfileExists ? _forestdistrictValues = forestdistrictfileContent.map<ForestDistrictsJson>(ForestDistrictsJson.fromJson).toList() : _newforestdistrictValues;
  }

  Future<List<StoolJson>> writeToStoolFile(BuildContext ctx) async {
    debugPrint("Writing to stool file! $stoolfileExists");
    if (stoolfileExists) {
      debugPrint("Stool File exists $stoolfileExists");
      try {
        var response = await http.get(Uri.parse(stoolUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var stooljsonFileContent = await json.decode(await stooljsonFile!.readAsString());
          stooljsonFileContent.clear();
          stooljsonFileContent.addAll(items);
          stooljsonFile?.writeAsString(json.encode(stooljsonFileContent));
        }
      } on SocketException {
        debugPrint("Error is first stool");
      }
    } else {
      debugPrint("Stool File does not exist! $stoolfileExists");
      try {
        var response = await http.get(Uri.parse(stoolUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createStoolFile(items, dir!, stoolfileName);
        } else {
          getLocalStoolValues(ctx);
        }
      } on SocketException {
        getLocalStoolValues(ctx);
      }
    }
    stoolfileExists ? stoolfileContent = await json.decode(await stooljsonFile!.readAsString()) : null;
    return stoolfileExists ? _stoolValues = stoolfileContent.map<StoolJson>(StoolJson.fromJson).toList() : _newstoolValues;
  }

  Future<List<CommunityJson>> writeToCommFile(BuildContext ctx) async {
    debugPrint("Writing to community file! $commfileExists");
    if (commfileExists) {
      debugPrint("Community File exists $commfileExists");
      try {
        var response = await http.get(Uri.parse(commUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var commjsonFileContent = await json.decode(await commjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile?.writeAsString(json.encode(commjsonFileContent));
        }
      } on SocketException {
        debugPrint("Error is first community");
      }
    } else {
      debugPrint("Community File does not exist! $commfileExists");
      try {
        var response = await http.get(Uri.parse(commUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createCommFile(items, dir!, commfileName);
        } else {
          getLocalCommValues(ctx);
        }
      } on SocketException {
        getLocalCommValues(ctx);
      }
    }
    commfileExists ? commfileContent = await json.decode(await commjsonFile!.readAsString()) : null;
    return commfileExists ? _commValues = commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList() : _newcommValues;
  }

  Future<List<RegionJson>> writeToRegionFile(BuildContext ctx) async {
    debugPrint("Writing to region file! $regionfileExists");
    if (regionfileExists) {
      debugPrint("Region File exists $regionfileExists");
      try {
        var response = await http.get(Uri.parse(regionUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var regionjsonFileContent = await json.decode(await regionjsonFile!.readAsString());
          regionjsonFileContent.clear();
          regionjsonFileContent.addAll(items);
          regionjsonFile?.writeAsString(json.encode(regionjsonFileContent));
        }
      } on SocketException {
        debugPrint("Error is first region");
      }
    } else {
      debugPrint("Region File does not exist! $regionfileExists");
      try {
        var response = await http.get(Uri.parse(regionUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createRegionFile(items, dir!, regionfileName);
        } else {
          getLocalRegionValues(ctx);
        }
      } on SocketException {
        getLocalRegionValues(ctx);
      }
    }
    regionfileExists ? regionfileContent = await json.decode(await regionjsonFile!.readAsString()) : null;
    return regionfileExists ? _regionValues = regionfileContent.map<RegionJson>(RegionJson.fromRegionJson).toList() : _newregionValues;
  }

  // Local data loading methods
  Future<List<DistrictsJson>> getLocalDistricts(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/districts.json');
    final body = json.decode(data);
    _newdistrictValues = body.map<DistrictsJson>(DistrictsJson.fromJson).toList();
    return _newdistrictValues;
  }

  Future<List<ForestDistrictsJson>> getLocalForestDistricts(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/forestdistrict.json');
    final body = json.decode(data);
    _newforestdistrictValues = body.map<ForestDistrictsJson>(ForestDistrictsJson.fromJson).toList();
    return _newforestdistrictValues;
  }

  Future<List<StoolJson>> getLocalStoolValues(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/stool.json');
    final body = json.decode(data);
    _newstoolValues = body.map<StoolJson>(StoolJson.fromJson).toList();
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

  // File initialization methods
  districtFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      districtjsonFile = File(dir!.path + "/" + districtfileName);
      districtfileExists = districtjsonFile!.existsSync();
      if (districtfileExists)
        districtfileContent = await json.decode(await districtjsonFile!.readAsString());
    });
    return districtfileContent;
  }

  forestdistrictFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      forestdistrictjsonFile = File(dir!.path + "/" + forestdistrictfileName);
      forestdistrictfileExists = forestdistrictjsonFile!.existsSync();
      if (forestdistrictfileExists)
        forestdistrictfileContent = await json.decode(await forestdistrictjsonFile!.readAsString());
    });
    return forestdistrictfileContent;
  }

  stoolFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      stooljsonFile = File(dir!.path + "/" + stoolfileName);
      stoolfileExists = stooljsonFile!.existsSync();
      if (stoolfileExists)
        stoolfileContent = await json.decode(await stooljsonFile!.readAsString());
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
        regionfileContent = await json.decode(await regionjsonFile!.readAsString());
    });
    return regionfileContent;
  }

  // Futures for async operations
  Future<List<DistrictsJson>>? myDFuture;
  Future<List<ForestDistrictsJson>>? myFDFuture;
  Future<List<StoolJson>>? mySFuture;
  Future<List<CommunityJson>>? myCFuture;
  Future<List<RegionJson>>? myRFuture;

  @override
  void initState() {
    super.initState();
    // Initialize file systems
    forestdistrictFileInit();
    stoolFileInit();
    districtFileInit();
    commFileInit();
    regionFileInit();

    // Initialize futures
    myDFuture = writeToDistrictFile(this.context);
    myFDFuture = writeToForestDistrictFile(this.context);
    mySFuture = writeToStoolFile(this.context);
    myCFuture = writeToCommFile(this.context);
    myRFuture = writeToRegionFile(this.context);

    _establishment = [];
  }

  // Establishment selection logic
  void _toggleEstablishment(String establishment) {
    setState(() {
      if (_establishment.contains(establishment)) {
        _establishment.remove(establishment);
        if (establishment == 'Other') {
          _otherEstablishmentController.clear();
        }
      } else {
        // Handle exclusive groups
        if (_exclusiveGroup1.contains(establishment)) {
          _establishment.removeWhere((item) => _exclusiveGroup1.contains(item));
        } else if (_exclusiveGroup2.contains(establishment)) {
          _establishment.removeWhere((item) => _exclusiveGroup2.contains(item));
        }

        _establishment.add(establishment);
      }
    });
  }

  bool _isEstablishmentSelected(String establishment) {
    return _establishment.contains(establishment);
  }

  // UI Components
  Widget _buildModernDropdown({
    required String title,
    required String? value,
    required List<dynamic> items,
    required Function(String?) onChanged,
    required String displayKey,
    bool isRequired = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: fPrimaryColour),
                elevation: 2,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select $title',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ),
                items: items.map<DropdownMenuItem<String>>((dynamic item) {
                  final displayValue = _getDisplayValue(item, displayKey);
                  return DropdownMenuItem<String>(
                    value: displayValue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        displayValue,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayValue(dynamic item, String key) {
    if (item is Map<String, dynamic>) {
      return item[key]?.toString() ?? '';
    }
    return item.toString();
  }

  Widget _buildEstablishmentChips() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                "Type of Establishment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Select the type of tree establishment (mutually exclusive groups)",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _establishmentOptions.map((option) {
              final isSelected = _isEstablishmentSelected(option['value']);
              final color = option['color'] as Color;

              return FilterChip(
                selected: isSelected,
                label: Text(
                  option['label'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                avatar: Icon(
                  option['icon'],
                  color: isSelected ? Colors.white : color,
                  size: 18,
                ),
                backgroundColor: Colors.grey[100],
                selectedColor: color,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? color : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                onSelected: (selected) {
                  _toggleEstablishment(option['value']);
                },
              );
            }).toList(),
          ),
          if (_establishment.contains('Other')) ...[
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: TextFieldWidget(
                controller: _otherEstablishmentController,
                decoration: InputDecoration(
                  labelText: "Specify other establishment type",
                  hintText: "Enter the type of establishment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: fPrimaryColour, width: 2),
                  ),
                ),
                validator: (input) {
                  if (_establishment.contains('Other') && (input == null || input.trim().isEmpty)) {
                    return 'Please specify the establishment type';
                  }
                  return null;
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                "Community",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!boxChecked)
            _buildModernDropdown(
              title: "",
              value: _community,
              items: commfileExists ? _commValues : _newcommValues,
              onChanged: (value) {
                setState(() {
                  _community = value;
                });
              },
              displayKey: 'name',
              isRequired: false,
            ),
          if (!boxChecked) const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: boxChecked,
                onChanged: (value) {
                  setState(() {
                    boxChecked = value!;
                    if (!boxChecked) {
                      _communityName.clear();
                    }
                  });
                },
                activeColor: fPrimaryColour,
              ),
              const Text(
                "Community not found in list",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (boxChecked) ...[
            const SizedBox(height: 12),
            TextFieldWidget(
              controller: _communityName,
              decoration: InputDecoration(
                labelText: "Enter Community Name",
                hintText: "Type the community name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: fPrimaryColour, width: 2),
                ),
              ),
              validator: (input) {
                if (boxChecked && (input == null || input.trim().isEmpty)) {
                  return 'Please enter the community name';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: 0.4, // 40% progress for farm details
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          const Text(
            "Step 2 of 5 - Farm Details",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: fPrimaryColour,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Continue to Farm Coordinates",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                regSP?.setBool("farmdetskipped", true);
                if (_establishment.isEmpty) {
                  overlayNotification('Please select type of establishment', "negative");
                } else {
                  _saveFormData();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => FarmCordinates(),
                    ),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: fPrimaryColour),
              ),
              child: Text(
                "Skip for Now",
                style: TextStyle(
                  color: fPrimaryColour,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndProceed() {
    if (_regionValue == null) {
      overlayNotification('Please select a region', "negative");
      return;
    }
    if (_districtValue == null) {
      overlayNotification('Please select a forest district', "negative");
      return;
    }
    if (_family == null) {
      overlayNotification('Please select a family', "negative");
      return;
    }
    if (_disV == null) {
      overlayNotification('Please select an MMDA', "negative");
      return;
    }
    if (_community == null && !boxChecked) {
      overlayNotification('Please select or enter a community', "negative");
      return;
    }
    if (_establishment.isEmpty) {
      overlayNotification('Please select type of establishment', "negative");
      return;
    }
    if (_formKey.currentState!.validate()) {
      regSP?.setBool("farmdetskipped", false);
      _saveFormData();
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (BuildContext context) => FarmCordinates(),
        ),
      );
    }
  }

  void _saveFormData() {
    regSP?.setString('region', _regionValue ?? "");
    regSP?.setString('forestDistrict', _districtValue ?? "");
    regSP?.setString('family', _family ?? "");
    regSP?.setInt('mddas', _mmdV ?? 0);
    regSP?.setString('mddasName', _disV ?? "");
    regSP?.setString('community', !boxChecked ? _community ?? "" : _communityName.text);
    regSP?.setStringList("est", _establishment);

    if (_establishment.contains('Other') && _otherEstablishmentController.text.isNotEmpty) {
      regSP?.setString('otherEstablishment', _otherEstablishmentController.text);
    }

    debugPrint("Farm details saved: $_establishment");
  }

  Widget _buildLoadingDropdown(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading $title...',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: fPrimaryColour,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Farm Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String choice) {
              if (choice == Constants.home) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const IndexPage()),
                );
              } else if (choice == Constants.load) {
                writeToStoolFile(context);
                writeToForestDistrictFile(context);
                writeToDistrictFile(context);
                writeToCommFile(context);
                writeToRegionFile(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => widget),
                );
              }
            },
            itemBuilder: (context) {
              return Constants.downChoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tree Farm Information",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Provide details about the location and type of your tree farm",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Region Dropdown
                    FutureBuilder<List<RegionJson>>(
                      future: myRFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingDropdown("Region");
                        }
                        return _buildModernDropdown(
                          title: "Region",
                          value: _regionValue,
                          items: regionfileExists ? _regionValues : _newregionValues,
                          onChanged: (value) {
                            setState(() {
                              _regionValue = value;
                            });
                          },
                          displayKey: 'name',
                        );
                      },
                    ),

                    // Forest District Dropdown
                    FutureBuilder<List<ForestDistrictsJson>>(
                      future: myFDFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingDropdown("Forest District");
                        }
                        return _buildModernDropdown(
                          title: "Forest District",
                          value: _fdisV,
                          items: forestdistrictfileExists ? _forestdistrictValues : _newforestdistrictValues,
                          onChanged: (value) {
                            setState(() {
                              _fdisV = value;
                              _districtValue = value;
                            });
                          },
                          displayKey: 'name',
                        );
                      },
                    ),

                    // Family/Stool Dropdown
                    FutureBuilder<List<StoolJson>>(
                      future: mySFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingDropdown("Family/Stool");
                        }
                        return _buildModernDropdown(
                          title: "TA/Stool/Skin/Family",
                          value: _stoolV,
                          items: stoolfileExists ? _stoolValues : _newstoolValues,
                          onChanged: (value) {
                            setState(() {
                              _stoolV = value;
                              _family = value;
                            });
                          },
                          displayKey: 'name',
                        );
                      },
                    ),

                    // MMDAs Dropdown
                    FutureBuilder<List<DistrictsJson>>(
                      future: myDFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingDropdown("MMDA");
                        }
                        return _buildModernDropdown(
                          title: "MMDA",
                          value: _disV,
                          items: districtfileExists ? _districtValues : _newdistrictValues,
                          onChanged: (value) {
                            setState(() {
                              _disV = value;
                              _districtValues.map((DistrictsJson ddvalue) {
                                if (ddvalue.district == value) {
                                  setState(() {
                                    _mmdV = ddvalue.districtcode;
                                  });
                                }
                              }).toString();
                            });
                          },
                          displayKey: 'district',
                        );
                      },
                    ),

                    // Community Section
                    FutureBuilder<List<CommunityJson>>(
                      future: myCFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingDropdown("Community");
                        }
                        return _buildCommunitySection();
                      },
                    ),

                    // Establishment Chips
                    _buildEstablishmentChips(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
}