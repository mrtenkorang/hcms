import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/farmerlistmodel.dart';
import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
import 'package:hcms_revived2/screens/treemonitoring/components/participantsModel.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TrainingLogController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController communityName = TextEditingController();
  final TextEditingController topic = TextEditingController();
  final TextEditingController durHours = TextEditingController();
  final TextEditingController durMins = TextEditingController();
  final TextEditingController trainerName = TextEditingController();
  final TextEditingController trainerOrg = TextEditingController();

  var visitDate = ''.obs;
  var isVisitDate = false.obs;
  var visitDateYearInString = ''.obs;
  var currentStep = 0.obs;
  var isLoading = false.obs;
  var boxChecked = false.obs;
  var communityVal = RxnInt();
  var community = ''.obs;
  var enumeratorValue = RxnInt();


  List<ParticipantsModelArray> items = [];
  List<ParticipantsModelArray> selectedPoints = [];
  String? encodedKeep;

  String? communityNameSP;
  int? communityIdSP;
  String? topicSP;
  String? durHoursSP;
  String? durMinsSP;
  String? trainerNameSP;
  String? trainerOrgSP;
  String? eventDateSP;

  File? commjsonFile;
  Directory? dir;
  String commfileName = "community.json";
  bool commfileExists = false;
  var commfileContent;
  List<CommunityJson> newcommValues = [];
  List<CommunityJson> commValues = [];

  File? farmerjsonFile;
  String farmerfileName = "farmerlist.json";
  bool farmerfileExists = false;
  var farmerfileContent;
  List<FarmerListJson> newfarmerValues = [];
  List<FarmerListJson> farmerValues = [];

  String? ffarmerlist;

  // Add the missing futures
  Future<List<CommunityJson>>? myCFuture;
  Future<List<FarmerListJson>>? myFlFuture;

  @override
  void onInit() {
    super.onInit();
    getEnumeratorValue();
    commFileInit();
    farmerFileInit();
    // Initialize the futures
    myCFuture = writeToCommFile();
    myFlFuture = writeToFarmerListFile(communityVal.value);
  }

  @override
  void onClose() {
    communityName.dispose();
    topic.dispose();
    durHours.dispose();
    durMins.dispose();
    trainerName.dispose();
    trainerOrg.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> getEnumeratorValue() async {
    try {
      final db = await DBHelper.database();
      var count = await db.rawQuery('SELECT enumeratorValue FROM first_time_user');
      var list = count.toList();

      if (list.isNotEmpty) {
        enumeratorValue.value = int.parse(list[0]['enumeratorValue'].toString());
      }
    } catch (e) {
      print("Error getting enumerator value: $e");
    }
  }

  void setTLValues() {
    regSP?.setString('tLComName', boxChecked.value ? communityName.text : community.value!);
    regSP?.setString('tLTopic', topic.text);
    regSP?.setString('tLDurationHour', durHours.text);
    regSP?.setString('tLDurationMins', durMins.text);
    regSP?.setString('tLTrainerName', trainerName.text);
    regSP?.setString('tLTrainerOrg', trainerOrg.text);
    regSP?.setString('tLVisitDate', visitDate.value!);
    if (communityVal.value != null) {
      regSP?.setInt('tLcommunityValue', communityVal.value!);
    }
  }

  void setVisitDate(DateTime date) {
    isVisitDate.value = true;
    visitDateYearInString.value = '${date.year}-${date.month}-${date.day}';
    visitDate.value = '${date.year}-${date.month}-${date.day}';
  }

  void onSelectedRow(bool selected, ParticipantsModelArray user) {
    if (selected) {
      selectedPoints.add(user);
    } else {
      selectedPoints.remove(user);
    }
    update();
  }

  void deleteSelected() {
    if (selectedPoints.isNotEmpty) {
      List<ParticipantsModelArray> temp = [];
      temp.addAll(selectedPoints);
      for (ParticipantsModelArray points in temp) {
        items.remove(points);
        selectedPoints.remove(points);
      }
    }
    update();
  }

  void convertu() {
    final String encodedData = ParticipantsModelArray.encode(items);
    encodedKeep = encodedData;
    setTDValues();
  }

  void setTDValues() async {
    await regSP?.setString("c2treeplantationDetail", encodedKeep!);
  }

  void getTLValues() {
    communityIdSP = regSP?.getInt("tLcommunityValue");
    communityNameSP = regSP?.getString('tLComName');
    topicSP = regSP?.getString('tLTopic');
    durHoursSP = regSP?.getString('tLDurationHour');
    durMinsSP = regSP?.getString('tLDurationMins');
    trainerNameSP = regSP?.getString('tLTrainerName');
    trainerOrgSP = regSP?.getString('tLTrainerOrg');
    eventDateSP = regSP?.getString('tLVisitDate');
  }

  void saveToLocalDB(String con) {
    Provider.of<TrainingLogProvider>(Get.context!, listen: false).addTrainingLog(
      communityIdSP.toString(),
      topicSP!,
      eventDateSP!,
      "${durHoursSP!} hours : ${durMinsSP!} minutes",
      trainerNameSP!,
      trainerOrgSP!,
      enumeratorValue.value.toString(),
      encodedKeep!,
      con,
    );
  }

  Future<void> attemptSignup(BuildContext ctx) async {
    getTLValues();
    isLoading.value = true;

    final String encodedData = ParticipantsModelArray.encode(items);
    final participantDetails = items.isNotEmpty
        ? json.decode(encodedData).cast<Map<String, dynamic>>()
        : Map();

    try {
      var trainingLog = {
        "trainingDetails": {
          "communityName": communityIdSP,
          "trainingTopic": topicSP,
          "dateEventBegan": eventDateSP,
          "eventDuration": "${durHoursSP!} hours : ${durMinsSP!} minutes",
          "trainerName": trainerNameSP,
          "trainerOrganisation": trainerOrgSP,
          "enumerator": enumeratorValue.value
        },
        "participantDetails": participantDetails
      };

      var response = await http.post(
        Uri.parse('$stageBaseUrl/trainingapi/'),
        body: json.encode(trainingLog),
      );

      final result = json.decode(response.body);
      var status = result["status"];

      if (status == "done") {
        saveToLocalDB("connected");
        Get.snackbar('Success', 'Data sent successfully', backgroundColor: Colors.green, colorText: Colors.white);
        clearAndNavigate();
      } else if (status == "exist") {
        Get.snackbar('Info', 'Data already exists', backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        throw Exception(result["error"] ?? 'Unknown error');
      }
    } on SocketException catch (e) {
      saveToLocalDB("not connected");
      Get.snackbar('Offline', 'Data saved locally', backgroundColor: Colors.blue, colorText: Colors.white);
      clearAndNavigate();
    } catch (e) {
      Get.snackbar('Error', 'Submission failed: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearAndNavigate() {
    clearForm();
    Get.offAllNamed('/tree-monitoring');
  }

  void clearForm() {
    communityName.clear();
    topic.clear();
    durHours.clear();
    durMins.clear();
    trainerName.clear();
    trainerOrg.clear();

    visitDate.value = "";
    isVisitDate.value = false;
    visitDateYearInString.value = '';
    currentStep.value = 0;
    items.clear();
    selectedPoints.clear();

    regSP?.clear();
  }

  void commFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      commjsonFile = File(dir!.path + "/" + commfileName);
      commfileExists = commjsonFile!.existsSync();
      if (commfileExists) {
        commfileContent = await json.decode(await commjsonFile!.readAsString());
      }
    });
  }

  void farmerFileInit() {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      farmerjsonFile = File(dir!.path + "/" + farmerfileName);
      farmerfileExists = farmerjsonFile!.existsSync();
      if (farmerfileExists) {
        farmerfileContent = await json.decode(await farmerjsonFile!.readAsString());
      }
    });
  }

  void onCommChanged(String commVal, int val) {
    community.value = commVal;
    communityVal.value = val;
    farmerValues = [];
    ffarmerlist = null;
    // Update the farmer list future when community changes
    myFlFuture = writeToFarmerListFile(val);
    update();
  }

  void onFarmerListChanged(String farmerListVal, FarmerListJson ffvalue) {
    ffarmerlist = farmerListVal;
    items.add(
      ParticipantsModelArray(
        farmerid: ffvalue.farmerid.toString(),
        farmerName: ffvalue.farmername,
        communityName: ffvalue.communityname,
      ),
    );
    update();
  }

  bool validateStep1() {
    return visitDate.value != null &&
        community.value != null &&
        topic.text.isNotEmpty &&
        durHours.text.isNotEmpty &&
        durMins.text.isNotEmpty &&
        trainerName.text.isNotEmpty &&
        trainerOrg.text.isNotEmpty;
  }

  bool validateStep2() {
    return items.isNotEmpty;
  }

  // Add the missing file writing methods
  Future<List<CommunityJson>> writeToCommFile() async {
    var commUrl = "$stageBaseUrl/communityapi/";

    if (commfileExists) {
      try {
        var response = await http.get(Uri.parse(commUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var commjsonFileContent = await json.decode(await commjsonFile!.readAsString());
          commjsonFileContent.clear();
          commjsonFileContent.addAll(items);
          commjsonFile!.writeAsString(json.encode(commjsonFileContent));
          commValues = commjsonFileContent.map<CommunityJson>(CommunityJson.fromJson).toList();
        }
      } on SocketException {
        // Use local values if online fails
        commValues = await getLocalCommValues();
      }
    } else {
      try {
        var response = await http.get(Uri.parse(commUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createCommFile(items, dir!, commfileName);
          commValues = items.map<CommunityJson>(CommunityJson.fromJson).toList();
        }
      } on SocketException {
        commValues = await getLocalCommValues();
      }
    }
    return commValues;
  }

  Future<List<FarmerListJson>> writeToFarmerListFile(int? communityId) async {
    if (communityId == null) return [];

    var farmerlistUrl = "$stageBaseUrl/farmerlist/?community=$communityId";

    if (farmerfileExists) {
      try {
        var response = await http.get(Uri.parse(farmerlistUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          var farmerFileContent = await json.decode(await farmerjsonFile!.readAsString());
          farmerFileContent.clear();
          farmerFileContent.addAll(items);
          farmerjsonFile!.writeAsString(json.encode(farmerFileContent));
          farmerValues = farmerFileContent.map<FarmerListJson>(FarmerListJson.fromJson).toList();
        }
      } on SocketException {
        // Handle offline case
        farmerValues = [];
      }
    } else {
      try {
        var response = await http.get(Uri.parse(farmerlistUrl));
        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();
          createFarmerListFile(items, dir!, farmerfileName);
          farmerValues = items.map<FarmerListJson>(FarmerListJson.fromJson).toList();
        }
      } on SocketException {
        farmerValues = [];
      }
    }
    return farmerValues;
  }

  void createCommFile(var content, Directory dir, String fileName) {
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    commfileExists = true;
    file.writeAsString(json.encode(content));
  }

  void createFarmerListFile(var content, Directory dir, String fileName) {
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    farmerfileExists = true;
    file.writeAsString(json.encode(content));
  }

  Future<List<CommunityJson>> getLocalCommValues() async {
    try {
      final assetBundle = DefaultAssetBundle.of(Get.context!);
      final data = await assetBundle.loadString('assets/community.json');
      final body = json.decode(data);
      newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();
      return newcommValues;
    } catch (e) {
      return [];
    }
  }

  // Method to refresh community data
  void refreshCommunityData() {
    myCFuture = writeToCommFile();
    update();
  }

  // Method to refresh farmer data
  void refreshFarmerData() {
    myFlFuture = writeToFarmerListFile(communityVal.value);
    update();
  }
}