import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_local_repo.dart';

class FarmerBiodataController extends GetxController {
  final FarmerBiodataRepository _repository = FarmerBiodataRepository();

  final Rx<FarmerBiodataModel> farmer = FarmerBiodataModel().obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  var communitiesData = <CommunityModel>[].obs;
  var selectedCommunity = Rxn<CommunityModel>();

  // TextEditingControllers
  late TextEditingController landscapeController;
  late TextEditingController communityController;
  late TextEditingController farmerNameController;
  late TextEditingController contactController;
  late TextEditingController nationalIdController;
  late TextEditingController cocoaCardController;
  late TextEditingController ageController;
  late TextEditingController dobController;

  // Dropdown options
  final List<String> nationalIdTypes = [
    'Passport',
    'National ID',
    'Voters Card',
    'Driver License'
  ];

  final List<String> genders = ['Male', 'Female'];

  final List<String> smallHolderCategories = [
    'Owner_Cocoaf',
  ];

  // List to store all farmers
  final RxList<FarmerBiodataModel> allFarmers = <FarmerBiodataModel>[].obs;

  var isLoadingCommunities = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadCommunitiesData();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    landscapeController = TextEditingController();
    communityController = TextEditingController();
    farmerNameController = TextEditingController();
    contactController = TextEditingController();
    nationalIdController = TextEditingController();
    cocoaCardController = TextEditingController();
    ageController = TextEditingController();
    dobController = TextEditingController();
  }

  void _disposeControllers() {
    landscapeController.dispose();
    communityController.dispose();
    farmerNameController.dispose();
    contactController.dispose();
    nationalIdController.dispose();
    cocoaCardController.dispose();
    ageController.dispose();
    dobController.dispose();
  }

  /// Initialize form for edit mode
  void initializeFormForEdit(FarmerBiodataModel farmerData) {
    farmer.value = farmerData;
    _updateControllersFromModel();

    // Set selected community if community ID exists
    if (farmerData.community != null) {
      final communityId = farmerData.community is String
          ? int.tryParse(farmerData.community as String)
          : farmerData.community as int?;

      if (communityId != null) {
        final existingCommunity = communitiesData.firstWhereOrNull(
                (c) => c.id == communityId
        );
        if (existingCommunity != null) {
          selectedCommunity.value = existingCommunity;
          communityController.text = existingCommunity.community ?? '';
        }
      }
    }
  }

  void _updateControllersFromModel() {
    final currentFarmer = farmer.value;
    landscapeController.text = currentFarmer.landscape ?? '';
    farmerNameController.text = currentFarmer.farmerName ?? '';
    contactController.text = currentFarmer.contact ?? '';
    nationalIdController.text = currentFarmer.nationalid ?? '';
    cocoaCardController.text = currentFarmer.cocoaCard ?? '';
    ageController.text = currentFarmer.age?.toString() ?? '';

    // Format date for display
    if (currentFarmer.dob != null) {
      final date = _parseDateFromApi(currentFarmer.dob!);
      if (date != null) {
        dobController.text = _formatDateForDisplay(date);
      } else {
        dobController.text = currentFarmer.dob ?? '';
      }
    } else {
      dobController.text = '';
    }
  }

  void _updateModelFromControllers() {
    farmer.update((val) {
      val!.landscape = landscapeController.text.trim();
      val.farmerName = farmerNameController.text.trim();
      val.contact = contactController.text.trim();
      val.nationalid = nationalIdController.text.trim();
      val.cocoaCard = cocoaCardController.text.trim();
      val.age = int.tryParse(ageController.text.trim());

      // Convert display date to ISO format for API
      if (dobController.text.trim().isNotEmpty) {
        final date = _parseDateFromDisplay(dobController.text.trim());
        if (date != null) {
          val.dob = _formatDateForApi(date);
        } else {
          val.dob = dobController.text.trim();
        }
      } else {
        val.dob = null;
      }

      // Set community from selected community
      if (selectedCommunity.value != null) {
        val.community = selectedCommunity.value!.id;
      }
    });
  }

  // Date parsing and formatting methods
  DateTime? _parseDateFromApi(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date from API: $e');
      return null;
    }
  }

  DateTime? _parseDateFromDisplay(String displayDate) {
    try {
      final parts = displayDate.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing display date: $e');
      return null;
    }
  }

  String _formatDateForDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateForApi(DateTime date) {
    return date.toIso8601String();
  }

  void selectCommunity(CommunityModel? community) {
    selectedCommunity.value = community;
    communityController.text = community?.community ?? '';
    update();
  }

  /// Fetches communities data from repository
  Future<void> loadCommunitiesData() async {
    try {
      isLoadingCommunities.value = true;

      final communities = await CommunityRepository().getAllCommunities();
      communitiesData.assignAll(communities);

      // If we're in edit mode and have a community ID, try to select it
      if (farmer.value.community != null && farmer.value.id != null) {
        final communityId = farmer.value.community is String
            ? int.tryParse(farmer.value.community as String)
            : farmer.value.community as int?;

        if (communityId != null) {
          final existingCommunity = communitiesData.firstWhereOrNull(
                  (c) => c.id == communityId
          );
          if (existingCommunity != null) {
            selectedCommunity.value = existingCommunity;
            communityController.text = existingCommunity.community ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading communities: $e');
      Get.snackbar('Error', 'Failed to load communities');
    } finally {
      isLoadingCommunities.value = false;
    }
  }

  // Method to get all farmer biodata
  Future<void> getAllFarmerBiodata() async {
    try {
      isLoading.value = true;
      final farmers = await _repository.getAllFarmerBiodata();
      allFarmers.assignAll(farmers);
    } catch (e) {
      errorMessage.value = 'Failed to load farmers: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Update methods for form fields
  void updateLandscape(String value) {
    farmer.update((val) {
      val!.landscape = value;
    });
  }

  void updateFarmerName(String value) {
    farmer.update((val) {
      val!.farmerName = value;
    });
  }

  void updateContact(String value) {
    farmer.update((val) {
      val!.contact = value;
    });
  }

  void updateNationalIdType(String? value) {
    farmer.update((val) {
      val!.nationalidType = value;
    });
  }

  void updateNationalId(String value) {
    farmer.update((val) {
      val!.nationalid = value;
    });
  }

  void updateMembershipRa(bool value) {
    farmer.update((val) {
      val!.membershipRa = value;
    });
  }

  void updateCocoaCard(String value) {
    farmer.update((val) {
      val!.cocoaCard = value;
    });
  }

  void updateGender(String? value) {
    farmer.update((val) {
      val!.gender = value;
    });
  }

  void updateDob(String value) {
    // Parse the display date and convert to ISO format for the model
    final date = _parseDateFromDisplay(value);
    if (date != null) {
      farmer.update((val) {
        val!.dob = _formatDateForApi(date);
      });
    } else {
      farmer.update((val) {
        val!.dob = value;
      });
    }
  }

  void updateAge(String value) {
    farmer.update((val) {
      val!.age = int.tryParse(value);
    });
  }

  void updateSmallHolderCategory(String? value) {
    farmer.update((val) {
      val!.smallHolderCategory = value;
    });
  }

  void clearAllFields() {
    farmer.value = FarmerBiodataModel(
      status: 'pending',
      createdAt: DateTime.now().toIso8601String(),
    );
    selectedCommunity.value = null;
    errorMessage.value = '';
    clearControllers();
  }

  void clearFormFields() {
    farmer.update((val) {
      val!.landscape = null;
      val.community = null;
      val.farmercode = null;
      val.farmerName = null;
      val.contact = null;
      val.nationalidType = null;
      val.nationalid = null;
      val.membershipRa = false;
      val.cocoaCard = null;
      val.gender = null;
      val.dob = null;
      val.age = null;
      val.smallHolderCategory = null;
      val.farmSize = null;

      if (val.id == null) {
        val.status = 'pending';
      }
    });
    selectedCommunity.value = null;
    errorMessage.value = '';
    clearControllers();
  }

  void clearControllers() {
    landscapeController.clear();
    communityController.clear();
    farmerNameController.clear();
    contactController.clear();
    nationalIdController.clear();
    cocoaCardController.clear();
    ageController.clear();
    dobController.clear();
  }

  void resetForm() {
    farmer.value = FarmerBiodataModel();
    selectedCommunity.value = null;
    errorMessage.value = '';
    clearControllers();
  }

  /// Comprehensive form validation
  bool validateForm() {
    errorMessage.value = '';

    // Required fields validation
    if (farmerNameController.text.trim().isEmpty) {
      errorMessage.value = 'Farmer Name is required';
      return false;
    }

    if (contactController.text.trim().isEmpty) {
      errorMessage.value = 'Contact is required';
      return false;
    }

    if (selectedCommunity.value == null) {
      errorMessage.value = 'Community selection is required';
      return false;
    }

    if (farmer.value.gender == null) {
      errorMessage.value = 'Gender selection is required';
      return false;
    }

    if (dobController.text.trim().isEmpty) {
      errorMessage.value = 'Date of Birth is required';
      return false;
    }

    if (ageController.text.trim().isEmpty) {
      errorMessage.value = 'Age is required';
      return false;
    }

    // Date validation
    if (dobController.text.trim().isNotEmpty) {
      final date = _parseDateFromDisplay(dobController.text.trim());
      if (date == null) {
        errorMessage.value = 'Please enter a valid date (DD/MM/YYYY)';
        return false;
      }
    }

    // Format validation
    if (contactController.text.trim().isNotEmpty) {
      final contactRegex = RegExp(r'^[0-9+]{10,15}$');
      if (!contactRegex.hasMatch(contactController.text.trim())) {
        errorMessage.value = 'Please enter a valid contact number';
        return false;
      }
    }

    if (ageController.text.trim().isNotEmpty) {
      final age = int.tryParse(ageController.text.trim());
      if (age == null || age < 18 || age > 100) {
        errorMessage.value = 'Please enter a valid age (18-100)';
        return false;
      }
    }

    return true;
  }

  Future<bool> submitForm() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Update model from controllers before submission
      _updateModelFromControllers();

      // Validate all fields
      if (!validateForm()) {
        return false;
      }

      // Set status to submitted
      farmer.update((val) {
        val!.status = 'submitted';
      });

      debugPrint("FARMER SUBMIT :::::::::::: ${farmer.value.toMap()}");
      debugPrint("FARMER DOB :::::::::::: ${farmer.value.dob}");

      final Map<String, dynamic> res = await APIMethods.submitFarmer(
        farmer.value,
      );

      if (res["success"]) {
        await _repository.insertFarmerBiodata(farmer.value);
        Get.back();
        clearFormFields();
        return true;
      } else {
        errorMessage.value = res["error"] ?? 'Submission failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to submit form: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveAsDraft() async {
    try {
      isLoading.value = true;

      // Update model from controllers before saving
      _updateModelFromControllers();

      // For draft, only validate required fields
      if (farmerNameController.text.trim().isEmpty) {
        errorMessage.value = 'Farmer Name is required even for draft';
        return false;
      }

      farmer.update((val) {
        val!.status = 'pending';
      });

      await _repository.insertFarmerBiodata(farmer.value);
      Get.back();
      clearFormFields();
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save draft: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFarmerForEdit(int id) async {
    try {
      isLoading.value = true;
      final loadedFarmer = await _repository.getFarmerBiodataById(id);
      if (loadedFarmer != null) {
        initializeFormForEdit(loadedFarmer);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load farmer data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}