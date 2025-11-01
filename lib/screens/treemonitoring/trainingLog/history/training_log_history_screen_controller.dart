import 'package:get/get.dart';
import 'package:hcms_revived2/controller/models/training_log_model.dart';
import 'package:hcms_revived2/controller/repos/training_log_repo.dart';

class TrainingLogHistoryScreenController extends GetxController {
  final TrainingLogRepository _repository = TrainingLogRepository();
  
  // Reactive lists for synced and pending logs
  final RxList<TrainingLogModel> syncedLogs = <TrainingLogModel>[].obs;
  final RxList<TrainingLogModel> pendingLogs = <TrainingLogModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrainingLogs();
  }

  Future<void> loadTrainingLogs() async {
    try {
      isLoading.value = true;
      
      // Load all logs
      final allLogs = await _repository.getAllTrainingLogs();
      
      // Separate into synced and pending
      syncedLogs.value = allLogs.where((log) => log.isSynced).toList();
      pendingLogs.value = allLogs.where((log) => !log.isSynced).toList();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load training logs: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  deleteLog(TrainingLogModel log) async {
    try {
      isLoading.value = true;
      await _repository.deleteTrainingLog(log.id!);
      await loadTrainingLogs();
      Get.snackbar(
        'Success',
        'Training log deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete training log: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}