import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:provider/provider.dart';

class HistoryPrivateSectorController extends GetxController {
  final RxList<LMBMonitoring> allRecords = <LMBMonitoring>[].obs;
  final RxList<LMBMonitoring> pendingRecords = <LMBMonitoring>[].obs;
  final RxList<LMBMonitoring> submittedRecords = <LMBMonitoring>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't load data here - wait for context to be available
  }

  Future<void> loadData(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get the provider and fetch all records
      final provider = Provider.of<LMBMonitoringProvider>(
        context,
        listen: false,
      );

      // Get all records from the local database
      await provider.fetchAndSetLMBMonitoring();

      // Update the lists
      allRecords.assignAll(provider.lmbLists);
      _categorizeRecords(provider.lmbLists);

    } catch (e) {
      errorMessage.value = 'Failed to load records: $e';
      debugPrint('Error loading private sector history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _categorizeRecords(List<LMBMonitoring> records) {
    pendingRecords.clear();
    submittedRecords.clear();

    for (var record in records) {
      if (record.lmbConStat == 'connected') {
        submittedRecords.add(record);
      } else {
        pendingRecords.add(record);
      }
    }
  }

  Future<void> refreshData(BuildContext context) async {
    await loadData(context);
  }
}