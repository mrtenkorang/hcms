// seedling_monitoring_controller.dart
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

class SeedlingMonitoringProviderr extends ChangeNotifier {
  // Reactive variables
  final RxInt currentPage = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString farmerName = ''.obs;
  final RxString community = ''.obs;
  final RxBool communityNotFound = false.obs;
  final RxString dateOfSurvey = ''.obs;
  final RxString plantationType = ''.obs;
  final RxList<String> speciesProvidedPlanted = <String>[].obs;
  final RxList<String> speciesAlive = <String>[].obs;
  final RxList<String> reasonForDeath = <String>[].obs;
  final RxList<String> sourceOfWater = <String>[].obs;
  final RxList<String> extremeWeathers = <String>[].obs;
  final RxString waterFrequency = ''.obs;
  final RxBool hasExtremeWeather = false.obs;
  final RxBool pestsAround = false.obs;
  final RxBool fertiliserApplied = false.obs;
  final RxBool pesticideApplied = false.obs;
  final RxBool signsOfDisease = false.obs;

  // Text controllers
  final TextEditingController farmerContact = TextEditingController();
  final TextEditingController surveyorName = TextEditingController();
  final TextEditingController farmerIDNumber = TextEditingController();
  final TextEditingController farmerNameController = TextEditingController();
  final TextEditingController farmSizeAcresController = TextEditingController();
  final TextEditingController communityName = TextEditingController();
  final TextEditingController totalSizeAcres = TextEditingController();
  final TextEditingController totalSeedlingsAlive = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController additionalObservations = TextEditingController();
  final TextEditingController pestDescription = TextEditingController();
  final TextEditingController fertiliserType = TextEditingController();
  final TextEditingController pesticideType = TextEditingController();
  final TextEditingController diseaseDescription = TextEditingController();

  // Species details controllers
  final Map<String, TextEditingController> quantityReceivedControllers = {};
  final Map<String, TextEditingController> quantityPlantedControllers = {};
  final Map<String, String> plantingDates = {};

  // Community data
  final RxList<CommunityJson> communities = <CommunityJson>[].obs;
  final RxBool loadingCommunities = false.obs;

  /// Collection of polylines for map display
  Set<Polyline> polyLines = HashSet<Polyline>();

  // void onInit() {
  //   super.onInit();
  //   _initializeControllers();
  //   loadCommunities();
  // }

  void initializeControllers() {
    final speciesList = [
      "Prekese",
      "Kokrodua_Afromosia",
      "Dahoma",
      "Edinam",
      "Emire",
      "Ofram",
      "Mahogany_Dubini",
      "Mansonia_Oprono",
      "Okoro",
      "Efoobodedwo_Utile",
      "Bako",
    ];

    for (var species in speciesList) {
      quantityReceivedControllers[species] = TextEditingController();
      quantityPlantedControllers[species] = TextEditingController();
    }
  }

  Future<void> loadCommunities() async {
    loadingCommunities.value = true;
    try {
      final response = await http.get(Uri.parse("$stageBaseUrl/communityapi/"));
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        communities.assignAll(
          items
              .map<CommunityJson>((json) => CommunityJson.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load communities');
    } finally {
      loadingCommunities.value = false;
    }
  }

  Future<void> searchFarmer() async {
    if (farmerContact.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter farmer contact',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
          "$stageBaseUrl/searchfarmer/?contact=${farmerContact.text}&form=seedling",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("THE FARMER SEARCHED DATA ::::::::::: ${data}");
        if (data["farmerid"] != null) {
          farmerName.value = data["farmer_name"] ?? '';
          farmerNameController.text = data["farmer_name"] ?? '';
          community.value = data["community_id"] ?? '';
          farmerIDNumber.text = data["contact"] ?? '';
          currentPage.value = 1;
          Get.snackbar(
            'Success',
            'Farmer record found',
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
        } else {
          Get.snackbar(
            'Error',
            'No farmer record found',
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search farmer');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSpeciesSelection(String species, bool selected) {
    if (selected) {
      speciesProvidedPlanted.add(species);
    } else {
      speciesProvidedPlanted.remove(species);
    }
  }

  void toggleSpeciesAlive(String species, bool selected) {
    if (selected) {
      speciesAlive.add(species);
    } else {
      speciesAlive.remove(species);
    }
  }

  void setPlantingDate(String species, DateTime date) {
    plantingDates[species] = '${date.year}-${date.month}-${date.day}';
  }

  void nextPage() {
    if (currentPage.value < 7) {
      currentPage.value++;
      debugPrint(currentPage.value.toString());
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  Future<void> submitData() async {
    isLoading.value = true;

    // TODO: Implement data submission logic
    await Future.delayed(Duration(seconds: 2)); // Simulate API call

    isLoading.value = false;
    Get.offAllNamed('/home');
    Get.snackbar(
      'Success',
      'Data submitted successfully',
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );
  }

  bool validateCurrentPage() {
    switch (currentPage.value) {
      case 0:
        return farmerContact.text.isNotEmpty;
      case 1:
        return surveyorName.text.isNotEmpty &&
            dateOfSurvey.isNotEmpty &&
            (community.isNotEmpty || communityName.text.isNotEmpty) &&
            farmerName.value.isNotEmpty &&
            farmerIDNumber.text.isNotEmpty;
      case 2:
        return plantationType.isNotEmpty && totalSizeAcres.text.isNotEmpty;
      // Add more validations for other pages
      default:
        return true;
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    farmerContact.dispose();
    surveyorName.dispose();
    farmerIDNumber.dispose();
    communityName.dispose();
    totalSizeAcres.dispose();
    totalSeedlingsAlive.dispose();
    otherController.dispose();
    additionalObservations.dispose();
    pestDescription.dispose();
    fertiliserType.dispose();
    pesticideType.dispose();
    diseaseDescription.dispose();

    for (var controller in quantityReceivedControllers.values) {
      controller.dispose();
    }
    for (var controller in quantityPlantedControllers.values) {
      controller.dispose();
    }

  }



}
