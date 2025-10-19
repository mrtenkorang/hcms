import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:http/http.dart' as http;
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';

class EditPrivateSectorEngagementController extends GetxController {
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

  LMBMonitoring? record;

  initializeFields() {
    if (record == null) return;

    debugPrint("Record: ${record!}");

    // Set basic fields
    privateName.text = record?.lmbPrivateName ?? '';
    lmbName.text = record?.lmbName ?? '';
    sectorController.text = record?.lmbSector ?? '';
    partnershipType.text = record?.lmbPartnershipType ?? '';
    partnershipDuration.text = record?.lmbPartnershipDuration ?? '';
    mouSigned.text = record?.lmbMou ?? '';
    financialName.text = record?.lmbFinancialName ?? '';
    typeLoanService.text = record?.lmbTypeLoanService ?? '';
    loanDuration.text = record?.lmbLoanDuration ?? '';
    loanInterest.text = record?.lmbLoanInterest ?? '';
    maleBenefitting.text = record?.lmbMaleBenefit ?? '';
    femaleBenefitting.text = record?.lmbFemaleBenefit ?? '';
    youthBenefitting.text = record?.lmbYouthBenefit ?? '';

    // Set sector and radio button
    final sectorValue = record?.lmbSector.toLowerCase() ?? '';
    sector.value = sectorValue;
    
    // Set radio button based on sector
    if (sectorValue.contains('private')) {
      selectedVisitRadio.value = 1;
    } else if (sectorValue.contains('financial')) {
      selectedVisitRadio.value = 2;
    } else {
      selectedVisitRadio.value = 0; // Default to none selected
    }

    // Set engagement date
    if (record?.lmbFirstEngagement != null && record!.lmbFirstEngagement.isNotEmpty) {
      try {
        final date = DateTime.parse(record!.lmbFirstEngagement);
        setEngagementDate(date);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }
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
    final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    visitDateYearInString.value = formattedDate;
    firstEngagement.value = formattedDate;
    debugPrint("Date of Engagement: $formattedDate");
  }

  // Save to local database
  void saveToLocalDB(String connectionStatus) {
    try {
      LMBMonitoring updatedRecord = LMBMonitoring(
        lmbId: record!.lmbId,
        lmbTimeDisplay: record!.lmbTimeDisplay,
        lmbEnumeratorValue: record!.lmbEnumeratorValue,
        lmbName: record!.lmbName,
        lmbSector: record!.lmbSector,
        lmbPrivateName: record!.lmbPrivateName,
        lmbFirstEngagement: record!.lmbFirstEngagement,
        lmbPartnershipType: record!.lmbPartnershipType,
        lmbPartnershipDuration: record!.lmbPartnershipDuration,
        lmbMou: record!.lmbMou,
        lmbFinancialName: record!.lmbFinancialName,
        lmbTypeLoanService: record!.lmbTypeLoanService,
        lmbLoanDuration: record!.lmbLoanDuration,
        lmbLoanInterest: record!.lmbLoanInterest,
        lmbFemaleBenefit: record!.lmbFemaleBenefit,
        lmbMaleBenefit: record!.lmbMaleBenefit,
        lmbYouthBenefit: record!.lmbYouthBenefit,
        lmbConStat: connectionStatus,
      );

      Provider.of<LMBMonitoringProvider>(
        Get.context!,
        listen: false,
      ).updateLMBMonitoring(updatedRecord);

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
        saveToLocalDB("connected");
        Get.snackbar(
          'Success',
          'Data sent successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
        Navigator.pop(lmbScreenContext!);
      } else if (status == "exist") {
        Get.snackbar(
          'Info',
          'Data already exists',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
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
    } catch (e, stackRace) {
      Globals().endWait(lmbScreenContext!);
      debugPrint("Upload error: $e");
      debugPrint("Upload error: $stackRace");
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

  // Show submission options
  void showSubmissionOptions() {
    if (!validateForm()) return;

    Get.dialog(
      AlertDialog(
        title: Text('Submission Options'),
        content: Text('Do you have internet connection?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              attemptLMBUpload();
            },
            child: Text('Send with Internet'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              saveLocally();
            },
            child: Text('Save Locally'),
          ),
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        ],
      ),
    );
  }
}
