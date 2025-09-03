// Payment Form Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/transaction/controller/payment_controller.dart';
import 'package:inventory_management_app/features/transaction/model/payment_model.dart';
import 'package:inventory_management_app/features/transaction/model/transaction_service.dart';
import 'package:inventory_management_app/features/transaction/widgets/order_card.dart';
import 'package:inventory_management_app/features/transaction/widgets/payment_gateway.dart';

class PaymentFormWidget extends ConsumerStatefulWidget {
  final OrderDetails orderDetails;
  final PaymentState paymentState;

  const PaymentFormWidget({
    super.key,
    required this.orderDetails,
    required this.paymentState,
  });

  @override
  ConsumerState<PaymentFormWidget> createState() => _PaymentFormWidgetState();
}

class _PaymentFormWidgetState extends ConsumerState<PaymentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '01970027387');
  final _addressController = TextEditingController(
    text: '123 Main Street, Gulshan-2',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderSummaryCard(orderDetails: widget.orderDetails),
            const SizedBox(height: 24),
            CustomerInfoCard(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              addressController: _addressController,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.paymentState == PaymentState.loading
                  ? null
                  : () => _initiatePayment(),
              child: Text("Checkout Order"),
            ),
          ],
        ),
      ),
    );
  }

  void _initiatePayment() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(paymentStateProvider.notifier).state = PaymentState.loading;

    final paymentRequest = PaymentRequest(
      amount: widget.orderDetails.amount,
      currency: 'BDT',
      customerName: _nameController.text,
      customerEmail: _emailController.text,
      customerPhone: _phoneController.text,
      customerAddress: _addressController.text,
      customerCity: 'Dhaka',
      customerCountry: 'Bangladesh',
      productName:
          '${widget.orderDetails.category} - ${widget.orderDetails.supplier}',
      productCategory: widget.orderDetails.category,
      productProfile: 'digital-goods',
    );

    try {
      final transactionService = TransactionService();
      final response = await transactionService.makePayment(
        paymentRequest.toJson(),
      );

      final paymentResponse = PaymentResponse.fromJson(response);

      if (paymentResponse.status == 'success') {
        // Store gateway URL for webview
        ref.read(gatewayUrlProvider.notifier).state =
            paymentResponse.gatewayUrl;
        ref.read(paymentStateProvider.notifier).state = PaymentState.gateway;
      } else {
        ref.read(paymentStateProvider.notifier).state = PaymentState.failed;
      }
    } catch (e) {
      print('Payment error: $e');
      ref.read(paymentStateProvider.notifier).state = PaymentState.failed;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
