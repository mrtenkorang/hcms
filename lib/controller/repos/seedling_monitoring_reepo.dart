// seedling_monitoring_repository.dart

import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';

class SeedlingMonitoringRepository {
  final AppDatabaseHelper _database = AppDatabaseHelper();

  // CREATE operations
  Future<int> create(SeedlingMonitoringModel model) async {
    try {
      return await _database.insertSeedlingMonitoring(model);
    } catch (e) {
      throw Exception('Failed to create seedling monitoring record: $e');
    }
  }

  Future<void> createMultiple(List<SeedlingMonitoringModel> models) async {
    try {
      await _database.bulkInsertSeedlingMonitoring(models);
    } catch (e) {
      throw Exception('Failed to create multiple seedling monitoring records: $e');
    }
  }

  // READ operations
  Future<List<SeedlingMonitoringModel>> getAll() async {
    try {
      return await _database.getAllSeedlingMonitoring();
    } catch (e) {
      throw Exception('Failed to get all seedling monitoring records: $e');
    }
  }

  Future<SeedlingMonitoringModel?> getById(int id) async {
    try {
      return await _database.getSeedlingMonitoringById(id);
    } catch (e) {
      throw Exception('Failed to get seedling monitoring record by ID: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getByStatus(String status) async {
    try {
      return await _database.getSeedlingMonitoringByStatus(status);
    } catch (e) {
      throw Exception('Failed to get seedling monitoring records by status: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getDrafts() async {
    try {
      return await _database.getSeedlingMonitoringByStatus('draft');
    } catch (e) {
      throw Exception('Failed to get draft seedling monitoring records: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getSubmitted() async {
    try {
      return await _database.getSeedlingMonitoringByStatus('submitted');
    } catch (e) {
      throw Exception('Failed to get submitted seedling monitoring records: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getUnsynced() async {
    try {
      return await _database.getUnsyncedSeedlingMonitoring();
    } catch (e) {
      throw Exception('Failed to get unsynced seedling monitoring records: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> search(String query) async {
    try {
      return await _database.searchSeedlingMonitoring(query);
    } catch (e) {
      throw Exception('Failed to search seedling monitoring records: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getByFarmerName(String farmerName) async {
    try {
      return await _database.searchSeedlingMonitoring(farmerName);
    } catch (e) {
      throw Exception('Failed to get seedling monitoring records by farmer name: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getByCommunity(String community) async {
    try {
      return await _database.searchSeedlingMonitoring(community);
    } catch (e) {
      throw Exception('Failed to get seedling monitoring records by community: $e');
    }
  }

  Future<List<SeedlingMonitoringModel>> getBySurveyor(String surveyorName) async {
    try {
      return await _database.searchSeedlingMonitoring(surveyorName);
    } catch (e) {
      throw Exception('Failed to get seedling monitoring records by surveyor: $e');
    }
  }

  // UPDATE operations
  Future<int> update(SeedlingMonitoringModel model) async {
    try {
      if (model.id == null) {
        throw Exception('Cannot update record without ID');
      }
      return await _database.updateSeedlingMonitoring(model);
    } catch (e) {
      throw Exception('Failed to update seedling monitoring record: $e');
    }
  }

  Future<int> updateFields({
    required int id,
    required Map<String, dynamic> fields,
  }) async {
    try {
      return await _database.updateSeedlingMonitoringFields(
        id: id,
        fields: fields,
      );
    } catch (e) {
      throw Exception('Failed to update seedling monitoring record fields: $e');
    }
  }

  Future<int> markAsSubmitted(int id) async {
    try {
      return await _database.markSeedlingMonitoringAsSubmitted(id);
    } catch (e) {
      throw Exception('Failed to mark seedling monitoring record as submitted: $e');
    }
  }

  Future<int> markAsDraft(int id) async {
    try {
      return await _database.markAsDraft(id);
    } catch (e) {
      throw Exception('Failed to mark seedling monitoring record as draft: $e');
    }
  }

  Future<int> updateConnectionStatus(int id, String status) async {
    try {
      return await _database.updateSeedlingMonitoringFields(
        id: id,
        fields: {'connection_status': status},
      );
    } catch (e) {
      throw Exception('Failed to update connection status: $e');
    }
  }

  Future<int> updateSubmissionStatus(int id, String status) async {
    try {
      return await _database.updateSeedlingMonitoringFields(
        id: id,
        fields: {'submission_status': status},
      );
    } catch (e) {
      throw Exception('Failed to update submission status: $e');
    }
  }

  // DELETE operations
  Future<int> delete(int id) async {
    try {
      return await _database.deleteSeedlingMonitoring(id);
    } catch (e) {
      throw Exception('Failed to delete seedling monitoring record: $e');
    }
  }

  Future<int> deleteMultiple(List<int> ids) async {
    try {
      int deletedCount = 0;
      for (final id in ids) {
        final result = await _database.deleteSeedlingMonitoring(id);
        if (result > 0) deletedCount++;
      }
      return deletedCount;
    } catch (e) {
      throw Exception('Failed to delete multiple seedling monitoring records: $e');
    }
  }

  Future<int> deleteAll() async {
    try {
      return await _database.deleteAllSeedlingMonitoring();
    } catch (e) {
      throw Exception('Failed to delete all seedling monitoring records: $e');
    }
  }

  Future<int> deleteByStatus(String status) async {
    try {
      final records = await _database.getSeedlingMonitoringByStatus(status);
      final ids = records.where((record) => record.id != null).map((record) => record.id!).toList();
      return await deleteMultiple(ids);
    } catch (e) {
      throw Exception('Failed to delete seedling monitoring records by status: $e');
    }
  }

  // COUNT operations
  Future<int> count() async {
    try {
      return await _database.getSeedlingMonitoringCount();
    } catch (e) {
      throw Exception('Failed to count seedling monitoring records: $e');
    }
  }

  Future<int> countByStatus(String status) async {
    try {
      return await _database.getSeedlingMonitoringCountByStatus(status);
    } catch (e) {
      throw Exception('Failed to count seedling monitoring records by status: $e');
    }
  }

  Future<int> countDrafts() async {
    try {
      return await _database.getSeedlingMonitoringCountByStatus('draft');
    } catch (e) {
      throw Exception('Failed to count draft seedling monitoring records: $e');
    }
  }

  Future<int> countSubmitted() async {
    try {
      return await _database.getSeedlingMonitoringCountByStatus('submitted');
    } catch (e) {
      throw Exception('Failed to count submitted seedling monitoring records: $e');
    }
  }

  Future<int> countUnsynced() async {
    try {
      final unsynced = await _database.getUnsyncedSeedlingMonitoring();
      return unsynced.length;
    } catch (e) {
      throw Exception('Failed to count unsynced seedling monitoring records: $e');
    }
  }

  // VALIDATION operations
  Future<List<String>> validateRecord(int id) async {
    try {
      final record = await _database.getSeedlingMonitoringById(id);
      if (record == null) {
        throw Exception('Record not found');
      }
      return record.validateAll();
    } catch (e) {
      throw Exception('Failed to validate seedling monitoring record: $e');
    }
  }

  Future<bool> isRecordComplete(int id) async {
    try {
      final record = await _database.getSeedlingMonitoringById(id);
      if (record == null) {
        throw Exception('Record not found');
      }
      return record.isComplete;
    } catch (e) {
      throw Exception('Failed to check if seedling monitoring record is complete: $e');
    }
  }

  // SYNC operations
  Future<List<SeedlingMonitoringModel>> getRecordsForSync() async {
    try {
      return await _database.getUnsyncedSeedlingMonitoring();
    } catch (e) {
      throw Exception('Failed to get records for sync: $e');
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _database.updateSeedlingMonitoringFields(
        id: id,
        fields: {
          'submission_status': 'submitted',
          'connection_status': 'connected',
        },
      );
    } catch (e) {
      throw Exception('Failed to mark record as synced: $e');
    }
  }

  Future<void> markMultipleAsSynced(List<int> ids) async {
    try {
      for (final id in ids) {
        await markAsSynced(id);
      }
    } catch (e) {
      throw Exception('Failed to mark multiple records as synced: $e');
    }
  }

  // TREE operations
  Future<int> addTreeToRecord(int recordId, Map<String, dynamic> tree) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      record.addTree(tree);
      return await _database.updateSeedlingMonitoring(record);
    } catch (e) {
      throw Exception('Failed to add tree to record: $e');
    }
  }

  Future<int> removeTreeFromRecord(int recordId, int treeIndex) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      record.removeTree(treeIndex);
      return await _database.updateSeedlingMonitoring(record);
    } catch (e) {
      throw Exception('Failed to remove tree from record: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTreesForRecord(int recordId) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      return record.treeData;
    } catch (e) {
      throw Exception('Failed to get trees for record: $e');
    }
  }

  Future<int> getTreeCountForRecord(int recordId) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      return record.treeCount;
    } catch (e) {
      throw Exception('Failed to get tree count for record: $e');
    }
  }

  // SPECIES operations
  Future<int> addSpeciesPlantingDetail(int recordId, SpeciesPlantingDetail detail) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      final updatedDetails = List<SpeciesPlantingDetail>.from(record.speciesPlantingDetails);
      updatedDetails.add(detail);

      return await _database.updateSeedlingMonitoringFields(
        id: recordId,
        fields: {
          'species_planting_details': updatedDetails.map((d) => d.toJson()).toList(),
        },
      );
    } catch (e) {
      throw Exception('Failed to add species planting detail: $e');
    }
  }

  Future<int> updateSpeciesPlantingDetail(int recordId, int detailIndex, SpeciesPlantingDetail detail) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      final updatedDetails = List<SpeciesPlantingDetail>.from(record.speciesPlantingDetails);
      if (detailIndex >= 0 && detailIndex < updatedDetails.length) {
        updatedDetails[detailIndex] = detail;

        return await _database.updateSeedlingMonitoringFields(
          id: recordId,
          fields: {
            'species_planting_details': updatedDetails.map((d) => d.toJson()).toList(),
          },
        );
      } else {
        throw Exception('Invalid detail index');
      }
    } catch (e) {
      throw Exception('Failed to update species planting detail: $e');
    }
  }

  Future<int> removeSpeciesPlantingDetail(int recordId, int detailIndex) async {
    try {
      final record = await _database.getSeedlingMonitoringById(recordId);
      if (record == null) {
        throw Exception('Record not found');
      }

      final updatedDetails = List<SpeciesPlantingDetail>.from(record.speciesPlantingDetails);
      if (detailIndex >= 0 && detailIndex < updatedDetails.length) {
        updatedDetails.removeAt(detailIndex);

        return await _database.updateSeedlingMonitoringFields(
          id: recordId,
          fields: {
            'species_planting_details': updatedDetails.map((d) => d.toJson()).toList(),
          },
        );
      } else {
        throw Exception('Invalid detail index');
      }
    } catch (e) {
      throw Exception('Failed to remove species planting detail: $e');
    }
  }

  // Cleanup
  Future<void> close() async {
    try {
      await _database.close();
    } catch (e) {
      throw Exception('Failed to close database: $e');
    }
  }

}