import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:http/http.dart' as http;
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/constants/urls.dart';

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

  void initializeFields() {
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
    update();

    // Set radio button based on sector
    if (sectorValue.contains('private')) {
      selectedVisitRadio.value = 1;
    } else if (sectorValue.contains('financial')) {
      selectedVisitRadio.value = 2;
    } else {
      selectedVisitRadio.value = 0;
    }

    // Set engagement date with proper error handling
    if (record?.lmbFirstEngagement != null && record!.lmbFirstEngagement.isNotEmpty) {
      try {
        final dateString = record!.lmbFirstEngagement;
        debugPrint("Parsing date: $dateString");

        // Handle various date formats
        DateTime? parsedDate = _parseDateString(dateString);

        if (parsedDate != null) {
          setEngagementDate(parsedDate);
        } else {
          debugPrint('Unable to parse date: $dateString');
          // Set a default value or leave empty
          firstEngagement.value = '';
          visitDateYearInString.value = '';
        }
      } catch (e) {
        debugPrint('Error parsing date: $e');
        // Set a default value or leave empty
        firstEngagement.value = '';
        visitDateYearInString.value = '';
      }
    }
  }

  DateTime? _parseDateString(String dateString) {
    try {
      // Try parsing as ISO format first
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('ISO parse failed, trying custom formats: $e');
    }

    try {
      // Handle common date formats
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          // Handle formats like "2025-11-1" (missing leading zeros)
          final year = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final day = int.tryParse(parts[2]);

          if (year != null && month != null && day != null) {
            return DateTime(year, month, day);
          }
        }
      }

      // Handle formats with slashes
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          // Try different order possibilities
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);

          if (day != null && month != null && year != null) {
            // Handle 2-digit years
            final fullYear = year < 100 ? 2000 + year : year;
            return DateTime(fullYear, month, day);
          }
        }
      }

      // Try parsing as milliseconds since epoch
      final milliseconds = int.tryParse(dateString);
      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }

      return null;
    } catch (e) {
      debugPrint('Custom date parsing failed: $e');
      return null;
    }
  }

  UserModel? user;


  final communities = <CommunityModel>[].obs;
  // Load communities from API
  Future<void> loadCommunities() async {
    try {
      // isLoadingCommunities.value = true;
      final result = await CommunityRepository().getAllCommunities();
      communities.assignAll(result);

      debugPrint("THE COMMUNITIES ::::::::::: ${communities.length}");
    } catch (e) {
      debugPrint("FAILED TO LOAD COMMUNITIES: $e");
    } finally {
      // isLoadingCommunities.value = false;
    }
  }

  loadUser() async {
    final cache = await CacheService.getInstance();
    user = await cache.getUserInfo();
    enumeratorValue.value = user!.id!;
    update();
  }

  // Parameters from widget
  // final String? lmbName;
  // final String? dateYear;
  // final String? sector;

  // LmbPrivFinController();

  @override
  void onInit() {
    super.onInit();
    loadUser();
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
      var url = '${URLS.baseUrl}${URLS.privateSectorEngagementURL}';
      var body = json.encode(submissionData);

      debugPrint("Uploading data: $body");

      var res = await http.post(Uri.parse(url), body: body);
      Globals().endWait(lmbScreenContext!);
      debugPrint("Status code: ${res.statusCode}");

      final response = json.decode(res.body);
      var status = response["status"];

      if (status == true) {
        saveToLocalDB("connected");
        Get.back();
        Get.back();
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
          'Data Exists already',
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
}
