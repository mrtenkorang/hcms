import 'dart:io';

import 'package:flutter/material.dart' show debugPrint;
import 'package:hcms_revived2/controller/constants/urls.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'dart:convert';
import 'package:hcms_revived2/controller/models/district_region_model.dart';
import 'package:hcms_revived2/controller/models/establishment_type_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/mmda_model.dart';
import 'package:hcms_revived2/controller/models/ta_stool_skin_family%20model.dart';
import 'package:hcms_revived2/controller/repos/community_repo.dart';
import 'package:hcms_revived2/controller/repos/dsitrict_region_repos.dart';
import 'package:hcms_revived2/controller/repos/establishment_repo.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/controller/repos/mmda_repo.dart';
import 'package:hcms_revived2/controller/repos/ta_stool_skin_family_repo.dart';
import 'package:http/http.dart' as http;
import 'package:hcms_revived2/services/serverurls.dart';

class InitMethods {
  final DistrictRepository _regionDistrictRepo =
  DistrictRepository();

  // Fetch districts and regions from API and store in database
  Future<bool> fetchDistrictAndRegion() async {
    try {
      debugPrint('Fetching districts and regions from API...');
      final String url = URLS.baseUrl + URLS.regionDistrictURL;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> responseData = data is List ? data : (data['data'] as List? ?? []);

        debugPrint('Received ${responseData.length} regions with districts');

        // Convert JSON data to DistrictModel list
        final List<DistrictModel> districts = [];

        for (var item in responseData) {
          try {
            final region = item['region'] as Map<String, dynamic>;
            final district = item['district'] as Map<String, dynamic>;

            final districtModel = DistrictModel(
              id: item['id'] ?? 0,
              regionName: (region['name'] as String?)?.trim() ?? '',
              districtName: (district['name'] as String?)?.trim() ?? 'Unknown District',
              districtId: (district['id'] as int?) ?? 0,
              regionId: (region['id'] as int?)?.toString() ?? '0',
            );

            districts.add(districtModel);
          } catch (e) {
            debugPrint('Error parsing district item: $e');
            debugPrint('Problematic item: $item');
          }
        }

        // Clear existing data and insert new data
        await _regionDistrictRepo.clearAllDistricts();
        if (districts.isNotEmpty) {
          await _regionDistrictRepo.createDistricts(districts);
        }

        debugPrint(
          'Successfully stored ${districts.length} districts with regions',
        );
        return true;
      } else {
        debugPrint('API request failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching districts and regions: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  final TaStoolSkinFamilyRepo _typeRepo = TaStoolSkinFamilyRepo();

  Future<bool> fetchTypes() async {
    try {
      final response = await http.get(
        Uri.parse('${URLS.baseUrl}${URLS.taStoolUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> responseData = data is List ? data : (data['data'] as List? ?? []);
        final List<TAStoolSkinFamilyModel> types = responseData
            .map<TAStoolSkinFamilyModel>((item) => TAStoolSkinFamilyModel.fromJson(item as Map<String, dynamic>))
            .toList();

        await _typeRepo.deleteAllTypes();
        await _typeRepo.bulkInsertTypes(types);

        debugPrint('Successfully stored ${types.length} types');
        return true;
      } else {
        debugPrint('Types API failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching types: $e');
      debugPrint('Error fetching types: $stackTrace');
      return false;
    }
  }

  Future<bool> fetchMMDA() async {
    try {
      final response = await http.get(
        Uri.parse('${URLS.baseUrl}${URLS.mmdaUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> responseData = data is List ? data : (data['data'] as List? ?? []);
        final List<MMDAModel> types = responseData
            .map<MMDAModel>((item) => MMDAModel.fromJson(item as Map<String, dynamic>))
            .toList();

        await MMDARepository().deleteAllMMDAs();
        await  MMDARepository().bulkInsertMMDAs(types);

        debugPrint('Successfully stored ${types.length} mmdas');
        return true;
      } else {
        debugPrint('Types API failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching types: $e');
      debugPrint('Error fetching types: $stackTrace');
      return false;
    }
  }

  final CommunityRepository _communityRepo = CommunityRepository();

  Future<bool> fetchCommunities() async {
    try {
      final response = await http.get(
        Uri.parse('${URLS.baseUrl}${URLS.communityUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> responseData = data is List ? data : (data['data'] as List? ?? []);
        final List<CommunityModel> communities = responseData
            .map<CommunityModel>((item) => CommunityModel.fromJson(item as Map<String, dynamic>))
            .toList();

        await _communityRepo.deleteAllCommunities();
        await _communityRepo.bulkInsertCommunities(communities);

        debugPrint('Successfully stored ${communities.length} communities');
        return true;
      } else {
        debugPrint(
          'Communities API failed with status: ${response.statusCode}',
        );
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching communities: $e');
      debugPrint('Error fetching communities: $stackTrace');
      return false;
    }
  }

  Future<void> fetAllFarmers() async {
    try {
      String? nextUrl = '${URLS.baseUrl}${URLS.farmersFromServerUrl}';
      int totalFarmers = 0;
      int page = 1;
      final List<FarmerFromServerModel> allFarmers = [];

      // Delete existing farmers before starting sync
      await FarmerFromServerRepository().deleteAllFarmersFromServer();

      while (nextUrl != null && nextUrl.isNotEmpty) {
        debugPrint('Fetching page $page: $nextUrl');
        
        final response = await http.get(
          Uri.parse(nextUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          
          // Extract data based on response structure
          List<dynamic> data = [];
          
          if (responseData is List) {
            data = responseData;
          } else if (responseData is Map) {
            // Handle pagination - get next URL if available
            nextUrl = responseData['next']?.toString();
            
            if (responseData.containsKey('results') && 
                responseData['results'] is Map &&
                responseData['results'].containsKey('data')) {
              // Handle nested structure: {results: {status: bool, msg: string, data: [...]}}
              data = responseData['results']['data'] as List<dynamic>? ?? [];
            } else if (responseData.containsKey('results') && 
                      responseData['results'] is List) {
              // Handle structure: {results: [...]}
              data = responseData['results'] as List<dynamic>;
            } else if (responseData.containsKey('data')) {
              // Handle structure: {data: [...]}
              data = responseData['data'] as List<dynamic>? ?? [];
            }
          }

          if (data.isNotEmpty) {
            final List<FarmerFromServerModel> pageFarmers = data
                .where((item) => item is Map<String, dynamic>)
                .map<FarmerFromServerModel>((item) => FarmerFromServerModel.fromMap(item as Map<String, dynamic>))
                .toList();

            debugPrint("THE FARMER :: ${pageFarmers.first.toMap()}");
            
            allFarmers.addAll(pageFarmers);
            totalFarmers += pageFarmers.length;
            debugPrint('Fetched ${pageFarmers.length} farmers from page $page');


            // await FarmerFromServerRepository().deleteAllFarmersFromServer();
            // Insert in batches to avoid memory issues
            await FarmerFromServerRepository().bulkInsertFarmers(pageFarmers);
          }
          
          page++;
          
        } else {
          debugPrint('Failed to fetch page $page. Status code: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
          break;
        }
      }

      debugPrint('Successfully fetched and stored $totalFarmers farmers in total');
      return;
      
    } on SocketException {
      debugPrint("Network error: No internet connection");
      rethrow; // Re-throw to allow the caller to handle the error
    } on http.ClientException catch (e) {
      debugPrint("HTTP client error: ${e.message}");
      rethrow;
    } catch (e, stackTrace) {
      debugPrint("Error in fetAllFarmers: $e");
      debugPrint("Stack trace: $stackTrace");
      rethrow;
    }
  }

  final EstaTypeRepository _estaTypeRepo = EstaTypeRepository();

  Future<bool> fetchEstaTypes() async {
    try {
      final response = await http.get(
        Uri.parse('$stageBaseUrl/esta_types/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final estaTypes = data
            .map((item) => EstaTypeModel.fromJson(item))
            .toList();

        await _estaTypeRepo.deleteAllEstaTypes();
        await _estaTypeRepo.bulkInsertEstaTypes(estaTypes);

        debugPrint('Successfully stored ${estaTypes.length} esta_types');
        return true;
      } else {
        debugPrint('EstaTypes API failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error fetching esta_types: $e');
      return false;
    }
  }

  /// Check the current app version against the server
  /// Returns a map containing version check status and data
  Future<bool> checkAppVersion() async {
    // final data = {
    //   "version": const String.fromEnvironment('VERSION_NAME', defaultValue: '1.0.0'),
    // };

    final data = {"version": URLS.buildNumber};

    try {
      debugPrint("Checking app version with data: $data");

      final response = await http.post(
        Uri.parse('${URLS.baseUrl}${URLS.checkAppVersionURL}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      debugPrint("Version check response: $response");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["status"]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error in checkAppVersion: $e");
      // On error, continue with sync
      return false;
    }
  }
}
