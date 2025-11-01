import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/deforestation_repo.dart';

class DeforestationEditController extends GetxController {
  final DeforestationRepository _repository = DeforestationRepository();
  final CommunityRepository _communityRepo = CommunityRepository();

  final Rx<DeforestationReportModel> originalReport = DeforestationReportModel().obs;
  final Rx<DeforestationFormData> formData = DeforestationFormData().obs;
  final RxBool isLoading = false.obs;
  final RxBool hasChanges = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEditMode = false.obs;

  // Community related
  final RxList<CommunityModel> communities = <CommunityModel>[].obs;
  final Rx<CommunityModel?> selectedCommunity = Rx<CommunityModel?>(null);
  final RxBool isLoadingCommunities = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCommunities();
  }

  // Initialize with existing report for editing
  void initializeForEdit(DeforestationReportModel report) {
    isEditMode.value = true;
    originalReport.value = report;
    _initializeFormFromReport(report);
  }

  void _initializeFormFromReport(DeforestationReportModel report) {
    // Convert report to form data
    formData.value = DeforestationFormData()
      ..gfwDirection = report.directedByGfw
      ..seeDeforestation = report.seeDeforestation
      ..deforestationCauses = report.deforestationCauses ?? []
      ..actionRequired = report.furtherActionRequired
      ..whyAction = report.reasonForAction
      ..location = report.latitude != null && report.longitude != null
          ? PlaceLocation(
        latitude: report.latitude!,
        longitude: report.longitude!,
        accuracy: 0.0, // You might want to store accuracy separately
      )
          : null
      ..photoBase64 = report.photos
      ..communityId = report.community != null ? int.tryParse(report.community!) : null;

    // Set selected community if available
    if (report.community != null) {
      final communityId = int.tryParse(report.community!);
      if (communityId != null) {
        _setCommunityFromId(communityId);
      }
    }

    hasChanges.value = false;
    errorMessage.value = '';
  }

  // Load communities from repository
  Future<void> loadCommunities() async {
    try {
      isLoadingCommunities.value = true;
      final result = await _communityRepo.getAllCommunities();
      communities.assignAll(result);

      // If we're in edit mode and have a community ID, try to select it
      if (isEditMode.value && formData.value.communityId != null) {
        _setCommunityFromId(formData.value.communityId!);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load communities: $e';
    } finally {
      isLoadingCommunities.value = false;
    }
  }

  void _setCommunityFromId(int communityId) {
    final community = communities.firstWhereOrNull((c) => c.id == communityId);
    if (community != null) {
      selectedCommunity.value = community;
    }
  }

  // Set selected community
  void setSelectedCommunity(CommunityModel? community) {
    selectedCommunity.value = community;
    if (community != null) {
      formData.update((val) {
        val!.communityId = community.id;
        val.communityName = community.community;
      });
      _checkForChanges();
    }
  }

  // Search communities
  List<CommunityModel> searchCommunities(String query) {
    if (query.isEmpty) return communities;
    return communities.where((community) {
      return community.community!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Form field updates with change detection
  void updateGfwDirection(String? value) {
    formData.update((val) {
      val!.gfwDirection = value;
    });
    _checkForChanges();
  }

  void updateSeeDeforestation(String? value) {
    formData.update((val) {
      val!.seeDeforestation = value;
    });
    _checkForChanges();
  }

  void toggleDeforestationCause(String cause, bool isSelected) {
    formData.update((val) {
      if (isSelected) {
        if (!val!.deforestationCauses.contains(cause)) {
          val.deforestationCauses.add(cause);
        }
      } else {
        val!.deforestationCauses.remove(cause);
      }
    });
    _checkForChanges();
  }

  void updateOtherCause(String value) {
    formData.update((val) {
      val!.otherCause = value;
    });
    _checkForChanges();
  }

  void updateActionRequired(String? value) {
    formData.update((val) {
      val!.actionRequired = value;
    });
    _checkForChanges();
  }

  void updateWhyAction(String value) {
    formData.update((val) {
      val!.whyAction = value;
    });
    _checkForChanges();
  }

  void updateLocation(PlaceLocation location) {
    formData.update((val) {
      val!.location = location;
    });
    _checkForChanges();
  }

  void updatePhotoBase64(String base64Image) {
    formData.update((val) {
      val!.photoBase64 = base64Image;
    });
    _checkForChanges();
  }

  // Check if any changes were made
  void _checkForChanges() {
    if (!isEditMode.value) {
      hasChanges.value = true;
      return;
    }

    final current = formData.value;
    final original = originalReport.value;

    hasChanges.value =
        current.gfwDirection != original.directedByGfw ||
            current.seeDeforestation != original.seeDeforestation ||
            _listsDifferent(current.deforestationCauses, original.deforestationCauses) ||
            current.actionRequired != original.furtherActionRequired ||
            current.whyAction != original.reasonForAction ||
            current.location?.latitude != original.latitude ||
            current.location?.longitude != original.longitude ||
            current.photoBase64 != original.photos ||
            current.communityId?.toString() != original.community;
  }

  bool _listsDifferent(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return false;
    if (list1 == null || list2 == null) return true;
    if (list1.length != list2.length) return true;

    for (var i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return true;
    }
    return false;
  }

  // Validation
  String? validateForm() {
    if (formData.value.communityId == null) {
      return 'Please select a community';
    }
    if (formData.value.location == null) {
      return 'Please capture GPS location';
    }
    if (formData.value.gfwDirection == null) {
      return 'Please indicate if directed by GFW';
    }
    if (formData.value.seeDeforestation == null) {
      return 'Please indicate if you see deforestation';
    }
    if (formData.value.photoBase64 == null || formData.value.photoBase64!.isEmpty) {
      return 'Please take a photo of the area';
    }
    if (formData.value.deforestationCauses.contains('Other') &&
        (formData.value.otherCause == null || formData.value.otherCause!.isEmpty)) {
      return 'Please specify the other cause';
    }
    if (formData.value.actionRequired == 'yes' &&
        (formData.value.whyAction == null || formData.value.whyAction!.isEmpty)) {
      return 'Please explain why action should be taken';
    }
    return null;
  }

  // Save changes to local database
  Future<bool> saveChanges() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final validationError = validateForm();
      if (validationError != null) {
        errorMessage.value = validationError;
        return false;
      }

      final updatedReport = _createUpdatedReport();
      await _repository.updateLocalReport(updatedReport);

      // Update original report
      originalReport.value = updatedReport;
      hasChanges.value = false;
      Get.back();
      Get.back();

      Get.snackbar(
        'Success',
        'Report updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update report: $e';
      Get.snackbar(
        'Error',
        'Failed to update report: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Submit updated report to server
  Future<bool> submitUpdatedReport() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final validationError = validateForm();
      if (validationError != null) {
        errorMessage.value = validationError;
        return false;
      }

      final updatedReport = _createUpdatedReport();
      final result = await APIMethods().submitDeforestationReportToServer(updatedReport);

      if (result['success'] == true) {
        Get.back();
        Get.back();
        // Update local record as submitted
        final submittedReport = updatedReport.copyWith(
          submissionStatus: 'submitted',
          updatedAt: DateTime.now(),
        );
        await _repository.updateLocalReport(submittedReport);

        originalReport.value = submittedReport;
        hasChanges.value = false;

        Get.snackbar(
          'Success',
          'Report submitted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        errorMessage.value = result['error'] ?? 'Submission failed';
        Get.snackbar(
          'Error',
          result['error'] ?? 'Submission failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to submit report: $e';
      Get.snackbar(
        'Error',
        'Failed to submit report: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  DeforestationReportModel _createUpdatedReport() {
    final form = formData.value;

    return DeforestationReportModel(
      id: originalReport.value.id,
      community: form.communityId?.toString(),
      directedByGfw: form.gfwDirection,
      seeDeforestation: form.seeDeforestation,
      deforestationCauses: form.deforestationCauses,
      furtherActionRequired: form.actionRequired,
      reasonForAction: form.whyAction,
      latitude: form.location?.latitude,
      longitude: form.location?.longitude,
      photos: form.photoBase64,
      submissionStatus: originalReport.value.submissionStatus,
      createdAt: originalReport.value.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Reset form to original values
  void resetForm() {
    if (isEditMode.value) {
      _initializeFormFromReport(originalReport.value);
    } else {
      formData.value = DeforestationFormData();
      selectedCommunity.value = null;
    }
    errorMessage.value = '';
    hasChanges.value = false;
  }

  // Check if cause is selected
  bool isCauseSelected(String cause) {
    return formData.value.deforestationCauses.contains(cause);
  }

  // Handle back navigation with unsaved changes
  Future<bool> onWillPop() async {
    if (!hasChanges.value) {
      return true;
    }

    final result = await Get.dialog(
      AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to save them before leaving?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: 'discard'),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Get.back(result: 'cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: 'save'),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    switch (result) {
      case 'save':
        final saved = await saveChanges();
        return saved; // Only pop if saved successfully
      case 'discard':
        return true;
      case 'cancel':
      default:
        return false;
    }
  }

  // Get location status for UI
  String get locationStatus {
    final location = formData.value.location;
    if (location == null) {
      return 'Location not captured';
    }
    return 'Lat: ${location.latitude.toStringAsFixed(6)}, Lng: ${location.longitude.toStringAsFixed(6)}';
  }

  bool get isLocationAccurate {
    return formData.value.location != null;
  }
}