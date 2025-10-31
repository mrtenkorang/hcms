import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/constants/urls.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

class AlternativeLivelihoodController extends GetxController {
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

  // Data submission
  Future<void> submitData(BuildContext context) async {
    if (!validateAllFields()) {
      return;
    }

    isLoading.value = true;
    update();

    try {
      // Try online submission first, fall back to offline
      await _submitOnline(context);

    } on SocketException catch (e) {
      debugPrint('Online submission failed, saving offline: $e');
      await _submitOffline(context);
    } catch (e) {
      debugPrint('Submission failed: $e');
      // Even if online fails, save offline as backup
      await _submitOffline(context);
    } finally {
      isLoading.value = false;
      update();
    }
  }
  //
  // Future<void> _createOfflineFarmer() async {
  //   try {
  //     final db = await DBHelper.database();
  //
  //     // Check if farmer already exists in offline table
  //     final existingFarmer = await db.query(
  //         "farmer_offline",
  //         where: "foContact = ?",
  //         whereArgs: [farmerContact.text]
  //     );
  //
  //     if (existingFarmer.isEmpty) {
  //       // Create new offline farmer record
  //       provider.addAlternativeLivelihood(pickedalCommunity, pickedalEnumeratorValue, pickedalVisitDate, pickedFarmerId, pickedalFarmerName, pickedalBasline, pickedalFarmerContact, pickedalAdditionalActivity, pickedalTrainerOrg, pickedalOperationsStartDate, pickedalInitialAmount, pickedalAmountType, pickedalAmount, pickedalAmountToLMB, pickedalActivitySupported, pickedalConStat)
  //
  //       farmerId.value = "0";
  //       farmerName.value = 'Unknown Farmer';
  //       community.value = 'Unknown Community';
  //       unsavedLocal.value = true;
  //
  //       debugPrint('Created offline farmer record for contact: ${farmerContact.text}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error creating offline farmer: $e');
  //     // // Continue anyway, we'll use default values
  //     // farmerId.value = "0";
  //     // farmerName.value = 'Unknown Farmer';
  //     // community.value = 'Unknown Community';
  //     // unsavedLocal.value = true;
  //   }
  // }

  Future<void> _submitOnline(BuildContext context) async {
    try {
      // Get current values
      getCurrentValues();

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

      final response = await http.post(
        Uri.parse('${URLS.baseUrl}${URLS.alternativeLivelihoodLogURL}'),
        body: json.encode(submissionData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);

        if (result["status"] == "done") {
          _saveToLocalDB("connected");
          Get.snackbar(
            'Success',
            'Data submitted successfully online',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          _clearAndNavigate();
        } else if (result["status"] == "exist") {
          Get.snackbar(
            'Info',
            'Data already exists online',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          // Save locally anyway
          _saveToLocalDB("exists online");
        } else {
          throw Exception(result["error"] ?? 'Unknown error from server');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } on SocketException {
      // This will be caught by the calling method and fall back to offline
      rethrow;
    } catch (e) {
      debugPrint('Online submission error: $e');
      rethrow;
    }
  }

  Future<void> _submitOffline(BuildContext context) async {
    try {
      getCurrentValues();
      _saveToLocalDB("not connected");
      Get.snackbar(
        'Offline',
        'Data saved locally',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      _clearAndNavigate();
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

  void getCurrentValues() {
    // Refresh values from shared preferences before submission
    // selectedFarmer.value = regSP?.getString('aLfarmerID') ?? farmerId.value;
    farmerName.value = regSP?.getString('aLfarmername') ?? farmerName.value;
    community.value = regSP?.getString('aLcommunity') ?? community.value;
    farmerPhoneNum.value =
        regSP?.getString('aLfarmerContact') ?? farmerPhoneNum.value;
    baseline.value = regSP?.getBool('aLbaseline') ?? baseline.value;
    unsavedLocal.value = regSP?.getBool('unsavedlocal') ?? unsavedLocal.value;
    visitDateYear.value =
        regSP?.getString('aLVisitDate') ?? visitDateYear.value;
    operationsStartDate.value =
        regSP?.getString('aLoperationsStartDate') ?? operationsStartDate.value;
    additionalActivity.value =
        regSP?.getString('aLadditionalActivity') ?? additionalActivity.value;
    activitySupport.value =
        regSP?.getString('aLactivitySupport') ?? activitySupport.value;
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
    // Navigate back or to home screen
    Future.delayed(Duration(seconds: 2), () {
      Get.back();
    });
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

    // Clear shared preferences
    regSP?.remove('aLfarmerID');
    regSP?.remove('aLbaseline');
    regSP?.remove('aLfarmername');
    regSP?.remove('aLcommunity');
    regSP?.remove('aLfarmerContact');
    regSP?.remove('unsavedlocal');
    regSP?.remove('aLVisitDate');
    regSP?.remove('aLoperationsStartDate');
    regSP?.remove('aLadditionalActivity');
    regSP?.remove('aLactivitySupport');
    regSP?.remove('aLtrainerorganisation');

    update();
  }
}
