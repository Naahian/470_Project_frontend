import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/transaction/controller/payment_controller.dart';
import 'package:inventory_management_app/features/transaction/model/payment_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';

class PaymentScreen extends ConsumerWidget {
  final OrderDetails orderDetails;

  const PaymentScreen({Key? key, required this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentStateProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref, paymentState),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // Show confirmation dialog if payment is in progress
          if (ref.read(paymentStateProvider) == PaymentState.gateway) {
            _showCancelConfirmationDialog(context, ref);
          } else {
            Navigator.of(context).pop();
          }
        },
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
        return PaymentGatewayWidget();
      case PaymentState.success:
        return PaymentResultWidget(
          isSuccess: true,
          onContinue: () => Navigator.of(context).pop(),
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

  void _showCancelConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Payment?'),
          content: const Text('Are you sure you want to cancel this payment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(paymentStateProvider.notifier).state =
                    PaymentState.initial;
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
