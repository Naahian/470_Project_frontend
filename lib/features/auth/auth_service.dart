// ignore: depend_on_referenced_packages
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
    } on DioException catch (e) {
      return "Registration Failed: ${e.response?.data}";
    }
  }

  Future<String?> login(String username, String password) async {
    final formData = FormData.fromMap({
      "username": username,
      "password": password,
    });
    try {
      Response response = await dio.post(APIs.login, data: formData);
      final data = await response.data;
      storeToken(data["access_token"]);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return "Wrong Username/Password.";
      } else {
        return e.response?.data;
      }
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
