// repos/tree_species_repo.dart
import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/tree_species_model.dart';

class TreeSpeciesRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<void> bulkInsertTreeSpecies(List<TreeSpeciesModel> treeSpecies) async {
    await _databaseHelper.bulkInsertTreeSpecies(treeSpecies);
  }

  Future<List<TreeSpeciesModel>> getAllTreeSpecies() async {
    return await _databaseHelper.getAllTreeSpecies();
  }

  Future<TreeSpeciesModel?> getTreeSpeciesById(int id) async {
    return await _databaseHelper.getTreeSpeciesById(id);
  }

  Future<List<TreeSpeciesModel>> searchTreeSpecies(String query) async {
    return await _databaseHelper.searchTreeSpecies(query);
  }

  Future<void> deleteAllTreeSpecies() async {
    await _databaseHelper.deleteAllTreeSpecies();

  }
}