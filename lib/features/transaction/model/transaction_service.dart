import 'package:dio/dio.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/dio_client.dart';

class TransactionService {
  final Dio _dio = DioClient.instance.dio;

  Future getAllTransactions() async {
    try {
      final Response response = await _dio.get(APIs.allTransactions);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future getSingleTransaction(String id) async {
    try {
      final Response response = await _dio.get(APIs.singleTransaction(id));
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future getAllSells() async {
    try {
      final Response response = await _dio.get(APIs.allSells);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future createOrder(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(APIs.createOrder, data: data);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future createSell(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(APIs.createSell, data: data);
      return processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future createMultiSell(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(APIs.createSell, data: data);
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
