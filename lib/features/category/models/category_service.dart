import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/dio_client.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

class CategoryService {
  final Dio _dio = DioClient.instance.dio;

  Future getAllCategories() async {
    try {
      final Response response = await _dio.get(APIs.allCategories);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future createCategory(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        APIs.createCategory,
        data: data,
      );
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future getCategoryWithProducts(String categoryId) async {
    try {
      final Response response = await _dio.get(
        APIs.categoryWithProducts(categoryId),
      );
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future deleteCategory(String categoryId) async {
    try {
      print(APIs.deleteCategory(categoryId));
      final Response response = await _dio.delete(
        APIs.deleteCategory(categoryId),
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

class TestCategoryService extends CategoryService {
  final Dio mockDio;

  TestCategoryService(this.mockDio);

  @override
  Dio get _dio => mockDio;
}
