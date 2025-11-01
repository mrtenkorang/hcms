import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/constants/urls.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';
import 'package:hcms_revived2/controller/models/seedling_monitoring_model.dart';
import 'package:hcms_revived2/controller/models/training_log_model.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:http/http.dart' as http;

class APIMethods {
  // Submit seedling monitoring
  Future<Map<String, dynamic>> submitSeedlingMonitoringToServer(
    SeedlingMonitoringModel seedlingMonitoring,
  ) async {
    try {
      final url = '${URLS.baseUrl}${URLS.seedlingMonitoringURL}';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(seedlingMonitoring.toApiJson()),
      );

      debugPrint("THE RESPONSE :::::::::::: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Seedling monitoring submitted successfully',
        };
      } else {
        debugPrint("THE RESPONSE :::::::::::: ${response.body}");
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } on SocketException {
      debugPrint("THE ERROR :::::::::::: No internet connection");
      return {'success': false, 'error': 'No internet connection'};
    } catch (e, stackTrace) {
      debugPrint("THE ERROR :::::::::::: $e");
      debugPrint("THE STACKTRACE :::::::::::: $stackTrace");
      return {
        'success': false,
        'error': 'Failed to submit seedling monitoring',
      };
    }
  }

  Future<Map<String, dynamic>> submitTrainingLogToServer(
    Map<String, dynamic> trainingLog,
  ) async {
    try {
      final url = '${URLS.baseUrl}${URLS.trainingLogURL}';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(trainingLog),
      );



      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Training log submitted successfully',
        };
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } on SocketException {
      debugPrint("THE ERROR :::::::::::: No internet connection");
      return {'success': false, 'error': 'No internet connection'};
    } catch (e, stackTrace) {
      debugPrint("THE ERROR :::::::::::: $e");
      debugPrint("THE STACKTRACE :::::::::::: $stackTrace");
      return {'success': false, 'error': 'Failed to submit training log'};
    }
  }

  // API operations
  Future<Map<String, dynamic>> submitDeforestationReportToServer(
    DeforestationReportModel report,
  ) async {
    final reportMap = report.toApiMap();
    debugPrint("THE REPORTTTTTTTTTTTTTTTTT :::::::::::: $reportMap");

    try {
      final url = '${URLS.baseUrl}${URLS.deforestationReportURL}';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(report.toApiMap()),
      );

      debugPrint("THE RESPONSE :::::::::::: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Report submitted successfully',
        };
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } on SocketException {
      debugPrint("THE ERROR :::::::::::: No internet connection");
      return {'success': false, 'error': 'No internet connection'};
    } catch (e, stackTrace) {
      debugPrint("THE ERROR :::::::::::: $e");
      debugPrint("THE STACKTRACE :::::::::::: $stackTrace");
      return {'success': false, 'error': 'Failed to submit report: $e'};
    }
  }

  static Future<Map<String, dynamic>> submitFarmer(
    FarmerBiodataModel farmer,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(URLS.baseUrl + URLS.farmerRegistrationURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(farmer.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Farmer submitted successfully',
        };
      } else {
        debugPrint("FALED ERRORROR :::::::::: ${response.body}");
        return {
          'success': false,
          'error': 'Failed to submit farmer: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e, stackTrace) {
      debugPrint("THE ERRRROOORRRR ::::::::;;;;;; $e");
      debugPrint("THE ERRRROOORRRR ::::::::;;;;;; $stackTrace");
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // login
  static Future<Map<String, dynamic>> login(
    String contact,
    String password,
  ) async {
    try {
      // Convert to JSON
      final jsonData = {'contact_number': contact, 'password': password};

      // Make POST request
      final response = await http.post(
        Uri.parse(URLS.baseUrl + URLS.loginURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        debugPrint("THE LOGIN RES ::::::::::::; $responseData");

        final user = UserModel.fromJson(responseData["data"]);

        // Cache user data
        final cacheService = await CacheService.getInstance();
        await cacheService.saveUserInfo(user);

        // save login status
        await cacheService.saveLoginStatus(true);

        return {
          'success': true,
          'data': responseData,
          'message': 'Login successful',
        };
      } else {
        debugPrint("Login failed with status code: ${response.body}");
        return {
          'success': false,
          'error': 'Failed to login: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e, stackTrace) {
      debugPrint("Login failed with error: $e\nStack trace: $stackTrace");
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Submit tree registration to server
  static Future<Map<String, dynamic>> submitTreeRegistration(
    TreeRegistrationModel registration,
  ) async {
    try {
      // Convert to JSON
      final jsonData = registration.toJson();

      // Make POST request
      final response = await http.post(
        Uri.parse(URLS.baseUrl + URLS.treeRegistrationURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Tree registration submitted successfully',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to submit: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}
