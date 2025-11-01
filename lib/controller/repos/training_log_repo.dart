// repositories/training_log_repository.dart
import 'dart:convert';
import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;
import '../models/training_log_model.dart';

class TrainingLogRepository {
  final AppDatabaseHelper _dbHelper = AppDatabaseHelper();

  // Local Database Operations

  Future<int> createTrainingLog(TrainingLogModel trainingLog) async {
    return await _dbHelper.insertTrainingLog(trainingLog);
  }

  Future<List<TrainingLogModel>> getAllTrainingLogs() async {
    return await _dbHelper.getAllTrainingLogs();
  }

  Future<TrainingLogModel?> getTrainingLogById(int id) async {
    return await _dbHelper.getTrainingLogById(id);
  }

  Future<List<TrainingLogModel>> getUnsyncedTrainingLogs() async {
    return await _dbHelper.getUnsyncedTrainingLogs();
  }

  Future<int> updateTrainingLog(TrainingLogModel trainingLog) async {
    return await _dbHelper.updateTrainingLog(trainingLog);
  }

  Future<int> deleteTrainingLog(int id) async {
    return await _dbHelper.deleteTrainingLog(id);
  }

  Future<int> markAsSynced(int id) async {
    return await _dbHelper.markAsSynced(id);
  }

  Future<List<TrainingLogModel>> getTrainingLogsByEnumerator(int enumeratorId) async {
    return await _dbHelper.getTrainingLogsByEnumerator(enumeratorId);
  }

  Future<List<TrainingLogModel>> getTrainingLogsByCommunity(int communityId) async {
    return await _dbHelper.getTrainingLogsByCommunity(communityId);
  }

  Future<int> getTrainingLogsCount() async {
    return await _dbHelper.getTrainingLogsCount();
  }

  // API Operations

  Future<Map<String, dynamic>> syncTrainingLogToServer(TrainingLogModel trainingLog) async {
    try {
      // Parse participants JSON string to list
      final participantsList = json.decode(trainingLog.participants) as List;

      var trainingLogData = {
        "trainingDetails": {
          "communityName": trainingLog.communityId,
          "trainingTopic": trainingLog.trainingTopic,
          "dateEventBegan": trainingLog.eventDate,
          "eventDuration": trainingLog.eventDuration,
          "trainerName": trainingLog.trainerName,
          "trainerOrganisation": trainingLog.trainerOrganisation,
          "enumerator": trainingLog.enumeratorId
        },
        "participantDetails": participantsList
      };

      var response = await http.post(
        Uri.parse('$stageBaseUrl/trainingapi/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(trainingLogData),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        var status = result["status"];

        if (status == "done") {
          // Mark as synced in local database
          await _dbHelper.markAsSynced(trainingLog.id!);
          return {
            'success': true,
            'message': 'Data synced successfully',
            'data': result
          };
        } else if (status == "exist") {
          return {
            'success': false,
            'message': 'Data already exists on server',
            'data': result
          };
        } else {
          return {
            'success': false,
            'message': result["error"] ?? 'Unknown error occurred',
            'data': result
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': null
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
        'data': null
      };
    }
  }

  Future<void> syncAllUnsyncedTrainingLogs() async {
    final unsyncedLogs = await _dbHelper.getUnsyncedTrainingLogs();

    for (final log in unsyncedLogs) {
      final result = await syncTrainingLogToServer(log);
      if (result['success'] == true) {
        print('Training log ${log.id} synced successfully');
      } else {
        print('Failed to sync training log ${log.id}: ${result['message']}');
      }
    }
  }

  // Utility methods for participants

  String encodeParticipants(List<Map<String, dynamic>> participants) {
    return json.encode(participants);
  }

  List<TrainingParticipant> decodeParticipants(String participantsJson) {
    try {
      final List<dynamic> participantsList = json.decode(participantsJson);
      return participantsList.map((item) => TrainingParticipant.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Create training log from form data
  Future<TrainingLogModel> createTrainingLogFromFormData({
    required int communityId,
    required String communityName,
    required String trainingTopic,
    required String eventDate,
    required String eventDuration,
    required String trainerName,
    required String trainerOrganisation,
    required int enumeratorId,
    required bool isSynced,
    required List<Map<String, dynamic>> participants,
  }) async {
    final trainingLog = TrainingLogModel(
      communityId: communityId,
      communityName: communityName,
      trainingTopic: trainingTopic,
      eventDate: eventDate,
      eventDuration: eventDuration,
      trainerName: trainerName,
      trainerOrganisation: trainerOrganisation,
      enumeratorId: enumeratorId,
      isSynced: isSynced,
      participants: encodeParticipants(participants),
    );

    final id = await createTrainingLog(trainingLog);
    trainingLog.id = id;
    return trainingLog;
  }
}