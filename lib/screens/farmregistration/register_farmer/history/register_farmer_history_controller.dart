import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';
import 'package:hcms_revived2/controller/repos/farmer_local_repo.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';

class RegisterFarmerHistoryController extends GetxController {
  final FarmerBiodataRepository _repository = FarmerBiodataRepository();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<List<FarmerBiodataModel>> getPendingFarmerBiodata() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final farmers = await _repository.getPendingFarmerBiodata();
      return farmers;
    } catch (e) {
      errorMessage.value = 'Failed to load pending farmers: ${e.toString()}';
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<FarmerBiodataModel>> getSubmittedFarmerBiodata() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final farmers = await _repository.getSubmittedFarmerBiodata();
      return farmers;
    } catch (e) {
      errorMessage.value = 'Failed to load submitted farmers: ${e.toString()}';
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncAllPendingFarmers(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get all pending farmers
      final pendingFarmers = await _repository.getPendingFarmerBiodata();

      if (pendingFarmers.isEmpty) {
        Globals().showSnackBar(
          title: "Bad State",
          message: "No pending farmers to sync.",
          backgroundColor: Colors.red,
        );
        return;
      }

      int successCount = 0;

      Globals().startWait(context);

      // Process each farmer
      for (var farmer in pendingFarmers) {
        try {
          final result = await APIMethods.submitFarmer(farmer);
          if (result['success'] == true) {
            // Update the status to submitted locally
            farmer.status = 'submitted';
            await _repository.updateFarmerBiodata(farmer);
            successCount++;
          }
        } catch (e) {
          Globals().endWait(context);
          // Log error but continue with next farmer
          debugPrint('Error syncing farmer ${farmer.id}: $e');
        }
      }
      Globals().endWait(context);

      // Show success message
      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          'Successfully synced $successCount out of ${pendingFarmers.length} pending farmers.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Sync Failed',
          'An unknown error occurred while syncing farmers.',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to sync farmers: ${e.toString()}';
      Get.snackbar(
        'Sync Error',
        'An error occurred while syncing: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
