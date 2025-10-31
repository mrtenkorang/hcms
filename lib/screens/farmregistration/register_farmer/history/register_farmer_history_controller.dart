import 'package:get/get.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';
import 'package:hcms_revived2/controller/repos/farmer_local_repo.dart';

class RegisterFarmerHistoryController extends GetxController {
  final FarmerBiodataRepository _repository = FarmerBiodataRepository();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<List<FarmerBiodataModel>> getPendingFarmerBiodata() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final farmers = await _repository.getPendingFarmerBiodata();
      return farmers;
    } catch (e) {
      errorMessage.value = 'Failed to load pending farmers: ${e.toString()}';
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<FarmerBiodataModel>> getSubmittedFarmerBiodata() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final farmers = await _repository.getSubmittedFarmerBiodata();
      return farmers;
    } catch (e) {
      errorMessage.value = 'Failed to load submitted farmers: ${e.toString()}';
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
