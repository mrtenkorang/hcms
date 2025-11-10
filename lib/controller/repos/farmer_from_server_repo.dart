// Example usage in your application:

import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';

class FarmerFromServerRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  // Add a new farmer
  Future<void> addFarmer(FarmerFromServerModel farmer) async {
    await _databaseHelper.insertFarmer(farmer);
  }

  Future<FarmerFromServerModel?> getFarmerById(String id) async {
    FarmerFromServerModel? farmer = await _databaseHelper.getFarmerById(id);
    return farmer;
  }

  // Add this to FarmerFromServerRepository class
  Future<List<FarmerFromServerModel>> getFarmersByCommunity(String communityId) async {
    final farmers = await _databaseHelper.getFarmersByCommunity(communityId);
    return farmers;
  }

  Future<void> bulkInsertFarmers(List<FarmerFromServerModel> farmers) async {
    await _databaseHelper.bulkInsertFarmers(farmers);
  }

  // Get all farmers
  Future<List<FarmerFromServerModel>> getAllFarmers() async {
    return await _databaseHelper.getAllFarmers();
  }

  // Search farmers
  Future<List<FarmerFromServerModel>> searchFarmers(String query) async {
    return await _databaseHelper.searchFarmers(query);
  }

  Future<void> deleteAllFarmersFromServer() async {
    await _databaseHelper.deleteAllFarmers();
  }

  // Update farmer information
  Future<void> updateFarmerContact(String farmerId, String newContact) async {
    await _databaseHelper.updateFarmerFields(
      id: farmerId,
      fields: {'contact': newContact},
    );
  }

  // Delete a farmer
  Future<void> removeFarmer(String farmerId) async {
    await _databaseHelper.deleteFarmer(farmerId);
  }
}
