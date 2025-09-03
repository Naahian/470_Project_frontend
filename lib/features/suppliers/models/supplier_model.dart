class SupplierModel {
  final int id;
  final String name;
  final String contactInfo;
  final DateTime createdAt;

  SupplierModel({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.createdAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as int,
      name: json['name'] as String,
      contactInfo: json['contact_info'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact_info': contactInfo,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
