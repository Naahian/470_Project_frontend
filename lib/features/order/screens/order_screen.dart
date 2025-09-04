import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/category/category.dart';
import 'package:inventory_management_app/features/order/models/payment_model.dart';
import 'package:inventory_management_app/features/suppliers/controller/supplier_controller.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';

// Providers for state management
final supplierProvider = StateProvider<String?>((ref) => null);
final productCategoryProvider = StateProvider<String?>((ref) => null);
final quantityProvider = StateProvider<int>((ref) => 0);
final selectedTabProvider = StateProvider<int>((ref) => 0);

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSupplier = ref.watch(supplierProvider);
    final selectedCategory = ref.watch(productCategoryProvider);
    final quantity = ref.watch(quantityProvider);
    final selectedTab = ref.watch(selectedTabProvider);

    final supplierState = ref.watch(supplierControllerProvider);
    final categoryState = ref.watch(categoryControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Supplier Company Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Supplier Company',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedSupplier,
                    decoration: const InputDecoration(
                      hintText: 'Select',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    onChanged: (value) {
                      ref.read(supplierProvider.notifier).state = value;
                    },
                    items: supplierState.suppliers
                        .map(
                          (cat) => DropdownMenuItem(
                            value: '${cat.id}',
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Product Category Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      hintText: 'Select',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    onChanged: (value) {
                      ref.read(productCategoryProvider.notifier).state = value;
                    },
                    items: categoryState.categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: '${cat.id}',
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quantity Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      ref.read(quantityProvider.notifier).state =
                          int.tryParse(value) ?? 0;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Place Order Button
            ElevatedButton(
              onPressed: () {
                ref.read(transactionControllerProvider.notifier).createOrder();
                context.push(
                  "/payment",
                  extra: OrderDetails(
                    supplier: selectedSupplier!,
                    category: selectedCategory!,
                    quantity: quantity,
                    amount: quantity.toDouble(),
                  ),
                );
              },
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 16),

            // Add New Supplier Button
            OutlinedButton(
              onPressed: () {
                // Handle add new supplier action
                ref
                    .read(supplierControllerProvider.notifier)
                    .fetchAllSuppliers();
              },
              child: const Text(
                'Add New Supplier',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Create Order',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showOrderConfirmation(
    BuildContext context,
    String? supplier,
    String? category,
    int quantity,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmation'),
        content: Text(
          'Order Details:\n'
          'Supplier: ${supplier ?? 'Not selected'}\n'
          'Category: ${category ?? 'Not selected'}\n'
          'Quantity: $quantity',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showAddSupplierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Supplier'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Supplier Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Supplier added successfully!')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
