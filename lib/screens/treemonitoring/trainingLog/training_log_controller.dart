import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
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

class TrainingLogController extends GetxController {
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

  loadUserInfo() async {
    final cache = await CacheService.getInstance();
    user = await cache.getUserInfo();
    enumeratorValue.value = user?.id;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadCommunities();
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
  Future<void> loadFarmersByCommunity(String communityId) async {
    try {
      isLoadingFarmers.value = true;
      final result = await FarmerFromServerRepository().getFarmersByCommunity(
        communityId,
      );

      farmers.assignAll(result);
      debugPrint("THE FARMER ::::::::::: ${farmers.first.toMap()}");
      debugPrint("THE FARMERS ::::::::::: ${farmers.length}");
    } catch (e) {
      debugPrint("FAILED TO LOAD FARMER: $e");
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
      loadFarmersByCommunity(community.community!);
    }
  }

  // Select farmer
  void selectFarmer(FarmerFromServerModel farmer) {
    selectedFarmer.value = farmer;
    for (var e in selectedParticipant) {
      if (e.id == farmer.id) {
        Globals().showSnackBar(
          title: "Farmer selected",
          message: "You cannot select the same farmer twice",
          backgroundColor: Colors.red,
        );
        return;
      }
    }
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

  // Save training log offline using repository
  saveTrainingLogOffline() async {
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

      // Save to local database using repository
      final trainingLog = await _trainingLogRepository
          .createTrainingLogFromFormData(
            communityId: selectedCommunity.value!.id!,
            communityName: selectedCommunity.value!.community ?? '',
            trainingTopic: topic.text,
            eventDate: visitDate.value,
            eventDuration: "${durHours.text} hours : ${durMins.text} minutes",
            trainerName: trainerName.text,
            trainerOrganisation: trainerOrg.text,
            enumeratorId: enumeratorValue.value ?? 0,
            isSynced: false,
            participants: participantDetails,
          );

      if (trainingLog.id.toString().isNotEmpty) {
        Get.back();
        clearForm();
        Get.snackbar(
          'Success',
          'Training log saved offline successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save training log offline',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save training log offline: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Submit training log to server
  submitTrainingLog() async {
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

      debugPrint("THE TRAINING DATA ::::::::::::: $trainingLog");

      Globals().startWait(trainingLogScreenContext!);
      final res = await APIMethods().submitTrainingLogToServer(trainingLog);
      Globals().endWait(trainingLogScreenContext!);

      if (res['success'] == true) {
        // save to local database
        // await _trainingLogRepository.markAsSynced(res['data']['id']);
        await _trainingLogRepository.createTrainingLogFromFormData(
          communityId: selectedCommunity.value!.id!,
          communityName: selectedCommunity.value!.community ?? '',
          trainingTopic: topic.text,
          eventDate: visitDate.value,
          eventDuration: "${durHours.text} hours : ${durMins.text} minutes",
          trainerName: trainerName.text,
          trainerOrganisation: trainerOrg.text,
          enumeratorId: enumeratorValue.value ?? 0,
          isSynced: true,
          participants: participantDetails,
        );

        Get.back();
        clearForm();
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
    }
  }

  // Method to sync all offline training logs
  // Future<void> syncOfflineTrainingLogs() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final unsyncedLogs = await _trainingLogRepository
  //         .getUnsyncedTrainingLogs();
  //
  //     if (unsyncedLogs.isEmpty) {
  //       Get.snackbar('Info', 'No offline training logs to sync');
  //       return;
  //     }
  //
  //     int successCount = 0;
  //     int failCount = 0;
  //
  //     for (final log in unsyncedLogs) {
  //       try {
  //         // Decode participants from stored JSON
  //         final participantsList =
  //             json.decode(log.participants) as List<dynamic>;
  //
  //         // Prepare data in the required format
  //         final trainingLogData = {
  //           "trainingDetails": {
  //             "communityName": log.communityId,
  //             "trainingTopic": log.trainingTopic,
  //             "dateEventBegan": log.eventDate,
  //             "eventDuration": log.eventDuration,
  //             "trainerName": log.trainerName,
  //             "trainerOrganisation": log.trainerOrganisation,
  //             "enumerator": log.enumeratorId,
  //           },
  //           "participantDetails": participantsList,
  //         };
  //
  //         var response = await http.post(
  //           Uri.parse('$stageBaseUrl/trainingapi/'),
  //           headers: {'Content-Type': 'application/json'},
  //           body: json.encode(trainingLogData),
  //         );
  //
  //         if (response.statusCode == 200 || response.statusCode == 201) {
  //           final result = json.decode(response.body);
  //           if (result["status"] == "done") {
  //             await _trainingLogRepository.markAsSynced(log.id!);
  //             successCount++;
  //           } else {
  //             failCount++;
  //           }
  //         } else {
  //           failCount++;
  //         }
  //       } catch (e) {
  //         failCount++;
  //         debugPrint("Failed to sync log ${log.id}: $e");
  //       }
  //     }
  //
  //     Get.snackbar(
  //       'Sync Complete',
  //       'Success: $successCount, Failed: $failCount',
  //       backgroundColor: successCount > 0 ? Colors.green : Colors.orange,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       'Sync Error',
  //       'Failed to sync offline logs: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // // Method to get training log statistics
  // Future<Map<String, dynamic>> getTrainingLogStats() async {
  //   try {
  //     final allLogs = await _trainingLogRepository.getAllTrainingLogs();
  //     final unsyncedLogs = await _trainingLogRepository
  //         .getUnsyncedTrainingLogs();
  //     final myLogs = await _trainingLogRepository.getTrainingLogsByEnumerator(
  //       enumeratorValue.value ?? 0,
  //     );
  //
  //     return {
  //       'total': allLogs.length,
  //       'unsynced': unsyncedLogs.length,
  //       'myLogs': myLogs.length,
  //       'synced': allLogs.length - unsyncedLogs.length,
  //     };
  //   } catch (e) {
  //     debugPrint("Error getting stats: $e");
  //     return {'total': 0, 'unsynced': 0, 'myLogs': 0, 'synced': 0};
  //   }
  // }
}
