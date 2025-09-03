import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/transaction/controller/payment_controller.dart';
import 'package:url_launcher/url_launcher.dart';

// Gateway URL provider
final gatewayUrlProvider = StateProvider<String>((ref) => '');

// Payment Gateway Widget with URL Launcher
class PaymentGatewayWidget extends ConsumerStatefulWidget {
  const PaymentGatewayWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentGatewayWidget> createState() =>
      _PaymentGatewayWidgetState();
}

class _PaymentGatewayWidgetState extends ConsumerState<PaymentGatewayWidget> {
  bool _isLaunching = false;
  bool _launchFailed = false;

  @override
  void initState() {
    super.initState();
    // Launch the payment URL when the widget is initialized
    _launchPaymentUrl();
  }

  Future<void> _launchPaymentUrl() async {
    setState(() {
      _isLaunching = true;
      _launchFailed = false;
    });

    try {
      final gatewayUrl = ref.read(gatewayUrlProvider);
      final uri = Uri.parse(gatewayUrl);

      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );

        if (!launched) {
          throw Exception('Could not launch payment URL');
        }

        // Since we're opening in external browser, we can't track URL changes
        // You'll need to handle payment status through other means:
        // - Webhooks from your backend
        // - Periodic status checks
        // - Deep linking when user returns to app
      } else {
        throw Exception('Cannot handle payment URL');
      }
    } catch (e) {
      setState(() {
        _launchFailed = true;
      });
      // You might want to show an error message or retry option
    } finally {
      setState(() {
        _isLaunching = false;
      });
    }
  }

  void _checkPaymentStatus() {
    // Implement this method to check payment status from your backend
    // This could be:
    // 1. API call to check payment status
    // 2. Webhook listener
    // 3. Manual status check triggered by user

    // Example:
    // ref.read(paymentControllerProvider).checkPaymentStatus().then((status) {
    //   if (status == 'success') {
    //     ref.read(paymentStateProvider.notifier).state = PaymentState.success;
    //   } else if (status == 'failed') {
    //     ref.read(paymentStateProvider.notifier).state = PaymentState.failed;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLaunching) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Opening payment gateway...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please complete the payment in your browser',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ] else if (_launchFailed) ...[
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Failed to open payment gateway',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please check your internet connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _launchPaymentUrl,
              child: const Text('Retry'),
            ),
          ] else ...[
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment gateway opened',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please complete the payment in your browser and return to this app',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _launchPaymentUrl,
              child: const Text('Reopen Payment Link'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _checkPaymentStatus,
              child: const Text('Check Payment Status'),
            ),
          ],
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              ref.read(paymentStateProvider.notifier).state =
                  PaymentState.initial;
            },
            child: const Text('Cancel Payment'),
          ),
        ],
      ),
    );
  }
}

// Payment Result Widget (unchanged)
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
