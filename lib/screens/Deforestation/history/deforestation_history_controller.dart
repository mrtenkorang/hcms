import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:hcms_revived2/controller/repos/deforestation_repo.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';

class DeforestationHistoryController extends GetxController {
  final DeforestationRepository _repository = DeforestationRepository();

  final RxList<DeforestationReportModel> allReports = <DeforestationReportModel>[].obs;
  final RxList<DeforestationReportModel> pendingReports = <DeforestationReportModel>[].obs;
  final RxList<DeforestationReportModel> submittedReports = <DeforestationReportModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reports = await _repository.getLocalReports();
      allReports.assignAll(reports);

      // Separate reports by status
      pendingReports.assignAll(
          reports.where((report) => report.submissionStatus == 'pending').toList()
      );

      submittedReports.assignAll(
          reports.where((report) => report.submissionStatus == 'submitted').toList()
      );

    } catch (e) {
      errorMessage.value = 'Failed to load reports: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshReports() async {
    await loadReports();
  }

  Future<void> submitPendingReport(int reportId) async {
    try {
      isLoading.value = true;

      final report = allReports.firstWhere((r) => r.id == reportId);
      final result = await APIMethods().submitDeforestationReportToServer(report);

      if (result['success'] == true) {
        Get.back();
        await _repository.markReportAsSubmitted(reportId);
        await loadReports();
        Get.snackbar(
          'Success',
          'Report submitted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to submit report',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit report: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  final RxBool isSyncing = false.obs;
  final RxString syncStatus = ''.obs;

  Future<void> submitAllPendingReports(BuildContext context) async {
    try {
      isSyncing.value = true;
      errorMessage.value = '';
      
      final pending = await _repository.getPendingReports();
      
      if (pending.isEmpty) {
        Get.snackbar(
          'No Pending Reports',
          'There are no pending reports to sync.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
        );
        return;
      }

      int successCount = 0;

      Globals().startWait(context);
      
      for (final report in pending) {
        try {
          final result = await APIMethods().submitDeforestationReportToServer(report);
          if (result['success'] == true) {
            await _repository.markReportAsSubmitted(report.id!);
            successCount++;
          } else {
            debugPrint('Failed to submit report ${report.id}: ${result['error']}');
          }
        } catch (e) {
          debugPrint('Error submitting report ${report.id}: $e');
        }
      }
      Globals().endWait(context);

      // Refresh the reports
      await loadReports();

      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          'Successfully synced $successCount out of ${pending.length} pending reports.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Sync Failed',
          'Failed to sync any reports. Please check your connection and try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Sync Error',
        'An error occurred while syncing: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    } finally {
      isSyncing.value = false;
    }
  }

  // Getter to check if there are pending reports
  bool get hasPendingReports => pendingReports.isNotEmpty;
  
  // Getter to check if there are submitted reports
  bool get hasSubmittedReports => submittedReports.isNotEmpty;
  
  // Get the current tab's reports
  List<DeforestationReportModel> get currentTabReports {
    return currentTabIndex.value == 0 ? pendingReports : submittedReports;
  }
  
  // Change tab
  void changeTab(int index) {
    currentTabIndex.value = index;
  }
  
  // Refresh reports
  // Future<void> refreshReports() async {
  //   await loadReports();
  // }

  Future<void> deleteReport(int reportId) async {
    try {
      final result = await Get.dialog(
        AlertDialog(
          title: const Text('Delete Report'),
          content: const Text('Are you sure you want to delete this report?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (result == true) {
        isLoading.value = true;
        await _repository.deleteLocalReport(reportId);
        await loadReports();

        Get.snackbar(
          'Success',
          'Report deleted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete report: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // void changeTab(int index) {
  //   currentTabIndex.value = index;
  // }
  //
  // List<DeforestationReportModel> get currentTabReports {
  //   switch (currentTabIndex.value) {
  //     case 0: // Pending
  //       return pendingReports;
  //     case 1: // Submitted
  //       return submittedReports;
  //     default:
  //       return [];
  //   }
  // }
  //
  // bool get hasPendingReports => pendingReports.isNotEmpty;
  // bool get hasSubmittedReports => submittedReports.isNotEmpty;
}