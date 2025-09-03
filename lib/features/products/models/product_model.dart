class ProductModel {
  final int? id;
  final String categoryName;
  final String supplierName;
  final int categoryId;
  final int supplierId;
  final String createdAt;
  final String? updatedAt;
  final bool inStock;

  ProductModel({
    required this.id,
    required this.categoryName,
    required this.supplierName,
    required this.categoryId,
    required this.supplierId,
    required this.createdAt,
    this.updatedAt,
    required this.inStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      categoryName: json['category_name'] as String,
      supplierName: json['supplier_name'] as String,
      categoryId: json['category_id'] as int,
      supplierId: json['supplier_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      inStock: json['in_stock'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'supplier_name': supplierName,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'in_stock': inStock,
    };
  }
}

class ProductCreateModel {
  final String categoryName;
  final String supplierName;
  final int categoryId;
  final int supplierId;

  ProductCreateModel({
    required this.categoryName,
    required this.supplierName,
    required this.categoryId,
    required this.supplierId,
  });

  factory ProductCreateModel.fromJson(Map<String, dynamic> json) {
    return ProductCreateModel(
      categoryName: json['category_name'] as String,
      supplierName: json['supplier_name'] as String,
      categoryId: json['category_id'] as int,
      supplierId: json['supplier_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'supplier_name': supplierName,
      'category_id': categoryId,
      'supplier_id': supplierId,
    };
  }
}
