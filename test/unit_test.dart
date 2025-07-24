import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import './unit_test_mock.mocks.dart'; // The file generated above

void main() {
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
  });

  test('should store token', () async {
    // await authService.storeToken('token:adfsadfaw2323');
    // final result = await authService.getToken();
    // expect(result, isTrue);
  });

  group('AuthService', () {
    // test('should return true for valid login', () async {
    //   final result = await authService.login('validUser', 'validPassword');
    //   expect(result, isTrue);
    // });

    // test('should return false for invalid login', () async {
    //   final result = await authService.login('invalidUser', 'wrongPassword');
    //   expect(result, isFalse);
    // });

    // test('should logout successfully', () async {
    //   await authService.login('validUser', 'validPassword');
    //   await authService.logout();
    //   expect(authService.isLoggedIn, isFalse);
    // });

    // test('should register new user', () async {
    //   final result = await authService.register('newUser', 'newPassword');
    //   expect(result, isTrue);
    // });

    // test('should not register existing user', () async {
    //   await authService.register('existingUser', 'password');
    //   final result = await authService.register('existingUser', 'password');
    //   expect(result, isFalse);
    // });
  });
}
