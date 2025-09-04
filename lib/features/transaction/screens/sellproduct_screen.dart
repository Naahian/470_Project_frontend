// screens/transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/products/models/product_model.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';

class SellproductScreen extends ConsumerWidget {
  const SellproductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionControllerProvider);
    final transactionController = ref.read(
      transactionControllerProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
        centerTitle: true,
        backgroundColor: Pallete.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Items List
            Expanded(
              child: ListView.builder(
                itemCount: transactionState.selectedProducts.length,
                itemBuilder: (context, index) {
                  final product = transactionState.selectedProducts[index];
                  return _buildTransactionItem(
                    product,
                    index,
                    transactionController,
                  );
                },
              ),
            ),

            // Total Amount
            _buildTotalAmount(transactionController.productTotalAmount()),

            const SizedBox(height: 16),

            // Confirm Button
            _buildConfirmButton(
              transactionState.isLoading,
              transactionController,
              context,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    ProductModel product,
    int index,
    TransactionController notifier,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        title: Text(
          "${product.id}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.updatedAt}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Category: ${product.categoryName}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              '#${product.id}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Text(
          '\$100',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmount(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total :',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(
    bool isLoading,
    TransactionController notifier,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                notifier.createSell();
                Navigator.pop(context);
              },
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Confirm Transaction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
