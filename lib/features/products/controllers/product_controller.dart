import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/products/models/product_model.dart';
import 'product_repo.dart';

class ProductController extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductRepository repository;

  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedSupplier;

  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedSupplier => _selectedSupplier;

  List<String> get categories =>
      state.asData?.value.map((p) => p.categoryName).toSet().toList() ?? [];

  List<String> get suppliers =>
      state.asData?.value.map((p) => p.supplierName).toSet().toList() ?? [];

  List<String> get brands =>
      state.asData?.value.map((p) => p.categoryName).toSet().toList() ?? [];

  List<ProductModel> get filteredProducts {
    final products = state.asData?.value ?? [];
    return products.where((product) {
      final matchesSearch =
          _searchQuery.isEmpty || product.id.toString().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == null ||
          product.categoryName == _selectedCategory;
      final matchesSupplier =
          selectedSupplier == null || product.supplierName == selectedSupplier;
      return matchesSearch && matchesSupplier && matchesCategory;
    }).toList();
  }

  ProductController(this.repository) : super(const AsyncValue.loading()) {
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await repository.fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await repository.addProduct(product);
      await fetchAllProducts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await repository.deleteProduct(id);
      await fetchAllProducts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Update methods for filters
  void updateSearchQuery(String query) {
    _searchQuery = query;
    // Force rebuild by creating new AsyncValue with same data
    final currentData = state.asData?.value;
    if (currentData != null) {
      state = AsyncValue.data(List<ProductModel>.from(currentData));
    }
  }

  void updateCategoryFilter(String? category) {
    _selectedCategory = category;
    // Force rebuild by creating new AsyncValue with same data
    final currentData = state.asData?.value;
    if (currentData != null) {
      state = AsyncValue.data(List<ProductModel>.from(currentData));
    }
  }

  void updateSupplierFilter(String? supplier) {
    _selectedSupplier = supplier;
    // Force rebuild by creating new AsyncValue with same data
    final currentData = state.asData?.value;
    if (currentData != null) {
      state = AsyncValue.data(List<ProductModel>.from(currentData));
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedSupplier = null;
    // Force rebuild by creating new AsyncValue with same data
    final currentData = state.asData?.value;
    if (currentData != null) {
      state = AsyncValue.data(List<ProductModel>.from(currentData));
    }
  }
}

final productControllerProvider =
    StateNotifierProvider<ProductController, AsyncValue<List<ProductModel>>>(
      (ref) => ProductController(ref.read(productRepositoryProvider)),
    );
