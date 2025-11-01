import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';

class FarmerBiodataRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<int> insertFarmerBiodata(FarmerBiodataModel farmer) async {
    return await _databaseHelper.insertFarmerBiodata(farmer);
  }

  Future<List<FarmerBiodataModel>> getAllFarmerBiodata() async {
    return await _databaseHelper.getAllFarmerBiodata();
  }

  Future<List<FarmerBiodataModel>> getPendingFarmerBiodata() async {
    return await _databaseHelper.getFarmerBiodataByStatus('pending');
  }

  Future<List<FarmerBiodataModel>> getSubmittedFarmerBiodata() async {
    return await _databaseHelper.getFarmerBiodataByStatus('submitted');
  }

  Future<FarmerBiodataModel?> getFarmerBiodataById(int id) async {
    return await _databaseHelper.getFarmerBiodataById(id);
  }

  Future<int> updateFarmerBiodata(FarmerBiodataModel farmer) async {
    return await _databaseHelper.updateFarmerBiodata(farmer);
  }

  Future<int> deleteFarmerBiodata(int id) async {
    return await _databaseHelper.deleteFarmerBiodata(id);
  }

  Future<void> bulkInsertFarmerBiodata(List<FarmerBiodataModel> farmers) async {
    await _databaseHelper.bulkInsertFarmerBiodata(farmers);
  }
}