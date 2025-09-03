import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentStateProvider = StateProvider<PaymentState>(
  (ref) => PaymentState.initial,
);

enum PaymentState { initial, loading, gateway, success, failed }
