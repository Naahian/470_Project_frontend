enum TransactionType { SELL, ORDER }

class TransactionModel {
  final int id;
  final String type;
  final int user_id;
  final String total_amount;

  TransactionModel({
    required this.id,
    required this.type,
    required this.user_id,
    required this.total_amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      type: json['type'] as String,
      user_id: json['user_id'] as int,
      total_amount: json['total_amount'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'user_id': user_id,
      'total_amount': total_amount,
    };
  }
}
