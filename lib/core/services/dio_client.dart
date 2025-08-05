import 'package:dio/dio.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';

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
          return handler.next(options);
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
