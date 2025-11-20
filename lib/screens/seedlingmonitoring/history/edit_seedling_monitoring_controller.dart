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

class EditSeedlingMonitoringController extends GetxController {
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

  // Plantation Type
  final RxString plantationType = ''.obs;
  final RxString otherPlantationType = ''.obs;

  final List<String> plantationTypes = [
    "Cocoa Farm",
    "Woodlot",
    "Degraded Area",
    "Riparian",
    "Modified Taungya System",
    "Other",
  ];

  final RxString dateOfSurvey = ''.obs;
  final RxString community = ''.obs;
  final RxBool communityNotFound = false.obs;
  final RxString customCommunityName = ''.obs;
  final TextEditingController farmerNameController = TextEditingController();
  final TextEditingController farmerIDNumberController =
      TextEditingController();
  final TextEditingController customCommunityNameController =
      TextEditingController();

  final RxString totalSizeAcres = ''.obs;
  final RxList<String> speciesProvidedPlanted = <String>[].obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController otherSpeciesController = TextEditingController();
  final RxList<String> filteredSpeciesList = <String>[].obs;
  final RxList<String> customSpeciesList = <String>[].obs;
  final RxList<String> speciesList = <String>[].obs;

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
  final RxBool hasExtremeWeather = false.obs;
  final RxList<String> extremeWeathers = <String>[].obs;
  final RxString otherExtremeWeather = ''.obs;
  int monitoringID = 0;

  // Final Observations
  final RxBool pestsAround = false.obs;
  final RxString pestDescription = ''.obs;
  final RxBool signsOfDisease = false.obs;
  final RxString diseaseDescription = ''.obs;
  final RxBool fertiliserApplied = false.obs;
  final RxString fertiliserType = ''.obs;
  final RxBool pesticideApplied = false.obs;
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

  void setTotalSizeAcres(String value) {
    farmSizeController.text = value;
    totalSizeAcres.value = value;
    update();
  }

  final TextEditingController speciesSearchController = TextEditingController();

  void filterSpecies(String query) {
    if (query.isEmpty) {
      filteredSpeciesList.assignAll(speciesList);
      filteredSpeciesList.remove('Other');

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

  void loadTreeSpecies() async {
    try {
      final treeSpecies = await TreeSpeciesRepository().getAllTreeSpeciesSeedling();
      debugPrint('TREE SPECIES :::::::::::::: $treeSpecies');
      // Add 'Other' to the list of species
      speciesList.assignAll([...treeSpecies.map((e) => e.name)]);
      filterSpecies(searchController.text);
    } catch (e) {
      debugPrint('Error loading tree species: $e');
    }
  }

  bool isOtherSelected() {
    return speciesProvidedPlanted.contains('Other') || otherSpeciesController.text.isNotEmpty;
  }

  void toggleSpeciesSelection(String species, bool selected) {
    if (selected) {
      // If 'Other' is selected, add it to the list and update UI
      if (species == 'Other') {
        if (!speciesProvidedPlanted.contains('Other')) {
          speciesProvidedPlanted.add('Other');
        }
        update();
        return;
      }

      // For regular species, add them immediately
      if (!speciesProvidedPlanted.contains(species)) {
        speciesProvidedPlanted.add(species);
        quantityReceivedControllers[species] = TextEditingController();
        quantityPlantedControllers[species] = TextEditingController();
      }
    } else {
      // If deselecting 'Other', clear the custom species
      if (species == 'Other') {
        otherSpeciesController.clear();
        for (var custom in customSpeciesList) {
          speciesProvidedPlanted.remove(custom);
          quantityPlantedControllers.remove(custom);
          quantityReceivedControllers.remove(custom);
          plantingDates.remove(custom);
        }
        customSpeciesList.clear();
        speciesProvidedPlanted.remove('Other');
      } else {
        // For regular species, remove them
        speciesProvidedPlanted.remove(species);
        quantityPlantedControllers.remove(species);
        quantityReceivedControllers.remove(species);
        plantingDates.remove(species);
      }
    }
    update();
    markFormAsDirty();
  }

  // Add a custom species when the user types in the 'Other' text field
  void addCustomSpecies(String customName) {
    if (customName.trim().isEmpty) return;

    final speciesName = customName.trim();

    // Add to custom species list if not already there
    if (!customSpeciesList.contains(speciesName)) {
      customSpeciesList.add(speciesName);
    }

    // Add to main species list if not already there
    if (!speciesProvidedPlanted.contains(speciesName)) {
      speciesProvidedPlanted.add(speciesName);
      quantityReceivedControllers[speciesName] = TextEditingController();
      quantityPlantedControllers[speciesName] = TextEditingController();
    }

    update();
    markFormAsDirty();
  }

  @override
  void onInit() {
    super.onInit();
    currentPage.value = 0;
    _initializeForm();
    loadUser();
    loadTreeSpeciesData();
    loadTreeSpecies();
    // Initialize with all species
    ever(speciesList, (_) => filterSpecies(''));

    // Update filtered list when search text changes
    speciesSearchController.addListener(() {
      filterSpecies(speciesSearchController.text);
    });
  }

  @override
  void onClose() {
    _disposeControllers();
    speciesSearchController.dispose();
    super.onClose();
  }

  loadTreeSpeciesData() async {
    try {
      final treeSpecies = await TreeSpeciesRepository()
          .getAllTreeSpeciesSeedling();
      debugPrint('TREE SPECIES :::::::::::::: $treeSpecies');
      speciesList.assignAll(treeSpecies.map((e) => e.name).toList());
    } catch (e) {
      debugPrint('Error loading tree species: $e');
    }
  }

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

  loadUser() async {
    final cache = await CacheService.getInstance();
    _user = await cache.getUserInfo();
    update();
  }

  /// Sync controller with monitoring data - COMPLETELY INITIALIZES ALL FIELDS
  void syncControllerWithMonitoring(SeedlingMonitoringModel monitoring) {
    monitoringID = int.parse(monitoring.id.toString());
    // Initialize the polygon from monitoring data
    if (monitoring.mappedFarmBoundaries != null &&
        monitoring.mappedFarmBoundaries!.isNotEmpty) {
      try {
        final polygonData = json.decode(monitoring.mappedFarmBoundaries!);
        if (polygonData is Map && polygonData['points'] is List) {
          final points = (polygonData['points'] as List).map<LatLng>((point) {
            return LatLng(
              point['latitude'] is num ? point['latitude'].toDouble() : 0.0,
              point['longitude'] is num ? point['longitude'].toDouble() : 0.0,
            );
          }).toList();

          polygon = Polygon(
            polygonId: const PolygonId('farm_polygon'),
            points: points,
            strokeWidth: polygonData['strokeWidth'] is num
                ? polygonData['strokeWidth'].toInt()
                : 2,
            strokeColor: polygonData['strokeColor'] is int
                ? Color(polygonData['strokeColor'])
                : const Color(0xFF00FF00).withOpacity(0.5),
            fillColor: polygonData['fillColor'] is int
                ? Color(polygonData['fillColor']).withOpacity(0.2)
                : const Color(0xFF00FF00).withOpacity(0.2),
          );
        }
      } catch (e) {
        debugPrint('Error initializing polygon: $e');
      }
    }

    debugPrint("STARTING INITIALIZATION");

    // Initialize farm size controller
    farmSizeController.text = monitoring.totalSizeAcres?.toString() ?? '';

    // Use delayed initialization for farmer and community selection
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    initializeFarmerAndCommunity(monitoring);
    // });

    // General Information
    surveyorNameController.text = monitoring.surveyorName ?? '';
    dateOfSurvey.value = monitoring.dateOfSurvey ?? '';
    community.value = monitoring.community ?? '';
    farmerNameController.text = monitoring.farmerName ?? '';
    farmerIDNumberController.text = monitoring.farmerIDNumber ?? '';
    communityNotFound.value = monitoring.communityNotFound ?? false;
    customCommunityName.value = monitoring.customCommunityName ?? '';
    customCommunityNameController.text = monitoring.customCommunityName ?? '';

    // Initialize plantation type
    if (monitoring.plantationType != null &&
        monitoring.plantationType!.isNotEmpty) {
      // Check if the plantation type is one of the predefined types
      if (plantationTypes.contains(monitoring.plantationType)) {
        plantationType.value = monitoring.plantationType!;
        otherPlantationType.value = '';
      } else {
        // If it's not a predefined type, set it as 'Other' and put the value in otherPlantationType
        plantationType.value = 'Other';
        otherPlantationType.value = monitoring.plantationType!;
      }
    }

    // Plantation Details
    totalSizeAcres.value = monitoring.totalSizeAcres?.toString() ?? '';
    farmSizeController.text = monitoring.totalSizeAcres?.toString() ?? '';

    // Species Provided and Planted
    speciesProvidedPlanted.assignAll(monitoring.speciesProvidedPlanted);

    // Initialize species controllers for the selected species
    initializeSpeciesControllers();

    // Species Planting Details
    for (final detail in monitoring.speciesPlantingDetails) {
      if (!quantityReceivedControllers.containsKey(detail.species)) {
        quantityReceivedControllers[detail.species] = TextEditingController();
      }
      if (!quantityPlantedControllers.containsKey(detail.species)) {
        quantityPlantedControllers[detail.species] = TextEditingController();
      }

      quantityReceivedControllers[detail.species]?.text = detail
          .quantityReceived
          .toString();
      quantityPlantedControllers[detail.species]?.text = detail.quantityPlanted
          .toString();
      plantingDates[detail.species] = detail.dateOfPlanting;
    }

    // if a value is in monitoring.speciesProvidedPlanted and not in specieList, add to specieList
    for (final species in monitoring.speciesProvidedPlanted) {
      if (!speciesList.contains(species)) {
        speciesList.add(species);
      }
    }

    // Seedling Survival
    totalSeedlingsAlive.value =
        monitoring.totalSeedlingsAlive?.toString() ?? '';
    speciesAlive.assignAll(monitoring.speciesAlive ?? []);
    reasonForDeath.assignAll(monitoring.reasonForDeath ?? []);

    // Environmental Conditions
    sourceOfWater.assignAll(monitoring.sourceOfWater ?? []);
    waterFrequency.value = monitoring.wateringFrequency ?? '';
    hasExtremeWeather.value = monitoring.hasExtremeWeather ?? false;
    extremeWeathers.assignAll(monitoring.extremeWeathers ?? []);
    otherExtremeWeather.value = monitoring.otherExtremeWeather ?? '';

    // Final Observations
    pestsAround.value = monitoring.pestsAround ?? false;
    pestDescription.value = monitoring.pestDescription ?? '';
    signsOfDisease.value = monitoring.signsOfDisease ?? false;
    diseaseDescription.value = monitoring.diseaseDescription ?? '';
    fertiliserApplied.value = monitoring.fertiliserApplied ?? false;
    fertiliserType.value = monitoring.fertiliserType ?? '';
    pesticideApplied.value = monitoring.pesticideApplied ?? false;
    pesticideType.value = monitoring.pesticideType ?? '';
    additionalObservations.value = monitoring.additionalObservations ?? '';

    // Tree data
    treeData.assignAll(monitoring.treeData ?? []);

    update();
  }

  void initializeFarmerAndCommunity(SeedlingMonitoringModel monitoring) {
    // debugPrint("INITIALIZING FARMER AND COMMUNITY");
    // debugPrint("INITIALIZING FARMER AND COMMUNITY FSRMER ID ::: ${monitoring.farmerIDNumber}");
    // Initialize farmer selection
    if (monitoring.farmerIDNumber != null && farmerData.isNotEmpty) {
      final matchingFarmer = farmerData.firstWhereOrNull(
        (farmer) => farmer.farmercode == monitoring.farmerIDNumber,
      );
      if (matchingFarmer != null) {
        selectedFarmer.value = matchingFarmer;
        // debugPrint("MATCHING FARMER ::::::: ${matchingFarmer}");
      }
    }

    // Initialize community selection
    if (monitoring.community != null && communities.isNotEmpty) {
      final matchingCommunity = communities.firstWhereOrNull(
        (community) => community.id.toString() == monitoring.community,
      );
      if (matchingCommunity != null) {
        selectedCommunity.value = matchingCommunity;
        debugPrint("MATCHING COMMUNITY ::::::: ${matchingCommunity}");
      }
    }

    update();
  }

  void _initializeForm() {
    initializeSpeciesControllers();
    loadCommunities();
    loadFarmerData();
  }

  void initializeSpeciesControllers() {
    for (var species in speciesList) {
      plantingDates[species] = plantingDates[species] ?? '';

      // Only initialize controllers if they don't exist
      if (!quantityReceivedControllers.containsKey(species)) {
        quantityReceivedControllers[species] = TextEditingController();
      }
      if (!quantityPlantedControllers.containsKey(species)) {
        quantityPlantedControllers[species] = TextEditingController();
      }
    }
  }

  // Farmer and Community Methods
  void selectFarmer(FarmerFromServerModel farmer) {
    selectedFarmer.value = farmer;
    farmerNameController.text = farmer.farmerName;
    farmerIDNumberController.text = farmer.farmercode;
    markFormAsDirty();
  }

  void selectCommunity(CommunityModel community) {
    selectedCommunity.value = community;
    selectedFarmer.value = null;
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

  // @override
  // void onClose() {
  //   _disposeControllers();
  //   super.onClose();
  // }

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

  void setHasExtremeWeather(bool value) {
    hasExtremeWeather.value = value;
    if (!value) {
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

  // Final Observations Methods
  void setPestsAround(bool value) {
    pestsAround.value = value;
    if (!value) {
      pestDescription.value = '';
    }
    markFormAsDirty();
  }

  void setSignsOfDisease(bool value) {
    signsOfDisease.value = value;
    if (!value) {
      diseaseDescription.value = '';
    }
    markFormAsDirty();
  }

  void setFertiliserApplied(bool value) {
    fertiliserApplied.value = value;
    if (!value) {
      fertiliserType.value = '';
    }
    markFormAsDirty();
  }

  void setPesticideApplied(bool value) {
    pesticideApplied.value = value;
    if (!value) {
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

      // Create the monitoring model
      final monitoringModel = SeedlingMonitoringModel(
        surveyorName: surveyorNameController.text.trim(),
        enumeratorValue: _user!.id!.toString(),
        dateOfSurvey: dateOfSurvey.value,
        community: community.value,
        customCommunityName: customCommunityName.value,
        farmerIDNumber: farmerIDNumberController.text.trim(),
        farmerName: farmerNameController.text.trim(),
        connectionStatus: "connected",
        communityNotFound: communityNotFound.value,
        plantationType: otherPlantationType.value.isNotEmpty
            ? otherPlantationType.value
            : plantationType.value,
        totalSizeAcres: double.tryParse(farmSizeController.text),
        speciesProvidedPlanted: speciesProvidedPlanted.toList(),
        mappedFarmBoundaries: _getPolygonAsJson(),
        mappedAreaHectares: double.tryParse(totalSizeAcres.value),
        totalSeedlingsAlive: treeData.length,
        speciesAlive: speciesAlive.toList(),
        reasonForDeath: reasonForDeath.toList(),
        sourceOfWater: sourceOfWater.toList(),
        wateringFrequency: waterFrequency.value,
        hasExtremeWeather: hasExtremeWeather.value,
        extremeWeathers: extremeWeathers.toList(),
        otherExtremeWeather: otherExtremeWeather.value,
        speciesPlantingDetails: speciesPlantingDetails,
        pestsAround: pestsAround.value,
        mappedSurvivingSeedlings: treeData.isNotEmpty
            ? json.encode(treeData)
            : null,
        pestDescription: pestDescription.value,
        signsOfDisease: signsOfDisease.value,
        diseaseDescription: diseaseDescription.value,
        fertiliserApplied: fertiliserApplied.value,
        fertiliserType: fertiliserType.value,
        pesticideApplied: pesticideApplied.value,
        pesticideType: pesticideType.value,
        additionalObservations: additionalObservations.value,
      );

      final onLineData = monitoringModel.toApiJson();
      debugPrint("THE ONLINE DATA ::::::::: $onLineData");

      onLineData["name_of_community"] = customCommunityName.value == ''
          ? selectedCommunity.value!.community
          : customCommunityName.value;

      onLineData["farm_boundary"] = _getPolygonAsGeoJson();

      Globals().startWait(seedlingMonitoringScreenContext!);
      final res = await APIMethods().submitSeedlingMonitoringToServer(
        onLineData,
      );
      Globals().endWait(seedlingMonitoringScreenContext);

      debugPrint("THE RESPONSE FROM THE SERVER ::::::::: $res");

      if (res["success"] == true) {
        await SeedlingMonitoringRepository().markAsSynced(monitoringID);

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
    } catch (e) {
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

      // Create the monitoring model
      final monitoringModel = SeedlingMonitoringModel(
        id: monitoringID,
        surveyorName: surveyorNameController.text.trim(),
        enumeratorValue: _user!.id!.toString(),
        dateOfSurvey: dateOfSurvey.value,
        community: community.value,
        customCommunityName: customCommunityName.value,
        farmerIDNumber: farmerIDNumberController.text.trim(),
        farmerName: farmerNameController.text.trim(),
        connectionStatus: "not connected",
        communityNotFound: communityNotFound.value,
        plantationType: otherPlantationType.value.isNotEmpty
            ? otherPlantationType.value
            : plantationType.value,
        totalSizeAcres: double.tryParse(farmSizeController.text),
        speciesProvidedPlanted: speciesProvidedPlanted.toList(),
        mappedFarmBoundaries: _getPolygonAsJson(),
        mappedAreaHectares: double.tryParse(totalSizeAcres.value),
        totalSeedlingsAlive: treeData.length,
        speciesAlive: speciesAlive.toList(),
        reasonForDeath: reasonForDeath.toList(),
        sourceOfWater: sourceOfWater.toList(),
        wateringFrequency: waterFrequency.value,
        hasExtremeWeather: hasExtremeWeather.value,
        extremeWeathers: extremeWeathers.toList(),
        otherExtremeWeather: otherExtremeWeather.value,
        speciesPlantingDetails: speciesPlantingDetails,
        pestsAround: pestsAround.value,
        mappedSurvivingSeedlings: treeData.isNotEmpty
            ? json.encode(treeData)
            : null,
        pestDescription: pestDescription.value,
        signsOfDisease: signsOfDisease.value,
        diseaseDescription: diseaseDescription.value,
        fertiliserApplied: fertiliserApplied.value,
        fertiliserType: fertiliserType.value,
        pesticideApplied: pesticideApplied.value,
        pesticideType: pesticideType.value,
        additionalObservations: additionalObservations.value,
      );

      final offlineData = monitoringModel.toJson();
      debugPrint("THE OFFLINE DATA ::::::::: $offlineData");

      final res = await SeedlingMonitoringRepository().update(monitoringModel);
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
    } catch (e) {
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
    community.value = '';
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
    hasExtremeWeather.value = false;
    extremeWeathers.clear();
    otherExtremeWeather.value = '';

    // Final observations
    pestsAround.value = false;
    pestDescription.value = '';
    signsOfDisease.value = false;
    diseaseDescription.value = '';
    fertiliserApplied.value = false;
    fertiliserType.value = '';
    pesticideApplied.value = false;
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
            (community.value.isNotEmpty ||
                customCommunityName.value.isNotEmpty) &&
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
      if (quantityPlantedControllers[species]?.text.isEmpty ?? true)
        return false;
      if (quantityReceivedControllers[species]?.text.isEmpty ?? true)
        return false;
      if (plantingDates[species]?.isEmpty ?? true) return false;
    }
    return true;
  }

  bool _validateEnvironmentalConditions() {
    return sourceOfWater.isNotEmpty && waterFrequency.value.isNotEmpty;
  }

  bool _validateFinalObservations() {
    // Check pest observation
    if (pestsAround.value == true && pestDescription.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please provide pest description when "Yes" is selected for pests around',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Check disease observation
    if (signsOfDisease.value == true && diseaseDescription.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please provide disease description when "Yes" is selected for signs of disease',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Check fertiliser application
    if (fertiliserApplied.value == true && fertiliserType.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please specify the type of fertilizer applied when "Yes" is selected',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Check pesticide application
    if (pesticideApplied.value == true && pesticideType.value.isEmpty) {
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
