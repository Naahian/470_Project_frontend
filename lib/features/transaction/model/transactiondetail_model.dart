//
enum TransactionType { ORDER, SELL }

//1. ORDER MODEL
class OrderModel {
  final int supplierId;
  final String paymentId;
  final int quantity;
  final DateTime deliveryDate;
  final int id;
  final DateTime timestamp;
  final TransactionType type;
  final bool isDelivered;
  final double totalAmount;
  final int userId;

  OrderModel({
    required this.supplierId,
    required this.paymentId,
    required this.quantity,
    required this.deliveryDate,
    required this.id,
    required this.timestamp,
    required this.type,
    required this.isDelivered,
    required this.totalAmount,
    required this.userId,
  });

  OrderModel.withDefaults({
    required this.supplierId,
    required this.paymentId,
    required this.deliveryDate,
    required this.id,
    required this.timestamp,
    required this.type,
    required this.totalAmount,
    required this.userId,
    this.quantity = 1,
    this.isDelivered = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      supplierId: json['supplier_id'] as int,
      paymentId: json['payment_id'] as String,
      quantity: json['quantity'] as int? ?? 1,
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      id: json['id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: _parseTransactionType(json['type'] as String),
      isDelivered: json['is_delivered'] as bool? ?? false,
      totalAmount: (json['total_amount'] as num).toDouble(),
      userId: json['user_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier_id': supplierId,
      'payment_id': paymentId,
      'quantity': quantity,
      'delivery_date': deliveryDate.toIso8601String(),
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': _transactionTypeToString(type),
      'is_delivered': isDelivered,
      'total_amount': totalAmount,
      'user_id': userId,
    };
  }

  // Helper methods
  static TransactionType _parseTransactionType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'ORDER':
        return TransactionType.ORDER;
      case 'SELL':
        return TransactionType.SELL;
      default:
        throw ArgumentError('Unknown transaction type: $typeString');
    }
  }

  static String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.ORDER:
        return 'ORDER';
      case TransactionType.SELL:
        return 'SELL';
    }
  }
}

//2. SELL MODEL

class SellModel {
  final int id;
  final int userId;
  final DateTime timestamp;
  final TransactionType type;
  final double totalAmount;
  final List<int> products;

  SellModel({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.type,
    required this.totalAmount,
    required this.products,
  });

  factory SellModel.fromJson(Map<String, dynamic> json) {
    return SellModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: _parseTransactionType(json['type'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      products: List<int>.from(json['products'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'type': _transactionTypeToString(type),
      'total_amount': totalAmount,
      'products': products,
    };
  }

  static TransactionType _parseTransactionType(String typeString) {
    switch (typeString) {
      case 'SELL':
        return TransactionType.SELL;
      case 'ORDER':
        return TransactionType.ORDER;
      default:
        throw ArgumentError('Unknown transaction type: $typeString');
    }
  }

  // Helper method to convert TransactionType to string
  static String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.SELL:
        return 'SELL';
      case TransactionType.ORDER:
        return 'ORDER';
    }
  }
}
