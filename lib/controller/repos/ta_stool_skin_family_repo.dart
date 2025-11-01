import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/ta_stool_skin_family%20model.dart';

class TaStoolSkinFamilyRepo {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<void> bulkInsertTypes(List<TAStoolSkinFamilyModel> types) async {
    await _databaseHelper.bulkInsertTypes(types);
  }

  Future<List<TAStoolSkinFamilyModel>> getAllTypes() async {
    return await _databaseHelper.getAllTypes();
  }

  Future<void> deleteAllTypes() async {
    await _databaseHelper.deleteAllTypes();
  }
}