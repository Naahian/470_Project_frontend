// features/supplier/repository/supplier_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/category/category.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_model.dart';

class SupplierRepository {
  SupplierRepository();

  Future<List<SupplierModel>> fetchSuppliers() async {
    try {
      final response = await CategoryService().getAllCategories();
      final List<dynamic> data = response.data;
      return data.map((json) => SupplierModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch suppliers: ${e.message}');
    }
  }

  Future<SupplierModel> addSupplier(SupplierModel supplier) async {
    try {
      final response = await CategoryService().createCategory(
        supplier.toJson(),
      );

      return SupplierModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to add supplier: ${e.message}');
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      final response = await CategoryService().deleteCategory(id);
    } on DioException catch (e) {
      throw Exception('Failed to delete supplier: ${e.message}');
    }
  }
}

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  return SupplierRepository();
});
