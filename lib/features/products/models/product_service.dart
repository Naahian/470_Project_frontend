import 'package:dio/dio.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/dio_client.dart';

class ProductService {
  final Dio _dio = DioClient.instance.dio;

  Future getAllProducts() async {
    try {
      final Response response = await _dio.get(APIs.allProducts);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future createProduct(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(APIs.createProduct, data: data);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future deleteProduct(String productId) async {
    try {
      final Response response = await _dio.delete(
        APIs.deleteProduct(productId),
      );
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  dynamic processResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data;
    } else {
      throw Exception(
        'Error: ${response.statusCode} - ${response.statusMessage}',
      );
    }
  }
}
