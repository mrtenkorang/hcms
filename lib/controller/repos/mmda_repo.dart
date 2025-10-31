import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/mmda_model.dart';

class MMDARepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<void> bulkInsertMMDAs(List<MMDAModel> mmdas) async {
    await _databaseHelper.bulkInsertMMDAs(mmdas);
  }

  Future<List<MMDAModel>> getAllMMDAs() async {
    return await _databaseHelper.getAllMMDAs();
  }

  Future<void> deleteAllMMDAs() async {
    await _databaseHelper.deleteAllMMDAs();
  }
}