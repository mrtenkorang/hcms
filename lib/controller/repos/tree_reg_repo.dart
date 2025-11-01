import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';

class TreeRegistrationRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<int> insertTreeRegistration(TreeRegistrationModel registration) async {
    return await _databaseHelper.insertTreeRegistration(registration);
  }

  Future<List<TreeRegistrationModel>> getAllTreeRegistrations() async {
    return await _databaseHelper.getAllTreeRegistrations();
  }

  Future<TreeRegistrationModel?> getTreeRegistrationById(int id) async {
    return await _databaseHelper.getTreeRegistrationById(id);
  }

  Future<List<TreeRegistrationModel>> getTreeRegistrationsByFarmerId(int farmerId) async {
    return await _databaseHelper.getTreeRegistrationsByFarmerId(farmerId);
  }

  Future<List<TreeRegistrationModel>> getUnsyncedTreeRegistrations() async {
    return await _databaseHelper.getUnsyncedTreeRegistrations();
  }

  Future<int> updateTreeRegistration(TreeRegistrationModel registration) async {
    return await _databaseHelper.updateTreeRegistration(registration);
  }

  Future<int> deleteTreeRegistration(int id) async {
    return await _databaseHelper.deleteTreeRegistration(id);
  }

  Future<int> deleteAllTreeRegistrations() async {
    return await _databaseHelper.deleteAllTreeRegistrations();
  }

  Future<int> markTreeRegistrationAsSynced(int id) async {
    return await _databaseHelper.markTreeRegistrationAsSynced(id);
  }

  Future<int> getTreeRegistrationCount() async {
    return await _databaseHelper.getTreeRegistrationCount();
  }

  Future<void> closeDatabase() async {
    await _databaseHelper.close();
  }
}