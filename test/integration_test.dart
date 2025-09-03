// test/integration/category_service_integration_test.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_management_app/features/category/models/category_service.dart';

void main() {
  late CategoryService categoryService;

  setUp(() {
    // Use the real service with real Dio client
    categoryService = CategoryService();
  });

  group('CategoryService Integration Tests', () {
    test(
      'getAllCategories - should fetch real categories from API',
      () async {
        print('🚀 Starting real API call to get all categories...');

        try {
          // Act - Make real API call
          final result = await categoryService.getAllCategories();

          // Print the actual API response
          print('✅ REAL API Response:');
          print('Response Type: ${result.runtimeType}');
          print('Response Data: $result');

          // Basic assertions
          expect(result, isNotNull, reason: 'API should return some data');

          // You can add more specific assertions based on what you see in the response
          // For example, if your API returns a Map with 'success' and 'data' fields:
          // expect(result['success'], isTrue);
          // expect(result['data'], isList);

          print('🎉 Test completed successfully!');
        } catch (e) {
          print('❌ API Error Details:');
          print('Error Type: ${e.runtimeType}');
          print('Error Message: $e');

          // Print more details if it's a DioException
          if (e.toString().contains('DioException')) {
            print('This appears to be a network/HTTP error');
          }

          // You can choose to fail the test or just log the error for investigation
          rethrow; // This will fail the test - remove if you just want to see the error
        }
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
