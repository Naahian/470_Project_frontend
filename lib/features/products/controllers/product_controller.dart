// product_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/products/models/product_service.dart';
import 'package:inventory_management_app/features/products/models/viewmodels.dart';
import '../models/product_model.dart';

class ProductState {
  final List<ProductModel> products;
  final List<ProductModel> selectedProducts;
  final bool isLoading;
  final Object? error;
  final StackTrace? stackTrace;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedSupplier;

  const ProductState({
    required this.selectedProducts,
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.stackTrace,
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedSupplier,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? selectedProducts,
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    String? searchQuery,
    String? selectedCategory,
    String? selectedSupplier,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
    );
  }

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final matchesSearch =
          searchQuery.isEmpty || product.id.toString().contains(searchQuery);
      final matchesCategory =
          selectedCategory == null || product.categoryName == selectedCategory;
      final matchesSupplier =
          selectedSupplier == null || product.supplierName == selectedSupplier;
      return matchesSearch && matchesCategory && matchesSupplier;
    }).toList();
  }

  bool get hasError => error != null;
}

//CONTROLLER
class ProductController extends StateNotifier<ProductState> {
  final ProductService productService = ProductService();

  ProductController() : super(ProductState(selectedProducts: []));

  List<DropdownModel> get categories {
    final uniqueCategories = <String, DropdownModel>{};

    for (final product in state.products) {
      uniqueCategories[product.categoryName] = DropdownModel(
        name: product.categoryName,
        id: product.categoryId,
      );
    }

    return uniqueCategories.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<DropdownModel> get suppliers {
    final uniqueSuppliers = <int, DropdownModel>{};

    for (final product in state.products) {
      uniqueSuppliers[product.supplierId] = DropdownModel(
        name: product.supplierName,
        id: product.supplierId,
      );
    }

    return uniqueSuppliers.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> fetchAllProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await productService.getAllProducts();
      final List<ProductModel> products = result
          .map<ProductModel>((product) => ProductModel.fromJson(product))
          .toList();

      state = state.copyWith(
        products: products,
        isLoading: false,
        error: null,
        stackTrace: null,
      );
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e, stackTrace: st);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await productService.deleteProduct(id);
      await fetchAllProducts();
    } catch (e, st) {
      state = state.copyWith(error: e, stackTrace: st);
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateCategoryFilter(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateSupplierFilter(String? supplier) {
    state = state.copyWith(selectedSupplier: supplier);
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCategory: null,
      selectedSupplier: null,
    );
    fetchAllProducts(); // Refresh with all products
  }

  void selectProduct(ProductModel product) {
    List<ProductModel> selectedProducts = List<ProductModel>.from(
      state.selectedProducts,
    );
    selectedProducts.add(product);
    state = state.copyWith(selectedProducts: selectedProducts);
  }

  void unselectProduct(ProductModel product) {
    List<ProductModel> selectedProducts = List<ProductModel>.from(
      state.selectedProducts,
    );
    selectedProducts.remove(product);
    state = state.copyWith(selectedProducts: selectedProducts);
  }
}

final productControllerProvider =
    StateNotifierProvider<ProductController, ProductState>(
      (ref) => ProductController(),
    );
