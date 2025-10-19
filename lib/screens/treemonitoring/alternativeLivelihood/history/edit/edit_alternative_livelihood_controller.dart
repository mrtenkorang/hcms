import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class EditAlternativeLivelihoodController extends GetxController {
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AlternativeLivelihoodProvider provider = Get.find<AlternativeLivelihoodProvider>();

  // Text editing controllers
  final TextEditingController farmerContact = TextEditingController();
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
    "Soap_Making"
  ];

  final List<String> supportOptions = [
    "School_Fees",
    "Home_Appliances",
    "Medical_Bills",
    "Buy_Farm_Inputs"
  ];

  String? recordId;

  @override
  void onInit() {
    super.onInit();
    getEnumeratorValue();
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

  // Database operations
  Future<void> getEnumeratorValue() async {
    try {
      final db = await DBHelper.database();
      var count = await db.rawQuery('SELECT enumeratorValue FROM first_time_user');
      var list = count.toList();

      if (list.isNotEmpty) {
        enumeratorValue.value = int.parse(list[0]['enumeratorValue'].toString());
      }
    } catch (e) {
      debugPrint("Error getting enumerator value: $e");
    }
  }

  // INIT DATA METHOD - SPECIFIC TO EDIT CONTROLLER
  void initData(AlternativeLivelihood alternativeLivelihood) {
    debugPrint('=== INITIALIZING EDIT DATA ===');
    debugPrint('Record ID: ${alternativeLivelihood.alId}');
    debugPrint('Farmer: ${alternativeLivelihood.alFarmerName}');
    debugPrint('Contact: ${alternativeLivelihood.alFarmerContact}');
    debugPrint('Activity: ${alternativeLivelihood.alAdditionalActivity}');
    debugPrint('Support: ${alternativeLivelihood.alActivitySupported}');
    debugPrint('Amount Type: ${alternativeLivelihood.alAmountType}');
    debugPrint('Initial Amount: ${alternativeLivelihood.alInitialAmount}');
    debugPrint('Amount: ${alternativeLivelihood.alAmount}');
    debugPrint('LMB Amount: ${alternativeLivelihood.alAmountToLMB}');

    // Store the original record ID
    recordId = alternativeLivelihood.alId;

    // Initialize text controllers
    farmerContact.text = alternativeLivelihood.alFarmerContact;
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

    // Initialize other data
    farmerId.value = alternativeLivelihood.alFarmerId;
    farmerName.value = alternativeLivelihood.alFarmerName;
    community.value = alternativeLivelihood.alCommunity;
    farmerPhoneNum.value = alternativeLivelihood.alFarmerContact;
    baseline.value = alternativeLivelihood.alBasline.toLowerCase() == "true";

    debugPrint('=== DATA INITIALIZATION COMPLETE ===');
    debugPrint('Selected Activity Radio: ${selectedActivityRadio.value}');
    debugPrint('Selected Support Radio: ${selectedSupportRadio.value}');
    debugPrint('Amount Type: ${amountType.value}');

    update(); // Force UI update
  }

  void _setSelectedActivity(String activity) {
    debugPrint('Setting activity: $activity');
    final index = activityOptions.indexOf(activity);
    if (index != -1) {
      selectedActivityRadio.value = index + 1;
      debugPrint('Activity index found: $index, setting radio to: ${index + 1}');
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

  // Farmer search and validation - Optional for manual lookup
  Future<void> searchFarmer(BuildContext context) async {
    if (farmerContact.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a contact number', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    update();

    try {
      await _searchFarmerOnline(context);
    } catch (e) {
      await _searchFarmerOffline(context);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _searchFarmerOnline(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(
          "$stageBaseUrl/searchfarmer/?contact=${farmerContact.text}&form=alternative"));

      if (response.statusCode == 200) {
        final items = json.decode(response.body);
        final farmerId = items["farmerid"];

        if (farmerId != null) {
          _processFarmerData(items, false);
          Get.snackbar('Success', 'Record found online', backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          throw Exception('Farmer not found online');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Online search failed: $e');
      throw e;
    }
  }

  Future<void> _searchFarmerOffline(BuildContext context) async {
    try {
      final farmer = await _getFarmerFromApiList(farmerContact.text);
      if (farmer != null) {
        _processFarmerData(farmer, false);
        Get.snackbar('Success', 'Record found offline', backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      final offlineFarmer = await _getFarmerFromOffline(farmerContact.text);
      if (offlineFarmer != null) {
        _processFarmerData(offlineFarmer, true);
        Get.snackbar('Success', 'Local record found', backgroundColor: Colors.blue, colorText: Colors.white);
        return;
      }

      Get.snackbar('Info', 'No existing record found. You can proceed with manual entry.', backgroundColor: Colors.blue, colorText: Colors.white);
    } catch (e) {
      debugPrint('Offline search failed: $e');
      Get.snackbar('Info', 'Search failed. You can proceed with manual entry.', backgroundColor: Colors.blue, colorText: Colors.white);
    }
  }

  Future<Map<String, dynamic>?> _getFarmerFromApiList(String contact) async {
    try {
      final db = await DBHelper.database();
      final result = await db.query(
          "farmer_api_list_alternative",
          where: "falAContact = ?",
          whereArgs: [contact]
      );

      return result.isNotEmpty ? {
        'farmerid': result[0]['id'].toString(),
        'baseline': result[0]['falABaseline'] == "true",
        'farmer_name': result[0]['falAFarmerName'].toString(),
        'community_id': result[0]['falACommunityId'].toString(),
        'contact': result[0]['falAContact'].toString()
      } : null;
    } catch (e) {
      debugPrint('Error getting farmer from API list: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getFarmerFromOffline(String contact) async {
    try {
      final db = await DBHelper.database();
      final result = await db.query(
          "farmer_offline",
          where: "foContact = ?",
          whereArgs: [contact]
      );

      return result.isNotEmpty ? {
        'farmer_name': result[0]['foFarmerName'].toString(),
        'community_id': result[0]['foCommunity'].toString(),
        'contact': result[0]['foContact'].toString(),
        'gender': result[0]['foGender'].toString(),
        'dob': result[0]['foDoB'].toString(),
        'holder_category': result[0]['foHolderCategory'].toString(),
        'farm_size': result[0]['foFarmSize'].toString()
      } : null;
    } catch (e) {
      debugPrint('Error getting farmer from offline: $e');
      return null;
    }
  }

  void _processFarmerData(Map<String, dynamic> data, bool isOffline) {
    try {
      farmerId.value = data['farmerid']?.toString() ?? '';
      farmerName.value = data['farmer_name']?.toString() ?? '';
      community.value = data['community_id']?.toString() ?? '';
      farmerPhoneNum.value = data['contact']?.toString() ?? '';
      baseline.value = data['baseline'] == true;
      unsavedLocal.value = isOffline;

      // Store in shared preferences
      regSP?.setString('aLfarmerID', farmerId.value);
      regSP?.setBool('aLbaseline', baseline.value);
      regSP?.setString('aLfarmername', farmerName.value);
      regSP?.setString('aLcommunity', community.value);
      regSP?.setString('aLfarmerContact', farmerPhoneNum.value);
      regSP?.setBool('unsavedlocal', unsavedLocal.value);

      debugPrint('Farmer data processed: ${farmerName.value}');

      // Show success message with farmer info
      Get.snackbar(
        'Farmer Found',
        'Name: ${farmerName.value}, Community: ${community.value}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Error processing farmer data: $e');
      Get.snackbar('Error', 'Failed to process farmer data', backgroundColor: Colors.red, colorText: Colors.white);
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

  // Step management
  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      update();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      update();
    }
  }

  // Validation
  bool validateStep1() {
    return visitDateYear.value.isNotEmpty &&
        formKey.currentState!.validate();
  }

  bool validateStep2() {
    return additionalActivity.value.isNotEmpty &&
        operationsStartDate.value.isNotEmpty &&
        trainerOrganisation.text.isNotEmpty;
  }

  bool validateStep3() {
    return activitySupport.value.isNotEmpty &&
        initAmount.text.isNotEmpty &&
        amount.text.isNotEmpty &&
        amountToLmb.text.isNotEmpty;
  }

  // Comprehensive validation for all fields
  bool validateAllFields() {
    // Validate Visit Details
    if (visitDateYear.value.isEmpty) {
      Get.snackbar('Error', 'Please select visit date', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (farmerContact.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a contact number', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    // Validate Activity Details
    if (additionalActivity.value.isEmpty) {
      Get.snackbar('Error', 'Please select activity type', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (trainerOrganisation.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter trainer organisation', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (operationsStartDate.value.isEmpty) {
      Get.snackbar('Error', 'Please select operations start date', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    // Validate Investment Details
    if (initAmount.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter initial amount invested', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (amount.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter amount raised', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (amountToLmb.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter amount contributed to LMB', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (activitySupport.value.isEmpty) {
      Get.snackbar('Error', 'Please select activity support', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    // Validate amount type
    if (amountType.value == null || amountType.value!.isEmpty) {
      Get.snackbar('Error', 'Please select amount duration', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }

  // Data submission - UPDATED FOR EDITING
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

  Future<void> _submitOnline(BuildContext context) async {
    try {
      // Get current values
      getCurrentValues();

      final submissionData = {
        "visitDetails": {
          "communityName": community.value.isNotEmpty ? int.tryParse(community.value) ?? 0 : 0,
          "enumerator": enumeratorValue.value ?? 0,
          "dateOfVisit": visitDateYear.value
        },
        "farmerDetails": {
          "farmerid": farmerId.value.isNotEmpty ? int.tryParse(farmerId.value) ?? 0 : 0,
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
            "lmbContrib": double.tryParse(amountToLmb.text) ?? 0.0
          },
          "activitiesSupported": activitySupport.value
        }
      };

      final response = await http.post(
        Uri.parse('$stageBaseUrl/alternativemonitoringapi/'),
        body: json.encode(submissionData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result["status"] == "done") {
          _saveToLocalDB("connected");
          Get.snackbar('Success', 'Data submitted successfully online', backgroundColor: Colors.green, colorText: Colors.white);
          _clearAndNavigate();
        } else if (result["status"] == "exist") {
          Get.snackbar('Info', 'Data already exists online', backgroundColor: Colors.orange, colorText: Colors.white);
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
      Get.snackbar('Offline', 'Data saved locally', backgroundColor: Colors.blue, colorText: Colors.white);
      _clearAndNavigate();
    } catch (e) {
      debugPrint('Offline submission error: $e');
      Get.snackbar('Error', 'Failed to save data locally: $e', backgroundColor: Colors.red, colorText: Colors.white);
      rethrow;
    }
  }

  void getCurrentValues() {
    // Refresh values from shared preferences before submission
    farmerId.value = regSP?.getString('aLfarmerID') ?? farmerId.value;
    farmerName.value = regSP?.getString('aLfarmername') ?? farmerName.value;
    community.value = regSP?.getString('aLcommunity') ?? community.value;
    farmerPhoneNum.value = regSP?.getString('aLfarmerContact') ?? farmerPhoneNum.value;
    baseline.value = regSP?.getBool('aLbaseline') ?? baseline.value;
    unsavedLocal.value = regSP?.getBool('unsavedlocal') ?? unsavedLocal.value;
    visitDateYear.value = regSP?.getString('aLVisitDate') ?? visitDateYear.value;
    operationsStartDate.value = regSP?.getString('aLoperationsStartDate') ?? operationsStartDate.value;
    additionalActivity.value = regSP?.getString('aLadditionalActivity') ?? additionalActivity.value;
    activitySupport.value = regSP?.getString('aLactivitySupport') ?? activitySupport.value;
  }

  Future<void> _saveToLocalDB(String connectionStatus) async {
    try {
      final farmerIdToUse = unsavedLocal.value ? "0" : (farmerId.value.isEmpty ? "0" : farmerId.value);
      final farmerNameToUse = farmerName.value.isEmpty ? 'Unknown Farmer' : farmerName.value;
      final communityToUse = community.value.isEmpty ? 'Unknown Community' : community.value;

      // Use the provider to add the updated record
      provider.updateAlternativeLivelihood(
        recordId!,
        communityToUse,
        enumeratorValue.value?.toString() ?? "0",
        visitDateYear.value,
        farmerIdToUse,
        farmerNameToUse,
        baseline.value ? "true" : "false",
        farmerPhoneNum.value.isEmpty ? farmerContact.text : farmerPhoneNum.value,
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
      debugPrint('New activity: ${additionalActivity.value}');
      debugPrint('New support: ${activitySupport.value}');
      debugPrint('New amount type: ${amountType.value}');
    } catch (e) {
      debugPrint('Error saving to local DB: $e');
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

    farmerId.value = "";
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

  // Optional: Method to manually set farmer details if known
  void setFarmerDetails(String id, String name, String communityName, String contact) {
    farmerId.value = id;
    farmerName.value = name;
    community.value = communityName;
    farmerPhoneNum.value = contact;
    farmerContact.text = contact;
    unsavedLocal.value = false;

    update();
  }
}