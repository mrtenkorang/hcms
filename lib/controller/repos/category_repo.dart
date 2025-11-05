// repos/category_repository.dart
import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/controller/models/category_model.dart';

class CategoryRepository {
  final AppDatabaseHelper _databaseHelper = AppDatabaseHelper();

  Future<void> bulkInsertCategories(List<CategoryModel> categories) async {
    await _databaseHelper.bulkInsertCategories(categories);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    return await _databaseHelper.getAllCategories();
  }

  Future<List<CategoryModel>> getActiveCategories() async {
    return await _databaseHelper.getActiveCategories();
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    return await _databaseHelper.getCategoryById(id);
  }

  Future<List<CategoryModel>> searchCategories(String query) async {
    return await _databaseHelper.searchCategories(query);
  }

  Future<void> deleteAllCategories() async {
    await _databaseHelper.deleteAllCategories();
  }

  Future<bool> hasCategoriesData() async {
    return await _databaseHelper.hasCategoriesData();
  }

  Future<int> getCategoriesCount() async {
    return await _databaseHelper.getCategoriesCount();
  }
}