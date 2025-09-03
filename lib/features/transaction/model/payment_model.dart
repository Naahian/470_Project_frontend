// Order details model
class OrderDetails {
  final String supplier;
  final String category;
  final int quantity;
  final double amount;

  OrderDetails({
    required this.supplier,
    required this.category,
    required this.quantity,
    required this.amount,
  });
}

// Payment request model
class PaymentRequest {
  final double amount;
  final String currency;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String customerCity;
  final String customerCountry;
  final String productName;
  final String productCategory;
  final String productProfile;

  PaymentRequest({
    required this.amount,
    required this.currency,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerCity,
    required this.customerCountry,
    required this.productName,
    required this.productCategory,
    required this.productProfile,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'customer_city': customerCity,
      'customer_country': customerCountry,
      'product_name': productName,
      'product_category': productCategory,
      'product_profile': productProfile,
    };
  }
}

// Payment response model
class PaymentResponse {
  final String status;
  final String message;
  final String gatewayUrl;
  final String sessionKey;
  final String transactionId;

  PaymentResponse({
    required this.status,
    required this.message,
    required this.gatewayUrl,
    required this.sessionKey,
    required this.transactionId,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      gatewayUrl: json['gateway_url'] ?? '',
      sessionKey: json['session_key'] ?? '',
      transactionId: json['transaction_id'] ?? '',
    );
  }
}
