import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/models/category_model.dart';
import 'package:dio/dio.dart';
import 'package:inventory_management_app/features/suppliers/controller/supplier_repo.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_model.dart';

class SupplierController
    extends StateNotifier<AsyncValue<List<SupplierModel>>> {
  final SupplierRepository repository;

  SupplierController(this.repository) : super(const AsyncValue.loading()) {
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await repository.fetchSuppliers();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final supplierControllerProvider =
    StateNotifierProvider<SupplierController, AsyncValue<List<SupplierModel>>>(
      (ref) => SupplierController(ref.read(supplierRepositoryProvider)),
    );
