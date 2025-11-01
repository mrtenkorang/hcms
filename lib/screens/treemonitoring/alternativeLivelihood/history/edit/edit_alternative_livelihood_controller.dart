import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../../../controller/constants/urls.dart';

class EditAlternativeLivelihoodController extends GetxController {
  BuildContext? alternativeLivelihoodContext;
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AlternativeLivelihoodProvider provider =
      Get.find<AlternativeLivelihoodProvider>();

  // Text editing controllers
  final TextEditingController trainerOrganisation = TextEditingController();
  final TextEditingController initAmount = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController amountToLmb = TextEditingController();

  // Reactive variables
  var visitDateYear = ''.obs;
  var operationsStartDate = ''.obs;
  var additionalActivity = ''.obs;
  var activitySupport = ''.obs;
  var amountType = Rxn<String>();

  var selectedActivityRadio = RxnInt();
  var selectedSupportRadio = RxnInt();

  var isVisitDate = false.obs;
  var isOperationsDate = false.obs;
  var visitDateYearString = ''.obs;
  var operationsDateString = ''.obs;
  var isLoading = false.obs;
  var currentStep = 0.obs;

  // Farmer selection variables
  var selectedFarmer = Rxn<FarmerFromServerModel>();
  var farmerData = <FarmerFromServerModel>[].obs;
  var isLoadingFarmers = false.obs;

  // Data variables
  var enumeratorValue = RxnInt();
  var community = ''.obs;
  var farmerId = ''.obs;
  var farmerName = ''.obs;
  var baseline = false.obs;
  var farmerPhoneNum = ''.obs;
  var unsavedLocal = false.obs;

  // Dropdown options
  final List<String> amountTypeValues = ["6 months", "1 year", "2 years"];
  final List<String> activityOptions = [
    "Snail_Rearing",
    "Vegetable_Farming",
    "Food_Processing_And_Value_Addition",
    "Pig_Sty",
    "Bee_Keeping",
    "Soap_Making",
  ];

  final List<String> supportOptions = [
    "School_Fees",
    "Home_Appliances",
    "Medical_Bills",
    "Buy_Farm_Inputs",
  ];

  String? recordId;

  @override
  void onInit() {
    super.onInit();
    loadFarmers();
    loadCommunities();
    // Initialize with first value
    amountType.value = amountTypeValues.isNotEmpty ? amountTypeValues[0] : null;
  }

  @override
  void onClose() {
    trainerOrganisation.dispose();
    initAmount.dispose();
    amount.dispose();
    amountToLmb.dispose();
    super.onClose();
  }

  // Load farmers for selection
  Future<void> loadFarmers() async {
    try {
      isLoadingFarmers.value = true;
      final result = await FarmerFromServerRepository().getAllFarmers();
      farmerData.assignAll(result);
      debugPrint("Loaded ${farmerData.length} farmers for selection");
    } catch (e) {
      debugPrint("Failed to load farmers: $e");
      Get.snackbar('Error', 'Failed to load farmers: $e');
    } finally {
      isLoadingFarmers.value = false;
    }
  }


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


  var selectedCommunity = Rxn<CommunityModel>();
  // Select community
  void selectCommunity(CommunityModel communit) {
    selectedCommunity.value = communit;
    selectedFarmer.value = null;
    // farmers.clear();
    if (communit.id != null) {
      community.value = communit.id.toString();
    }
  }

  // Farmer selection method
  void selectFarmer(FarmerFromServerModel farmer) {
    selectedFarmer.value = farmer;
    farmerId.value = farmer.id.toString();
    farmerName.value = farmer.farmerName;
    farmerPhoneNum.value = farmer.contact;

    debugPrint('Farmer selected: ${farmer.farmerName}');
    update();
  }

  // INIT DATA METHOD - SPECIFIC TO EDIT CONTROLLER
  void initData(AlternativeLivelihood alternativeLivelihood) async {
    debugPrint('=== INITIALIZING EDIT DATA ===');
    debugPrint('Record ID: ${alternativeLivelihood.alId}');
    debugPrint('Farmer ID: ${alternativeLivelihood.alFarmerId}');
    debugPrint('Farmer: ${alternativeLivelihood.alFarmerName}');
    debugPrint('Contact: ${alternativeLivelihood.alFarmerContact}');
    debugPrint('Activity: ${alternativeLivelihood.alAdditionalActivity}');
    debugPrint('Support: ${alternativeLivelihood.alActivitySupported}');
    debugPrint('Amount Type: ${alternativeLivelihood.alAmountType}');
    debugPrint('Initial Amount: ${alternativeLivelihood.alInitialAmount}');
    debugPrint('Amount: ${alternativeLivelihood.alAmount}');
    debugPrint('LMB Amount: ${alternativeLivelihood.alAmountToLMB}');
    debugPrint('Commmm: ${alternativeLivelihood.alCommunity}');

    selectedFarmer.value = await FarmerFromServerRepository().getFarmerById(
      alternativeLivelihood.alFarmerId,
    );

    selectedCommunity.value = communities.firstWhere(
      (community) => community.id.toString() == alternativeLivelihood.alCommunity,
    );

    // Store the original record ID
    recordId = alternativeLivelihood.alId;

    // Initialize text controllers
    trainerOrganisation.text = alternativeLivelihood.alTrainerOrg;
    initAmount.text = alternativeLivelihood.alInitialAmount;
    amount.text = alternativeLivelihood.alAmount;
    amountToLmb.text = alternativeLivelihood.alAmountToLMB;

    // Initialize reactive variables
    visitDateYear.value = alternativeLivelihood.alVisitDate;
    operationsStartDate.value = alternativeLivelihood.alOperationsStartDate;
    additionalActivity.value = alternativeLivelihood.alAdditionalActivity;
    activitySupport.value = alternativeLivelihood.alActivitySupported;
    amountType.value = alternativeLivelihood.alAmountType;

    // Set date display strings
    if (alternativeLivelihood.alVisitDate.isNotEmpty) {
      isVisitDate.value = true;
      visitDateYearString.value = alternativeLivelihood.alVisitDate;
    }

    if (alternativeLivelihood.alOperationsStartDate.isNotEmpty) {
      isOperationsDate.value = true;
      operationsDateString.value = alternativeLivelihood.alOperationsStartDate;
    }

    // Set selected radio values based on activity and support
    _setSelectedActivity(alternativeLivelihood.alAdditionalActivity);
    _setSelectedSupport(alternativeLivelihood.alActivitySupported);

    // Initialize farmer data
    farmerId.value = alternativeLivelihood.alFarmerId;
    farmerName.value = alternativeLivelihood.alFarmerName;
    community.value = alternativeLivelihood.alCommunity;
    farmerPhoneNum.value = alternativeLivelihood.alFarmerContact;
    baseline.value = alternativeLivelihood.alBasline.toLowerCase() == "true";

    // Find and set the selected farmer from loaded farmers
    if (farmerId.value.isNotEmpty) {
      await _findAndSetSelectedFarmer();
    }

    debugPrint('=== DATA INITIALIZATION COMPLETE ===');
    debugPrint('Selected Activity Radio: ${selectedActivityRadio.value}');
    debugPrint('Selected Support Radio: ${selectedSupportRadio.value}');
    debugPrint('Amount Type: ${amountType.value}');
    debugPrint('Selected Farmer: ${selectedFarmer.value?.farmerName}');

    update();
  }

  Future<void> _findAndSetSelectedFarmer() async {
    try {
      // Try to find farmer in loaded farmer data
      final foundFarmer = farmerData.firstWhereOrNull(
        (farmer) => farmer.id.toString() == farmerId.value,
      );

      if (foundFarmer != null) {
        selectedFarmer.value = foundFarmer;
        debugPrint('Found farmer in loaded data: ${foundFarmer.farmerName}');
      } else {
        debugPrint('Farmer not found in loaded data');
      }
    } catch (e) {
      debugPrint('Error finding selected farmer: $e');
    }
  }

  void _setSelectedActivity(String activity) {
    debugPrint('Setting activity: $activity');
    final index = activityOptions.indexOf(activity);
    if (index != -1) {
      selectedActivityRadio.value = index + 1;
      debugPrint(
        'Activity index found: $index, setting radio to: ${index + 1}',
      );
    } else {
      debugPrint('Activity not found in options: $activity');
      selectedActivityRadio.value = null;
    }
  }

  void _setSelectedSupport(String support) {
    debugPrint('Setting support: $support');
    final index = supportOptions.indexOf(support);
    if (index != -1) {
      selectedSupportRadio.value = index + 1;
      debugPrint('Support index found: $index, setting radio to: ${index + 1}');
    } else {
      debugPrint('Support not found in options: $support');
      selectedSupportRadio.value = null;
    }
  }

  // Date handling
  void setVisitDate(DateTime date) {
    isVisitDate.value = true;
    visitDateYearString.value = '${date.year}-${date.month}-${date.day}';
    visitDateYear.value = '${date.year}-${date.month}-${date.day}';
    regSP?.setString('aLVisitDate', visitDateYear.value);
    update();
  }

  void setOperationsDate(DateTime date) {
    isOperationsDate.value = true;
    operationsDateString.value = '${date.year}-${date.month}-${date.day}';
    operationsStartDate.value = '${date.year}-${date.month}-${date.day}';
    regSP?.setString('aLoperationsStartDate', operationsStartDate.value);
    update();
  }

  // Activity selection
  void setAdditionalActivity(int value) {
    selectedActivityRadio.value = value;
    additionalActivity.value = activityOptions[value - 1];
    regSP?.setString('aLadditionalActivity', additionalActivity.value);
    debugPrint('Activity selected: $value -> ${activityOptions[value - 1]}');
    update();
  }

  void setActivitySupport(int value) {
    selectedSupportRadio.value = value;
    activitySupport.value = supportOptions[value - 1];
    regSP?.setString('aLactivitySupport', activitySupport.value);
    debugPrint('Support selected: $value -> ${supportOptions[value - 1]}');
    update();
  }

  void setTrainerOrganisation() {
    regSP?.setString('aLtrainerorganisation', trainerOrganisation.text);
  }

  // Validation
  bool validateAllFields() {
    // Validate Visit Details
    if (visitDateYear.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select visit date',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedFarmer.value == null) {
      Get.snackbar(
        'Error',
        'Please select a farmer',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Validate Activity Details
    if (additionalActivity.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select activity type',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (trainerOrganisation.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter trainer organisation',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (operationsStartDate.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select operations start date',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Validate Investment Details
    if (initAmount.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter initial amount invested',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (amount.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter amount raised',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (amountToLmb.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter amount contributed to LMB',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (activitySupport.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select activity support',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Validate amount type
    if (amountType.value == null || amountType.value!.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select amount duration',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> submitOnline() async {
    try {

      final submissionData = {
        "visitDetails": {
          "communityName": community.value.isNotEmpty
              ? int.tryParse(community.value) ?? 0
              : 0,
          "enumerator": enumeratorValue.value ?? 0,
          "dateOfVisit": visitDateYear.value,
        },
        "farmerDetails": {
          "farmerid": selectedFarmer.value != null
              ? int.tryParse(selectedFarmer.value!.id.toString()) ?? 0
              : 0,
          "baseline": baseline.value ? "yes" : "no",
        },
        "activityDetails": {
          "additionalLivelihood": additionalActivity.value,
          "trainerOrganisation": trainerOrganisation.text,
          "dateOperationsStarted": operationsStartDate.value,
          "amounts": {
            "invested": double.tryParse(initAmount.text) ?? 0.0,
            "duration": amountType.value,
            "amount": double.tryParse(amount.text) ?? 0.0,
            "lmbContrib": double.tryParse(amountToLmb.text) ?? 0.0,
          },
          "activitiesSupported": activitySupport.value,
        },
      };

      debugPrint("THE DATATTTTTTT :::::::::::::: $submissionData");

      Globals().startWait(alternativeLivelihoodContext!);
      final response = await http.post(
        Uri.parse('${URLS.baseUrl}${URLS.alternativeLivelihoodLogURL}'),
        body: json.encode(submissionData),
        headers: {'Content-Type': 'application/json'},
      );
      Globals().endWait(alternativeLivelihoodContext);

      debugPrint("THE RES FROM SERVER ::::::::::::: ${response.statusCode}");
      debugPrint("THE RES FROM SERVER ::::::::::::: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        debugPrint("SUBMITTED;;;;;;;;;;;;;;;;;;;;;;;");

        if (result["status"] == true) {
          Globals().endWait(alternativeLivelihoodContext);
          _saveToLocalDB("connected");
          _clearAndNavigate();
          Get.back();
          Get.back();
          Get.snackbar(
            'Success',
            'Data submitted successfully online',
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
          );

        } else if (result["status"] == "exist") {
          Globals().endWait(alternativeLivelihoodContext);
          Get.snackbar(
            'Info',
            'Data already exists online',
            backgroundColor: Colors.orange,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
          );
          // Save locally anyway
          // _saveToLocalDB("exists online");
        } else {
          Get.snackbar(
            'Unknown Error',
            'An Unknown error occurred',
            backgroundColor: Colors.orange,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
          );
          Globals().endWait(alternativeLivelihoodContext);

          throw Exception(result["error"] ?? 'Unknown error from server');
        }
      } else {
        Get.snackbar(
          'Info',
          'Data Exists already',
          backgroundColor: Colors.orange,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
        Globals().endWait(alternativeLivelihoodContext);
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } on SocketException {
      Get.snackbar(
        'No internet',
        'No internet connection',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
      );
      Globals().endWait(alternativeLivelihoodContext);
      // This will be caught by the calling method and fall back to offline
      rethrow;
    } catch (e) {
      Globals().endWait(alternativeLivelihoodContext);
      debugPrint('Online submission error: $e');
      rethrow;
    }
  }

  Future<void> saveOffline() async {
    try {
      Globals().startWait(alternativeLivelihoodContext!);
      _saveToLocalDB("not connected");
      Globals().endWait(alternativeLivelihoodContext);

      _clearAndNavigate();
      Get.back();
      Get.back();
      Get.snackbar(
        'Offline',
        'Data saved locally',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      debugPrint('Offline submission error: $e');
      Get.snackbar(
        'Error',
        'Failed to save data locally: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }


  Future<void> _saveToLocalDB(String connectionStatus) async {
    try {
      final farmerIdToUse = unsavedLocal.value
          ? "0"
          : (farmerId.value.isEmpty ? "0" : farmerId.value);
      final farmerNameToUse = farmerName.value.isEmpty
          ? 'Unknown Farmer'
          : farmerName.value;
      final communityToUse = community.value.isEmpty
          ? 'Unknown Community'
          : community.value;

      // Use the provider to update the record
      provider.updateAlternativeLivelihood(
        recordId!,
        communityToUse,
        enumeratorValue.value?.toString() ?? "0",
        visitDateYear.value,
        farmerIdToUse,
        farmerNameToUse,
        baseline.value ? "true" : "false",
        farmerPhoneNum.value,
        additionalActivity.value,
        trainerOrganisation.text,
        operationsStartDate.value,
        initAmount.text,
        amountType.value!,
        amount.text,
        amountToLmb.text,
        activitySupport.value,
        connectionStatus,
      );

      debugPrint(
        'Data updated in local database with status: $connectionStatus',
      );
      debugPrint('Updated activity: ${additionalActivity.value}');
      debugPrint('Updated support: ${activitySupport.value}');
      debugPrint('Updated amount type: ${amountType.value}');
    } catch (e) {
      debugPrint('Error updating local DB: $e');
      rethrow;
    }
  }

  void _clearAndNavigate() {
    clearForm();
    // Navigate back or to home screen
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  void clearForm() {
    trainerOrganisation.clear();
    initAmount.clear();
    amount.clear();
    amountToLmb.clear();

    visitDateYear.value = "";
    operationsStartDate.value = "";
    additionalActivity.value = "";
    activitySupport.value = "";
    amountType.value = amountTypeValues.isNotEmpty ? amountTypeValues[0] : null;

    selectedActivityRadio.value = null;
    selectedSupportRadio.value = null;
    selectedFarmer.value = null;

    isVisitDate.value = false;
    isOperationsDate.value = false;
    visitDateYearString.value = '';
    operationsDateString.value = '';
    currentStep.value = 0;

    farmerId.value = "";
    farmerName.value = "";
    community.value = "";
    farmerPhoneNum.value = "";
    baseline.value = false;
    unsavedLocal.value = false;


    update();
  }
}
