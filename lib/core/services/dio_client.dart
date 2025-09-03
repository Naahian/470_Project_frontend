import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:inventory_management_app/routes/app_routes.dart';

class DioClient {
  late final Dio _dio;
  Dio get dio => _dio;
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: APIs.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = await AuthService.instance.getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print("### Making request to: ${options.baseUrl}${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("### Response received: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print("### Dio Error: ${error.type} - ${error.message}");

          // timeout errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            print("### Timeout error occurred");
          }

          // connection errors
          if (error.type == DioExceptionType.connectionError) {
            print("### Connection error - server might be offline");
          }

          if (error.response?.statusCode == 401) {
            await AuthService.instance.logout();
            AppRoutes.navigateToLogin();
          }

          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          print("### DIO LOG: $object");
        },
      ),
    );
  }
}
