// // seedling_monitoring_service.dart
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:hcms_revived2/controller/api/api_methods.dart';
// import 'package:hcms_revived2/controller/repos/seedling_monitoring_reepo.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';
//
// class SeedlingMonitoringService extends GetxService {
//   final SeedlingMonitoringRepository _repository =
//       SeedlingMonitoringRepository();
//   final Rx<SeedlingMonitoringModel> currentMonitoring =
//       SeedlingMonitoringModel().obs;
//   final RxList<SeedlingMonitoringModel> savedMonitorings =
//       <SeedlingMonitoringModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadSavedData();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//     _repository.close();
//   }
//
//   // Add tree data to the current monitoring session
//   Future<void> addTreeData(Map<String, dynamic> treeData) async {
//     try {
//       // Get current tree data
//       final currentTrees = currentMonitoring.value.treeData;
//
//       // Add the new tree data
//       currentTrees.add(treeData);
//
//       // Update the current monitoring with new tree data
//       currentMonitoring.value = currentMonitoring.value.copyWith(
//         mappedSurvivingSeedlings: json.encode(currentTrees),
//       );
//
//       // Refresh the observable
//       currentMonitoring.refresh();
//
//       debugPrint('Added tree data: $treeData');
//       debugPrint('Total trees: ${currentTrees.length}');
//     } catch (e) {
//       debugPrint('Error adding tree data: $e');
//       rethrow;
//     }
//   }
//
//   // Set all tree data at once
//   void setTreeData(List<Map<String, dynamic>> treeData) {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       mappedSurvivingSeedlings: treeData.isNotEmpty
//           ? json.encode(treeData)
//           : null,
//     );
//     currentMonitoring.refresh();
//     debugPrint('Set tree data with ${treeData.length} trees');
//   }
//
//   // Clear all tree data
//   void clearTreeData() {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       mappedSurvivingSeedlings: null,
//     );
//     currentMonitoring.refresh();
//     debugPrint('Cleared tree data');
//   }
//
//   // Get tree count
//   int get treeCount => currentMonitoring.value.treeCount;
//
//   // Load all saved data from database using repository
//   Future<void> _loadSavedData() async {
//     try {
//       final monitorings = await _repository.getAll();
//       savedMonitorings.assignAll(monitorings);
//       debugPrint('Loaded ${monitorings.length} monitoring records');
//     } catch (e) {
//       debugPrint('Error loading saved data: $e');
//     }
//   }
//
//   // Start new monitoring session
//   void startNewMonitoring() {
//     currentMonitoring.value = SeedlingMonitoringModel(
//       createdAt: DateTime.now(),
//       submissionStatus: 'draft',
//       connectionStatus: 'not connected',
//     );
//     debugPrint('Started new monitoring session');
//   }
//
//   // Update general information
//   void updateGeneralInformation({
//     String? surveyorName,
//     String? dateOfSurvey,
//     String? community,
//     String? farmerName,
//     String? farmerIDNumber,
//     bool? communityNotFound,
//     String? customCommunityName,
//   }) {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       surveyorName: surveyorName,
//       dateOfSurvey: dateOfSurvey,
//       community: community,
//       farmerName: farmerName,
//       farmerIDNumber: farmerIDNumber,
//       communityNotFound: communityNotFound,
//       customCommunityName: customCommunityName,
//     );
//     debugPrint('Updated general information');
//   }
//
//   // Update plantation details
//   void updatePlantationDetails({
//     String? plantationType,
//     double? totalSizeAcres,
//     List<String>? speciesProvidedPlanted,
//   }) {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       plantationType: plantationType,
//       totalSizeAcres: totalSizeAcres,
//       speciesProvidedPlanted: speciesProvidedPlanted,
//     );
//     debugPrint('Updated plantation details');
//   }
//
//   // Add species planting detail
//   void addSpeciesPlantingDetail(SpeciesPlantingDetail detail) {
//     final currentDetails = List<SpeciesPlantingDetail>.from(
//       currentMonitoring.value.speciesPlantingDetails,
//     );
//
//     final existingIndex = currentDetails.indexWhere(
//       (d) => d.species == detail.species,
//     );
//     if (existingIndex >= 0) {
//       currentDetails[existingIndex] = detail;
//     } else {
//       currentDetails.add(detail);
//     }
//
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       speciesPlantingDetails: currentDetails,
//     );
//     debugPrint('Added species planting detail: ${detail.species}');
//   }
//
//   // Update mapped area
//   void updateMappedArea({
//     String? mappedFarmBoundaries,
//     double? mappedAreaHectares,
//   }) {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       mappedFarmBoundaries: mappedFarmBoundaries,
//       mappedAreaHectares: mappedAreaHectares,
//     );
//     debugPrint('Updated mapped area');
//   }
//
//   // Update seedling survival data
//   void updateSeedlingSurvival({
//     int? totalSeedlingsAlive,
//     List<String>? speciesAlive,
//     List<String>? reasonForDeath,
//     String? mappedSurvivingSeedlings,
//     List<Map<String, dynamic>>? treeData,
//   }) {
//     // Use treeData if provided, otherwise use mappedSurvivingSeedlings
//     final survivingSeedlings = treeData != null
//         ? json.encode(treeData)
//         : mappedSurvivingSeedlings;
//
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       totalSeedlingsAlive: totalSeedlingsAlive,
//       speciesAlive: speciesAlive,
//       reasonForDeath: reasonForDeath,
//       mappedSurvivingSeedlings: survivingSeedlings,
//     );
//     debugPrint('Updated seedling survival data');
//   }
//
//   // Update environmental conditions
//   void updateEnvironmentalConditions({
//     List<String>? sourceOfWater,
//     String? wateringFrequency,
//     bool? hasExtremeWeather,
//     List<String>? extremeWeathers,
//     String? otherExtremeWeather,
//   }) {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       sourceOfWater: sourceOfWater,
//       wateringFrequency: wateringFrequency,
//       hasExtremeWeather: hasExtremeWeather,
//       extremeWeathers: extremeWeathers,
//       otherExtremeWeather: otherExtremeWeather,
//     );
//     debugPrint('Updated environmental conditions');
//   }
//
//   // Update final observations
//   void updateFinalObservations({
//     bool? pestsAround,
//     String? pestDescription,
//     bool? signsOfDisease,
//     String? diseaseDescription,
//     bool? fertiliserApplied,
//     String? fertiliserType,
//     bool? pesticideApplied,
//     String? pesticideType,
//     String? additionalObservations,
//   }) {
//     currentMonitoring.value = currentMonitoring.value.copyWith(
//       pestsAround: pestsAround,
//       pestDescription: pestDescription,
//       signsOfDisease: signsOfDisease,
//       diseaseDescription: diseaseDescription,
//       fertiliserApplied: fertiliserApplied,
//       fertiliserType: fertiliserType,
//       pesticideApplied: pesticideApplied,
//       pesticideType: pesticideType,
//       additionalObservations: additionalObservations,
//     );
//     debugPrint('Updated final observations');
//   }
//
//   // Save current monitoring to database using repository
//   Future<int> saveCurrentMonitoring() async {
//     try {
//       final monitoring = currentMonitoring.value;
//
//       if (monitoring.surveyorName == null || monitoring.surveyorName!.isEmpty) {
//         debugPrint('Cannot save: Surveyor name is required');
//         return -1;
//       }
//
//       int monitoringId;
//
//       // Check if this is an update to existing record
//       if (monitoring.id != null) {
//         // Update existing record
//         monitoringId = monitoring.id!;
//         await _repository.update(monitoring);
//         clearCurrentMonitoring();
//         debugPrint('Updated existing monitoring record: $monitoringId');
//       } else {
//
//         debugPrint(
//           "THE NEW :::::::::: ${monitoring.treeData.first}",
//         );
//
//         // Insert new record
//         monitoringId = await _repository.create(monitoring);
//         // Update the current monitoring with the new ID
//         currentMonitoring.value = monitoring.copyWith(id: monitoringId);
//         clearCurrentMonitoring();
//         debugPrint('Created new monitoring record: $monitoringId');
//       }
//
//       // Reload data to update the list
//       await _loadSavedData();
//
//       return monitoringId;
//     } catch (e) {
//       debugPrint('Error saving monitoring: $e');
//       return -1;
//     }
//   }
//
//   // Load a specific monitoring session
//   Future<void> loadMonitoring(SeedlingMonitoringModel monitoring) async {
//     currentMonitoring.value = monitoring;
//     debugPrint('Loaded monitoring session: ${monitoring.id}');
//   }
//
//   // Load monitoring by ID using repository
//   Future<void> loadMonitoringById(int id) async {
//     try {
//       final monitoring = await _repository.getById(id);
//       if (monitoring != null) {
//         currentMonitoring.value = monitoring;
//         debugPrint('Loaded monitoring by ID: $id');
//       } else {
//         debugPrint('Monitoring not found with ID: $id');
//       }
//     } catch (e) {
//       debugPrint('Error loading monitoring by ID: $e');
//     }
//   }
//
//   // Delete a monitoring session using repository
//   Future<bool> deleteMonitoring(SeedlingMonitoringModel monitoring) async {
//     try {
//       if (monitoring.id == null) {
//         debugPrint('Cannot delete monitoring: ID is null');
//         return false;
//       }
//
//       final result = await _repository.delete(monitoring.id!);
//
//       if (result > 0) {
//         // Remove from local list
//         savedMonitorings.removeWhere((m) => m.id == monitoring.id);
//
//         // Clear current monitoring if it's the one being deleted
//         if (currentMonitoring.value.id == monitoring.id) {
//           startNewMonitoring();
//         }
//
//         debugPrint('Deleted monitoring record: ${monitoring.id}');
//         return true;
//       }
//
//       return false;
//     } catch (e) {
//       debugPrint('Error deleting monitoring: $e');
//       return false;
//     }
//   }
//
//   // Delete multiple monitoring sessions
//   Future<int> deleteMultipleMonitorings(List<int> ids) async {
//     try {
//       final result = await _repository.deleteMultiple(ids);
//
//       if (result > 0) {
//         // Remove from local list
//         savedMonitorings.removeWhere((m) => m.id != null && ids.contains(m.id));
//
//         // Clear current monitoring if it's being deleted
//         if (currentMonitoring.value.id != null &&
//             ids.contains(currentMonitoring.value.id)) {
//           startNewMonitoring();
//         }
//
//         debugPrint('Deleted $result monitoring records');
//       }
//
//       return result;
//     } catch (e) {
//       debugPrint('Error deleting multiple monitorings: $e');
//       return 0;
//     }
//   }
//
//   // Submit monitoring data online
//   Future<bool> submitOnline() async {
//     try {
//       // Validate data first
//       final errors = currentMonitoring.value.validateAll();
//       if (errors.isNotEmpty) {
//         Get.snackbar(
//           'Validation Error',
//           'Please fix all errors before submission:\n${errors.join('\n')}',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return false;
//       }
//
//       final res = await APIMethods().submitSeedlingMonitoringToServer(
//         currentMonitoring.value,
//       );
//
//       debugPrint("THE SUBMISSION RES :::::::::::::::: $res");
//
//       if (res['success'] == true) {
//         // Delete record if exist in local db
//         if(currentMonitoring.value.id != null){
//           await _repository.delete(currentMonitoring.value.id!);
//         }
//
//         // Update current monitoring status
//         currentMonitoring.value = currentMonitoring.value.copyWith(
//           submissionStatus: 'submitted',
//           connectionStatus: 'connected',
//         );
//
//         // Reload data
//         await _loadSavedData();
//
//         return true;
//       }
//
//       return false;
//     } catch (e, stackTrace) {
//       debugPrint('Online submission error: $e');
//       debugPrint('Online submission error: $stackTrace');
//       return false;
//     }
//   }
//
//   // Save offline using repository
//   Future<bool> saveOffline() async {
//     try {
//       final errors = currentMonitoring.value.validateAll();
//       if (errors.isNotEmpty) {
//         Get.snackbar(
//           'Validation Warning',
//           'Some fields are incomplete. Data will be saved as draft.\n${errors.join('\n')}',
//           duration: Duration(seconds: 10),
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//       }
//
//       currentMonitoring.value = currentMonitoring.value.copyWith(
//         submissionStatus: 'draft',
//         connectionStatus: 'not connected',
//       );
//
//       final savedId = await saveCurrentMonitoring();
//       return savedId > 0;
//     } catch (e) {
//       debugPrint('Offline save error: $e');
//       return false;
//     }
//   }
//
//   // Export data for backup
//   String exportData() {
//     return json.encode({
//       'exportedAt': DateTime.now().toIso8601String(),
//       'records': savedMonitorings.map((m) => m.toJson()).toList(),
//     });
//   }
//
//   // Get monitorings by status using repository
//   Future<List<SeedlingMonitoringModel>> getMonitoringsByStatus(
//     String status,
//   ) async {
//     try {
//       return await _repository.getByStatus(status);
//     } catch (e) {
//       debugPrint('Error getting monitorings by status: $e');
//       return [];
//     }
//   }
//
//   // Search monitorings by farmer name using repository
//   Future<List<SeedlingMonitoringModel>> searchByFarmerName(String query) async {
//     try {
//       return await _repository.getByFarmerName(query);
//     } catch (e) {
//       debugPrint('Error searching by farmer name: $e');
//       return [];
//     }
//   }
//
//   // Search monitorings using repository
//   Future<List<SeedlingMonitoringModel>> searchMonitorings(String query) async {
//     try {
//       return await _repository.search(query);
//     } catch (e) {
//       debugPrint('Error searching monitorings: $e');
//       return [];
//     }
//   }
//
//   // Get all monitoring data using repository
//   Future<List<SeedlingMonitoringModel>> getAllMonitorings() async {
//     try {
//       return await _repository.getAll();
//     } catch (e) {
//       debugPrint('Error getting all monitorings: $e');
//       return [];
//     }
//   }
//
//   // Get monitoring by ID using repository
//   Future<SeedlingMonitoringModel?> getMonitoringById(int id) async {
//     try {
//       return await _repository.getById(id);
//     } catch (e) {
//       debugPrint('Error getting monitoring by id: $e');
//       return null;
//     }
//   }
//
//   // Get draft monitorings
//   Future<List<SeedlingMonitoringModel>> getDrafts() async {
//     try {
//       return await _repository.getDrafts();
//     } catch (e) {
//       debugPrint('Error getting drafts: $e');
//       return [];
//     }
//   }
//
//   // Get submitted monitorings
//   Future<List<SeedlingMonitoringModel>> getSubmitted() async {
//     try {
//       return await _repository.getSubmitted();
//     } catch (e) {
//       debugPrint('Error getting submitted: $e');
//       return [];
//     }
//   }
//
//   // Get unsynced monitorings
//   Future<List<SeedlingMonitoringModel>> getUnsynced() async {
//     try {
//       return await _repository.getUnsynced();
//     } catch (e) {
//       debugPrint('Error getting unsynced: $e');
//       return [];
//     }
//   }
//
//   // Update offline using repository
//   Future<bool> updateOffline(SeedlingMonitoringModel monitoring) async {
//     try {
//       if (monitoring.id == null) {
//         debugPrint('Cannot update monitoring: ID is null');
//         return false;
//       }
//
//       final result = await _repository.update(monitoring);
//
//       if (result > 0) {
//         // Update the current monitoring if it's the one being updated
//         if (currentMonitoring.value.id == monitoring.id) {
//           currentMonitoring.value = monitoring;
//         }
//
//         // Refresh the saved monitorings list
//         await _loadSavedData();
//         return true;
//       }
//
//       return false;
//     } catch (e) {
//       debugPrint('Error updating monitoring offline: $e');
//       return false;
//     }
//   }
//
//   // Sync unsynced records
//   Future<void> syncUnsyncedRecords() async {
//     try {
//       final unsynced = await _repository.getUnsynced();
//       debugPrint('Found ${unsynced.length} unsynced records');
//
//       int successCount = 0;
//
//       for (final record in unsynced) {
//         try {
//           final res = await APIMethods().submitSeedlingMonitoringToServer(
//             record,
//           );
//
//           if (res['success'] == true) {
//             await _repository.markAsSynced(record.id!);
//             successCount++;
//             debugPrint('Successfully synced record: ${record.id}');
//           } else {
//             debugPrint('Failed to sync record: ${record.id}');
//           }
//         } catch (e) {
//           debugPrint('Error syncing record ${record.id}: $e');
//         }
//       }
//
//       if (successCount > 0) {
//         await _loadSavedData();
//       }
//
//       debugPrint(
//         'Sync completed: $successCount/${unsynced.length} records synced',
//       );
//     } catch (e) {
//       debugPrint('Error syncing unsynced records: $e');
//     }
//   }
//
//   // Validate current monitoring
//   List<String> validateCurrentMonitoring() {
//     return currentMonitoring.value.validateAll();
//   }
//
//   // Check if current monitoring is complete
//   bool get isCurrentMonitoringComplete => currentMonitoring.value.isComplete;
//
//   // Get count of monitorings
//   Future<int> getMonitoringCount() async {
//     try {
//       return await _repository.count();
//     } catch (e) {
//       debugPrint('Error getting monitoring count: $e');
//       return 0;
//     }
//   }
//
//   // Clear current monitoring
//   void clearCurrentMonitoring() {
//     startNewMonitoring();
//     debugPrint('Cleared current monitoring session');
//   }
//
//   // Check if monitoring exists with same details
//   Future<bool> monitoringExists({
//     required String farmerName,
//     required String farmerIDNumber,
//     required String dateOfSurvey,
//   }) async {
//     try {
//       final allMonitorings = await _repository.getAll();
//       return allMonitorings.any(
//         (m) =>
//             m.farmerName == farmerName &&
//             m.farmerIDNumber == farmerIDNumber &&
//             m.dateOfSurvey == dateOfSurvey,
//       );
//     } catch (e) {
//       debugPrint('Error checking if monitoring exists: $e');
//       return false;
//     }
//   }
// }
