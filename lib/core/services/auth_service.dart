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

  Future<bool> register(user) async {
    //class to json string or body
    //call api with json body
    return true;
  }

  Future<String> login(String username, String password) async {
    final formData = FormData.fromMap({
      "username": username,
      "password": password,
    });
    try {
      await dio.post(APIs.login, data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return "Wrong Username/Password.";
      } else {
        return e.response?.data;
      }
    }
    return "";
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

  Future storeToken(String token) async {
    await _storage.write(key: accessKey, value: token);
  }

  Future clearTokens() async {
    await _storage.delete(key: accessKey);
  }
}
