import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/order/models/payment_model.dart';
import 'package:inventory_management_app/features/order/payment_service.dart';

import '../widgets/widgets.dart';

// Payment state provider

class PaymentScreen extends ConsumerWidget {
  final OrderDetails orderDetails;

  const PaymentScreen({Key? key, required this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentStateProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: _buildBody(context, ref, paymentState),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        'Payment Gateway',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PaymentState paymentState,
  ) {
    switch (paymentState) {
      case PaymentState.gateway:
        return const PaymentGatewayWidget();
      case PaymentState.success:
        return PaymentResultWidget(
          isSuccess: true,
          onContinue: () => onContinue(context, ref),
        );
      case PaymentState.failed:
        return PaymentResultWidget(
          isSuccess: false,
          onRetry: () => ref.read(paymentStateProvider.notifier).state =
              PaymentState.initial,
        );
      default:
        return PaymentFormWidget(
          orderDetails: orderDetails,
          paymentState: paymentState,
        );
    }
  }

  void onContinue(BuildContext context, WidgetRef ref) {
    ref.read(paymentStateProvider.notifier).state = PaymentState.initial;
    Navigator.of(context).pop();
  }
}
