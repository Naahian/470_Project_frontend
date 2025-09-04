import 'package:dio/dio.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/dio_client.dart';

class SupplierService {
  final Dio _dio = DioClient.instance.dio;

  Future getAllSuppliers() async {
    try {
      final Response response = await _dio.get(APIs.allSuppliers);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future createSupplier(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        APIs.createSupplier,
        data: data,
      );
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future deleteSupplier(String supplierId) async {
    try {
      final Response response = await _dio.delete(
        APIs.deleteProduct(supplierId),
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
      return response.data["suppliers"];
    } else {
      throw Exception(
        'Error: ${response.statusCode} - ${response.statusMessage}',
      );
    }
  }
}

class TestSupplierService extends SupplierService {
  final Dio mockDio;

  TestSupplierService(this.mockDio);

  @override
  Dio get _dio => mockDio;
}
