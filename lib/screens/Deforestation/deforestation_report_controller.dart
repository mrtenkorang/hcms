import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/deforestation_repo.dart';

class DeforestationController extends GetxController {
  final DeforestationRepository _repository = DeforestationRepository();
  final LocationService locationService = Get.put(LocationService());
  final CommunityRepository _communityRepo = CommunityRepository();

  final Rx<DeforestationFormData> formData = DeforestationFormData().obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool autoLocationStarted = false.obs;

  // Community related
  final RxList<CommunityModel> communities = <CommunityModel>[].obs;
  final Rx<CommunityModel?> selectedCommunity = Rx<CommunityModel?>(null);
  final RxBool isLoadingCommunities = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startAutomaticLocationCapture();
    loadCommunities();
  }

  // Load communities from repository
  Future<void> loadCommunities() async {
    isLoadingCommunities.value = true;
    final result = await _communityRepo.getAllCommunities();
    isLoadingCommunities.value = false;
    communities.assignAll(result);
  }

  // Set selected community
  void setSelectedCommunity(CommunityModel? community) {
    selectedCommunity.value = community;
    if (community != null) {
      formData.update((val) {
        val!.communityId = community.id;
      });
    }
  }

  // Search communities
  List<CommunityModel> searchCommunities(String query) {
    if (query.isEmpty) return [];
    return communities.where((community) {
      return community.community!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void onClose() {
    locationService.stopLocationListening();
    super.onClose();
  }

  // Automatic location capture on screen load
  void _startAutomaticLocationCapture() {
    autoLocationStarted.value = true;
    locationService.startLocationListening();

    // Listen to location updates
    ever(locationService.currentLocation, (PlaceLocation? location) {
      if (location != null) {
        updateLocation(location);

        // Show success message when good accuracy is achieved
        if (location.accuracy! <= 5.0) {
          Get.snackbar(
            'Location Captured',
            'GPS accuracy: ${location.accuracy!.toStringAsFixed(2)}m',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    });

    // Listen to location errors
    ever(locationService.errorMessage, (String error) {
      if (error.isNotEmpty) {
        errorMessage.value = error;
      }
    });
  }

  // Manual location recapture
  Future<void> recaptureLocation() async {
    autoLocationStarted.value = true;
    locationService.stopLocationListening();
    await locationService.startLocationListening();
  }

  // Form field updates
  void updateGfwDirection(String? value) {
    formData.update((val) {
      val!.gfwDirection = value;
    });
  }

  void updateSeeDeforestation(String? value) {
    formData.update((val) {
      val!.seeDeforestation = value;
    });
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
  }

  void updateOtherCause(String value) {
    formData.update((val) {
      val!.otherCause = value;
    });
  }

  void updateActionRequired(String? value) {
    formData.update((val) {
      val!.actionRequired = value;
    });
  }

  void updateWhyAction(String value) {
    formData.update((val) {
      val!.whyAction = value;
    });
  }

  void updateLocation(PlaceLocation location) {
    formData.update((val) {
      val!.location = location;
    });
  }

  void updatePhotoBase64(String base64Image) {
    formData.update((val) {
      val!.photoBase64 = base64Image;
    });
  }

  void updateCommunity(int? communityId, String? communityName) {
    formData.update((val) {
      val!.communityId = communityId;
      val.communityName = communityName;
    });
  }

  // Validation
  String? validateForm() {
    if (formData.value.communityId == null) {
      return 'Please select a community';
    }
    if (formData.value.location == null) {
      return 'Please wait for GPS location to be captured';
    }
    // if (!locationService.isLocationAccurate(formData.value.location)) {
    //   return 'GPS accuracy must be 5 meters or better. Current: ${formData.value.location!.accuracy!.toStringAsFixed(2)}m';
    // }
    if (formData.value.gfwDirection == null) {
      return 'Please indicate if directed by GFW';
    }
    if (formData.value.seeDeforestation == null) {
      return 'Please indicate if you see deforestation';
    }
    if (formData.value.photoBase64 == null ||
        formData.value.photoBase64!.isEmpty) {
      return 'Please take a photo of the area';
    }
    if (formData.value.deforestationCauses.contains('Other') &&
        (formData.value.otherCause == null ||
            formData.value.otherCause!.isEmpty)) {
      return 'Please specify the other cause';
    }
    if (formData.value.actionRequired == 'yes' &&
        (formData.value.whyAction == null ||
            formData.value.whyAction!.isEmpty)) {
      return 'Please explain why action should be taken';
    }
    return null;
  }

  // Save to local database
  Future<bool> saveReportLocally() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final validationError = validateForm();
      if (validationError != null) {
        errorMessage.value = validationError;
        return false;
      }

      final report = formData.value.toReport();
      await _repository.saveReportLocally(report);

      Get.back();
      clearForm();

      Get.snackbar(
        'Success',
        'Report saved locally',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save report: $e';
      Get.snackbar(
        'Error',
        'Failed to save report: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Submit to server
  Future<bool> submitReportToServer() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final validationError = validateForm();
      if (validationError != null) {
        errorMessage.value = validationError;
        return false;
      }

      final report = formData.value.toReport();
      final result = await APIMethods().submitDeforestationReportToServer(report);

      if (result['success'] == true) {
        // Also save locally as submitted
        await _repository.saveReportLocally(
          report.copyWith(submissionStatus: 'submitted'),
        );
        clearForm();
        Get.back();


        Get.snackbar(
          'Success',
          'Report submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        errorMessage.value = result['error'] ?? 'Submission failed';

        // Save locally as pending if server submission fails
        await _repository.saveReportLocally(report);

        Get.snackbar(
          'Submitted Locally',
          'Report saved locally. Will sync when online.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        return true;
      }
    } catch (e) {
      errorMessage.value = 'Failed to submit report: $e';

      // Save locally as pending
      final report = formData.value.toReport();
      await _repository.saveReportLocally(report);

      Get.snackbar(
        'Saved Locally',
        'Report saved locally due to connection issues.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      return true;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    formData.value.clearFields();
    errorMessage.value = '';
  }

  clearFields(){
    selectedCommunity.value = null;

  }

  // Check if cause is selected
  bool isCauseSelected(String cause) {
    return formData.value.deforestationCauses.contains(cause);
  }

  // Get location status
  String get locationStatus {
    final location = formData.value.location;
    if (location == null) {
      return 'Searching for GPS signal...';
    }

    if (location.accuracy! <= 5.0) {
      return 'High Accuracy (${location.accuracy!.toStringAsFixed(2)}m)';
    } else if (location.accuracy! <= 15.0) {
      return 'Medium Accuracy (${location.accuracy!.toStringAsFixed(2)}m)';
    } else {
      return 'Low Accuracy (${location.accuracy!.toStringAsFixed(2)}m)';
    }
  }

  bool get isLocationAccurate {
    return formData.value.location != null &&
        formData.value.location!.accuracy! <= 5.0;
  }
}

class LocationService extends GetxController {
  final Rx<PlaceLocation?> currentLocation = Rx<PlaceLocation?>(null);
  final RxBool isListening = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble bestAccuracy = 100.0.obs; // Start with poor accuracy

  StreamSubscription<Position>? _positionStream;

  @override
  void onClose() {
    stopLocationListening();
    super.onClose();
  }

  // Check and request location permissions
  Future<bool> _checkPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value =
            'Location services are disabled. Please enable them.';
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        errorMessage.value =
            'Location permissions are permanently denied. Please enable them in app settings.';
        return false;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          errorMessage.value = 'Location permissions are denied.';
          return false;
        }
      }

      return true;
    } catch (e) {
      errorMessage.value = 'Error checking location permissions: $e';
      return false;
    }
  }

  // Start automatic location listening with best accuracy
  Future<void> startLocationListening() async {
    try {
      errorMessage.value = '';

      if (!await _checkPermissions()) {
        return;
      }

      isListening.value = true;
      bestAccuracy.value = 1000.0; // Reset best accuracy

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1, // 1 meter
        timeLimit: Duration(
          seconds: 30,
        ), // Stop after 30 seconds if no good accuracy
      );

      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) {
              _handleNewPosition(position);
            },
            onError: (error) {
              errorMessage.value = 'Location error: $error';
              stopLocationListening();
            },
          );

      // Also get initial position quickly
      try {
        Position initialPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        _handleNewPosition(initialPosition);
      } catch (e) {
        // Ignore initial position errors, stream will handle it
      }
    } catch (e) {
      errorMessage.value = 'Failed to start location service: $e';
      isListening.value = false;
    }
  }

  void _handleNewPosition(Position position) {
    final newLocation = PlaceLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
    );

    // Update best accuracy
    if (position.accuracy < bestAccuracy.value) {
      bestAccuracy.value = position.accuracy;
    }

    // Always update current location
    currentLocation.value = newLocation;

    // Stop if we have good enough accuracy
    if (position.accuracy <= 5.0) {
      Future.delayed(const Duration(seconds: 2), () {
        stopLocationListening();
      });
    }
  }

  // Stop location listening
  void stopLocationListening() {
    _positionStream?.cancel();
    _positionStream = null;
    isListening.value = false;
  }

  // Get single location with best accuracy
  Future<PlaceLocation?> getCurrentLocation() async {
    try {
      if (!await _checkPermissions()) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      return PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      errorMessage.value = 'Failed to get current location: $e';
      return null;
    }
  }

  // Check if location meets accuracy requirements
  bool isLocationAccurate(PlaceLocation? location) {
    return location != null && location.accuracy! <= 5.0;
  }

  // Calculate distance between two locations in meters
  double calculateDistance(PlaceLocation loc1, PlaceLocation loc2) {
    return Geolocator.distanceBetween(
      loc1.latitude,
      loc1.longitude,
      loc2.latitude,
      loc2.longitude,
    );
  }
}
