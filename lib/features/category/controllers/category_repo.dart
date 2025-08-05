import 'package:inventory_management_app/features/category/models/category_service.dart';
import '../models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryRepository {
  List<CategoryModel> _categories = [];

  Future<List<CategoryModel>> fetchCategories() async {
    final data = await CategoryService().getAllCategories();
    final categoriesData = data["categories"] as List<dynamic>? ?? [];
    _categories = categoriesData
        .map((item) => CategoryModel.fromJson(item))
        .toList();

    return List<CategoryModel>.from(_categories);
  }

  Future<void> addCategory(CategoryModel category) async {
    await CategoryService().createCategory(category.toJson());
    _categories.add(category);
  }

  Future<void> deleteCategory(String id) async {
    await CategoryService().deleteCategory(id);
    _categories.removeWhere((cat) => cat.id == int.parse(id));
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});
