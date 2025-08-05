class CategoryModel {
  final int? id;
  final String name;
  final int imageNo;
  final int quantity;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageNo,
    required this.quantity,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageNo: json['imageNo'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'imageNo': imageNo, 'quantity': quantity};
  }
}
