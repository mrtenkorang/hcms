import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/establishment_type_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/seedling_monitoring_model.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/establishment_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/controller/repos/seedling_monitoring_reepo.dart';
import 'package:hcms_revived2/controller/repos/tree_species_repo.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map_controller.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:intl/intl.dart';

class SeedlingMonitoringController extends GetxController {
  BuildContext? seedlingMonitoringScreenContext;

  final PickTreeMapController pickTreeMapController = Get.put(
    PickTreeMapController(),
  );

  // Reactive variables for page navigation
  final RxInt currentPage = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFormDirty = false.obs;

  TextEditingController farmSizeController = TextEditingController();

  // Farmer and Community Selection
  final Rx<FarmerFromServerModel?> selectedFarmer = Rx<FarmerFromServerModel?>(
    null,
  );
  final Rx<CommunityModel?> selectedCommunity = Rx<CommunityModel?>(null);
  final RxList<FarmerFromServerModel> farmerData =
      <FarmerFromServerModel>[].obs;
  final RxList<CommunityModel> communities = <CommunityModel>[].obs;

  // General Information
  final TextEditingController surveyorNameController = TextEditingController();
  final RxString dateOfSurvey = ''.obs;
  final RxBool communityNotFound = false.obs;
  final RxString customCommunityName = ''.obs;
  final TextEditingController farmerNameController = TextEditingController();
  final TextEditingController farmerIDNumberController =
      TextEditingController();

  final TextEditingController searchController = TextEditingController();
  final RxList<String> filteredSpeciesList = <String>[].obs;

  // Plantation Details
  final RxString plantationType = ''.obs;
  final RxString totalSizeAcres = ''.obs;
  final RxList<String> speciesProvidedPlanted = <String>[].obs;

  // Species Details
  final Map<String, TextEditingController> quantityReceivedControllers = {};
  final Map<String, TextEditingController> quantityPlantedControllers = {};
  final Map<String, String> plantingDates = <String, String>{}.obs;

  // Seedling Survival
  final RxString totalSeedlingsAlive = ''.obs;
  final RxList<String> speciesAlive = <String>[].obs;
  final RxList<String> reasonForDeath = <String>[].obs;

  // Environmental Conditions
  final RxList<String> sourceOfWater = <String>[].obs;
  final RxString waterFrequency = ''.obs;
  RxString? hasExtremeWeather = "".obs;
  final RxList<String> extremeWeathers = <String>[].obs;
  final RxString otherExtremeWeather = ''.obs;

  // Final Observations - Changed from RxBool? to RxString?
  RxString? pestsAround = "".obs;
  final RxString pestDescription = ''.obs;
  RxString? signsOfDisease = "".obs;
  final RxString diseaseDescription = ''.obs;
  RxString? fertiliserApplied = "".obs;
  final RxString fertiliserType = ''.obs;
  RxString? pesticideApplied = "".obs;
  final RxString pesticideType = ''.obs;
  final RxString additionalObservations = ''.obs;

  // Tree data management
  final RxList<Map<String, dynamic>> treeData = <Map<String, dynamic>>[].obs;

  final RxMap<String, int> treeTypeCount = <String, int>{}.obs;

  /// Counts the number of trees of each type in [treeData].
  ///
  /// This function clears the [treeTypeCount] map and then iterates over each
  /// tree in [treeData]. For each tree, it retrieves the tree type and increments
  /// the count for that tree type in [treeTypeCount].
  ///
  /// This function is useful for getting an overview of the distribution of tree
  /// types in the survey.
  ///
  /// This function does not return anything, but it updates the [treeTypeCount]
  /// map.
  void getTreeTypeCount() {
    // Clear the map first
    treeTypeCount.clear();

    if (treeData.isEmpty) {
      Globals().showSnackBar(
        title: "No Trees Mapped",
        message: "Please map at least one tree before proceeding.",
        backgroundColor: Colors.red,
        duration: 8,
      );
      return;
    }

    // Iterate over each tree in treeData
    for (var tree in treeData) {
      // Get the tree type from the tree data. If the tree type is null,
      // replace it with 'Unknown'.
      final treeType = tree['treeType']?.toString() ?? 'Unknown';

      // Increment the count for the current tree type in treeTypeCount. If the
      // tree type is not yet in treeTypeCount, set its count to 1. Otherwise,
      // increment its count by 1.
      treeTypeCount[treeType] = (treeTypeCount[treeType] ?? 0) + 1;
    }

    // Print the updated treeTypeCount map for debugging purposes
    debugPrint('Tree Type Counts: $treeTypeCount');
  }

  /// Verifies if the quantity of trees mapped matches the quantity planted for each species.
  ///
  /// Returns `true` if for every tree type in [treeTypeCount], the count matches
  /// the value in [quantityPlantedControllers]. Returns `false` if any count doesn't match
  /// or if a tree type is missing from either map.
  bool verifyTreeSpeciesMappedQuantity() {
    // First ensure we have the latest counts
    getTreeTypeCount();

    // Check if both maps have the same set of keys
    final treeTypes = treeTypeCount.keys.toSet();
    final plantedTypes = quantityPlantedControllers.keys.toSet();

    // Check each tree type
    for (final type in treeTypes) {
      final mappedCount = treeTypeCount[type] ?? 0;
      final plantedText = quantityPlantedControllers[type]?.text;
      final plantedCount = int.tryParse(plantedText ?? '') ?? 0;

      debugPrint('Checking $type: mapped=$mappedCount, planted=$plantedCount');

      if (mappedCount > plantedCount) {
        debugPrint(
          'Mismatch for $type: mapped=$mappedCount, planted=$plantedCount',
        );
        Globals().showSnackBar(
          title: "Mismatched",
          message:
              "Number of trees mapped for $type ($mappedCount) doesn't match the quantity planted ($plantedCount).",
          backgroundColor: Colors.red,
          duration: 8,
        );
        return false;
      }
    }
    return true;
  }

  // Map data
  Set<Polyline> polyLines = HashSet<Polyline>();
  Set<Marker>? markers;
  Polygon? polygon;

  final mapFarmFormKey = GlobalKey<FormState>();
  Globals globals = Globals();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final RxList<String> speciesList = <String>[].obs;
  final TextEditingController speciesSearchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
    loadUser();
    loadTreeSpecies();
    loadFarmerData();
    loadCommunities();

    // Initialize with all species
    ever(speciesList, (_) => filterSpecies(''));

    // Update filtered list when search text changes
    searchController.addListener(() {
      filterSpecies(searchController.text);
    });
  }

  void filterSpecies(String query) {
    if (query.isEmpty) {
      filteredSpeciesList.assignAll(speciesList);

      debugPrint('Filtered species list: $filteredSpeciesList');
    } else {
      filteredSpeciesList.assignAll(
        speciesList
            .where(
              (species) => species.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  // Available options for dropdowns and selections
  final List<String> plantationTypes = [
    "Cocoa Farm",
    "Woodlot",
    "Degraded Area",
    "Riparian",
    "Others",
  ];

  void loadTreeSpecies() async {
    try {
      final treeSpecies = await TreeSpeciesRepository()
          .getAllTreeSpeciesSeedling();
      debugPrint('TREE SPECIES :::::::::::::: $treeSpecies');
      speciesList.assignAll(treeSpecies.map((e) => e.name).toList());
      filterSpecies(searchController.text);
    } catch (e) {
      debugPrint('Error loading tree species: $e');
    }
  }

  // final List<String> speciesList = [
  //   "Prekese",
  //   "Kokrodua_Afromosia",
  //   "Dahoma",
  //   "Edinam",ghjkl
  //   "Emire",
  //   "Ofram",
  //   "Mahogany_Dubini",
  //   "Mansonia_Oprono",
  //   "Okoro",
  //   "Efoobodedwo_Utile",
  //   "Bako",
  // ];

  final List<String> waterSources = [
    "Rain_Fed",
    "Manual_Watering",
    "Irrigation_With_Pumps",
  ];

  final List<Map<String, String>> frequencyOptions = [
    {"label": "Daily", "value": "Daily"},
    {"label": "Weekly", "value": "Weekly"},
    {"label": "Monthly", "value": "Monthly"},
    {"label": "Rarely/Never", "value": "Rarely_Never"},
  ];

  final List<String> weatherEvents = ["Drought", "Flooding", "Fire", "Other"];
  final List<String> deathReasons = [
    "Disease",
    "Drought",
    "Pest",
    "Vandalism",
    "Transportation_Shocks",
    "none",
  ];

  UserModel? _user;

  void setTotalSizeAcres(String value) {
    farmSizeController.text = value;
    totalSizeAcres.value = value;
    update();
  }

  loadUser() async {
    final cache = await CacheService.getInstance();
    _user = await cache.getUserInfo();
    surveyorNameController.text = "${_user!.fname} ${_user!.sname}";
    update();
  }

  void _initializeForm() {
    initializeSpeciesControllers();
    loadCommunities();
    loadFarmerData();
  }

  void initializeSpeciesControllers() {
    for (var species in speciesList) {
      plantingDates[species] = '';
    }
  }

  // Farmer and Community Methods
  void selectFarmer(FarmerFromServerModel farmer) {
    selectedFarmer.value = farmer;
    farmerNameController.text = farmer.farmerName;
    farmerIDNumberController.text = farmer.farmercode;
    update();
    markFormAsDirty();
  }

  void selectCommunity(CommunityModel community) {
    selectedCommunity.value = community;
    if (community.id != null) {
      customCommunityName.value = community.community ?? '';
    }
    markFormAsDirty();
  }

  Future<void> loadFarmerData() async {
    try {
      final farmers = await FarmerFromServerRepository().getAllFarmers();
      farmerData.assignAll(farmers);
    } catch (e) {
      debugPrint('Error loading farmers: $e');
    }
  }

  Future<void> loadCommunities() async {
    try {
      final result = await CommunityRepository().getAllCommunities();
      communities.assignAll(result);
    } catch (e) {
      debugPrint("FAILED TO LOAD COMMUNITIES: $e");
    }
  }

  // Species Methods
  void toggleSpeciesSelection(String species, bool selected) {
    if (selected) {
      speciesProvidedPlanted.add(species);
      quantityReceivedControllers[species] = TextEditingController();
      quantityPlantedControllers[species] = TextEditingController();
    } else {
      speciesProvidedPlanted.remove(species);
      quantityPlantedControllers.remove(species);
      quantityReceivedControllers.remove(species);
      plantingDates.remove(species);
    }
    markFormAsDirty();
  }

  void toggleSpeciesAlive(String species, bool selected) {
    if (selected) {
      speciesAlive.add(species);
    } else {
      speciesAlive.remove(species);
    }
    markFormAsDirty();
  }

  void setPlantingDate(String species, DateTime date) {
    plantingDates[species] = '${date.year}-${date.month}-${date.day}';
    markFormAsDirty();
  }

  void setQuantityReceived(String species, String value) {
    if (!quantityReceivedControllers.containsKey(species)) {
      quantityReceivedControllers[species] = TextEditingController(text: value);
    } else {
      quantityReceivedControllers[species]!.text = value;
    }
    markFormAsDirty();
    update();
  }

  void setQuantityPlanted(String species, String value) {
    if (!quantityPlantedControllers.containsKey(species)) {
      quantityPlantedControllers[species] = TextEditingController(text: value);
    } else {
      quantityPlantedControllers[species]!.text = value;
    }
    markFormAsDirty();
    update();
  }

  @override
  void onClose() {
    _disposeControllers();
    searchController.dispose();
    super.onClose();
  }

  void _disposeControllers() {
    for (var controller in quantityReceivedControllers.values) {
      controller.dispose();
    }
    for (var controller in quantityPlantedControllers.values) {
      controller.dispose();
    }
    quantityReceivedControllers.clear();
    quantityPlantedControllers.clear();
  }

  validateMappedTreeLengthSpecies() {}

  // Environmental Conditions Methods
  void toggleWaterSource(String source, bool selected) {
    if (selected) {
      sourceOfWater.add(source);
    } else {
      sourceOfWater.remove(source);
    }
    markFormAsDirty();
  }

  void toggleExtremeWeather(String weather, bool selected) {
    if (selected) {
      extremeWeathers.add(weather);
    } else {
      extremeWeathers.remove(weather);
      if (weather == "Other") {
        otherExtremeWeather.value = '';
      }
    }
    markFormAsDirty();
  }

  void setWaterFrequency(String frequency) {
    waterFrequency.value = frequency;
    markFormAsDirty();
  }

  void setHasExtremeWeather(String value) {
    hasExtremeWeather!.value = value;
    if (value == "No") {
      extremeWeathers.clear();
      otherExtremeWeather.value = '';
    }
    markFormAsDirty();
  }

  // Seedling Survival Methods
  void toggleReasonForDeath(String reason, bool selected) {
    if (selected) {
      reasonForDeath.add(reason);
    } else {
      reasonForDeath.remove(reason);
    }
    markFormAsDirty();
  }

  // Final Observations Methods - Updated to accept String
  void setPestsAround(String value) {
    pestsAround!.value = value;
    if (value == "No") {
      pestDescription.value = '';
    }
    markFormAsDirty();
  }

  void setSignsOfDisease(String value) {
    signsOfDisease!.value = value;
    if (value == "No") {
      diseaseDescription.value = '';
    }
    markFormAsDirty();
  }

  void setFertiliserApplied(String value) {
    fertiliserApplied!.value = value;
    if (value == "No") {
      fertiliserType.value = '';
    }
    markFormAsDirty();
  }

  void setPesticideApplied(String value) {
    pesticideApplied!.value = value;
    if (value == "No") {
      pesticideType.value = '';
    }
    markFormAsDirty();
  }

  // Navigation Methods
  void nextPage() {
    if (currentPage.value < 7) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  // Tree Data Methods
  void addTree(Map<String, dynamic> tree) {
    treeData.add(tree);
    markFormAsDirty();
  }

  void removeTree(String treeId) {
    treeData.removeWhere((tree) => tree['id'] == treeId);
    markFormAsDirty();
  }

  // Form State Management
  void markFormAsDirty() {
    if (!isFormDirty.value) {
      isFormDirty.value = true;
    }
  }

  void markFormAsClean() {
    isFormDirty.value = false;
  }

  // Map Methods
  void usePolygonDrawingTool() {
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon != null) polys.add(polygon!);

    Get.to(
      () => PolygonDrawingTool(
        layers: polys,
        initialPolygon: polygon,
        viewInitialPolygon: polygon != null,
        useBackgroundLayers: false,
        allowTappingInputMethod: false,
        allowTracingInputMethod: false,
        maxAccuracy: MaxLocationAccuracy.max,
        persistMaxAccuracy: true,
        onSave: (poly, mkr, area) {
          if (mkr.isNotEmpty) {
            polygon = poly;
            markers = mkr;
            totalSizeAcres.value = area.truncateToDecimalPlaces(6).toString();
            farmSizeController.text = area
                .truncateToDecimalPlaces(6)
                .toString();
            markFormAsDirty();

            globals.showOkayDialog(
              context: seedlingMonitoringScreenContext,
              title: 'Measurement Result',
              image: 'lib/libassets/logos/hcmslogo.jpeg',
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'measured area estimates in hectares',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${area.truncateToDecimalPlaces(6).toString()} ha',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      transition: Transition.fadeIn,
    );
  }

  String? _getPolygonAsJson() {
    if (polygon == null) return null;
    try {
      final polygonData = {
        'points': polygon!.points
            .map(
              (point) => {
                'latitude': point.latitude,
                'longitude': point.longitude,
              },
            )
            .toList(),
        'strokeColor': polygon!.strokeColor.value,
        'fillColor': polygon!.fillColor.value,
        'strokeWidth': polygon!.strokeWidth,
      };
      return json.encode(polygonData);
    } catch (e) {
      debugPrint('Error converting polygon to JSON: $e');
      return null;
    }
  }

  String? _getPolygonAsGeoJson() {
    if (polygon == null) return null;
    try {
      final coordinates = polygon!.points
          .map((point) => [point.longitude, point.latitude])
          .toList();

      if (coordinates.isNotEmpty && coordinates.first != coordinates.last) {
        coordinates.add(coordinates.first);
      }

      final geoJson = {
        "type": "Polygon",
        "coordinates": [coordinates],
      };

      return json.encode(geoJson);
    } catch (e) {
      debugPrint('Error converting polygon to GeoJSON: $e');
      return null;
    }
  }

  Future<void> submitDataOnline() async {
    isLoading.value = true;
    try {
      if (!_validateFinalObservations()) {
        return;
      }

      List<SpeciesPlantingDetail> speciesPlantingDetails = [];

      for (final species in speciesProvidedPlanted) {
        final received = int.tryParse(
          quantityReceivedControllers[species]!.text,
        );
        final planted = int.tryParse(quantityPlantedControllers[species]!.text);
        final date = plantingDates[species];

        if (received != null && planted != null && date != null) {
          final detail = SpeciesPlantingDetail(
            species: species,
            quantityReceived: received,
            quantityPlanted: planted,
            dateOfPlanting: date,
          );

          speciesPlantingDetails.add(detail);
        }
      }

      selectedCommunity.value = CommunityModel(id: 0, community: "0");

      // Create the monitoring model - Updated boolean conversions
      final monitoringModel = SeedlingMonitoringModel(
        surveyorName: surveyorNameController.text.trim(),
        enumeratorValue: _user!.id!.toString(),
        dateOfSurvey: dateOfSurvey.value,
        community: selectedCommunity.value!.id!.toString(),
        customCommunityName: customCommunityName.value,
        farmerIDNumber: farmerIDNumberController.text.trim(),
        farmerName: farmerNameController.text.trim(),
        connectionStatus: "connected",
        communityNotFound: communityNotFound.value,
        plantationType: plantationType.value,
        totalSizeAcres: double.tryParse(farmSizeController.text),
        speciesProvidedPlanted: speciesProvidedPlanted.toList(),
        mappedFarmBoundaries: _getPolygonAsGeoJson(),
        mappedAreaHectares: double.tryParse(totalSizeAcres.value),
        totalSeedlingsAlive: treeData.length,
        speciesAlive: speciesAlive.toList(),
        reasonForDeath: reasonForDeath.toList(),
        sourceOfWater: sourceOfWater.toList(),
        wateringFrequency: waterFrequency.value,
        hasExtremeWeather: hasExtremeWeather!.value == "Yes",
        extremeWeathers: extremeWeathers.toList(),
        otherExtremeWeather: otherExtremeWeather.value,
        speciesPlantingDetails: speciesPlantingDetails,
        // Updated boolean conversions from String
        pestsAround: pestsAround!.value == "Yes",
        mappedSurvivingSeedlings: treeData.isNotEmpty
            ? json.encode(treeData)
            : null,
        pestDescription: pestDescription.value,
        signsOfDisease: signsOfDisease!.value == "Yes",
        diseaseDescription: diseaseDescription.value,
        fertiliserApplied: fertiliserApplied!.value == "Yes",
        fertiliserType: fertiliserType.value,
        pesticideApplied: pesticideApplied!.value == "Yes",
        pesticideType: pesticideType.value,
        additionalObservations: additionalObservations.value,
      );

      final onLineData = monitoringModel.toApiJson();
      debugPrint("THE ONLINE DATA ::::::::: $onLineData");

      onLineData["name_of_community"] = customCommunityName.value == ''
          ? selectedCommunity.value!.community
          : customCommunityName.value;

      Globals().startWait(seedlingMonitoringScreenContext!);
      final res = await APIMethods().submitSeedlingMonitoringToServer(
        onLineData,
      );
      Globals().endWait(seedlingMonitoringScreenContext);

      if (res["success"] == true) {
        await SeedlingMonitoringRepository().create(monitoringModel);
        Get.snackbar(
          'Success',
          'Data submitted successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        _resetFormAndNavigate();
      } else {
        Get.snackbar(
          'Error',
          res["error"],
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("THE SAVE ERROR ::::::::::::::: ${e}");
      debugPrint("THE SAVE ERROR ::::::::::::::: ${stackTrace}");
      Get.snackbar(
        'Submission Error',
        'Failed to submit data: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDataOffline() async {
    if (!_validateFinalObservations()) {
      return;
    }

    isLoading.value = true;
    try {
      List<SpeciesPlantingDetail> speciesPlantingDetails = [];

      for (final species in speciesProvidedPlanted) {
        final received = int.tryParse(
          quantityReceivedControllers[species]!.text,
        );
        final planted = int.tryParse(quantityPlantedControllers[species]!.text);
        final date = plantingDates[species];

        if (received != null && planted != null && date != null) {
          final detail = SpeciesPlantingDetail(
            species: species,
            quantityReceived: received,
            quantityPlanted: planted,
            dateOfPlanting: date,
          );

          speciesPlantingDetails.add(detail);
        }
      }

      if(selectedCommunity.value == null) {
        selectedCommunity.value = CommunityModel(id: 0, community: "0");
      }

      // Create the monitoring model - Updated boolean conversions
      final monitoringModel = SeedlingMonitoringModel(
        surveyorName: surveyorNameController.text.trim(),
        enumeratorValue: _user!.id!.toString(),
        dateOfSurvey: dateOfSurvey.value,
        customCommunityName: customCommunityName.value,
        community: selectedCommunity.value!.id!.toString(),
        farmerIDNumber: farmerIDNumberController.text.trim(),
        farmerName: farmerNameController.text.trim(),
        connectionStatus: "not connected",
        communityNotFound: communityNotFound.value,
        plantationType: plantationType.value,
        totalSizeAcres: double.tryParse(farmSizeController.text),
        speciesProvidedPlanted: speciesProvidedPlanted.toList(),
        mappedFarmBoundaries: _getPolygonAsGeoJson(),
        mappedAreaHectares: double.tryParse(totalSizeAcres.value),
        totalSeedlingsAlive: treeData.length,
        speciesAlive: speciesAlive.toList(),
        reasonForDeath: reasonForDeath.toList(),
        sourceOfWater: sourceOfWater.toList(),
        wateringFrequency: waterFrequency.value,
        hasExtremeWeather: hasExtremeWeather!.value == "Yes",
        extremeWeathers: extremeWeathers.toList(),
        otherExtremeWeather: otherExtremeWeather.value,
        speciesPlantingDetails: speciesPlantingDetails,
        // Updated boolean conversions from String
        pestsAround: pestsAround!.value == "Yes",
        mappedSurvivingSeedlings: treeData.isNotEmpty
            ? json.encode(treeData)
            : null,
        pestDescription: pestDescription.value,
        signsOfDisease: signsOfDisease!.value == "Yes",
        diseaseDescription: diseaseDescription.value,
        fertiliserApplied: fertiliserApplied!.value == "Yes",
        fertiliserType: fertiliserType.value,
        pesticideApplied: pesticideApplied!.value == "Yes",
        pesticideType: pesticideType.value,
        additionalObservations: additionalObservations.value,
      );

      final offlineData = monitoringModel.toJson();
      debugPrint("THE OFFLINE DATA ::::::::: $offlineData");

      final res = await SeedlingMonitoringRepository().create(monitoringModel);
      if (res > 0) {
        Get.snackbar(
          'Success',
          'Data saved offline successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        _resetFormAndNavigate();
      } else {
        Get.snackbar(
          'Error',
          'Failed to save data offline',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("THE SAVE ERROR ::::::::::::::: ${e}");
      debugPrint("THE SAVE ERROR ::::::::::::::: ${stackTrace}");
      Get.snackbar(
        'Save Error',
        'Failed to save data: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _resetFormAndNavigate() {
    clearFormAndReset();
    if (seedlingMonitoringScreenContext != null &&
        seedlingMonitoringScreenContext!.mounted) {
      Navigator.of(seedlingMonitoringScreenContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const IndexPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void clearFormAndReset() {
    // Reset page navigation
    currentPage.value = 0;

    // Clear all text controllers
    surveyorNameController.clear();
    farmerNameController.clear();
    farmerIDNumberController.clear();
    farmSizeController.clear();

    // Clear all reactive variables
    dateOfSurvey.value = '';
    communityNotFound.value = false;
    customCommunityName.value = '';

    plantationType.value = '';
    totalSizeAcres.value = '';
    speciesProvidedPlanted.clear();

    // Clear species controllers and dates
    _disposeControllers();
    plantingDates.clear();

    totalSeedlingsAlive.value = '';
    speciesAlive.clear();
    reasonForDeath.clear();

    sourceOfWater.clear();
    waterFrequency.value = '';
    hasExtremeWeather!.value = "";
    extremeWeathers.clear();
    otherExtremeWeather.value = '';

    // Final observations - Reset to empty strings
    pestsAround!.value = "";
    pestDescription.value = '';
    signsOfDisease!.value = "";
    diseaseDescription.value = '';
    fertiliserApplied!.value = "";
    fertiliserType.value = '';
    pesticideApplied!.value = "";
    pesticideType.value = '';
    additionalObservations.value = '';

    // Tree and map data
    treeData.clear();
    polygon = null;
    markers?.clear();
    polyLines.clear();

    // Selection data
    selectedCommunity.value = null;
    selectedFarmer.value = null;

    markFormAsClean();
    initializeSpeciesControllers();
  }

  // Validation methods
  bool validateCurrentPage() {
    switch (currentPage.value) {
      case 0:
        return selectedFarmer.value != null;
      case 1:
        return surveyorNameController.text.isNotEmpty &&
            dateOfSurvey.value.isNotEmpty &&
            farmerNameController.text.isNotEmpty &&
            farmerIDNumberController.text.isNotEmpty;
      case 2:
        return plantationType.value.isNotEmpty &&
            totalSizeAcres.value.isNotEmpty;
      case 3:
        return _validateSpeciesDetails();
      case 4:
        return polygon != null && totalSizeAcres.value.isNotEmpty;
      case 6:
        return _validateEnvironmentalConditions();
      case 7:
        return _validateFinalObservations();
      default:
        return true;
    }
  }

  bool _validateSpeciesDetails() {
    if (speciesProvidedPlanted.isEmpty) return false;
    for (final species in speciesProvidedPlanted) {
      if (quantityPlantedControllers[species]?.text.isEmpty ?? true) {
        return false;
      }
      if (quantityReceivedControllers[species]?.text.isEmpty ?? true) {
        return false;
      }
      if (plantingDates[species]?.isEmpty ?? true) return false;
    }
    return true;
  }

  bool _validateEnvironmentalConditions() {
    return sourceOfWater.isNotEmpty && waterFrequency.value.isNotEmpty;
  }

  bool _validateFinalObservations() {
    // Check pest observation
    if (pestsAround!.value == "Yes" && pestDescription.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please provide pest description when "Yes" is selected for pests around',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Check disease observation
    if (signsOfDisease!.value == "Yes" && diseaseDescription.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please provide disease description when "Yes" is selected for signs of disease',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Check fertiliser application
    if (fertiliserApplied!.value == "Yes" && fertiliserType.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please specify the type of fertilizer applied when "Yes" is selected',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Check pesticide application
    if (pesticideApplied!.value == "Yes" && pesticideType.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please specify the type of pesticide applied when "Yes" is selected',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    return true;
  }
}
