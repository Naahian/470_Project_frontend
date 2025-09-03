import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/dio_client.dart';

class AuthService {
  AuthService._authService();
  static final AuthService _instance = AuthService._authService();
  static AuthService get instance => _instance;

  final _storage = FlutterSecureStorage();
  Dio dio = DioClient.instance.dio;
  String accessKey = "access_key";
  String? currentUser = null; //TODO:data type AuthUser

  Future<String?> register(
    String name,
    String username,
    String email,
    String password,
  ) async {
    final data = {
      "email": email,
      "username": username,
      "password": password,
      "full_name": name,
    };

    try {
      Response response = await dio.post(APIs.register, data: data);
      // Return null on success, or handle response as needed
      return null;
    } on DioException catch (e) {
      return "Registration Failed: ${e.response?.data ?? e.message}";
    }
  }

  Future<String?> login(String username, String password) async {
    final formData = FormData.fromMap({
      "username": username,
      "password": password,
    });

    try {
      Response response = await dio.post(APIs.login, data: formData);
      final data = response.data;
      await storeToken(data["access_token"]);
      return null; // Success
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return "Network error. Please check your internet connection.";
      } else if (e.response?.statusCode == 401) {
        return "Wrong Username/Password.";
      } else {
        return e.response?.data?.toString() ?? e.message ?? "Login failed";
      }
    } catch (e) {
      return "An unexpected error occurred: ${e.toString()}";
    }
  }

  Future<bool> logout() async {
    //call api
    await _storage.delete(key: accessKey);
    return true;
  }

  Future<String> getToken() async {
    final key = await _storage.read(key: accessKey) ?? '';
    return key;
  }

  Future<bool> authenticated() async {
    final String token = await getToken();
    return token.isNotEmpty;
  }

  Future storeToken(String token) async {
    await _storage.write(key: accessKey, value: token);
  }

  Future clearTokens() async {
    await _storage.delete(key: accessKey);
  }
}
