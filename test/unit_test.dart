import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/category/models/category_service.dart';
import 'package:inventory_management_app/features/suppliers/models/supplier_service.dart';
import 'package:mockito/mockito.dart';
import './unit_test_mock.mocks.dart'; // The file generated above

void main() {
  late MockDio mockDio;
  late TestCategoryService categoryService;
  late TestSupplierService supplierService;
  setUp(() {
    mockDio = MockDio();
    categoryService = TestCategoryService(mockDio);
    supplierService = TestSupplierService(mockDio);
  });

  test("CategoryService Test", () async {
    final mockResponse = Response(
      requestOptions: RequestOptions(path: APIs.allCategories),
      statusCode: 200,
      data: {
        'success': true,
        'data': [
          {'id': 1, 'name': 'Electronics'},
          {'id': 2, 'name': 'Books'},
        ],
      },
    );

    when(mockDio.get(APIs.allCategories)).thenAnswer((_) async => mockResponse);

    // Act
    final result = await categoryService.getAllCategories();
    print(result);
    // Assert
    expect(result, isNotNull);
  });
}
