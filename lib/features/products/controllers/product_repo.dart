import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/products/models/product_model.dart';
import 'package:inventory_management_app/features/products/models/product_service.dart';

class ProductRepository {
  List<ProductModel> _products = [];

  Future<List<ProductModel>> fetchProducts() async {
    final data = await ProductService().getAllProducts();
    final productsData = data as List<dynamic>? ?? [];
    _products = productsData
        .map((item) => ProductModel.fromJson(item))
        .toList();
    return List<ProductModel>.from(_products);
  }

  Future<void> addProduct(ProductModel product) async {
    await ProductService().createProduct(product.toJson());
    _products.add(product);
  }

  Future<void> deleteProduct(String id) async {
    await ProductService().deleteProduct(id);
    _products.removeWhere((p) => p.id == int.parse(id));
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});
