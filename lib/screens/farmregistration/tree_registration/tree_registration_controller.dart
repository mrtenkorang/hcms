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
import '../../addedMaps/dependencies/style.dart';

class TreeRegistrationController extends GetxController {
  // Context for navigation and dialogs
  BuildContext? treeRegisterScreenContext;

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

  @override
  void onInit() {
    super.onInit();
    _loadAllData();
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
  }

  /// Fetches farmer data from repository
  Future<void> loadFarmerData() async {
    isLoadingFarmers.value = true;
    try {
      final farmers = await FarmerFromServerRepository().getAllFarmers();
      debugPrint("THE FARMER FROM SERVER ::::::: ${farmers.length}");
      farmerData.assignAll(farmers);
    } catch (e) {
      debugPrint('Error loading farmers: $e');
      // Show error to user if needed
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

      //for test
      mmdasData.assignAll([
        MMDAModel(id: 1, mmda: 'MMDA 1'),
        MMDAModel(id: 2, mmda: 'MMDA 2'),
      ]);
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
      // First try to load from API
      final establishmentTypes = await EstaTypeRepository().getAllEstaTypes();

      debugPrint("THE ESTABLISHMENT TYPES ::::::::::: ${establishmentTypes.length}");

      // If API call is successful and returns data, use it
      if (establishmentTypes.isNotEmpty) {
        establishmentTypesData.assignAll(establishmentTypes);
      } else {
        // Fallback to test data if API returns empty
        establishmentTypesData.assignAll([
          EstaTypeModel(id: 1, esta_type: 'test'),
          EstaTypeModel(id: 2, esta_type: 'test'),
        ]);
      }
    } catch (e) {
      debugPrint('Error loading establishment types: $e');
      // On error, use test data as fallback
      establishmentTypesData.assignAll([
        EstaTypeModel(id: 1, esta_type: 'Farmer'),
        EstaTypeModel(id: 2, esta_type: 'Group'),
      ]);
    } finally {
      isLoadingEstablishmentTypes.value = false;
    }
  }

  // Selection methods

  /// Sets the selected farmer and triggers UI update
  void selectFarmer(FarmerFromServerModel? farmer) {
    selectedFarmer.value = farmer;
  }

  /// Sets the selected region and filters districts accordingly
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

  /// Sets the selected district
  void selectDistrict(DistrictModel? district) {
    selectedDistrict.value = district;
    update();
  }

  /// Sets the selected MMDA
  void selectMMDA(MMDAModel? mmda) {
    selectedMMDA.value = mmda;
  }

  /// Sets the selected community
  void selectCommunity(CommunityModel? community) {
    selectedCommunity.value = community;
  }

  /// Sets the selected establishment type
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

  /// Validates the main form fields
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

  /// Validates the declaration section (signatures and witness info)
  // bool validateDeclarationForm() {
  //   return farmerSignature.value.isNotEmpty &&
  //       witnessSignature.value.isNotEmpty &&
  //       witnessNameController.text.isNotEmpty &&
  //       witnessPhoneController.text.isNotEmpty;
  // }

  // Form reset

  /// Resets all form fields and selections
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

    farmerSignature.value = '';
    witnessSignature.value = '';
    farmerSig.value = null;
    witnessSig.value = null;

    polygon.value = null;
    markers.value = null;
    totalSizeAcres.value = '';
  }

  // Mapping functionality

  /// Navigates to the tree mapping screen
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

  /// Opens the polygon drawing tool for boundary mapping
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

            // Show measurement result dialog
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

  // Signature handling

  /// Handles farmer signature capture and conversion to base64
  // Future<void> onFarmerSign(File pickedImage) async {
  //   farmerSig.value = pickedImage;
  //   final base64String = await _convertImageToBase64(pickedImage);
  //   farmerSignature.value = base64String;
  //   await _saveFormDataToSP(); // Auto-save when signature is added
  // }
  //
  // /// Handles witness signature capture and conversion to base64
  // Future<void> onWitnessSign(File pickedImage) async {
  //   witnessSig.value = pickedImage;
  //   final base64String = await _convertImageToBase64(pickedImage);
  //   witnessSignature.value = base64String;
  //   await _saveFormDataToSP(); // Auto-save when signature is added
  // }

  // Data persistence

  /// Saves all form data to SharedPreferences for persistence
  // Future<void> _saveFormDataToSP() async {
  //   // Save farmer data
  //   await regSP?.setString('_beneficiaryType', 'Individual');
  //   await regSP?.setString('farmerId', selectedFarmer.value?.id ?? '');
  //   await regSP?.setString(
  //     'farmerfirstName',
  //     selectedFarmer.value?.farmerName ?? '',
  //   );
  //   await regSP?.setString(
  //     'farmerPhoneNum',
  //     selectedFarmer.value?.contact ?? '',
  //   );
  //
  //   // Save location data
  //   await regSP?.setString('region', selectedRegion.value?.region ?? '');
  //   await regSP?.setString(
  //     'forestDistrict',
  //     selectedDistrict.value?.name ?? '',
  //   );
  //   await regSP?.setString('mddasName', selectedMMDA.value?.mmda ?? '');
  //   await regSP?.setInt('mddas', selectedMMDA.value?.id ?? 0);
  //   await regSP?.setString(
  //     'community',
  //     selectedCommunity.value?.community ?? '',
  //   );
  //   await regSP?.setString('family', selectedDistrict.value?.name ?? '');
  //   await regSP?.setStringList('est', [
  //     selectedEstablishmentType.value?.esta_type ?? '',
  //   ]);
  //
  //   // Save farm coordinates
  //   await regSP?.setString(
  //     'farmID',
  //     'farm_${DateTime.now().millisecondsSinceEpoch}',
  //   );
  //   await regSP?.setString('farmArea', totalSizeAcres.value);
  //   await regSP?.setString('pointsString', _encodePolygonPoints());
  //
  //   // Save next of kin data
  //   await regSP?.setString('kinName', nextOfKinNameController.text);
  //   await regSP?.setString(
  //     'kinRelationship',
  //     relationShipWithNextOfKinController.text,
  //   );
  //   await regSP?.setString('kinDoB', dobController.text);
  //   await regSP?.setString('kinGender', genderController.text);
  //   await regSP?.setString('kinPhoneNum', phoneNumberController.text);
  //   await regSP?.setString('kinPostal', postalAddressController.text);
  //
  //   // Save witness data
  //   await regSP?.setString('witnessName', witnessNameController.text);
  //   await regSP?.setString('witnessPhone', witnessPhoneController.text);
  //
  //   // Save signatures
  //   await regSP?.setString('base64signature', farmerSignature.value);
  //   await regSP?.setString('witnessbase64signature', witnessSignature.value);
  // }

  /// Encodes polygon points for storage
  String _encodePolygonPoints() {
    if (polygon.value == null || polygon.value!.points.isEmpty) {
      return '';
    }

    final points = polygon.value!.points.map((point) {
      return FarmInformationArray(
        date: DateTime.now().toString(),
        latitude: point.latitude,
        longitude: point.longitude,
        accuracy: 0.0,
        pointID: 'point_${point.latitude}_${point.longitude}',
        wayPointNumber: 'way_${point.latitude}_${point.longitude}',
      );
    }).toList();

    return FarmInformationArray.encode(points);
  }

  // Utility methods

  /// Converts image file to base64 string with compression
  Future<String> _convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      // Resize and compress image to reduce storage size
      final originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        // Resize to max 800px width while maintaining aspect ratio
        final resizedImage = img.copyResize(originalImage, width: 800);
        final resizedBytes = img.encodeJpg(resizedImage, quality: 80);
        return base64Encode(resizedBytes);
      }

      return base64Encode(bytes);
    } catch (e) {
      debugPrint("Error converting image to base64: $e");
      return "";
    }
  }

  submitTreeData() async {
    try {
      polygon.value!.points.add(polygon.value!.points.first);

      // Convert polygon to coordinate format
      var boundaryCoordinates = polygon.value!.points
          .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
          .toList();

      TreeRegistrationModel treeRegistrationModel = TreeRegistrationModel(
        farmerId: selectedFarmer.value!.id,
        regionId: selectedRegion.value!.id!,
        districtId: selectedDistrict.value!.id!,
        mmdaId: selectedMMDA.value!.id!,
        communityId: selectedCommunity.value!.id!,
        establishmentType: selectedEstablishmentType.value!.esta_type,
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
      // Submit to server
      final result = await APIMethods.submitTreeRegistration(treeRegistrationModel);

      Globals().endWait(treeRegisterScreenContext!);

      if (result['success']) {
        resetForm();
        clearAllTrees();
        // Navigator.of(treeRegisterScreenContext!).pop();
        Globals().showSnackBar(
          title: "Success",
          message: 'Tree registration submitted to server successfully!',
          backgroundColor: Colors.green,
        );

        // save the synced data locally
        TreeRegistrationRepository().insertTreeRegistration(treeRegistrationModel);
      } else {
        Globals().showSnackBar(
          title: "Submission Failed",
          message: 'Failed to submit: ${result['error']}',
          backgroundColor: Colors.orange,
        );

        // Fallback to offline save
        await saveTreeDataOffline();
      }
    } catch (e) {
      Globals().endWait(treeRegisterScreenContext!);

      // Fallback to offline save on any error
      await saveTreeDataOffline();

      Globals().showSnackBar(
        title: "Network Error",
        message: 'Saved offline due to network issue',
        backgroundColor: Colors.orange,
      );
    }
  }


  /// Saves tree registration data to local database
   saveTreeDataOffline() async {
    try {
      if (treeRegisterScreenContext == null) {
        throw Exception('Context is not initialized');
      }

      Globals().startWait(treeRegisterScreenContext!);

      // Validate required fields
      if (selectedFarmer.value == null || selectedRegion.value == null) {
        throw Exception('Farmer and Region are required fields');
      }

      // Convert boundary coordinates to JSON-serializable format
      final boundaryCoordinates = polygon.value!.points
          .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
          .toList();

      // Helper function to safely get value from Rx types
      dynamic getValue(dynamic value) {
        if (value == null) return null;
        if (value is RxString) return value.value;
        if (value is RxInt) return value.value;
        if (value is RxDouble) return value.value;
        if (value is RxBool) return value.value;
        if (value is Rx) return value.value;
        return value;
      }

      // Process tree data to handle any reactive values
      final processedTreeData = treeData.map((tree) {
        return Map<String, dynamic>.fromEntries(
          tree.entries.map((e) => MapEntry(e.key, getValue(e.value)))
        );
      }).toList();

      // Create the model with all required fields
      final treeRegistrationModel = TreeRegistrationModel(
        farmerId: selectedFarmer.value!.id,
        regionId: int.tryParse(selectedRegion.value!.regionId) ?? 0,
        districtId: selectedDistrict.value?.districtId ?? 0,
        mmdaId: selectedMMDA.value?.id ?? 0,
        communityId: selectedCommunity.value?.id ?? 0,
        establishmentType: selectedEstablishmentType.value?.esta_type ?? '',
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
        trees: processedTreeData,
        groupName: groupPresidentController.text.trim(),
        groupPresident: groupPresidentController.text.trim(),
        groupSecretary: groupSecretaryController.text.trim(),
        companyDirectors: companyDirectorsController.text.trim(),
        groupPhoneNumber: groupPhoneController.text.trim(),
        groupEmail: groupEmailController.text.trim(),
        groupPostalAddress: groupAddressController.text.trim(),
        groupRegNumb: groupregNumbController.text.trim(),

        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final Map<String, dynamic> data = treeRegistrationModel.toJson();

      debugPrint("THE TREE REG DATA ::::::::::::::: $data");

      int id = await TreeRegistrationRepository().insertTreeRegistration(
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
}
