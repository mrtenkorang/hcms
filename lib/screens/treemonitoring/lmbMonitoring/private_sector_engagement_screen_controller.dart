import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:http/http.dart' as http;
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';

class PrivateSectorEngagementController extends GetxController {
  BuildContext? lmbScreenContext;
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController privateName = TextEditingController();
  final TextEditingController lmbName = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController partnershipType = TextEditingController();
  final TextEditingController partnershipDuration = TextEditingController();
  final TextEditingController mouSigned = TextEditingController();
  final TextEditingController financialName = TextEditingController();
  final TextEditingController typeLoanService = TextEditingController();
  final TextEditingController loanDuration = TextEditingController();
  final TextEditingController loanInterest = TextEditingController();
  final TextEditingController maleBenefitting = TextEditingController();
  final TextEditingController femaleBenefitting = TextEditingController();
  final TextEditingController youthBenefitting = TextEditingController();

  // Observable variables
  final selectedVisitRadio = 0.obs;
  final sector = "".obs;
  final firstEngagement = "".obs;
  final isVisitDate = false.obs;
  final visitDateYearInString = ''.obs;
  final enumeratorValue = 0.obs;
  final isLoading = false.obs;

  void toggleSectorValue(String val) {
    sector.value = val;
    sectorController.text = val;
  }

  // Parameters from widget
  // final String? lmbName;
  // final String? dateYear;
  // final String? sector;

  // LmbPrivFinController();

  @override
  void onInit() {
    super.onInit();
    getEnumeratorValue();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    privateName.dispose();
    partnershipType.dispose();
    partnershipDuration.dispose();
    mouSigned.dispose();
    financialName.dispose();
    typeLoanService.dispose();
    loanDuration.dispose();
    loanInterest.dispose();
    maleBenefitting.dispose();
    femaleBenefitting.dispose();
    youthBenefitting.dispose();
    super.onClose();
  }

  // Get enumerator value from database
  Future<void> getEnumeratorValue() async {
    try {
      final db = await DBHelper.database();
      var count = await db.rawQuery(
        'SELECT enumeratorValue FROM first_time_user',
      );
      var list = count.toList();

      if (list.isNotEmpty) {
        enumeratorValue.value = int.parse(
          list[0]['enumeratorValue'].toString(),
        );
        debugPrint("Enumerator Value - ${enumeratorValue.value}");
      }
    } catch (e) {
      debugPrint("Error getting enumerator value: $e");
    }
  }

  // Set engagement date
  void setEngagementDate(DateTime date) {
    isVisitDate.value = true;
    visitDateYearInString.value = '${date.year}-${date.month}-${date.day}';
    firstEngagement.value = '${date.year}-${date.month}-${date.day}';
    debugPrint("Date of Engagement: ${firstEngagement.value}");
  }

  // Save to local database
  void saveToLocalDB(String connectionStatus) {
    try {
      // Globals().startWait(lmbScreenContext!);
      Provider.of<LMBMonitoringProvider>(
        Get.context!,
        listen: false,
      ).addLMBMonitoring(
        enumeratorValue.value.toString(),
        lmbName.text,
        sector.value,
        privateName.text,
        firstEngagement.value,
        partnershipType.text,
        partnershipDuration.text,
        mouSigned.text,
        financialName.text,
        typeLoanService.text,
        loanDuration.text,
        loanInterest.text,
        femaleBenefitting.text,
        maleBenefitting.text,
        youthBenefitting.text,
        connectionStatus,
      );
      // Globals().endWait(lmbScreenContext);
      debugPrint("Successfully saved LMB Monitoring to local DB");
    } catch (e) {
      debugPrint("Error saving to local DB: $e");
    }
  }

  // Validate form
  bool validateForm() {
    if (firstEngagement.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select date of first engagement',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!formKey.currentState!.validate()) {
      return false;
    }

    return true;
  }

  // Prepare data for submission
  Map<String, dynamic> prepareSubmissionData() {
    int male = maleBenefitting.text.isEmpty
        ? 0
        : int.parse(maleBenefitting.text);
    int female = femaleBenefitting.text.isEmpty
        ? 0
        : int.parse(femaleBenefitting.text);
    int youth = youthBenefitting.text.isEmpty
        ? 0
        : int.parse(youthBenefitting.text);
    double loanDur = loanDuration.text.isEmpty
        ? 0.0
        : double.parse(loanDuration.text);
    double loanInt = loanInterest.text.isEmpty
        ? 0.0
        : double.parse(loanInterest.text);

    return {
      "enumeratorDetails": {
        "enumerator": enumeratorValue.value,
        "lmbName": lmbName.text,
        "lmbType": "${sector.value} Sector Engagement",
      },
      "engagementDetails": {
        "privateSectorName": privateName.text,
        "dateOfFirstEng": firstEngagement.value,
        "partnershipType": partnershipType.text,
        "partnershipDuration": partnershipDuration.text,
        "mouSigned": mouSigned.text,
        "finServiceName": financialName.text,
        "finServiceType": typeLoanService.text,
        "loanDuration": loanDur,
        "interestRate": loanInt,
        "numOfFarmersBenfitting": {
          "female": female,
          "male": male,
          "youth": youth,
        },
      },
    };
  }

  // Attempt to upload data
  Future<void> attemptLMBUpload() async {
    debugPrint("Uploading data");
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      Globals().startWait(lmbScreenContext!);
      var submissionData = prepareSubmissionData();
      var url = '$stageBaseUrl/lmbmonitoringapi/';
      var body = json.encode(submissionData);

      debugPrint("Uploading data: $body");

      var res = await http.post(Uri.parse(url), body: body);
      Globals().endWait(lmbScreenContext!);
      debugPrint("Status code: ${res.statusCode}");

      final response = json.decode(res.body);
      var status = response["status"];

      if (status == "done") {
        debugPrint("Data sent successfully!");
        Navigator.pushAndRemoveUntil(
          lmbScreenContext!,
          MaterialPageRoute(builder: (context) => IndexPage()),
          (route) => false,
        );
        saveToLocalDB("connected");
        Get.snackbar(
          'Success',
          'Data sent successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
        Navigator.pushAndRemoveUntil(
          lmbScreenContext!,
          MaterialPageRoute(builder: (context) => IndexPage()),
              (route) => false,
        );
      } else if (status == "exist") {
        debugPrint("Data already exists!");
        Navigator.pushAndRemoveUntil(
          lmbScreenContext!,
          MaterialPageRoute(builder: (context) => IndexPage()),
              (route) => false,
        );
        saveToLocalDB("connected");
        Get.snackbar(
          'Info',
          'Data already exists',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        debugPrint("Error occurred: ${response["error"]}");
        Get.snackbar(
          'Error',
          'Error occurred: ${response["error"]}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on SocketException catch (e) {
      Globals().endWait(lmbScreenContext!);
      debugPrint("Socket exception: $e");
      saveToLocalDB("not connected");
      Get.snackbar(
        'Internet Error',
        'Data saved locally. Please go to "History" to send when connected.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      clearForm();
      Navigator.pop(lmbScreenContext!);
    } catch (e, stackTrace) {
      Globals().endWait(lmbScreenContext!);
      debugPrint("Upload error: $e");
      debugPrint("Upload error: $stackTrace");
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Save data locally without uploading
  void saveLocally() {
    if (!validateForm()) return;

    saveToLocalDB("not connected");
    Get.snackbar(
      'Success',
      'Data saved locally. Please go to "History" to send later.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    clearForm();
    Navigator.pop(lmbScreenContext!);
  }

  // Clear form
  void clearForm() {
    privateName.clear();
    partnershipType.clear();
    partnershipDuration.clear();
    mouSigned.clear();
    financialName.clear();
    typeLoanService.clear();
    loanDuration.clear();
    loanInterest.clear();
    maleBenefitting.clear();
    femaleBenefitting.clear();
    youthBenefitting.clear();
    firstEngagement.value = "";
    isVisitDate.value = false;
    visitDateYearInString.value = '';
  }
}
