import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';

class CommunityRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<void> bulkInsertCommunities(List<CommunityModel> communities) async {
    await _databaseHelper.bulkInsertCommunities(communities);
  }

  Future<List<CommunityModel>> getAllCommunities() async {
    return await _databaseHelper.getAllCommunities();
  }

  Future<CommunityModel?> getCommunitiesByID(int id) async {
    return await _databaseHelper.getCommunityById(id);
  }

  Future<void> deleteAllCommunities() async {
    await _databaseHelper.deleteAllCommunities();
  }
}