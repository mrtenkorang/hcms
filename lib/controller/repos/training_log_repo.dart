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