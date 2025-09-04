import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_model.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_service.dart';

// Supplier State class
class SupplierState {
  final List<SupplierModel> suppliers;
  final bool isLoading;
  final String? error;
  final bool isAdding;
  final bool isDeleting;

  const SupplierState({
    this.suppliers = const [],
    this.isLoading = false,
    this.error,
    this.isAdding = false,
    this.isDeleting = false,
  });

  SupplierState copyWith({
    List<SupplierModel>? suppliers,
    bool? isLoading,
    String? error,
    bool? isAdding,
    bool? isDeleting,
  }) {
    return SupplierState(
      suppliers: suppliers ?? this.suppliers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAdding: isAdding ?? this.isAdding,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  // Helper getters
  bool get hasError => error != null;
  bool get isEmpty => suppliers.isEmpty && !isLoading;
  bool get hasData => suppliers.isNotEmpty;
}

// Supplier Controller with direct service calls
class SupplierController extends StateNotifier<SupplierState> {
  SupplierController() : super(const SupplierState()) {
    fetchAllSuppliers();
  }
  Future<void> fetchAllSuppliers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Debug: Print what we're getting from the service
      print("🔍 Fetching suppliers...");

      final data = await SupplierService().getAllSuppliers();

      // Debug: Check the raw data
      print("📦 Raw data type: ${data.runtimeType}");
      print("📦 Raw data: $data");

      List<SupplierModel> suppliers = [];

      // Handle different response formats
      if (data is List) {
        // If data is directly a List
        print("✅ Data is a List with ${data.length} items");
        suppliers = data.map((json) => SupplierModel.fromJson(json)).toList();
      } else if (data is Map && data.containsKey('data')) {
        // If data is wrapped in a response object
        print("✅ Data is wrapped in response object");
        final List<dynamic> dataList = data['data'];
        print("📋 Data list length: ${dataList.length}");
        suppliers = dataList
            .map((json) => SupplierModel.fromJson(json))
            .toList();
      } else {
        // Unknown format
        print("❌ Unknown data format");
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }

      print("✅ Parsed ${suppliers.length} suppliers");

      // Force state update
      state = SupplierState(
        suppliers: suppliers,
        isLoading: false,
        error: null,
        isAdding: false,
        isDeleting: false,
      );

      print(
        "🎯 State updated. Current suppliers count: ${state.suppliers.length}",
      );

      // Debug: Print supplier names
      for (var supplier in state.suppliers) {
        print("👤 Supplier: ${supplier.name}");
      }
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Response: ${e.response?.data}");

      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch suppliers: ${e.message}',
      );
    } catch (e, stackTrace) {
      print("❌ Exception: $e");
      print("❌ StackTrace: $stackTrace");

      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<bool> addSupplier(SupplierModel supplier) async {
    state = state.copyWith(isAdding: true, error: null);

    try {
      final response = await SupplierService().createSupplier(
        supplier.toJson(),
      );

      final newSupplier = SupplierModel.fromJson(response.data);
      final updatedSuppliers = [...state.suppliers, newSupplier];

      state = state.copyWith(
        suppliers: updatedSuppliers,
        isAdding: false,
        error: null,
      );

      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isAdding: false,
        error: 'Failed to add supplier: ${e.message}',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isAdding: false,
        error: 'An unexpected error occurred: $e',
      );
      return false;
    }
  }

  Future<bool> deleteSupplier(String id) async {
    state = state.copyWith(isDeleting: true, error: null);

    try {
      await SupplierService().deleteSupplier(id);

      final updatedSuppliers = state.suppliers
          .where((supplier) => supplier.id.toString() != id)
          .toList();

      state = state.copyWith(
        suppliers: updatedSuppliers,
        isDeleting: false,
        error: null,
      );

      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'Failed to delete supplier: ${e.message}',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'An unexpected error occurred: $e',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  SupplierModel? getSupplierById(int id) {
    try {
      return state.suppliers.firstWhere((supplier) => supplier.id == id);
    } catch (e) {
      return null;
    }
  }

  List<SupplierModel> searchSuppliers(String query) {
    if (query.isEmpty) return state.suppliers;

    return state.suppliers.where((supplier) {
      return supplier.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

// Provider
final supplierControllerProvider =
    StateNotifierProvider<SupplierController, SupplierState>((ref) {
      return SupplierController();
    });
