import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/training_log_model.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/controller/repos/training_log_repo.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

class EditTrainingLogController extends GetxController {
  // Context for navigation and dialogs
  BuildContext? trainingLogScreenContext;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Repository
  final TrainingLogRepository _trainingLogRepository = TrainingLogRepository();

  // Text editing controllers
  final TextEditingController topic = TextEditingController();
  final TextEditingController durHours = TextEditingController();
  final TextEditingController durMins = TextEditingController();
  final TextEditingController trainerName = TextEditingController();
  final TextEditingController trainerOrg = TextEditingController();
  final TextEditingController communityName = TextEditingController();
  final TextEditingController community = TextEditingController();

  // Reactive variables
  var visitDate = ''.obs;
  var isVisitDate = false.obs;
  var visitDateYearInString = ''.obs;
  var currentStep = 0.obs;
  var isLoading = false.obs;
  var boxChecked = false.obs;
  var enumeratorValue = RxnInt();

  // Dropdown selections
  var selectedCommunity = Rxn<CommunityModel>();
  var selectedFarmer = Rxn<FarmerFromServerModel>();

  // Data lists
  final communities = <CommunityModel>[].obs;
  final farmers = <FarmerFromServerModel>[].obs;

  // Loading states
  var isLoadingCommunities = false.obs;
  var isLoadingFarmers = false.obs;

  // Participants
  final RxList<FarmerFromServerModel> selectedParticipant =
      <FarmerFromServerModel>[].obs;

  FarmerFromServerModel? participant;

  List<FarmerFromServerModel> participants = [];

  UserModel? user;

  // Store the original training log for editing
  TrainingLogModel? originalTrainingLog;

  loadUserInfo() async {
    final cache = await CacheService.getInstance();
    user = await cache.getUserInfo();
    enumeratorValue.value = user?.id;
    update();
  }

  initializeData(TrainingLogModel trainingLog) async {
    originalTrainingLog = trainingLog;

    // Set basic form data
    topic.text = trainingLog.trainingTopic ?? '';
    trainerName.text = trainingLog.trainerName ?? '';
    trainerOrg.text = trainingLog.trainerOrganisation ?? '';

    // Parse and set event duration
    _parseAndSetDuration(trainingLog.eventDuration ?? '');

    // Set date
    if (trainingLog.eventDate != null && trainingLog.eventDate!.isNotEmpty) {
      visitDate.value = trainingLog.eventDate!;
      visitDateYearInString.value = trainingLog.eventDate!;
      isVisitDate.value = true;
    }

    // Set enumerator
    enumeratorValue.value = trainingLog.enumeratorId;

    // Load communities first, then set the selected community
    await loadCommunities();

    // Find and set the selected community
    if (trainingLog.communityId != null) {
      final community = communities.firstWhereOrNull(
              (c) => c.id == trainingLog.communityId
      );
      if (community != null) {
        selectCommunity(community);
        communityName.text = community.community ?? '';

        // Load farmers for this community
        await loadFarmersByCommunity(community.id!);

        // Parse and set participants
        await _parseAndSetParticipants(trainingLog.participants);
      }
    }

    update();
  }

  void _parseAndSetDuration(String duration) {
    try {
      if (duration.contains('hours') && duration.contains('minutes')) {
        final hoursMatch = RegExp(r'(\d+)\s*hours').firstMatch(duration);
        final minutesMatch = RegExp(r'(\d+)\s*minutes').firstMatch(duration);

        if (hoursMatch != null) {
          durHours.text = hoursMatch.group(1)!;
        }
        if (minutesMatch != null) {
          durMins.text = minutesMatch.group(1)!;
        }
      } else {
        // Fallback: try to split by common separators
        final parts = duration.split(RegExp(r'[:]'));
        if (parts.length >= 2) {
          durHours.text = parts[0].trim();
          durMins.text = parts[1].trim();
        }
      }
    } catch (e) {
      debugPrint("Error parsing duration: $e");
      // Set default values if parsing fails
      durHours.text = '0';
      durMins.text = '0';
    }
  }

  Future<void> _parseAndSetParticipants(String? participantsJson) async {
    if (participantsJson == null || participantsJson.isEmpty) return;

    try {
      final participantsList = json.decode(participantsJson) as List<dynamic>;
      selectedParticipant.clear();

      for (final participantData in participantsList) {
        final farmerId = participantData['farmerid'];
        if (farmerId != null) {
          // Find the farmer in the loaded farmers list
          final farmer = farmers.firstWhereOrNull((f) => f.id == farmerId);
          if (farmer != null) {
            selectedParticipant.add(farmer);
          }
        }
      }
    } catch (e) {
      debugPrint("Error parsing participants: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  // Populate participants
  void populateParticipants() {
    participants.add(participant!);
    selectedParticipant.add(participant!);
  }

  // Load communities from API
  Future<void> loadCommunities() async {
    try {
      isLoadingCommunities.value = true;
      final result = await CommunityRepository().getAllCommunities();
      communities.assignAll(result);

      debugPrint("THE COMMUNITIES ::::::::::: ${communities.length}");
    } catch (e) {
      debugPrint("FAILED TO LOAD COMMUNITIES: $e");
    } finally {
      isLoadingCommunities.value = false;
    }
  }

  // Load farmers by community ID
  Future<void> loadFarmersByCommunity(int communityId) async {
    try {
      isLoadingFarmers.value = true;
      final result = await FarmerFromServerRepository().getFarmersByCommunity(
        communityId,
      );
      farmers.assignAll(result);
      debugPrint("THE FARMERS ::::::::::: ${farmers.length}");
    } catch (e) {
      Get.snackbar('Error', 'Failed to load farmers: $e');
    } finally {
      isLoadingFarmers.value = false;
    }
  }

  // Select community
  void selectCommunity(CommunityModel community) {
    selectedCommunity.value = community;
    selectedFarmer.value = null;
    farmers.clear();
    if (community.id != null) {
      communityName.text = community.community ?? '';
      loadFarmersByCommunity(community.id!);
    }
  }

  // Select farmer
  void selectFarmer(FarmerFromServerModel farmer) {
    selectedFarmer.value = farmer;
    selectedParticipant.add(farmer);
    update();
  }

  @override
  void onClose() {
    topic.dispose();
    durHours.dispose();
    durMins.dispose();
    trainerName.dispose();
    trainerOrg.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void setVisitDate(DateTime date) {
    isVisitDate.value = true;
    visitDateYearInString.value = '${date.year}-${date.month}-${date.day}';
    visitDate.value = '${date.year}-${date.month}-${date.day}';
    update();
  }

  void onSelectedRow(bool selected, FarmerFromServerModel user) {
    if (selected) {
      selectedParticipant.add(user);
    } else {
      selectedParticipant.remove(user);
    }
    update();
  }

  void deleteSelected() {
    if (selectedParticipant.isNotEmpty) {
      final temp = List<FarmerFromServerModel>.from(selectedParticipant);
      for (final t in temp) {
        selectedParticipant.remove(t);
      }
    }
    update();
  }

  void clearAndNavigate() {
    clearForm();
  }

  void clearForm() {
    communityName.clear();
    selectedCommunity.value = null;
    selectedFarmer.value = null;
    topic.clear();
    durHours.clear();
    durMins.clear();
    trainerName.clear();
    trainerOrg.clear();

    visitDate.value = "";
    isVisitDate.value = false;
    visitDateYearInString.value = '';
    currentStep.value = 0;
    selectedParticipant.clear();

    update();
  }

  // Validation methods
  bool validateStep1() {
    return topic.text.isNotEmpty &&
        durHours.text.isNotEmpty &&
        durMins.text.isNotEmpty &&
        trainerName.text.isNotEmpty &&
        trainerOrg.text.isNotEmpty &&
        visitDate.value.isNotEmpty &&
        selectedCommunity.value != null;
  }

  bool validateStep2() {
    return selectedParticipant.isNotEmpty;
  }

  bool validateForm() {
    return validateStep1() && validateStep2();
  }

  // Update training log offline using repository
  updateTrainingLogOffline() async {
    try {
      if (!validateForm()) {
        Get.snackbar(
          'Error',
          'Please fill all required fields and add participants',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (originalTrainingLog == null) {
        Get.snackbar(
          'Error',
          'No training log data found to update',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      // Prepare participants data in the required format
      final List<Map<String, dynamic>> participantDetails = selectedParticipant
          .map((farmer) => {'farmerid': farmer.id})
          .toList();

      // Update in local database using repository
      final updatedTrainingLog = TrainingLogModel(
        id: originalTrainingLog!.id,
        communityId: selectedCommunity.value!.id!,
        communityName: selectedCommunity.value!.community ?? '',
        trainingTopic: topic.text,
        eventDate: visitDate.value,
        eventDuration: "${durHours.text} hours : ${durMins.text} minutes",
        trainerName: trainerName.text,
        trainerOrganisation: trainerOrg.text,
        enumeratorId: enumeratorValue.value ?? 0,
        isSynced: originalTrainingLog!.isSynced,
        participants: json.encode(participantDetails),
        createdAt: originalTrainingLog!.createdAt,
        updatedAt: DateTime.now(),
      );

      final data = updatedTrainingLog.toMap();

      debugPrint('THEHHHHHHHHHHHHHHHHH :::::: ${data}');

      final success = await _trainingLogRepository.updateTrainingLog(updatedTrainingLog);

      if (success >=0) {
        Get.back();
        Get.snackbar(
          'Success',
          'Training log updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update training log',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update training log: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Submit updated training log to server
  submitUpdatedTrainingLog() async {
    try {
      if (!validateForm()) {
        Get.snackbar(
          'Error',
          'Please fill all required fields and add participants',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      // Prepare participants data in the required format
      final List<Map<String, dynamic>> participantDetails = selectedParticipant
          .map((farmer) => {'farmerid': farmer.id})
          .toList();

      // Prepare training details following the specified flow
      final trainingDetails = {
        "communityName": selectedCommunity.value!.id,
        "trainingTopic": topic.text,
        "dateEventBegan": visitDate.value,
        "eventDuration": "${durHours.text} hours : ${durMins.text} minutes",
        "trainerName": trainerName.text,
        "trainerOrganisation": trainerOrg.text,
        "enumerator": enumeratorValue.value,
      };

      // Create complete training log following the specified API flow
      final trainingLog = {
        "trainingDetails": trainingDetails,
        "participantDetails": participantDetails,
      };

      debugPrint("THE UPDATED TRAINING DATA ::::::::::::: $trainingLog");

      Globals().startWait(trainingLogScreenContext!);
      final res = await APIMethods().submitTrainingLogToServer(trainingLog);
      Globals().endWait(trainingLogScreenContext!);

      debugPrint("THE SUBMISSION RES :::::::::::::::: $res");

      if (res['success'] == true) {
        // Update local database record
        final updatedTrainingLog = TrainingLogModel(
          id: originalTrainingLog!.id,
          communityId: selectedCommunity.value!.id!,
          communityName: selectedCommunity.value!.community ?? '',
          trainingTopic: topic.text,
          eventDate: visitDate.value,
          eventDuration: "${durHours.text} hours : ${durMins.text} minutes",
          trainerName: trainerName.text,
          trainerOrganisation: trainerOrg.text,
          enumeratorId: enumeratorValue.value ?? 0,
          isSynced: true,
          participants: json.encode(participantDetails),
          createdAt: originalTrainingLog!.createdAt,
          updatedAt: DateTime.now(),
        );

        await _trainingLogRepository.markAsSynced(updatedTrainingLog.id!);

        Get.back();
        Get.back();

        Get.snackbar(
          'Success',
          res['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          res['error'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('THE ERRROOOOOOORRRRR ::::::::: $e');
      debugPrint('THE ERRROOOOOOORRRRR ::::::::: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to submit training log: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}