import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/district_region_model.dart';


class DistrictRepository {
  final AppDatabaseHelper _dbHelper = AppDatabaseHelper();

  // Create
  Future<int> createDistrict(DistrictModel district) async {
    return await _dbHelper.insertDistrict(district);
  }


  // Bulk Create
  Future<void> createDistricts(List<DistrictModel> districts) async {
    await _dbHelper.bulkInsertDistricts(districts);
  }

  // Read
  Future<List<DistrictModel>> getAllDistricts() async {
    return await _dbHelper.getAllDistricts();
  }

  Future<DistrictModel?> getDistrictById(int id) async {
    return await _dbHelper.getDistrictById(id);
  }

  Future<DistrictModel?> getDistrictByDistrictId(int districtId) async {
    return await _dbHelper.getDistrictByDistrictId(districtId);
  }

  Future<List<DistrictModel>> getDistrictsByRegionId(String regionId) async {
    return await _dbHelper.getDistrictsByRegionId(regionId);
  }

  Future<List<DistrictModel>> getDistrictsByRegionName(String regionName) async {
    return await _dbHelper.getDistrictsByRegionName(regionName);
  }

  // Search
  Future<List<DistrictModel>> searchDistricts(String query) async {
    return await _dbHelper.searchDistricts(query);
  }

  // Update
  Future<int> updateDistrict(DistrictModel district) async {
    return await _dbHelper.updateDistrict(district);
  }

  // Delete
  Future<int> deleteDistrict(int id) async {
    return await _dbHelper.deleteDistrict(id);
  }

  Future<int> deleteDistrictByDistrictId(int districtId) async {
    return await _dbHelper.deleteDistrictByDistrictId(districtId);
  }

  Future<int> clearAllDistricts() async {
    return await _dbHelper.deleteAllDistricts();
  }

  // Utility Methods
  Future<int> getCount() async {
    return await _dbHelper.getDistrictsCount();
  }

  Future<bool> exists(int districtId) async {
    return await _dbHelper.districtExists(districtId);
  }

  Future<List<String>> getRegions() async {
    return await _dbHelper.getUniqueRegions();
  }

  Future<List<DistrictModel>> getPaginatedDistricts({
    required int page,
    required int pageSize,
    String? regionId,
  }) async {
    final offset = (page - 1) * pageSize;
    return await _dbHelper.getDistrictsWithPagination(
      limit: pageSize,
      offset: offset,
      regionId: regionId,
    );
  }

  // Close database connection
  Future<void> close() async {
    await _dbHelper.close();
  }
}