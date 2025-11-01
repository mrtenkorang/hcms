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
import '../../../../addedMaps/dependencies/style.dart';

class TreeRegistrationEditController extends GetxController {
  // Context for navigation and dialogs
  BuildContext? treeRegisterScreenContext;

  // Existing registration data
  TreeRegistrationModel? existingRegistration;

  // Selected values with reactive observables
  var selectedFarmer = Rxn<FarmerFromServerModel>();
  var selectedRegion = Rxn<DistrictModel>();
  var selectedDistrict = Rxn<DistrictModel>();
  var selectedMMDA = Rxn<MMDAModel>();
  var selectedCommunity = Rxn<CommunityModel>();
  var selectedEstablishmentType = Rxn<EstaTypeModel>();

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

  // Mapping related observables
  var markers = Rxn<Set<Marker>>();
  var polygon = Rxn<Polygon>();
  var totalSizeAcres = ''.obs;

  final List<Map<String, dynamic>> treeData = [];

  bool isTreeDataEmpty() {
    return treeData.isEmpty;
  }

  // Method to add a tree to the list
  void addTree(Map<String, dynamic> tree) {
    treeData.add(tree);
    update();
  }

  // Method to remove a tree from the list
  void removeTree(String treeId) {
    treeData.removeWhere((tree) => tree['id'] == treeId);
    update();
  }

  // Method to clear all trees
  void clearAllTrees() {
    treeData.clear();
    update();
  }

  // Signature states
  var farmerSignature = ''.obs;
  var witnessSignature = ''.obs;
  var farmerSig = Rxn<File>();
  var witnessSig = Rxn<File>();

  // Initialize with existing data
  void initializeWithData(TreeRegistrationModel registration) {
    existingRegistration = registration;
    _populateFormData(registration);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   _loadAllData();
  // }

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
    super.onClose();
  }

  /// Populates form with existing data
  void _populateFormData(TreeRegistrationModel registration) {

    final data = registration.toJson();
    debugPrint("THE REGISTRATION DATA ::::::::::: $data");
    // Populate farmer data if available
    if (registration.farmerId.toString().isNotEmpty) {
      // Find and set the farmer from farmerData
      final farmer = farmerData.firstWhereOrNull(
              (f) => f.id == registration.farmerId
      );
      if (farmer != null) {
        selectedFarmer.value = farmer;
      }
    }

    debugPrint("THE SELECTED FARMER ::::::::::: ${selectedFarmer.value}");

    // Populate text fields
    nextOfKinNameController.text = registration.nextOfKinName!;
    relationShipWithNextOfKinController.text = registration.farmerRelationshipWithNextOfKin!;
    dobController.text = registration.nextOfKinDoB!.toIso8601String().split('T')[0];
    genderController.text = registration.nextOfKinGender!;
    phoneNumberController.text = registration.nextOfKinPhoneNumber!;
    postalAddressController.text = registration.nextOfKinPostalAddress!;

    selectedRegion.value = regionsData.firstWhereOrNull((r) => r.districtId == registration.districtId);
    selectedDistrict.value = filteredDistricts.firstWhereOrNull((d) => d.districtId == registration.districtId);
    selectedMMDA.value = mmdasData.firstWhereOrNull((m) => m.id == registration.mmdaId);
    selectedCommunity.value = communitiesData.firstWhereOrNull((c) => c.id == registration.communityId);
    selectedEstablishmentType.value = establishmentTypesData.firstWhereOrNull((e) => e.id == registration.id);

    selectRegion(selectedRegion.value);
    selectDistrict(selectedRegion.value);
    selectMMDA(selectedMMDA.value);
    selectCommunity(selectedCommunity.value);
    selectEstablishmentType(selectedEstablishmentType.value);

    debugPrint("THE SELECTED REGION ::::::::::: ${selectedRegion.value}");
    debugPrint("THE SELECTED DISTRICT ::::::::::: ${selectedDistrict.value}");
    debugPrint("THE SELECTED MMDA ::::::::::: ${selectedMMDA.value}");
    debugPrint("THE SELECTED COMMUNITY ::::::::::: ${selectedCommunity.value}");
    debugPrint("THE SELECTED ESTABLISHMENT TYPE ::::::::::: ${selectedEstablishmentType.value}");

    // Populate group fields
    groupNameController.text = registration.groupName!;
    groupPresidentController.text = registration.groupPresident!;
    groupSecretaryController.text = registration.groupSecretary!;
    companyDirectorsController.text = registration.companyDirectors!;
    groupPhoneController.text = registration.groupPhoneNumber!;
    groupEmailController.text = registration.groupEmail!;
    groupAddressController.text = registration.groupPostalAddress!;
    groupregNumbController.text = registration.groupRegNumb!;

    totalSizeAcres.value = registration.farmSize.toString();

    // Populate tree data
    treeData.clear();
    treeData.addAll(registration.trees);

    // Populate polygon data if available
    if (registration.farmBoundaryPolygon!.isNotEmpty) {
      try {
        final boundaryJson = utf8.decode(registration.farmBoundaryPolygon!);
        final boundaryData = jsonDecode(boundaryJson) as List;
        final points = boundaryData.map((point) => LatLng(
          point['latitude'] as double,
          point['longitude'] as double,
        )).toList();

        if (points.isNotEmpty) {
          polygon.value = Polygon(
            polygonId: const PolygonId('existing_polygon'),
            points: points,
            strokeWidth: 2,
            strokeColor: fPrimaryColour,
            fillColor: fPrimaryColour.withOpacity(0.15),
          );
          // totalSizeAcres.value = '0.0';
        }
      } catch (e) {
        debugPrint('Error parsing boundary data: $e');
      }
    }
  }

  /// Loads all initial data required for the form
  Future<void> loadAllData() async {
    await Future.wait([
      loadEstablishmentTypesData(),
      loadFarmerData(),
      loadRegionsData(),
      loadMMDAsData(),
      loadCommunitiesData(),
    ]);

    debugPrint("THE FARMER FROM SERVER ::::::: ${farmerData.length}");
    debugPrint("THE REGIONS FROM SERVER ::::::: ${regionsData.length}");
    debugPrint("THE DISTRICTS FROM SERVER ::::::: ${filteredDistricts.length}");
    debugPrint("THE MMDAS FROM SERVER ::::::: ${mmdasData.length}");
    debugPrint("THE COMMUNITIES FROM SERVER ::::::: ${communitiesData.length}");
    debugPrint("THE ESTABLISHMENT TYPES FROM SERVER ::::::: ${establishmentTypesData.length}");
  }

  /// Fetches farmer data from repository
  Future<void> loadFarmerData() async {
    isLoadingFarmers.value = true;
    try {
      final farmers = await FarmerFromServerRepository().getAllFarmers();
      debugPrint("THE FARMER FROM SERVER ::::::: ${farmers.length}");
      farmerData.assignAll(farmers);

      // If we have existing registration, set the farmer after data is loaded
      if (existingRegistration != null) {
        final farmer = farmers.firstWhereOrNull(
                (f) => f.id == existingRegistration!.farmerId
        );
        if (farmer != null) {
          selectedFarmer.value = farmer;
        }
      }
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
    debugPrint("Loading establishments");
    isLoadingEstablishmentTypes.value = true;
    try {
      final establishmentTypes = await EstaTypeRepository().getAllEstaTypes();
      if (establishmentTypes.isNotEmpty) {
        establishmentTypesData.assignAll(establishmentTypes);
      } else {
        establishmentTypesData.assignAll([
          EstaTypeModel(id: 1, esta_type: 'Farmer'),
          EstaTypeModel(id: 2, esta_type: 'Group'),
        ]);
      }
    } catch (e) {
      debugPrint('Error loading establishment types: $e');
      establishmentTypesData.assignAll([
        EstaTypeModel(id: 1, esta_type: 'Farmer'),
        EstaTypeModel(id: 2, esta_type: 'Group'),
      ]);
    } finally {
      isLoadingEstablishmentTypes.value = false;
    }
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

  void selectEstablishmentType(EstaTypeModel? establishmentType) {
    selectedEstablishmentType.value = establishmentType;
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
        selectedEstablishmentType.value != null &&
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
    selectedEstablishmentType.value = null;

    nextOfKinNameController.clear();
    relationShipWithNextOfKinController.clear();
    dobController.clear();
    genderController.clear();
    phoneNumberController.clear();
    postalAddressController.clear();
    witnessNameController.clear();
    witnessPhoneController.clear();

    groupNameController.clear();
    groupPresidentController.clear();
    groupSecretaryController.clear();
    groupDirectorsController.clear();
    companyDirectorsController.clear();
    groupPhoneController.clear();
    groupregNumbController.clear();
    groupEmailController.clear();
    groupAddressController.clear();

    farmerSignature.value = '';
    witnessSignature.value = '';
    farmerSig.value = null;
    witnessSig.value = null;

    polygon.value = null;
    markers.value = null;
    totalSizeAcres.value = '';
    treeData.clear();
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

            debugPrint("THE SIZE OF THE FARM :::::::::::: ${totalSizeAcres.value}");

            if (treeRegisterScreenContext != null) {
              Globals().showOkayDialog(
                context: treeRegisterScreenContext!,
                title: 'Measurement Result',
                image: 'lib/libassets/logos/hcmslogo.jpeg',
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'measured area estimates in hectares',
                        style: TextStyle(color: AppColor.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${area.truncateToDecimalPlaces(6).toString()} ha',
                        style: TextStyle(
                          color: AppColor.black,
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
          }
        },
      ),
      transition: Transition.fadeIn,
    );
  }

  // Update existing registration
  Future<void> updateTreeData() async {
    try {
      if (polygon.value != null && polygon.value!.points.isNotEmpty) {
        polygon.value!.points.add(polygon.value!.points.first);
      }

      // Convert polygon to coordinate format
      var boundaryCoordinates = polygon.value?.points
          .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
          .toList() ?? [];

      TreeRegistrationModel updatedRegistration = TreeRegistrationModel(
        id: existingRegistration?.id,
        farmerId: selectedFarmer.value?.id ?? existingRegistration?.farmerId,
        regionId: selectedRegion.value?.id ?? existingRegistration?.regionId ?? 0,
        districtId: selectedDistrict.value?.districtId ?? existingRegistration?.districtId ?? 0,
        mmdaId: selectedMMDA.value?.id ?? existingRegistration?.mmdaId ?? 0,
        communityId: selectedCommunity.value?.id ?? existingRegistration?.communityId ?? 0,
        establishmentType: selectedEstablishmentType.value?.esta_type ?? existingRegistration?.establishmentType ?? '',
        nextOfKinName: nextOfKinNameController.text,
        farmerRelationshipWithNextOfKin: relationShipWithNextOfKinController.text,
        nextOfKinDoB: DateTime.tryParse(dobController.text) ?? existingRegistration?.nextOfKinDoB ?? DateTime.now(),
        nextOfKinGender: genderController.text,
        nextOfKinPhoneNumber: phoneNumberController.text,
        nextOfKinPostalAddress: postalAddressController.text,
        farmBoundaryPolygon: Uint8List.fromList(
          utf8.encode(jsonEncode(boundaryCoordinates)),
        ),
        farmSize: double.tryParse(totalSizeAcres.value),
        trees: treeData,
        groupName: groupNameController.text,
        groupPresident: groupPresidentController.text,
        groupSecretary: groupSecretaryController.text,
        companyDirectors: companyDirectorsController.text,
        groupPhoneNumber: groupPhoneController.text,
        groupEmail: groupEmailController.text,
        groupPostalAddress: groupAddressController.text,
        groupRegNumb: groupregNumbController.text,
        isSynced: 0,
        createdAt: existingRegistration?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final data  = updatedRegistration.toJson();
      debugPrint("THE DATA FOR TREE UPDATE ::::::::::: $data");

      Globals().startWait(treeRegisterScreenContext!);

      // Update in local database
      int rowsAffected = await TreeRegistrationRepository().updateTreeRegistration(updatedRegistration);

      Globals().endWait(treeRegisterScreenContext!);

      if (rowsAffected > 0) {
        Get.offAll(() => IndexPage());
        Globals().showSnackBar(
          title: "Success",
          message: 'Tree registration updated successfully!',
          backgroundColor: Colors.green,
        );
      } else {
        Globals().showSnackBar(
          title: "Update Failed",
          message: 'Failed to update tree registration',
          backgroundColor: Colors.orange,
        );
      }
    } catch (e) {
      Globals().endWait(treeRegisterScreenContext!);
      debugPrint("Error updating tree data: $e");
      Globals().showSnackBar(
        title: "Error",
        message: 'An error occurred while updating',
        backgroundColor: Colors.red,
      );
    }
  }

  // Submit updated data to server
  Future<void> submitUpdatedTreeData() async {
    try {
      if (polygon.value != null && polygon.value!.points.isNotEmpty) {
        polygon.value!.points.add(polygon.value!.points.first);
      }

      var boundaryCoordinates = polygon.value?.points
          .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
          .toList() ?? [];

      TreeRegistrationModel updatedRegistration = TreeRegistrationModel(
        id: existingRegistration?.id,
        farmerId: selectedFarmer.value?.id ?? existingRegistration?.farmerId,
        regionId: selectedRegion.value?.id ?? existingRegistration?.regionId ?? 0,
        districtId: selectedDistrict.value?.districtId ?? existingRegistration?.districtId ?? 0,
        mmdaId: selectedMMDA.value?.id ?? existingRegistration?.mmdaId ?? 0,
        communityId: selectedCommunity.value?.id ?? existingRegistration?.communityId ?? 0,
        establishmentType: selectedEstablishmentType.value?.esta_type ?? existingRegistration?.establishmentType ?? '',
        nextOfKinName: nextOfKinNameController.text,
        farmerRelationshipWithNextOfKin: relationShipWithNextOfKinController.text,
        nextOfKinDoB: DateTime.tryParse(dobController.text) ?? existingRegistration?.nextOfKinDoB ?? DateTime.now(),
        nextOfKinGender: genderController.text,
        nextOfKinPhoneNumber: phoneNumberController.text,
        nextOfKinPostalAddress: postalAddressController.text,
        farmBoundaryPolygon: Uint8List.fromList(
          utf8.encode(jsonEncode(boundaryCoordinates)),
        ),
        farmSize: double.tryParse(totalSizeAcres.value),
        trees: treeData,
        groupName: groupNameController.text,
        groupPresident: groupPresidentController.text,
        groupSecretary: groupSecretaryController.text,
        companyDirectors: companyDirectorsController.text,
        groupPhoneNumber: groupPhoneController.text,
        groupEmail: groupEmailController.text,
        groupPostalAddress: groupAddressController.text,
        groupRegNumb: groupregNumbController.text,
        isSynced: 1, // Mark as synced
        createdAt: existingRegistration?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Globals().startWait(treeRegisterScreenContext!);

      // Submit to server
      final result = await APIMethods.submitTreeRegistration(updatedRegistration);

      Globals().endWait(treeRegisterScreenContext!);

      if (result['success']) {
        // Update local record with synced status using copyWith
        updatedRegistration = updatedRegistration.copyWith(isSynced: 1);
        await TreeRegistrationRepository().updateTreeRegistration(updatedRegistration);

        Get.back(result: true);
        // Get.offAll(() => IndexPage());
        Globals().showSnackBar(
          title: "Success",
          message: 'Tree registration updated and synced successfully!',
          backgroundColor: Colors.green,
        );
      } else {
        // Save locally if server submission fails
        await updateTreeData();
        Globals().showSnackBar(
          title: "Update Saved Offline",
          message: 'Updated saved locally due to network issue',
          backgroundColor: Colors.orange,
        );
      }
    } catch (e) {
      Globals().endWait(treeRegisterScreenContext!);
      // Fallback to local update
      await updateTreeData();
      Globals().showSnackBar(
        title: "Network Error",
        message: 'Updated saved offline due to network issue',
        backgroundColor: Colors.orange,
      );
    }
  }
}