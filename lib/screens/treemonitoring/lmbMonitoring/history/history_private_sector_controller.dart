import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../controller/constants/urls.dart';

class HistoryPrivateSectorController extends GetxController {
  final RxList<LMBMonitoring> allRecords = <LMBMonitoring>[].obs;
  final RxList<LMBMonitoring> pendingRecords = <LMBMonitoring>[].obs;
  final RxList<LMBMonitoring> submittedRecords = <LMBMonitoring>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSyncing = false.obs;
  final RxInt currentTabIndex = 0.obs;
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

  Future<void> syncAllPendingRecords(BuildContext context) async {
    try {
      isSyncing.value = true;
      errorMessage.value = '';

      if (pendingRecords.isEmpty) {
        Globals().showSnackBar(
          title: "No Pending Data",
          message: "There are no pending records to sync.",
          backgroundColor: Colors.red,
        );
        return;
      }

      Globals().startWait(context);
      int successCount = 0;
      final provider = Provider.of<LMBMonitoringProvider>(
        context,
        listen: false,
      );

      // Create a copy of pendingRecords to avoid concurrent modification
      final recordsToProcess = List<LMBMonitoring>.from(pendingRecords);
      
      for (final record in recordsToProcess) {
        int male = record.lmbMaleBenefit.toString().isEmpty
            ? 0
            : int.parse(record.lmbMaleBenefit);
        int female = record.lmbFemaleBenefit.toString().isEmpty
            ? 0
            : int.parse(record.lmbFemaleBenefit);
        int youth = record.lmbYouthBenefit.toString().isEmpty
            ? 0
            : int.parse(record.lmbYouthBenefit);
        double loanDur = record.lmbLoanDuration.toString().isEmpty
            ? 0.0
            : double.parse(record.lmbLoanDuration);
        double loanInt = record.lmbLoanInterest.toString().isEmpty
            ? 0.0
            : double.parse(record.lmbLoanInterest);

        final submitData = {
          "enumeratorDetails": {
            "enumerator": record.lmbEnumeratorValue,
            "lmbName": record.lmbName,
            "lmbType": "${record.lmbSector} Sector Engagement",
          },
          "engagementDetails": {
            "privateSectorName": record.lmbPrivateName,
            "dateOfFirstEng": record.lmbFirstEngagement,
            "partnershipType": record.lmbPartnershipType,
            "partnershipDuration": record.lmbPartnershipDuration,
            "mouSigned": record.lmbMou,
            "finServiceName": record.lmbFinancialName,
            "finServiceType": record.lmbTypeLoanService,
            "loanDuration": loanInt,
            "interestRate": loanDur,
            "numOfFarmersBenfitting": {
              "female": female,
              "male": male,
              "youth": youth,
            },
          },
        };

        debugPrint('Submitting record ::::::::::::::::::: $submitData');

        try {

          var url = '${URLS.baseUrl}${URLS.privateSectorEngagementURL}';
          var body = json.encode(submitData);

          debugPrint("Uploading data: $body");

          var res = await http.post(Uri.parse(url), body: body);

          debugPrint("Status code: ${res.statusCode}");

          final response = json.decode(res.body);
          var status = response["status"];

          // final result = await APIMethods.submitLMBMonitoring(submitData);

          if (status == true) {
            // Update the connection status locally
            record.lmbConStat = 'connected';
            await provider.updateLMBMonitoring(record);
            successCount++;

            // Update the UI lists
            pendingRecords.remove(record);
            submittedRecords.add(record);
          } else {
            debugPrint(
              'Failed to submit record ${record.lmbId}: ${response['msg']}',
            );
          }
        } catch (e, stackTrace) {
          debugPrint('Error submitting record: $e');
          debugPrint('Error submitting record: $stackTrace');
        }
      }

      Globals().endWait(context);

      // Show result message
      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          'Successfully synced $successCount out of ${pendingRecords.length} pending records.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );

        // Refresh the data to ensure consistency
        await loadData(context);
      } else {
        Get.snackbar(
          'Sync Failed',
          'Failed to sync any records. Please check your connection and try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error syncing records: $e');
      debugPrint('Error syncing records: $stackTrace');
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
  bool get hasPendingRecords => pendingRecords.isNotEmpty;
  bool get hasSubmittedRecords => submittedRecords.isNotEmpty;

  List<LMBMonitoring> get currentTabRecords =>
      currentTabIndex.value == 0 ? submittedRecords : pendingRecords;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
