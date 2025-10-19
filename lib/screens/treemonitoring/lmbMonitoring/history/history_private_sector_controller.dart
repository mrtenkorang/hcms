import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:provider/provider.dart';

class HistoryPrivateSectorController extends GetxController {
  BuildContext? historyPrivateSectorHistoryContext;
  final RxList<LMBMonitoring> allRecords = <LMBMonitoring>[].obs;
  final RxList<LMBMonitoring> pendingRecords = <LMBMonitoring>[].obs;
  final RxList<LMBMonitoring> submittedRecords = <LMBMonitoring>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get the provider and fetch all records
      final provider = Provider.of<LMBMonitoringProvider>(
        historyPrivateSectorHistoryContext!,
        listen: false,
      );
      
      // Get all records from the local database
      await provider.fetchAndSetLMBMonitoring();
      
      // Update the lists
      allRecords.assignAll(provider.lmbLists.map((lmb) => lmb));
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

    records.forEach(
        (r){
          debugPrint("Record: ${r.toJson()}");
        }
    );

    // debugPrint("RecordsSSSSSSSSSSSSSSSSSSSSSSSSSSS: ${records.}");
    
    for (var record in records) {
      if (record.lmbConStat == 'connected') {
        submittedRecords.add(record);
      } else {
        pendingRecords.add(record);
      }
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  Future<void> submitRecord(LMBMonitoring record) async {
    try {
      // Here you would implement the actual submission logic
      // This is a placeholder for the submission process
      await Future.delayed(const Duration(seconds: 1));
      
      // After successful submission, update the record
      final provider = Provider.of<LMBMonitoringProvider>(
        historyPrivateSectorHistoryContext!,
        listen: false,
      );
      
      // Update the record status to 'connected' in local DB
      await provider.updateLMBMonitoring(record);
      
      // Refresh the data
      await loadData();
      
      // Show success message
      if (historyPrivateSectorHistoryContext != null && historyPrivateSectorHistoryContext!.mounted) {
        ScaffoldMessenger.of(historyPrivateSectorHistoryContext!).showSnackBar(
          const SnackBar(content: Text('Record submitted successfully')),
        );
      }
    } catch (e) {
      if (historyPrivateSectorHistoryContext != null && historyPrivateSectorHistoryContext!.mounted) {
        ScaffoldMessenger.of(historyPrivateSectorHistoryContext!).showSnackBar(
          SnackBar(content: Text('Failed to submit record: $e')),
        );
      }
    }
  }
}