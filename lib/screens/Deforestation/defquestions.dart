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
    var count = await db.rawQuery(
      'SELECT enumeratorValue FROM first_time_user',
    );

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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Reporting Deforestation",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please wait...",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  File? commjsonFile;
  Directory? dir;
  String commfileName = "community.json";
  bool commfileExists = false;
  var commfileContent;
  List<CommunityJson> _newcommValues = [];
  List<CommunityJson> _commValues = [];

  final _pn = TextEditingController();
  final _species = TextEditingController();
  final _whyAction = TextEditingController();
  final _otherCauseController = TextEditingController();
  final _communityName = TextEditingController();

  String? _gfwDirection;
  String? _seeDeforestation;
  String? _actionRequired;

  bool _isBBChecked = false;
  bool _isMChecked = false;
  bool _isLChecked = false;
  bool _isFChecked = false;
  bool _isCPChecked = false;
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

          var commjsonFileContent = await json.decode(
            await commjsonFile!.readAsString(),
          );
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile?.writeAsString(json.encode(commjsonFileContent));
        } else {
          debugPrint("didn't work here");
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
          debugPrint("Community");

          debugPrint("content $items");
          debugPrint("object");

          createCommFile(items, dir!, commfileName);
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
        ? commfileContent = await json.decode(
            await commjsonFile!.readAsString(),
          )
        : null;
    debugPrint(commfileContent.toString());

    return commfileExists
        ? _commValues = commfileContent
              .map<CommunityJson>(CommunityJson.fromJson)
              .toList()
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

  bool boxChecked = false;

  void _onComChanged(bool val) {
    setState(() {
      boxChecked = val;
    });
  }

  List<String> _deforestationCause = [];

  void toggleCause(String cause, bool value) {
    setState(() {
      if (value) {
        _deforestationCause.add(cause);
      } else {
        _deforestationCause.remove(cause);
      }
    });
  }

  void _onBBChanged(bool val) {
    setState(() {
      _isBBChecked = val;
      toggleCause("Bush_Burning", val);
    });
  }

  void _onMChanged(bool val) {
    setState(() {
      _isMChecked = val;
      toggleCause("Mining", val);
    });
  }

  void _onOChanged(bool val) {
    setState(() {
      _isOchecked = val;
      toggleCause("Other", val);
    });
  }

  void _onLChanged(bool val) {
    setState(() {
      _isLChecked = val;
      toggleCause("Logging", val);
    });
  }

  void _onFChanged(bool val) {
    setState(() {
      _isFChecked = val;
      toggleCause("Farming", val);
    });
  }

  void _onCPChanged(bool val) {
    setState(() {
      _isCPChecked = val;
      toggleCause("Charcoal", val);
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

    commFileInit();

    myCFuture = writeToCommFile(this.context);

    p_nValues.addAll(["Planted", "Natural"]);

    _deforestationCause = [];
  }

  Widget buildSectionCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildSectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget buildChoiceChips({
    required String label,
    required List<Map<String, String>> options,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final value = option['value']!;
            final displayText = option['label']!;
            final isSelected = selectedValue == value;

            return InkWell(
              onTap: () => onSelected(value),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? fPrimaryColour : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? fPrimaryColour : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildCauseChip({
    required String label,
    required bool isSelected,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? fPrimaryColour.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? fPrimaryColour : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? fPrimaryColour : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? fPrimaryColour : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: fPrimaryColour, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: fPrimaryColour,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: fPrimaryColour,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "Deforestation Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String choice) {
              if (choice == Constants.home) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const IndexPage(),
                  ),
                );
              } else if (choice == Constants.load) {
                writeToCommFile(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => this.widget,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return Constants.exceptiondownChoices.map((String choice) {
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // const SizedBox(height: 20),
                    // Location Section
                    // buildModernCard(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // buildSectionTitle(
                    //       //   "Location Information",
                    //       //   subtitle:
                    //       //   "Select your community and capture GPS coordinates",
                    //       // ),
                    //       // const SizedBox(height: 24),
                    //       // Container(
                    //       //   padding: const EdgeInsets.all(16),
                    //       //   decoration: BoxDecoration(
                    //       //     color: Colors.blue[50],
                    //       //     borderRadius: BorderRadius.circular(12),
                    //       //     border: Border.all(color: Colors.blue[200]!),
                    //       //   ),
                    //       //   child: Row(
                    //       //     children: [
                    //       //       Icon(Icons.info_outline,
                    //       //           color: Colors.blue[700]),
                    //       //       const SizedBox(width: 12),
                    //       //       Expanded(
                    //       //         child: Text(
                    //       //           "Please use the previous community selection",
                    //       //           style: TextStyle(
                    //       //             color: Colors.blue[900],
                    //       //             fontSize: 14,
                    //       //           ),
                    //       //         ),
                    //       //       ),
                    //       //     ],
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),

                    // GPS Coordinates
                    buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: fPrimaryColour,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "GPS Coordinates",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          NewLocationService(onSelectLatLng: _selectLatLng),
                          if (_pickedLocation != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green[700],
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Location Captured",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildCoordinateRow(
                                    "Latitude",
                                    _pickedLocation!.latitude.toString(),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildCoordinateRow(
                                    "Longitude",
                                    _pickedLocation!.longitude.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Assessment Questions
                    // buildModernCard(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       buildSectionTitle(
                    //         "Assessment Questions",
                    //         subtitle:
                    //         "Help us understand the deforestation situation",
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // GFW Question
                    buildSectionCard(
                      child: buildChoiceChips(
                        label:
                            "Were you directed to this location by Global Forest Watch (GFW)?",
                        options: [
                          {'value': 'yes', 'label': 'Yes'},
                          {'value': 'no', 'label': 'No'},
                        ],
                        selectedValue: _gfwDirection,
                        onSelected: (value) {
                          setState(() {
                            _gfwDirection = value;
                          });
                        },
                      ),
                    ),

                    // Deforestation Question
                    buildSectionCard(
                      child: buildChoiceChips(
                        label:
                            "Do you see deforestation at this location?                 ",
                        options: [
                          {'value': 'yes', 'label': 'Yes'},
                          {'value': 'no', 'label': 'No'},
                        ],
                        selectedValue: _seeDeforestation,
                        onSelected: (value) {
                          setState(() {
                            _seeDeforestation = value;
                          });
                        },
                      ),
                    ),

                    // Causes Section
                    if (_seeDeforestation == "yes") ...[
                      buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSectionTitle(
                              "Deforestation Causes",
                              subtitle: "Select all causes that apply",
                            ),
                          ],
                        ),
                      ),
                      buildSectionCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            buildCauseChip(
                              label: "Bush Burning",
                              isSelected: _isBBChecked,
                              onChanged: _onBBChanged,
                              icon: Icons.local_fire_department,
                            ),
                            const SizedBox(height: 12),
                            buildCauseChip(
                              label: "Mining",
                              isSelected: _isMChecked,
                              onChanged: _onMChanged,
                              icon: Icons.landscape,
                            ),
                            const SizedBox(height: 12),
                            buildCauseChip(
                              label: "Logging",
                              isSelected: _isLChecked,
                              onChanged: _onLChanged,
                              icon: Icons.park,
                            ),
                            const SizedBox(height: 12),
                            buildCauseChip(
                              label: "Farming",
                              isSelected: _isFChecked,
                              onChanged: _onFChanged,
                              icon: Icons.agriculture,
                            ),
                            const SizedBox(height: 12),
                            buildCauseChip(
                              label: "Charcoal Production",
                              isSelected: _isCPChecked,
                              onChanged: _onCPChanged,
                              icon: Icons.fireplace,
                            ),
                            const SizedBox(height: 12),
                            buildCauseChip(
                              label: "Other",
                              isSelected: _isOchecked,
                              onChanged: _onOChanged,
                              icon: Icons.more_horiz,
                            ),
                            if (_isOchecked) ...[
                              const SizedBox(height: 16),
                              TextFieldWidget(
                                controller: _otherCauseController,
                                decoration: InputDecoration(
                                  hintText: "Please specify the cause",
                                  hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: fPrimaryColour,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (input) =>
                                    _deforestationCause.contains("Other")
                                    ? input!.trim().isEmpty
                                          ? 'Please specify the cause'
                                          : null
                                    : null,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    // Further Action Section
                    buildSectionCard(
                      child: buildChoiceChips(
                        label:
                            "Do you think further action should be taken?                    ",
                        options: [
                          {'value': 'yes', 'label': 'Yes'},
                          {'value': 'no', 'label': 'No'},
                        ],
                        selectedValue: _actionRequired,
                        onSelected: (value) {
                          setState(() {
                            _actionRequired = value;
                          });
                        },
                      ),
                    ),

                    if (_actionRequired == "yes") ...[
                      buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Why should action be taken?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFieldWidget(
                              controller: _whyAction,
                              decoration: InputDecoration(
                                hintText: "Explain why action is needed...",
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: fPrimaryColour,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (input) => input!.trim().isEmpty
                                  ? 'Please enter a reason'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Photo Section
                    buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: fPrimaryColour,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Photo Evidence",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(child: SpeciesImage(_selectedImage)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: fPrimaryColour,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Submit Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReport() async {
    await getspeciesbase64Img();

    if (_communityVal == null) {
      overlayNotification('Please select a community', "negative");
    } else if (_speciesbase64Image.isEmpty) {
      overlayNotification('Please take picture of area', "negative");
    } else if (_pickedLocation == null) {
      overlayNotification('GPS accuracy must be 5m or lower', "negative");
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
            "negative",
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const IndexPage(),
            ),
          );
          regSP?.clear();
        },
        disapprovePress: () => null,
      );
    }
  }

  void saveToLocalDB(String? con) {
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
        "photos": _speciesbase64Image,
      };

      var url = '$stageBaseUrl/deforestationapi/';

      var body = json.encode(deforestationdata);

      var bodyMap = jsonDecode(body);
      print(body);

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
          'Data sent successfully with status: $status.',
          "positive",
        );

        regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const IndexPage(),
          ),
        );
      } else if (status == "exist") {
        overlayNotification('Data already: $status.', "positive");
        Navigator.pop(context);
      } else {
        overlayNotification(
          'Error occured with error: ${itemss.toString()}',
          "negative",
        );
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
      }
    } on SocketException catch (e) {
      print("e === $e");
      saveToLocalDB("not connected");
      overlayNotification(
        'Oops! Internet error. Please make sure you\'re connected to the internet and try again from "View Reports".',
        "negative",
      );
      regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const IndexPage()),
      );
    } catch (i) {
      print("i ===> ${i.toString()}");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }
}
