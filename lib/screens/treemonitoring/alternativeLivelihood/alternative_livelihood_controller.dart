import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/constants/urls.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

class AlternativeLivelihoodController extends GetxController {

  BuildContext? alternativeLivelihoodContext;
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AlternativeLivelihoodProvider provider = Get.put(
    AlternativeLivelihoodProvider(),
  );

  // Text editing controllers
  final TextEditingController farmerContact = TextEditingController();
  final TextEditingController trainerOrganisation = TextEditingController();
  final TextEditingController initAmount = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController amountToLmb = TextEditingController();

  var selectedFarmer = Rxn<FarmerFromServerModel>();

  // Reactive variables
  var visitDateYear = ''.obs;
  var operationsStartDate = ''.obs;
  var additionalActivity = ''.obs;
  var activitySupport = ''.obs;
  var amountType = Rxn<String>();

  var selectedActivityRadio = RxnInt();
  var selectedSupportRadio = RxnInt();

  var farmerData = <FarmerFromServerModel>[].obs;

  var isVisitDate = false.obs;
  var isOperationsDate = false.obs;
  var visitDateYearString = ''.obs;
  var operationsDateString = ''.obs;
  var isLoading = false.obs;
  var currentStep = 0.obs;

  // Data variables
  var enumeratorValue = RxnInt();
  var community = ''.obs;
  // var farmerId = ''.obs;
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

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadFarmerData();
    loadCommunities();
    // Initialize with first value
    amountType.value = amountTypeValues.isNotEmpty ? amountTypeValues[0] : null;
  }

  @override
  void onClose() {
    farmerContact.dispose();
    trainerOrganisation.dispose();
    initAmount.dispose();
    amount.dispose();
    amountToLmb.dispose();
    super.onClose();
  }

  var selectedCommunity = Rxn<CommunityModel>();
  // Select community
  void selectCommunity(CommunityModel communit) {
    selectedCommunity.value = communit;
    // farmers.clear();
    if (communit.id != null) {
      community.value = communit.id.toString();
    }
  }

  UserModel? user;

  loadUserInfo() async {
    final cache = await CacheService.getInstance();
    cache.getUserInfo().then((value) {
      user = value;
      enumeratorValue.value = user!.id;
    });
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

  selectFarmer(FarmerFromServerModel farmer) {
    selectedFarmer.value = farmer;
    update();
  }

  /// Fetches farmer data from repository
  Future<void> loadFarmerData() async {
    try {
      final farmers = await FarmerFromServerRepository().getAllFarmers();
      debugPrint("THE FARMER FROM SERVER ::::::: ${farmers.length}");
      farmerData.assignAll(farmers);
    } catch (e) {
      debugPrint('Error loading farmers: $e');
      // Show error to user if needed
    } finally {}
  }

  // Activity selection
  void setAdditionalActivity(int value) {
    selectedActivityRadio.value = value;
    additionalActivity.value = activityOptions[value - 1];
    regSP?.setString('aLadditionalActivity', additionalActivity.value);
    update();
  }

  void setActivitySupport(int value) {
    selectedSupportRadio.value = value;
    activitySupport.value = supportOptions[value - 1];
    regSP?.setString('aLactivitySupport', activitySupport.value);
    update();
  }

  void setTrainerOrganisation() {
    regSP?.setString('aLtrainerorganisation', trainerOrganisation.text);
  }

  // Comprehensive validation for all fields
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
        // Globals().endWait(alternativeLivelihoodContext);
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
      // Globals().endWait(alternativeLivelihoodContext);
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
      final farmerIdToUse = selectedFarmer.value!.id.toString();
      final farmerNameToUse = selectedFarmer.value!.farmerName;
      final communityToUse = community.value.isEmpty
          ? 'Unknown Community'
          : community.value;

      // Use the already initialized GetX provider
      provider.addAlternativeLivelihood(
        communityToUse,
        enumeratorValue.value?.toString() ?? "0",
        visitDateYear.value,
        farmerIdToUse,
        farmerNameToUse,
        baseline.value ? "true" : "false",
        farmerPhoneNum.value.isEmpty
            ? farmerContact.text
            : farmerPhoneNum.value,
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

      debugPrint('Data saved to local database with status: $connectionStatus');
    } catch (e) {
      debugPrint('Error saving to local DB: $e');
      rethrow;
    }
  }

  void _clearAndNavigate() {
    clearForm();
  }

  void clearForm() {
    farmerContact.clear();
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

    isVisitDate.value = false;
    isOperationsDate.value = false;
    visitDateYearString.value = '';
    operationsDateString.value = '';
    currentStep.value = 0;

    selectedFarmer.value = null;
    farmerName.value = "";
    community.value = "";
    farmerPhoneNum.value = "";
    baseline.value = false;
    unsavedLocal.value = false;

    update();
  }
}
