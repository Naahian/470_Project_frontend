import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/order/payment_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

final gatewayUrlProvider = StateProvider<String>((ref) => '');

// Provider to store payment response data
final paymentResponseProvider = StateProvider<Map<String, dynamic>?>(
  (ref) => null,
);

// Payment Gateway WebView Widget
class PaymentGatewayWidget extends ConsumerStatefulWidget {
  const PaymentGatewayWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentGatewayWidget> createState() =>
      _PaymentGatewayWidgetState();
}

class _PaymentGatewayWidgetState extends ConsumerState<PaymentGatewayWidget> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    final gatewayUrl = ref.read(gatewayUrlProvider);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            _handleUrlChange(change.url ?? '');
          },
          onPageFinished: (url) {
            _handlePageFinished(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(gatewayUrl));
  }

  void _handleUrlChange(String url) {
    print("🌐 URL Changed: $url");

    if (url.contains('payment/success')) {
      ref.read(paymentStateProvider.notifier).state = PaymentState.success;
      _extractPaymentData(url);
    } else if (url.contains('fail') || url.contains('cancel')) {
      ref.read(paymentStateProvider.notifier).state = PaymentState.failed;
    }
  }

  void _handlePageFinished(String url) {
    print("📄 Page Finished: $url");

    if (url.contains('payment/success')) {
      // Try to get JSON data from the page content
      // _getPageContent();
    }
  }

  Future _extractPaymentData(String url) async {
    try {
      final uri = Uri.parse(url);
      final queryParameters = await Dio().get(url);

      print("🔍 Query Parameters: $queryParameters");

      if (queryParameters.data.isNotEmpty) {
        // Store query parameters as payment response
        ref.read(paymentResponseProvider.notifier).state = queryParameters.data;
        print("✅ Payment data extracted from URL: ${queryParameters.data}");
      }
    } catch (e) {
      print("❌ Error extracting payment data from URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}

// Consumer widget to display payment response data
class PaymentResponseDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentResponse = ref.watch(paymentResponseProvider);

    if (paymentResponse == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
        color: Colors.green.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Response:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            const JsonEncoder.withIndent('  ').convert(paymentResponse),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

// Usage example in your payment screen:
/*
class PaymentScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentStateProvider);
    final paymentResponse = ref.watch(paymentResponseProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Column(
        children: [
          Expanded(
            child: const PaymentGatewayWidget(),
          ),
          if (paymentState == PaymentState.success && paymentResponse != null)
            PaymentResponseDisplay(),
        ],
      ),
    );
  }
}
*/
