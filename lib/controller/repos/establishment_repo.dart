import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/establishment_type_model.dart';

class EstaTypeRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<void> bulkInsertEstaTypes(List<EstaTypeModel> estaTypes) async {
    await _databaseHelper.bulkInsertEstaTypes(estaTypes);
  }

  Future<List<EstaTypeModel>> getAllEstaTypes() async {
    return await _databaseHelper.getAllEstaTypes();
  }

  Future<void> deleteAllEstaTypes() async {
    await _databaseHelper.deleteAllEstaTypes();
  }
}