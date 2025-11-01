import 'dart:convert';
import 'dart:io';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:http/http.dart' as http;

class DeforestationRepository {

  // Local database operations
  Future<int> saveReportLocally(DeforestationReportModel report) async {
    return await AppDatabaseHelper().insertReport(report);
  }

  Future<List<DeforestationReportModel>> getLocalReports() async {
    return await AppDatabaseHelper().getAllReports();
  }

  Future<List<DeforestationReportModel>> getPendingReports() async {
    return await AppDatabaseHelper().getPendingReports();
  }

  Future<int> updateLocalReport(DeforestationReportModel report) async {
    return await AppDatabaseHelper().updateReport(report);
  }

  Future<int> deleteLocalReport(int id) async {
    return await AppDatabaseHelper().deleteReport(id);
  }

  Future<int> markReportAsSubmitted(int id) async {
    return await AppDatabaseHelper().markAsSubmitted(id);
  }



  Future<Map<String, dynamic>> submitPendingReports() async {
    try {
      final pendingReports = await getPendingReports();
      int successfulSubmissions = 0;
      List<String> errors = [];

      for (final report in pendingReports) {
        final result = await APIMethods().submitDeforestationReportToServer(report);
        if (result['success'] == true) {
          await markReportAsSubmitted(report.id!);
          successfulSubmissions++;
        } else {
          errors.add('Report ${report.id}: ${result['error']}');
        }
      }

      return {
        'success': successfulSubmissions > 0,
        'submitted': successfulSubmissions,
        'total': pendingReports.length,
        'errors': errors,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to submit pending reports: $e',
      };
    }
  }
}