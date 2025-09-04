import 'package:flutter/material.dart';

class PaymentResultWidget extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback? onContinue;
  final VoidCallback? onRetry;

  const PaymentResultWidget({
    Key? key,
    required this.isSuccess,
    this.onContinue,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            size: 80,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            isSuccess ? 'Payment Successful!' : 'Payment Failed!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            isSuccess
                ? 'Your payment has been processed successfully.'
                : 'There was an error processing your payment.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSuccess ? onContinue : onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isSuccess ? 'Continue' : 'Try Again',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
