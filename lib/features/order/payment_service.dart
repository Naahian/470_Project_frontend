import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/dio_client.dart';

final paymentStateProvider = StateProvider<PaymentState>(
  (ref) => PaymentState.initial,
);

enum PaymentState { initial, loading, gateway, success, failed }

class PaymentService {
  final Dio _dio = DioClient.instance.dio;
  Future makePayment(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(APIs.makePayment, data: data);
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
