import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/controller/repos/tree_reg_repo.dart';

class TreeRegHistoryController extends GetxController {
  BuildContext? treeRegHistoryScreenContext;

  final RxList<TreeRegistrationModel> _allTreeData = <TreeRegistrationModel>[].obs;
  final RxInt _selectedTabIndex = 0.obs;
  final RxBool _isLoading = true.obs;

  List<TreeRegistrationModel> get allTreeData => _allTreeData;
  List<TreeRegistrationModel> get syncedData => _allTreeData.where((item) => item.isSynced == true).toList();
  List<TreeRegistrationModel> get unsyncedData => _allTreeData.where((item) => item.isSynced != true).toList();
  int get selectedTabIndex => _selectedTabIndex.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadTreeData();
  }

  Future<void> loadTreeData() async {
    try {
      _isLoading.value = true;
      _allTreeData.value = await TreeRegistrationRepository().getAllTreeRegistrations();
    } catch (e) {
      print('Error loading tree data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void changeTab(int index) {
    _selectedTabIndex.value = index;
  }

  Future<void> retrySync(TreeRegistrationModel registration) async {
    // Implement retry sync logic here
    // You can call your submission service here
  }

  Future<void> deleteRegistration(TreeRegistrationModel registration) async {
    if (registration.id != null) {
      await TreeRegistrationRepository().deleteTreeRegistration(registration.id!);
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