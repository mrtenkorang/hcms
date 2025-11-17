import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/seedling_monitoring_model.dart';
import 'package:hcms_revived2/controller/repos/seedling_monitoring_reepo.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';

class SeedlingMonitoringHistoryController extends GetxController {
  final SeedlingMonitoringRepository _repository = SeedlingMonitoringRepository();
  
  final RxList<SeedlingMonitoringModel> allMonitorings = <SeedlingMonitoringModel>[].obs;
  final RxList<SeedlingMonitoringModel> pendingMonitorings = <SeedlingMonitoringModel>[].obs;
  final RxList<SeedlingMonitoringModel> submittedMonitorings = <SeedlingMonitoringModel>[].obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMonitorings();
  }

  Future<void> loadMonitorings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final monitorings = await _repository.getAll();
      allMonitorings.assignAll(monitorings);
      
      // Separate monitorings by status
      pendingMonitorings.assignAll(
        monitorings.where((m) => m.connectionStatus == 'not connected').toList()
      );
      
      submittedMonitorings.assignAll(
        monitorings.where((m) => m.connectionStatus == 'connected').toList()
      );
      
    } catch (e) {
      errorMessage.value = 'Failed to load monitorings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMonitorings() async {
    await loadMonitorings();
  }

  Future<void> syncAllPendingMonitorings(BuildContext context) async {
    try {
      isSyncing.value = true;
      errorMessage.value = '';
      
      final pending = pendingMonitorings.toList();
      
      if (pending.isEmpty) {
        Globals().showSnackBar(
          title: "No Pending Data",
          message: "There are no pending monitorings to sync.",
          backgroundColor: Colors.red,
        );
        return;
      }

      Globals().startWait(context);
      int successCount = 0;
      
      for (final monitoring in List.from(pending)) {

        debugPrint('Submitting monitoring ${monitoring.toApiJson()}');
        try {
          final result = await APIMethods().submitSeedlingMonitoringToServer(monitoring);
          
          if (result['success'] == true) {
            // Update the connection status locally
            monitoring.connectionStatus = 'connected';
            await _repository.update(monitoring);
            successCount++;
          } else {
            debugPrint('Failed to submit monitoring ${monitoring.id}: ${result['error']}');
          }
        } catch (e) {
          debugPrint('Error submitting monitoring ${monitoring.id}: $e');
        }
      }
      
      Globals().endWait(context);
      
      // Refresh the data
      await loadMonitorings();
      
      // Show result message
      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          'Successfully synced $successCount out of ${pending.length} pending monitorings.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Sync Failed',
          'Failed to sync any monitorings, please try again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      }
      
    } catch (e) {
      Globals().endWait(context);
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
  
  // Getters
  bool get hasPendingMonitorings => pendingMonitorings.isNotEmpty;
  bool get hasSubmittedMonitorings => submittedMonitorings.isNotEmpty;
  
  List<SeedlingMonitoringModel> get currentTabMonitorings => 
      currentTabIndex.value == 0 ? submittedMonitorings : pendingMonitorings;
  
  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
