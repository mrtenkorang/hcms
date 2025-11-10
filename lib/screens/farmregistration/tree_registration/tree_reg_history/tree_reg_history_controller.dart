import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/controller/repos/tree_reg_repo.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:intl/intl.dart';

class TreeRegHistoryController extends GetxController {
  BuildContext? treeRegHistoryScreenContext;

  final RxList<TreeRegistrationModel> _allTreeData =
      <TreeRegistrationModel>[].obs;
  final RxInt _selectedTabIndex = 0.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isSyncing = false.obs;

  bool get isSyncing => _isSyncing.value;

  List<TreeRegistrationModel> get allTreeData => _allTreeData;
  List<TreeRegistrationModel> get syncedData =>
      _allTreeData.where((item) => item.isSynced == 1).toList();
  List<TreeRegistrationModel> get unsyncedData =>
      _allTreeData.where((item) => item.isSynced != 1).toList();
  int get selectedTabIndex => _selectedTabIndex.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadTreeData();
  }

  Future<List<TreeRegistrationModel>> loadTreeData() async {
    try {
      _isLoading.value = true;
      _allTreeData.value = await TreeRegistrationRepository()
          .getAllTreeRegistrations();
      return _allTreeData;
    } catch (e) {
      print('Error loading tree data: $e');
      return [];
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> syncAllPendingTrees(BuildContext context) async {
    try {
      final cache = await CacheService.getInstance();
      final user = await cache.getUserInfo();
      _isSyncing.value = true;
      final unsynced = unsyncedData;

      debugPrint('Number of unsynced trees: ${unsynced.first.toJson()}');

      if (unsynced.isEmpty) {
        Globals().showSnackBar(
          title: "No Pending Data",
          message: "There are no pending tree registrations to sync.",
          backgroundColor: Colors.red,
        );
        return;
      }

      Globals().startWait(context);
      int successCount = 0;
      final repo = TreeRegistrationRepository();

      Map<String, dynamic> submissionMap = {};

      for (var tree in unsynced) {
        submissionMap.clear();
        try {
          if (tree.farmerId.toString().isNotEmpty) {
            submissionMap = {
              "beneficiaryDetails": {
                "beneficiaryType": "Individual",
                "farmerbiodata_id": tree.farmerId.toString(),
                "firstName": "",
                "surname": "",
                "otherNames": "",
                "gender": "",
                "dateOfBirth": DateFormat('yyyy-MM-dd').format(
                  DateTime.tryParse(tree.nextOfKinDoB.toString()) ??
                      DateTime.now(),
                ),

                "address": "",
                "phoneNumber": "",
                "email": "",
                "enumerator": user!.id,
                "passportImageBase64String": "",
                "nextOfKin": {
                  "name": tree.nextOfKinName,
                  "phoneNumber": tree.nextOfKinPhoneNumber,
                  "relationship": tree.farmerRelationshipWithNextOfKin,
                  "gender": tree.nextOfKinGender,
                  "address": tree.nextOfKinPostalAddress,
                  "dateOfBirth": DateFormat('yyyy-MM-dd').format(
                    DateTime.tryParse(tree.nextOfKinDoB.toString()) ??
                        DateTime.now(),
                  ),
                },
              },
              "location": {
                "forestDistrict": "",
                "family": "",
                "mmdas": tree.districtId,
                "community": tree.communityId,
              },
              "treeFarmInformationArray": [
                {
                  "typeOfEstablishments": tree.establishmentType,
                  // create a list of objects with the lat and long of each tree
                  "farmInformationArray": tree.farmBoundaryPolygon,
                  // create a list of objects with the tree information
                  "treeInformationOption1Array": tree.trees
                      .map(
                        (e) => {
                          {
                            "numberOfTrees": tree.trees.length,
                            "plantingDistance": 3,
                            "yearOfEstablishment": e["yo_establishment"],
                            // "treeSize": e["size"],
                          },
                        },
                      )
                      .toList(),
                },
              ],
            };
          } else {
            submissionMap = {
              "beneficiaryDetails": {
                "beneficiaryType": "Group",
                "groupName": tree.groupName,
                "groupPresident": tree.groupPresident,
                "groupSecretary": tree.groupSecretary,
                "companyDirectors": tree.companyDirectors,
                "phoneNumber": tree.groupPhoneNumber,
                "enumerator": user!.id,
                "passportImageBase64String": "",
              },
              "location": {
                "forestDistrict": "",
                "family": "Akan",
                "mmdas": tree.districtId,
                "community": tree.communityId,
              },

              "treeFarmInformationArray": [
                {
                  "typeOfEstablishments": tree.establishmentType,
                  //
                  "farmInformationArray": tree.farmBoundaryPolygon,
                  // create a list of objects with the tree information
                  "treeInformationOption1Array": tree.trees
                      .map(
                        (e) => {
                          {
                            "speciesPlanted": e["species"],
                            "numberOfTrees": tree.trees.length,
                            "plantingDistance": 3,
                            "yearOfEstablishment": e["yo_establishment"],
                            // "treeSize": e["size"],
                          },
                        },
                      )
                      .toList(),
                },
              ],
            };
          }

          debugPrint('Submission Map ::::::::::::::::::::: ${submissionMap.toString()}');


          final result = await APIMethods.submitTreeRegistration(submissionMap);

          if (result['success'] == true) {
            // Update the sync status locally
            tree.isSynced = 1;
            await repo.updateTreeRegistration(tree);
            successCount++;
          }
        } catch (e) {
          Globals().endWait(context);
          debugPrint('Error syncing tree registration ${tree.id}: $e');
        }
      }

      Globals().endWait(context);

      // Refresh the data
      await loadTreeData();

      // Show result message
      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          'Successfully synced $successCount out of ${unsynced.length} pending tree registrations.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Sync Failed',
          'Failed to sync any tree registrations. Please check your connection and try again.',
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
      _isSyncing.value = false;
    }
  }

  // Helper methods to filter data
  List<TreeRegistrationModel> getUnsyncedData(
    List<TreeRegistrationModel> allData,
  ) {
    return allData.where((registration) => registration.isSynced == 0).toList();
  }

  List<TreeRegistrationModel> getSyncedData(
    List<TreeRegistrationModel> allData,
  ) {
    return allData.where((registration) => registration.isSynced == 1).toList();
  }

  void changeTab(int index) {
    _selectedTabIndex.value = index;
  }

  Future<void> deleteRegistration(TreeRegistrationModel registration) async {
    if (registration.id != null) {
      await TreeRegistrationRepository().deleteTreeRegistration(
        registration.id!,
      );
      await loadTreeData(); // Refresh the list
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String getTreeCountText(TreeRegistrationModel registration) {
    final count = registration.trees.length;
    return '$count tree${count == 1 ? '' : 's'}';
  }

  Color getStatusColor(TreeRegistrationModel registration) {
    return registration.isSynced == true ? Colors.green : Colors.orange;
  }

  String getStatusText(TreeRegistrationModel registration) {
    return registration.isSynced == true ? 'Synced' : 'Pending Sync';
  }
}
