import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
import 'package:inventory_management_app/features/category/models/category_service.dart';
import 'package:inventory_management_app/features/products/models/product_model.dart';
import 'package:inventory_management_app/features/products/models/product_service.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_model.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_service.dart';

class AddProductState {
  final List<CategoryModel> categories;
  final List<SupplierModel> suppliers;
  final int? selectedCategory;
  final int? selectedSupplier;
  final bool isLoading;
  final String? error;

  AddProductState({
    this.categories = const [],
    this.suppliers = const [],
    this.selectedCategory,
    this.selectedSupplier,
    this.isLoading = false,
    this.error,
  });

  // Create a copyWith method for immutable state updates
  AddProductState copyWith({
    List<CategoryModel>? categories,
    List<SupplierModel>? suppliers,
    int? selectedCategory,
    int? selectedSupplier,
    bool? isLoading,
    String? error,
  }) {
    return AddProductState(
      categories: categories ?? this.categories,
      suppliers: suppliers ?? this.suppliers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AddProductController extends StateNotifier<AddProductState> {
  AddProductController() : super(AddProductState());

  // Fixed method name and proper async handling
  Future<void> fetchAll() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Wait for both operations to complete
      await Future.wait([fetchCategories(), fetchSuppliers()]);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data: ${e.toString()}',
      );
      return;
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> fetchCategories() async {
    try {
      final result = await CategoryService().getAllCategories();
      final categories = result["categories"]
          .map<CategoryModel>((cat) => CategoryModel.fromJson(cat))
          .toList();

      state = state.copyWith(categories: categories);
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  Future<void> fetchSuppliers() async {
    try {
      final result = await SupplierService().getAllSuppliers();
      final suppliers = result["suppliers"]
          .map<SupplierModel>((sup) => SupplierModel.fromJson(sup))
          .toList();

      state = state.copyWith(suppliers: suppliers);
    } catch (e) {
      throw Exception('Failed to fetch suppliers: ${e.toString()}');
    }
  }

  void selectCategory(int categoryId) {
    state = state.copyWith(selectedCategory: categoryId);
  }

  void selectSupplier(int supplierId) {
    state = state.copyWith(selectedSupplier: supplierId);
  }

  void clearSelections() {
    state = state.copyWith(selectedCategory: null, selectedSupplier: null);
  }

  Future<void> addProduct(ProductCreateModel product) async {
    try {
      await ProductService().createProduct(product.toJson());
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final addProductControllerProvider =
    StateNotifierProvider<AddProductController, AddProductState>(
      (ref) => AddProductController(),
    );
