// farmer_list_controller.dart
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';

class FarmerListController extends GetxController {
  final FarmerFromServerRepository repository = FarmerFromServerRepository();
  final RxList<FarmerFromServerModel> farmers = <FarmerFromServerModel>[].obs;
  final RxList<FarmerFromServerModel> filteredFarmers = <FarmerFromServerModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFarmers();
  }

  Future<void> loadFarmers() async {
    try {
      isLoading.value = true;
      final result = await repository.getAllFarmers();
      farmers.assignAll(result);
      filteredFarmers.assignAll(farmers);
        } catch (e) {
      Get.snackbar('Error', 'Failed to load farmers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchFarmers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredFarmers.assignAll(farmers);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    filteredFarmers.assignAll(
      farmers.where((farmer) {
        return farmer.farmerName.toLowerCase().contains(lowercaseQuery) == true ||
            farmer.farmercode.toLowerCase().contains(lowercaseQuery) == true ||
            (farmer.contact.toLowerCase().contains(lowercaseQuery));
      }).toList(),
    );
  }

  void refreshList() async {
    await loadFarmers();
  }
}