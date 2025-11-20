import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/models/seedling_monitoring_model.dart';
import 'package:hcms_revived2/controller/repos/seedling_monitoring_reepo.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';

class SeedlingMonitoringHistoryController extends GetxController {
  final SeedlingMonitoringRepository _repository =
      SeedlingMonitoringRepository();

  final RxList<SeedlingMonitoringModel> allMonitorings =
      <SeedlingMonitoringModel>[].obs;
  final RxList<SeedlingMonitoringModel> pendingMonitorings =
      <SeedlingMonitoringModel>[].obs;
  final RxList<SeedlingMonitoringModel> submittedMonitorings =
      <SeedlingMonitoringModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMonitorings();
  }

  Polygon? polygon;

  Future<void> loadMonitorings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final monitorings = await _repository.getAll();

      for (final monitoring in monitorings) {
        debugPrint("Monitoring: ${monitoring.customCommunityName}");
      }

      allMonitorings.assignAll(monitorings);

      // Separate monitorings by status
      pendingMonitorings.assignAll(
        monitorings
            .where((m) => m.connectionStatus == 'not connected')
            .toList(),
      );

      submittedMonitorings.assignAll(
        monitorings.where((m) => m.connectionStatus == 'connected').toList(),
      );
    } catch (e) {
      errorMessage.value = 'Failed to load monitorings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMonitorings() async {
    await loadMonitorings();
  }

  String? _getPolygonAsGeoJson() {
    if (polygon == null) return null;
    try {
      final coordinates = polygon!.points
          .map((point) => [point.longitude, point.latitude])
          .toList();

      if (coordinates.isNotEmpty && coordinates.first != coordinates.last) {
        coordinates.add(coordinates.first);
      }

      final geoJson = {
        "type": "Polygon",
        "coordinates": [coordinates],
      };

      return json.encode(geoJson);
    } catch (e) {
      debugPrint('Error converting polygon to GeoJSON: $e');
      return null;
    }
  }

  Future<void> syncAllPendingMonitorings(BuildContext context) async {
    try {
      isSyncing.value = true;
      errorMessage.value = '';

      final pending = pendingMonitorings.toList();

      if (pending.isEmpty) {
        Globals().showSnackBar(
          title: "No Pending Data",
          message: "There are no pending monitorings to sync.",
          backgroundColor: Colors.red,
        );
        return;
      }

      Globals().startWait(context);
      int successCount = 0;

      for (final monitoring in List.from(pending)) {
        debugPrint('Submitting monitoring ${monitoring.toApiJson()}');

        if (monitoring.mappedFarmBoundaries != null &&
            monitoring.mappedFarmBoundaries!.isNotEmpty) {
          try {
            final polygonData = json.decode(monitoring.mappedFarmBoundaries!);
            if (polygonData is Map && polygonData['points'] is List) {
              final points = (polygonData['points'] as List).map<LatLng>((
                point,
              ) {
                return LatLng(
                  point['latitude'] is num ? point['latitude'].toDouble() : 0.0,
                  point['longitude'] is num
                      ? point['longitude'].toDouble()
                      : 0.0,
                );
              }).toList();

              polygon = Polygon(
                polygonId: const PolygonId('farm_polygon'),
                points: points,
                strokeWidth: polygonData['strokeWidth'] is num
                    ? polygonData['strokeWidth'].toInt()
                    : 2,
                strokeColor: polygonData['strokeColor'] is int
                    ? Color(polygonData['strokeColor'])
                    : const Color(0xFF00FF00).withOpacity(0.5),
                fillColor: polygonData['fillColor'] is int
                    ? Color(polygonData['fillColor']).withOpacity(0.2)
                    : const Color(0xFF00FF00).withOpacity(0.2),
              );
            }
          } catch (e) {
            debugPrint('Error initializing polygon: $e');
          }
        }

        final Map<String, dynamic> data = monitoring.toApiJson();
        data['farm_boundary'] = _getPolygonAsGeoJson();
        data["name_of_community"] = monitoring.customCommunityName;


        debugPrint('API Data :::::::::::::;;;;;;: $data');

        try {
          final result = await APIMethods().submitSeedlingMonitoringToServer(
            data,
          );

          debugPrint('Result: ${result.toString()}');

          if (result['success'] == true) {
            // Update the connection status locally
            monitoring.connectionStatus = 'connected';
            await _repository.update(monitoring);
            successCount++;
          } else {
            debugPrint(
              'Failed to submit monitoring ${monitoring.id}: ${result['error']}',
            );
          }
        } catch (e) {
          debugPrint('Error submitting monitoring ${monitoring.id}: $e');
        }
      }

      Globals().endWait(context);

      // Refresh the data
      await loadMonitorings();

      // Show result message
      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          'Successfully synced $successCount out of ${pending.length} pending monitorings.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      } else {
        debugPrint("SUCCESS COUNT IS $successCount");
        Get.snackbar(
          'Sync Failed',
          'Failed to sync any monitorings, please try again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
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
  bool get hasPendingMonitorings => pendingMonitorings.isNotEmpty;
  bool get hasSubmittedMonitorings => submittedMonitorings.isNotEmpty;

  List<SeedlingMonitoringModel> get currentTabMonitorings =>
      currentTabIndex.value == 0 ? submittedMonitorings : pendingMonitorings;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
