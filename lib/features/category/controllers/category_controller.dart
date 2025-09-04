import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
import 'package:dio/dio.dart';
import 'package:inventory_management_app/features/category/models/category_service.dart';
import 'category_repo.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;
  final bool isRefillable;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.isRefillable = false,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CategoryController extends StateNotifier<CategoryState> {
  final CategoryService categoryService;

  CategoryController(this.categoryService) : super(const CategoryState()) {
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await categoryService.getAllCategories();
      final categoriesData = data["categories"] as List<dynamic>? ?? [];
      final categories = categoriesData
          .map((item) => CategoryModel.fromJson(item))
          .toList();

      state = state.copyWith(
        categories: categories,
        isLoading: false,
        error: null,
      );
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await categoryService.createCategory(category.toJson());
      // Refresh the list after adding
      await fetchAllCategories();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await categoryService.deleteCategory(id);
      // Remove from local state immediately for better UX
      state = state.copyWith(
        categories: state.categories
            .where((cat) => cat.id != int.parse(id))
            .toList(),
        isLoading: false,
      );
    } on DioException catch (dioErr) {
      final statusCode = dioErr.response?.statusCode;
      state = state.copyWith(
        isLoading: false,
        error: "Error $statusCode: ${dioErr.message}",
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Unexpected error: $e");
      rethrow;
    }
  }

  // Helper method to get category count for home screen
  int get categoryCount => state.categories.length;
}

// Provider for CategoryService
final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

// Provider for CategoryController
final categoryControllerProvider =
    StateNotifierProvider<CategoryController, CategoryState>(
      (ref) => CategoryController(ref.read(categoryServiceProvider)),
    );
