import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
import 'package:dio/dio.dart';
import 'category_repo.dart';

class CategoryController
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CategoryRepository repository;

  CategoryController(this.repository) : super(const AsyncValue.loading()) {
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await repository.fetchCategories();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await repository.addCategory(category);
      await fetchAllCategories();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await repository.deleteCategory(id);
      await fetchAllCategories();
    } on DioException catch (dioErr, st) {
      final statusCode = dioErr.response?.statusCode;
      state = AsyncValue.error("$statusCode", st);
    } catch (e, st) {
      state = AsyncValue.error("Unexpected error", st);
    }
  }
}

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<List<CategoryModel>>>(
      (ref) => CategoryController(ref.read(categoryRepositoryProvider)),
    );
