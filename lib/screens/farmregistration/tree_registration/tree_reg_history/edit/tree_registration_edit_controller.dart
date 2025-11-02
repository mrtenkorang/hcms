import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/controller/repos/tree_reg_repo.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/district_region_model.dart';
import 'package:hcms_revived2/controller/models/establishment_type_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/mmda_model.dart';
import 'package:hcms_revived2/controller/repos/dsitrict_region_repos.dart';
import 'package:hcms_revived2/controller/repos/establishment_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/controller/repos/mmda_repo.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map.dart';


class TreeRegistrationEditController extends GetxController {
  // Context for navigation and dialogs
  BuildContext? treeRegisterScreenContext;

  // The original model being edited
  TreeRegistrationModel? originalModel;
  int? registrationId;

  // Selected values with reactive observables
  var selectedFarmer = Rxn<FarmerFromServerModel>();
  var selectedRegion = Rxn<DistrictModel>();
  var selectedDistrict = Rxn<DistrictModel>();
  var selectedMMDA = Rxn<MMDAModel>();
  var selectedCommunity = Rxn<CommunityModel>();

  // Multi-select establishment types
  var selectedEstablishmentTypes = <String>[].obs;

  // Tree details controllers
  final treeNameController = TextEditingController();
  final treeSizeController = TextEditingController();
  var pnValue = ''.obs;
  var treeSpeciesValue = ''.obs;
  var yoEstablishment = ''.obs;
  final pnValues = ["Planted", "Natural"];
  final treeSpeciesValues = ["Acacia", "Bamboo", "Teak", "Mahogany", "Other"];

  // Data lists
  var farmerData = <FarmerFromServerModel>[].obs;
  var regionsData = <DistrictModel>[].obs;
  var filteredDistricts = <DistrictModel>[].obs;
  var mmdasData = <MMDAModel>[].obs;
  var communitiesData = <CommunityModel>[].obs;
  var establishmentTypesData = <EstaTypeModel>[].obs;

  // Text editing controllers
  final nextOfKinNameController = TextEditingController();
  final relationShipWithNextOfKinController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final postalAddressController = TextEditingController();
  final witnessNameController = TextEditingController();
  final witnessPhoneController = TextEditingController();

  // Group controllers
  final groupNameController = TextEditingController();
  final groupPresidentController = TextEditingController();
  final groupSecretaryController = TextEditingController();
  final groupDirectorsController = TextEditingController();
  final companyDirectorsController = TextEditingController();
  final groupPhoneController = TextEditingController();
  final groupregNumbController = TextEditingController();
  final groupEmailController = TextEditingController();
  final groupAddressController = TextEditingController();

  // Loading states
  var isLoadingFarmers = false.obs;
  var isLoadingRegions = false.obs;
  var isLoadingDistricts = false.obs;
  var isLoadingMMDAs = false.obs;
  var isLoadingCommunities = false.obs;
  var isLoadingEstablishmentTypes = false.obs;
  var isLoadingData = false.obs;

  // Mapping related observables
  var markers = Rxn<Set<Marker>>();
  var polygon = Rxn<Polygon>();
  var totalSizeAcres = ''.obs;

  final treeData = <Map<String, dynamic>>[].obs;

  // Computed properties
  bool get showTreeDetailsSection {
    final selectedTypes = selectedEstablishmentTypes;
    return selectedTypes.contains('Woodlot') ||
        selectedTypes.contains('Commercial Plantation') ||
        selectedTypes.contains('Other');
  }

  bool isTreeDataEmpty() {
    return treeData.isEmpty;
  }

  // Initialize with existing data
  Future<void> initializeWithData(TreeRegistrationModel model, int id) async {
    isLoadingData.value = true;
    originalModel = model;
    registrationId = id;

    try {
      // Load all necessary data first
      await _loadAllData();

      // Initialize form fields with model data
      _initializeFormFields(model);

      // Initialize mapping data if available
      _initializeMappingData(model);

      // Initialize tree data
      _initializeTreeData(model);

    } catch (e) {
      debugPrint('Error initializing edit form: $e');
      Get.snackbar(
        'Error',
        'Failed to load registration data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingData.value = false;
    }
  }

  void _initializeFormFields(TreeRegistrationModel model) {
    // Initialize establishment types
    if (model.establishmentType != null && model.establishmentType!.isNotEmpty) {
      selectedEstablishmentTypes.assignAll(model.establishmentType!.split(', '));
    }

    // Initialize next of kin data
    nextOfKinNameController.text = model.nextOfKinName ?? '';
    relationShipWithNextOfKinController.text = model.farmerRelationshipWithNextOfKin ?? '';

    if (model.nextOfKinDoB != null) {
      dobController.text = '${model.nextOfKinDoB!.year}-${model.nextOfKinDoB!.month}-${model.nextOfKinDoB!.day}';
    }

    // Initialize selected region
    selectedRegion.value = regionsData.firstWhere((region) => region.id == model.regionId);


    genderController.text = model.nextOfKinGender ?? '';
    phoneNumberController.text = model.nextOfKinPhoneNumber ?? '';
    postalAddressController.text = model.nextOfKinPostalAddress ?? '';

    // Initialize group data
    groupNameController.text = model.groupName ?? '';
    groupPresidentController.text = model.groupPresident ?? '';
    groupSecretaryController.text = model.groupSecretary ?? '';
    companyDirectorsController.text = model.companyDirectors ?? '';
    groupPhoneController.text = model.groupPhoneNumber ?? '';
    groupEmailController.text = model.groupEmail ?? '';
    groupAddressController.text = model.groupPostalAddress ?? '';
    groupregNumbController.text = model.groupRegNumb ?? '';

    // Set farm size
    if (model.farmSize != null) {
      totalSizeAcres.value = model.farmSize!.toString();
    }
  }

  void _initializeMappingData(TreeRegistrationModel model) {
    if (model.farmBoundaryPolygon != null && model.farmBoundaryPolygon!.isNotEmpty) {
      try {
        final boundaryJson = utf8.decode(model.farmBoundaryPolygon!);
        final boundaryData = jsonDecode(boundaryJson) as List;

        final points = boundaryData.map((point) {
          return LatLng(
            point['latitude'] ?? 0.0,
            point['longitude'] ?? 0.0,
          );
        }).toList();

        if (points.isNotEmpty) {
          polygon.value = Polygon(
            polygonId: const PolygonId('farm_boundary'),
            points: points,
            strokeWidth: 2,
            strokeColor: fPrimaryColour,
            fillColor: fPrimaryColour.withOpacity(0.15),
          );
        }
      } catch (e) {
        debugPrint('Error parsing boundary data: $e');
      }
    }
  }

  void _initializeTreeData(TreeRegistrationModel model) {
    if (model.trees.isNotEmpty) {
      treeData.assignAll(model.trees);
    }
  }

  // Method to add a tree to the list
  void addTree(Map<String, dynamic> tree) {
    treeData.add(tree);
  }

  // Method to remove a tree from the list
  void removeTree(String treeId) {
    treeData.removeWhere((tree) => tree['id'] == treeId);
  }

  // Method to clear all trees
  void clearAllTrees() {
    treeData.clear();
  }

  @override
  void onInit() {
    super.onInit();
    // Don't load data automatically - wait for initializeWithData call
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
    nextOfKinNameController.dispose();
    relationShipWithNextOfKinController.dispose();
    dobController.dispose();
    genderController.dispose();
    phoneNumberController.dispose();
    postalAddressController.dispose();
    witnessNameController.dispose();
    witnessPhoneController.dispose();
    treeNameController.dispose();
    treeSizeController.dispose();
    super.onClose();
  }

  /// Loads all initial data required for the form
  Future<void> _loadAllData() async {
    await Future.wait([
      loadEstablishmentTypesData(),
      loadFarmerData(),
      loadRegionsData(),
      loadMMDAsData(),
      loadCommunitiesData(),
    ]);

    // After loading data, set the selected values from the model
    _setSelectedValuesFromModel();
  }

  void _setSelectedValuesFromModel() {
    if (originalModel == null) return;

    // Set selected farmer
    if (originalModel!.farmerId != null) {
      final farmer = farmerData.firstWhereOrNull(
              (f) => f.id == originalModel!.farmerId
      );
      if (farmer != null) {
        selectedFarmer.value = farmer;
      }
    }

    // Set selected region
    if (originalModel!.regionId != null) {
      final region = regionsData.firstWhereOrNull(
              (r) => r.id == originalModel!.regionId
      );
      if (region != null) {
        selectedRegion.value = region;
        _updateFilteredDistricts().then((_) {
          selectedDistrict.value = filteredDistricts.firstWhereOrNull(
                  (d) => d.districtId == originalModel!.districtId
          );
          // After districts are loaded, set selected district
          _setDistrictAndMMDA();
        });
      }
    }
  }

  void _setDistrictAndMMDA() {
    if (originalModel == null) return;

    // Set selected district
    if (originalModel!.districtId != null) {
      final district = filteredDistricts.firstWhereOrNull(
              (d) => d.districtId == originalModel!.districtId
      );
      if (district != null) {
        selectedDistrict.value = district;
      }
    }

    // Set selected MMDA
    if (originalModel!.mmdaId != null) {
      final mmda = mmdasData.firstWhereOrNull(
              (m) => m.id == originalModel!.mmdaId
      );
      if (mmda != null) {
        selectedMMDA.value = mmda;
      }
    }

    // Set selected community
    if (originalModel!.communityId != null) {
      final community = communitiesData.firstWhereOrNull(
              (c) => c.id == originalModel!.communityId
      );
      if (community != null) {
        selectedCommunity.value = community;
      }
    }
  }

  /// Fetches farmer data from repository
  Future<void> loadFarmerData() async {
    isLoadingFarmers.value = true;
    try {
      final farmers = await FarmerFromServerRepository().getAllFarmers();
      farmerData.assignAll(farmers);
    } catch (e) {
      debugPrint('Error loading farmers: $e');
    } finally {
      isLoadingFarmers.value = false;
    }
  }

  /// Fetches unique regions data from repository
  Future<void> loadRegionsData() async {
    try {
      isLoadingRegions.value = true;
      final regions = await DistrictRepository().getAllDistricts();
      final regionModels = regions.map((obj) => DistrictModel(
        regionName: obj.regionName,
        districtName: obj.districtName,
        districtId: obj.districtId,
        regionId: obj.regionId,
        id: obj.id,
      )).toList();
      regionsData.assignAll(regionModels);
    } catch (e) {
      debugPrint('Error loading regions: $e');
      Get.snackbar('Error', 'Failed to load regions');
    } finally {
      isLoadingRegions.value = false;
    }
  }

  /// Fetches MMDAs data from repository
  Future<void> loadMMDAsData() async {
    isLoadingMMDAs.value = true;
    try {
      final mmdas = await MMDARepository().getAllMMDAs();
      mmdasData.assignAll(mmdas);
    } catch (e) {
      debugPrint('Error loading MMDAs: $e');
    } finally {
      isLoadingMMDAs.value = false;
    }
  }

  /// Fetches communities data from repository
  Future<void> loadCommunitiesData() async {
    isLoadingCommunities.value = true;
    try {
      final communities = await CommunityRepository().getAllCommunities();
      communitiesData.assignAll(communities);
    } catch (e) {
      debugPrint('Error loading communities: $e');
    } finally {
      isLoadingCommunities.value = false;
    }
  }

  /// Fetches establishment types data from repository
  Future<void> loadEstablishmentTypesData() async {
    isLoadingEstablishmentTypes.value = true;
    try {
      final establishmentTypes = await EstaTypeRepository().getAllEstaTypes();
      if (establishmentTypes.isNotEmpty) {
        establishmentTypesData.assignAll(establishmentTypes);
        establishmentTypesData.add(EstaTypeModel(id: establishmentTypes.length + 1, esta_type: 'Other'));
      } else {
        // Fallback data
        establishmentTypesData.assignAll([
          EstaTypeModel(id: 1, esta_type: 'Woodlot'),
          EstaTypeModel(id: 2, esta_type: 'Commercial Plantation'),
          EstaTypeModel(id: 3, esta_type: 'Home Garden'),
          EstaTypeModel(id: 4, esta_type: 'Other'),
        ]);
      }
    } catch (e) {
      debugPrint('Error loading establishment types: $e');
      establishmentTypesData.assignAll([
        EstaTypeModel(id: 1, esta_type: 'Woodlot'),
        EstaTypeModel(id: 2, esta_type: 'Commercial Plantation'),
        EstaTypeModel(id: 3, esta_type: 'Home Garden'),
        EstaTypeModel(id: 4, esta_type: 'Other'),
      ]);
    } finally {
      isLoadingEstablishmentTypes.value = false;
    }
  }

  // Establishment type selection methods
  void toggleEstablishmentType(String type) {
    final isSpecialType = type == 'Woodlot' || type == 'Commercial Plantation' || type == 'Other';
    final hasSpecialType = selectedEstablishmentTypes.any((selected) =>
    selected == 'Woodlot' || selected == 'Commercial Plantation' || selected == 'Other');
    final hasNonSpecialType = selectedEstablishmentTypes.any((selected) =>
    selected != 'Woodlot' && selected != 'Commercial Plantation' && selected != 'Other');

    if (selectedEstablishmentTypes.contains(type)) {
      // Deselecting
      selectedEstablishmentTypes.remove(type);
    } else {
      // Selecting new type
      if (isSpecialType && hasNonSpecialType) {
        Get.snackbar(
          'Selection Error',
          'Woodlot, Commercial Plantation, and Other cannot be combined with other establishment types.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      } else if (!isSpecialType && hasSpecialType) {
        Get.snackbar(
          'Selection Error',
          'Other establishment types cannot be combined with Woodlot, Commercial Plantation, or Other.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      } else {
        // Valid selection
        selectedEstablishmentTypes.add(type);
      }
    }
    update();
  }

  bool isEstablishmentTypeSelected(String type) {
    return selectedEstablishmentTypes.contains(type);
  }

  // Selection methods
  void selectFarmer(FarmerFromServerModel? farmer) {
    selectedFarmer.value = farmer;
  }

  Future<void> selectRegion(DistrictModel? region) async {
    selectedRegion.value = region;
    selectedDistrict.value = null;
    if (region != null) {
      await _updateFilteredDistricts();
    } else {
      filteredDistricts.clear();
    }
    update();
  }

  void selectDistrict(DistrictModel? district) {
    selectedDistrict.value = district;
    update();
  }

  void selectMMDA(MMDAModel? mmda) {
    selectedMMDA.value = mmda;
  }

  void selectCommunity(CommunityModel? community) {
    selectedCommunity.value = community;
  }

  // Tree details methods
  void onTreeSpeciesChanged(String value) {
    treeSpeciesValue.value = value;
    update();
  }

  void onPNChanged(String value) {
    pnValue.value = value;
    update();
  }

  void setYearOfEstablishment(String year) {
    yoEstablishment.value = year;
    update();
  }

  /// Filters districts based on the selected region
  Future<void> _updateFilteredDistricts() async {
    if (selectedRegion.value == null) {
      filteredDistricts.clear();
      return;
    }

    try {
      final regionName = selectedRegion.value!.regionName;
      final districts = await DistrictRepository().getDistrictsByRegionName(regionName);
      filteredDistricts.assignAll(districts);
    } catch (e) {
      debugPrint('Error loading districts: $e');
      Get.snackbar('Error', 'Failed to load districts');
      filteredDistricts.clear();
    }
    update();
  }

  // Validation methods
  bool validateForm() {
    return selectedFarmer.value != null &&
        selectedRegion.value != null &&
        selectedDistrict.value != null &&
        selectedMMDA.value != null &&
        selectedCommunity.value != null &&
        selectedEstablishmentTypes.isNotEmpty &&
        nextOfKinNameController.text.isNotEmpty &&
        relationShipWithNextOfKinController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        postalAddressController.text.isNotEmpty;
  }

  // Form reset
  void resetForm() {
    selectedFarmer.value = null;
    selectedRegion.value = null;
    selectedDistrict.value = null;
    selectedMMDA.value = null;
    selectedCommunity.value = null;
    selectedEstablishmentTypes.clear();

    nextOfKinNameController.clear();
    relationShipWithNextOfKinController.clear();
    dobController.clear();
    genderController.clear();
    phoneNumberController.clear();
    postalAddressController.clear();
    witnessNameController.clear();
    witnessPhoneController.clear();
    treeNameController.clear();
    treeSizeController.clear();

    pnValue.value = '';
    treeSpeciesValue.value = '';
    yoEstablishment.value = '';

    polygon.value = null;
    markers.value = null;
    totalSizeAcres.value = '';
  }

  // Mapping functionality
  void navigateToMap() {
    if (treeRegisterScreenContext == null) return;

    final mappedFarm = {"bounds": polygon.value?.points ?? []};

    Navigator.of(treeRegisterScreenContext!).push(
      CupertinoPageRoute(
        builder: (BuildContext context) => PickTreesMap(
          isTreeRegisterMode: true,
          survivedSeedlings: [],
          farm: mappedFarm,
        ),
      ),
    );
  }

  void usePolygonDrawingTool() {
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon.value != null) polys.add(polygon.value!);

    Get.to(
          () => PolygonDrawingTool(
        layers: polys,
        initialPolygon: polygon.value,
        viewInitialPolygon: polygon.value != null,
        useBackgroundLayers: false,
        allowTappingInputMethod: false,
        allowTracingInputMethod: false,
        maxAccuracy: MaxLocationAccuracy.max,
        persistMaxAccuracy: true,
        onSave: (poly, mkr, area) {
          if (mkr.isNotEmpty) {
            polygon.value = poly;
            markers.value = mkr;
            totalSizeAcres.value = area.truncateToDecimalPlaces(6).toString();
            update();
          }
        },
      ),
      transition: Transition.fadeIn,
    );
  }

  // Tree details validation
  bool validateTreeDetails() {
    return treeNameController.text.isNotEmpty &&
        pnValue.value.isNotEmpty &&
        treeSpeciesValue.value.isNotEmpty &&
        treeSizeController.text.isNotEmpty &&
        yoEstablishment.value.isNotEmpty;
  }

  void addTreeFromDetails() {
    if (!validateTreeDetails()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all tree details',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final tree = {
      'id': 'tree_${DateTime.now().millisecondsSinceEpoch}',
      'tree_name': treeNameController.text,
      'pn': pnValue.value,
      'species': treeSpeciesValue.value,
      'size': treeSizeController.text,
      'yo_establishment': yoEstablishment.value,
    };

    addTree(tree);

    // Clear tree details after adding
    treeNameController.clear();
    treeSizeController.clear();
    pnValue.value = '';
    treeSpeciesValue.value = '';
    yoEstablishment.value = '';

    Get.snackbar(
      'Success',
      'Tree added successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }


  submitTreeData() async {
    try {
      if (polygon.value == null || polygon.value!.points.isEmpty) {
        throw Exception('Farm boundary is required');
      }


      List<Map<String, double>> boundaryCoordinates;
      if(!showTreeDetailsSection) {
        // polygon.value!.points.add(polygon.value!.points.first);
        // Convert polygon to coordinate format
        boundaryCoordinates = polygon.value!.points
            .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
            .toList();
      } else {
        boundaryCoordinates = [];
      }

      TreeRegistrationModel treeRegistrationModel = TreeRegistrationModel(
        id: registrationId,
        farmerId: selectedFarmer.value!.id,
        regionId: selectedRegion.value!.id!,
        districtId: selectedDistrict.value!.id!,
        mmdaId: selectedMMDA.value!.id!,
        communityId: selectedCommunity.value!.id!,
        establishmentType: selectedEstablishmentTypes.join(', '),
        nextOfKinName: nextOfKinNameController.text,
        farmerRelationshipWithNextOfKin: relationShipWithNextOfKinController.text,
        nextOfKinDoB: DateTime.parse(dobController.text),
        nextOfKinGender: genderController.text,
        nextOfKinPhoneNumber: phoneNumberController.text,
        nextOfKinPostalAddress: postalAddressController.text,
        farmBoundaryPolygon: Uint8List.fromList(
          utf8.encode(jsonEncode(boundaryCoordinates)),
        ),
        farmSize: double.tryParse(totalSizeAcres.value),
        trees: treeData,
        groupName: groupPresidentController.text,
        groupPresident: groupPresidentController.text,
        groupSecretary: groupSecretaryController.text,
        companyDirectors: companyDirectorsController.text,
        groupPhoneNumber: groupPhoneController.text,
        groupEmail: groupEmailController.text,
        groupPostalAddress: groupAddressController.text,
        groupRegNumb: groupregNumbController.text,
        isSynced: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Globals().startWait(treeRegisterScreenContext!);
      final result = await APIMethods.submitTreeRegistration(treeRegistrationModel);
      Globals().endWait(treeRegisterScreenContext!);

      if (result['success']) {
        TreeRegistrationRepository().updateTreeRegistration(treeRegistrationModel);

        resetForm();
        clearAllTrees();
        Globals().showSnackBar(
          title: "Success",
          message: 'Tree registration submitted to server successfully!',
          backgroundColor: Colors.green,
        );

         } else {
        Globals().showSnackBar(
          title: "Submission Failed",
          message: 'Failed to submit: ${result['error']}',
          backgroundColor: Colors.orange,
        );

        await saveTreeDataOffline();
      }
    } catch (e) {
      Globals().endWait(treeRegisterScreenContext!);
      await saveTreeDataOffline();
      Globals().showSnackBar(
        title: "Network Error",
        message: 'Saved offline due to network issue',
        backgroundColor: Colors.orange,
      );
    }
  }

  saveTreeDataOffline() async {
    try {
      if (treeRegisterScreenContext == null) {
        throw Exception('Context is not initialized');
      }

      Globals().startWait(treeRegisterScreenContext!);

      if (selectedFarmer.value == null || selectedRegion.value == null) {
        throw Exception('Farmer and Region are required fields');
      }

      List<Map<String, double>> boundaryCoordinates;
      if(!showTreeDetailsSection) {
        // polygon.value!.points.add(polygon.value!.points.first);
        // Convert polygon to coordinate format
        boundaryCoordinates = polygon.value!.points
            .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
            .toList();
      } else {
        boundaryCoordinates = [];
      }

      final treeRegistrationModel = TreeRegistrationModel(
        id: registrationId,
        farmerId: selectedFarmer.value!.id,
        regionId: int.tryParse(selectedRegion.value!.regionId) ?? 0,
        districtId: selectedDistrict.value?.districtId ?? 0,
        mmdaId: selectedMMDA.value?.id ?? 0,
        communityId: selectedCommunity.value?.id ?? 0,
        establishmentType: selectedEstablishmentTypes.join(', '),
        nextOfKinName: nextOfKinNameController.text.trim(),
        farmerRelationshipWithNextOfKin: relationShipWithNextOfKinController.text.trim(),
        nextOfKinDoB: DateTime.tryParse(dobController.text) ?? DateTime.now(),
        nextOfKinGender: genderController.text.trim(),
        nextOfKinPhoneNumber: phoneNumberController.text.trim(),
        nextOfKinPostalAddress: postalAddressController.text.trim(),
        farmBoundaryPolygon: Uint8List.fromList(
          utf8.encode(jsonEncode(boundaryCoordinates)),
        ),
        farmSize: double.tryParse(totalSizeAcres.value),
        trees: treeData,
        groupName: groupPresidentController.text.trim(),
        groupPresident: groupPresidentController.text.trim(),
        groupSecretary: groupSecretaryController.text.trim(),
        companyDirectors: companyDirectorsController.text.trim(),
        groupPhoneNumber: groupPhoneController.text.trim(),
        groupEmail: groupEmailController.text.trim(),
        groupPostalAddress: groupAddressController.text.trim(),
        groupRegNumb: groupregNumbController.text.trim(),
        createdAt: DateTime.now(),
        isSynced: 0,
        updatedAt: DateTime.now(),
      );

      final Map<String, dynamic> data = treeRegistrationModel.toJson();
      debugPrint("THE TREE REG DATA ::::::::::::::: $data");

      int id = await TreeRegistrationRepository().updateTreeRegistration(
        treeRegistrationModel,
      );

      Globals().endWait(treeRegisterScreenContext!);

      if (id > 0) {
        Get.offAll(()=> IndexPage());
        resetForm();
        clearAllTrees();

        Globals().showSnackBar(
          title: "Success",
          message: 'Tree registration saved successfully!',
          backgroundColor: Colors.green,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("THE ERROR ::::: $e");
      debugPrint("THE ERROR ::::: $stackTrace");
      Globals().endWait(treeRegisterScreenContext!);
      Globals().showSnackBar(
        title: "Error",
        message: 'An unknown error occurred',
        backgroundColor: Colors.red,
      );
    }
  }


  // Check if form has changes
  bool get hasChanges {
    if (originalModel == null) return true;

    // Compare establishment types
    final currentEstablishmentTypes = selectedEstablishmentTypes.join(', ');
    if (currentEstablishmentTypes != (originalModel!.establishmentType ?? '')) {
      return true;
    }

    // Compare other fields
    if (nextOfKinNameController.text != (originalModel!.nextOfKinName ?? '')) return true;
    if (relationShipWithNextOfKinController.text != (originalModel!.farmerRelationshipWithNextOfKin ?? '')) return true;
    if (phoneNumberController.text != (originalModel!.nextOfKinPhoneNumber ?? '')) return true;
    if (postalAddressController.text != (originalModel!.nextOfKinPostalAddress ?? '')) return true;

    // Compare tree data
    if (treeData.length != (originalModel!.trees.length ?? 0)) return true;

    return false;
  }
}