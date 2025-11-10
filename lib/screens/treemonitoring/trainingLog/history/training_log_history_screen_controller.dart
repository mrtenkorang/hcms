import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/training_log_model.dart';
import 'package:hcms_revived2/controller/repos/training_log_repo.dart';

class TrainingLogHistoryScreenController extends GetxController {
  final TrainingLogRepository _repository = TrainingLogRepository();

  // Reactive lists for synced and pending logs
  final RxList<TrainingLogModel> syncedLogs = <TrainingLogModel>[].obs;
  final RxList<TrainingLogModel> pendingLogs = <TrainingLogModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrainingLogs();
  }

  Future<void> loadTrainingLogs() async {
    try {
      isLoading.value = true;

      // Load all logs
      final allLogs = await _repository.getAllTrainingLogs();

      // Separate into synced and pending
      syncedLogs.value = allLogs.where((log) => log.isSynced).toList();
      pendingLogs.value = allLogs.where((log) => !log.isSynced).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load training logs: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  deleteLog(TrainingLogModel log) async {
    try {
      isLoading.value = true;
      await _repository.deleteTrainingLog(log.id!);
      await loadTrainingLogs();
      Get.snackbar(
        'Success',
        'Training log deleted successfully',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete training log: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  /// Syncs all pending training logs with the server
  Future<void> syncAllPendingData() async {
    try {
      isLoading.value = true;

      // Get all pending logs
      final pending = await _repository.getUnsyncedTrainingLogs();

      if (pending.isEmpty) {
        Get.snackbar(
          'Info',
          'No pending logs to sync',
          backgroundColor: Colors.red,
        );
        return;
      }

      int successCount = 0;
      int failCount = 0;

      // Sync each pending log
      for (final log in pending) {
        debugPrint("THE LOG IS ${log.participants}");

        final hoursMatch = RegExp(
          r'(\d+)\s*hours',
        ).firstMatch(log.eventDuration);
        final minutesMatch = RegExp(
          r'(\d+)\s*minutes',
        ).firstMatch(log.eventDuration);

        // Prepare training details following the specified flow
        final trainingDetails = {
          "communityName": log.communityId,
          "trainingTopic": log.trainingTopic,
          "dateEventBegan": log.eventDate,
          "eventDuration": "$hoursMatch hours : $minutesMatch minutes",
          "trainerName": log.trainerName,
          "trainerOrganisation": log.trainerOrganisation,
          "enumerator": log.enumeratorId,
        };

        // Create complete training log following the specified API flow
        final trainingLog = {
          "trainingDetails": trainingDetails,
          "participantDetails": log.participants,
        };

        try {
          final response = await APIMethods().submitTrainingLogToServer(
            trainingLog,
          );

          if (response['success'] == true) {
            await _repository.markAsSynced(log.id!);
            successCount++;
            debugPrint('Synced log ${log.id}');
          } else {
            failCount++;
            debugPrint('Sync failed for log ${log.id}: ${response['message']}');
          }
        } catch (e) {
          failCount++;
          debugPrint('Failed to sync log ${log.id}: $e');
        }
      }

      // Refresh the logs list
      await loadTrainingLogs();

      // Show appropriate message based on results
      if (failCount == 0) {
        Get.snackbar(
          'Success',
          'All $successCount logs synced successfully',
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Partial Success',
          '$successCount synced, $failCount failed',
          backgroundColor: Colors.orange,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Failed to sync pending logs: $e\n$stackTrace');
      Get.snackbar(
        'Error',
        'Failed to sync pending logs',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
