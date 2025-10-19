// seedling_monitoring_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';
import 'package:sqflite/sqflite.dart';

class SeedlingMonitoringService extends GetxService {
  final DBHelper _dbHelper = DBHelper();
  final Rx<SeedlingMonitoringModel> currentMonitoring = SeedlingMonitoringModel().obs;
  final RxList<SeedlingMonitoringModel> savedMonitorings = <SeedlingMonitoringModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Add tree data to the current monitoring session
  Future<void> addTreeData(Map<String, dynamic> treeData) async {
    try {
      // Get current tree data
      final currentTrees = currentMonitoring.value.treeData;

      // Add the new tree data
      currentTrees.add(treeData);

      // Update the current monitoring with new tree data
      currentMonitoring.value = currentMonitoring.value.copyWith(
        mappedSurvivingSeedlings: json.encode(currentTrees),
      );

      // Refresh the observable
      currentMonitoring.refresh();

      debugPrint('Added tree data: $treeData');
      debugPrint('Total trees: ${currentTrees.length}');
    } catch (e) {
      debugPrint('Error adding tree data: $e');
      rethrow;
    }
  }

  // Set all tree data at once
  void setTreeData(List<Map<String, dynamic>> treeData) {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      mappedSurvivingSeedlings: treeData.isNotEmpty ? json.encode(treeData) : null,
    );
    currentMonitoring.refresh();
    debugPrint('Set tree data with ${treeData.length} trees');
  }

  // Clear all tree data
  void clearTreeData() {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      mappedSurvivingSeedlings: null,
    );
    currentMonitoring.refresh();
    debugPrint('Cleared tree data');
  }

  // Get tree count
  int get treeCount => currentMonitoring.value.treeCount;

  // Load all saved data from database
  Future<void> _loadSavedData() async {
    try {
      final Database db = await DBHelper.database();

      // Load main monitoring records
      final List<Map<String, dynamic>> monitoringMaps = await db.query(
          'seedling_monitorings',
          orderBy: 'created_at DESC'
      );

      final List<SeedlingMonitoringModel> monitorings = [];

      for (final map in monitoringMaps) {
        // Load species planting details for this monitoring
        final List<Map<String, dynamic>> speciesMaps = await db.query(
          'species_planting_details',
          where: 'monitoring_id = ?',
          whereArgs: [map['id']],
        );

        final speciesDetails = speciesMaps.map((speciesMap) => SpeciesPlantingDetail(
          species: speciesMap['species'],
          quantityReceived: speciesMap['quantity_received'],
          quantityPlanted: speciesMap['quantity_planted'],
          dateOfPlanting: speciesMap['date_of_planting'],
        )).toList();

        final monitoring = SeedlingMonitoringModel.fromJson(_convertDbMapToJson(map));
        monitoring.speciesPlantingDetails = speciesDetails;
        monitorings.add(monitoring);
      }

      savedMonitorings.assignAll(monitorings);
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

  // Convert database map to JSON format
  Map<String, dynamic> _convertDbMapToJson(Map<String, dynamic> dbMap) {
    return {
      'surveyorName': dbMap['surveyor_name'],
      'dateOfSurvey': dbMap['date_of_survey'],
      'community': dbMap['community'],
      'farmerName': dbMap['farmer_name'],
      'farmerIDNumber': dbMap['farmer_id_number'],
      'communityNotFound': dbMap['community_notfound'] == 1,
      'customCommunityName': dbMap['custom_community_name'],
      'plantationType': dbMap['plantation_type'],
      'totalSizeAcres': dbMap['total_size_acres'],
      'speciesProvidedPlanted': dbMap['species_provided_planted'] != null
          ? List<String>.from(json.decode(dbMap['species_provided_planted']))
          : [],
      'mappedFarmBoundaries': dbMap['mapped_farm_boundaries'],
      'mappedAreaHectares': dbMap['mapped_area_hectares'],
      'totalSeedlingsAlive': dbMap['total_seedlings_alive'],
      'speciesAlive': dbMap['species_alive'] != null
          ? List<String>.from(json.decode(dbMap['species_alive']))
          : [],
      'reasonForDeath': dbMap['reason_for_death'] != null
          ? List<String>.from(json.decode(dbMap['reason_for_death']))
          : [],
      'mappedSurvivingSeedlings': dbMap['mapped_surviving_seedlings'],
      'sourceOfWater': dbMap['source_of_water'] != null
          ? List<String>.from(json.decode(dbMap['source_of_water']))
          : [],
      'wateringFrequency': dbMap['watering_frequency'],
      'hasExtremeWeather': dbMap['has_extreme_weather'] == 1,
      'extremeWeathers': dbMap['extreme_weathers'] != null
          ? List<String>.from(json.decode(dbMap['extreme_weathers']))
          : [],
      'otherExtremeWeather': dbMap['other_extreme_weather'],
      'pestsAround': dbMap['pests_around'] == 1,
      'pestDescription': dbMap['pest_description'],
      'signsOfDisease': dbMap['signs_of_disease'] == 1,
      'diseaseDescription': dbMap['disease_description'],
      'fertiliserApplied': dbMap['fertiliser_applied'] == 1,
      'fertiliserType': dbMap['fertiliser_type'],
      'pesticideApplied': dbMap['pesticide_applied'] == 1,
      'pesticideType': dbMap['pesticide_type'],
      'additionalObservations': dbMap['additional_observations'],
      'farmerContact': dbMap['farmer_contact'],
      'enumeratorValue': dbMap['enumerator_value'],
      'submissionStatus': dbMap['submission_status'],
      'connectionStatus': dbMap['connection_status'],
      'createdAt': dbMap['created_at'],
    };
  }

  // Convert model to database map
  Map<String, dynamic> _convertModelToDbMap(SeedlingMonitoringModel monitoring) {
    return {
      'surveyor_name': monitoring.surveyorName,
      'date_of_survey': monitoring.dateOfSurvey,
      'community': monitoring.community,
      'farmer_name': monitoring.farmerName,
      'farmer_id_number': monitoring.farmerIDNumber,
      'community_notfound': monitoring.communityNotFound == true ? 1 : 0,
      'custom_community_name': monitoring.customCommunityName,
      'plantation_type': monitoring.plantationType,
      'total_size_acres': monitoring.totalSizeAcres,
      'species_provided_planted': json.encode(monitoring.speciesProvidedPlanted),
      'mapped_farm_boundaries': monitoring.mappedFarmBoundaries,
      'mapped_area_hectares': monitoring.mappedAreaHectares,
      'total_seedlings_alive': monitoring.totalSeedlingsAlive,
      'species_alive': json.encode(monitoring.speciesAlive),
      'reason_for_death': json.encode(monitoring.reasonForDeath),
      'mapped_surviving_seedlings': monitoring.mappedSurvivingSeedlings,
      'source_of_water': json.encode(monitoring.sourceOfWater),
      'watering_frequency': monitoring.wateringFrequency,
      'has_extreme_weather': monitoring.hasExtremeWeather == true ? 1 : 0,
      'extreme_weathers': json.encode(monitoring.extremeWeathers),
      'other_extreme_weather': monitoring.otherExtremeWeather,
      'pests_around': monitoring.pestsAround == true ? 1 : 0,
      'pest_description': monitoring.pestDescription,
      'signs_of_disease': monitoring.signsOfDisease == true ? 1 : 0,
      'disease_description': monitoring.diseaseDescription,
      'fertiliser_applied': monitoring.fertiliserApplied == true ? 1 : 0,
      'fertiliser_type': monitoring.fertiliserType,
      'pesticide_applied': monitoring.pesticideApplied == true ? 1 : 0,
      'pesticide_type': monitoring.pesticideType,
      'additional_observations': monitoring.additionalObservations,
      'farmer_contact': monitoring.farmerContact,
      'enumerator_value': monitoring.enumeratorValue,
      'submission_status': monitoring.submissionStatus,
      'connection_status': monitoring.connectionStatus,
      'created_at': monitoring.createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Start new monitoring session
  void startNewMonitoring() {
    currentMonitoring.value = SeedlingMonitoringModel(
      createdAt: DateTime.now(),
      submissionStatus: 'draft',
      connectionStatus: 'not_connected',
    );
  }

  // Update general information
  void updateGeneralInformation({
    String? surveyorName,
    String? dateOfSurvey,
    String? community,
    String? farmerName,
    String? farmerIDNumber,
    bool? communityNotFound,
    String? customCommunityName,
  }) {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      surveyorName: surveyorName,
      dateOfSurvey: dateOfSurvey,
      community: community,
      farmerName: farmerName,
      farmerIDNumber: farmerIDNumber,
      communityNotFound: communityNotFound,
      customCommunityName: customCommunityName,
    );
  }

  // Update plantation details
  void updatePlantationDetails({
    String? plantationType,
    double? totalSizeAcres,
    List<String>? speciesProvidedPlanted,
  }) {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      plantationType: plantationType,
      totalSizeAcres: totalSizeAcres,
      speciesProvidedPlanted: speciesProvidedPlanted,
    );
  }

  // Add species planting detail
  void addSpeciesPlantingDetail(SpeciesPlantingDetail detail) {
    final currentDetails = List<SpeciesPlantingDetail>.from(currentMonitoring.value.speciesPlantingDetails);

    final existingIndex = currentDetails.indexWhere((d) => d.species == detail.species);
    if (existingIndex >= 0) {
      currentDetails[existingIndex] = detail;
    } else {
      currentDetails.add(detail);
    }

    currentMonitoring.value = currentMonitoring.value.copyWith(
      speciesPlantingDetails: currentDetails,
    );
  }

  // Update mapped area
  void updateMappedArea({
    String? mappedFarmBoundaries,
    double? mappedAreaHectares,
  }) {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      mappedFarmBoundaries: mappedFarmBoundaries,
      mappedAreaHectares: mappedAreaHectares,
    );
  }

  // Update seedling survival data
  void updateSeedlingSurvival({
    int? totalSeedlingsAlive,
    List<String>? speciesAlive,
    List<String>? reasonForDeath,
    String? mappedSurvivingSeedlings,
    List<Map<String, dynamic>>? treeData,
  }) {
    // Use treeData if provided, otherwise use mappedSurvivingSeedlings
    final survivingSeedlings = treeData != null ? json.encode(treeData) : mappedSurvivingSeedlings;

    currentMonitoring.value = currentMonitoring.value.copyWith(
      totalSeedlingsAlive: totalSeedlingsAlive,
      speciesAlive: speciesAlive,
      reasonForDeath: reasonForDeath,
      mappedSurvivingSeedlings: survivingSeedlings,
    );
  }

  // Update environmental conditions
  void updateEnvironmentalConditions({
    List<String>? sourceOfWater,
    String? wateringFrequency,
    bool? hasExtremeWeather,
    List<String>? extremeWeathers,
    String? otherExtremeWeather,
  }) {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      sourceOfWater: sourceOfWater,
      wateringFrequency: wateringFrequency,
      hasExtremeWeather: hasExtremeWeather,
      extremeWeathers: extremeWeathers,
      otherExtremeWeather: otherExtremeWeather,
    );
  }

  // Update final observations
  void updateFinalObservations({
    bool? pestsAround,
    String? pestDescription,
    bool? signsOfDisease,
    String? diseaseDescription,
    bool? fertiliserApplied,
    String? fertiliserType,
    bool? pesticideApplied,
    String? pesticideType,
    String? additionalObservations,
  }) {
    currentMonitoring.value = currentMonitoring.value.copyWith(
      pestsAround: pestsAround,
      pestDescription: pestDescription,
      signsOfDisease: signsOfDisease,
      diseaseDescription: diseaseDescription,
      fertiliserApplied: fertiliserApplied,
      fertiliserType: fertiliserType,
      pesticideApplied: pesticideApplied,
      pesticideType: pesticideType,
      additionalObservations: additionalObservations,
    );
  }

  // Save current monitoring to database
  Future<int> saveCurrentMonitoring() async {
    try {
      final Database db = await DBHelper.database();
      final monitoring = currentMonitoring.value;

      if (monitoring.surveyorName == null || monitoring.surveyorName!.isEmpty) {
        return -1;
      }

      final dbMap = _convertModelToDbMap(monitoring);
      debugPrint("THE DATA TO INSERT FROM START :::::::::::::::: ${dbMap}");

      int monitoringId;

      // Check if this is an update to existing record
      if (monitoring.createdAt != null) {
        debugPrint("THE DATA TO INSERT CREATE AT :::::::::::::::: ${dbMap}");
        // Update existing record
        final existingRecords = await db.query(
          'seedling_monitorings',
          where: 'created_at = ?',
          whereArgs: [monitoring.createdAt!.toIso8601String()],
        );

        if (existingRecords.isNotEmpty) {
          debugPrint("THE DATA TO INSERT EXISTING :::::::::::::::: ${dbMap}");
          monitoringId = existingRecords.first['id'] as int;
          await db.update(
            'seedling_monitorings',
            dbMap,
            where: 'id = ?',
            whereArgs: [monitoringId],
          );

          // Delete existing species details
          await db.delete(
            'species_planting_details',
            where: 'monitoring_id = ?',
            whereArgs: [monitoringId],
          );
        } else {
          debugPrint("THE DATA TO INSERT :::::::::::::::: ${dbMap}");
          // Insert as new record
          monitoringId = await db.insert('seedling_monitorings', dbMap);
        }
      } else {
        debugPrint("THE DATA TO INSERT :::::::::::::::: ${dbMap}");
        // Insert new record
        monitoringId = await db.insert('seedling_monitorings', dbMap);
      }

      // Save species planting details
      for (final detail in monitoring.speciesPlantingDetails) {
        await db.insert('species_planting_details', {
          'monitoring_id': monitoringId,
          'species': detail.species,
          'quantity_received': detail.quantityReceived,
          'quantity_planted': detail.quantityPlanted,
          'date_of_planting': detail.dateOfPlanting,
        });
      }

      // Reload data to update the list
      await _loadSavedData();

      return monitoringId;
    } catch (e) {
      debugPrint('Error saving monitoring: $e');
      return -1;
    }
  }

  // Load a specific monitoring session
  Future<void> loadMonitoring(SeedlingMonitoringModel monitoring) async {
    currentMonitoring.value = monitoring;
  }

  // Delete a monitoring session
  Future<bool> deleteMonitoring(SeedlingMonitoringModel monitoring) async {
    try {
      final Database db = await DBHelper.database();

      if (monitoring.createdAt != null) {
        final result = await db.delete(
          'seedling_monitorings',
          where: 'created_at = ?',
          whereArgs: [monitoring.createdAt!.toIso8601String()],
        );

        if (result > 0) {
          await _loadSavedData();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting monitoring: $e');
      return false;
    }
  }

  // Submit monitoring data online
  Future<bool> submitOnline() async {
    try {
      // Validate data first
      final errors = currentMonitoring.value.validateAll();
      if (errors.isNotEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please fix all errors before submission:\n${errors.join('\n')}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Update status and save
      currentMonitoring.value = currentMonitoring.value.copyWith(
        submissionStatus: 'submitted',
        connectionStatus: 'connected',
      );

      final savedId = await saveCurrentMonitoring();

      if (savedId > 0) {
        // Here you would typically make your API call
        // For now, we'll just simulate success
        await _simulateApiCall();

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Online submission error: $e');
      return false;
    }
  }

  // Simulate API call - replace with your actual API integration
  Future<void> _simulateApiCall() async {
    await Future.delayed(const Duration(seconds: 2));
    // Add your actual API call logic here
    debugPrint('Simulating API call for monitoring data');
  }

  // Save offline
  Future<bool> saveOffline() async {
    try {
      final errors = currentMonitoring.value.validateAll();
      if (errors.isNotEmpty) {
        Get.snackbar(
          'Validation Warning',
          'Some fields are incomplete. Data will be saved as draft.\n${errors.join('\n')}',
          duration: Duration(seconds: 10),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

      currentMonitoring.value = currentMonitoring.value.copyWith(
        submissionStatus: 'draft',
        connectionStatus: 'not_connected',
      );

      final savedId = await saveCurrentMonitoring();
      return savedId > 0;
    } catch (e) {
      debugPrint('Offline save error: $e');
      return false;
    }
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    final submitted = savedMonitorings.where((m) => m.submissionStatus == 'submitted').length;
    final drafts = savedMonitorings.where((m) => m.submissionStatus == 'draft').length;
    final totalFarmers = savedMonitorings.map((m) => m.farmerName).toSet().length;

    return {
      'totalRecords': savedMonitorings.length,
      'submitted': submitted,
      'drafts': drafts,
      'totalFarmers': totalFarmers,
    };
  }

  // Export data for backup
  String exportData() {
    return json.encode({
      'exportedAt': DateTime.now().toIso8601String(),
      'records': savedMonitorings.map((m) => m.toJson()).toList(),
    });
  }

  // Get monitorings by status
  List<SeedlingMonitoringModel> getMonitoringsByStatus(String status) {
    return savedMonitorings.where((m) => m.submissionStatus == status).toList();
  }

  // Search monitorings by farmer name
  List<SeedlingMonitoringModel> searchByFarmerName(String query) {
    return savedMonitorings.where((m) =>
    m.farmerName?.toLowerCase().contains(query.toLowerCase()) == true
    ).toList();
  }

  // Get all monitoring data
  Future<List<SeedlingMonitoringModel>> getAllMonitorings() async {
    try {
      final Database db = await DBHelper.database();

      final List<Map<String, dynamic>> monitoringMaps = await db.query(
          'seedling_monitorings',
          orderBy: 'created_at DESC'
      );

      final List<SeedlingMonitoringModel> monitorings = [];

      for (final map in monitoringMaps) {
        final monitoring = await _getMonitoringWithDetails(map);
        monitorings.add(monitoring);
      }

      debugPrint("THE MONITORING :::::::::::::::::: ${monitorings.first.toJson()}");

      return monitorings;
    } catch (e) {
      debugPrint('Error getting all monitorings: $e');
      return [];
    }
  }

  // Get monitoring by ID
  Future<SeedlingMonitoringModel?> getMonitoringById(int id) async {
    try {
      final Database db = await DBHelper.database();

      final List<Map<String, dynamic>> monitoringMaps = await db.query(
        'seedling_monitorings',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (monitoringMaps.isEmpty) return null;

      return await _getMonitoringWithDetails(monitoringMaps.first);
    } catch (e) {
      debugPrint('Error getting monitoring by id: $e');
      return null;
    }
  }

  // Helper method to load monitoring with species details
  Future<SeedlingMonitoringModel> _getMonitoringWithDetails(Map<String, dynamic> map) async {
    final Database db = await DBHelper.database();

    // Load species planting details
    final List<Map<String, dynamic>> speciesMaps = await db.query(
      'species_planting_details',
      where: 'monitoring_id = ?',
      whereArgs: [map['id']],
    );

    final speciesDetails = speciesMaps.map((speciesMap) => SpeciesPlantingDetail(
      species: speciesMap['species'],
      quantityReceived: speciesMap['quantity_received'],
      quantityPlanted: speciesMap['quantity_planted'],
      dateOfPlanting: speciesMap['date_of_planting'],
    )).toList();

    final monitoring = SeedlingMonitoringModel.fromJson(_convertDbMapToJson(map));
    monitoring.speciesPlantingDetails = speciesDetails;

    return monitoring;
  }
}