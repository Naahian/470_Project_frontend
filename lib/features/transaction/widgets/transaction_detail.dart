import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/time_format.dart';
import 'package:inventory_management_app/features/transaction/model/transactiondetail_model.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';

class TransactionDetail extends ConsumerStatefulWidget {
  final int transactionId;

  const TransactionDetail({super.key, required this.transactionId});

  @override
  ConsumerState<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends ConsumerState<TransactionDetail> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final controller = ref.read(transactionControllerProvider.notifier);
      controller.getSingleTransaction(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionControllerProvider);
    final bool isSell = state.selectedType == 'SELL';

    return Container(
      padding: EdgeInsets.all(8),
      child: state.loadingSelected
          ? loadingWidget()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...(isSell
                      ? buildSellInfo(state.selectedTransaction as SellModel)
                      : buildOrderInfo(
                          state.selectedTransaction as OrderModel,
                        )),
                ],
              ),
            ),
    );
  }

  SizedBox loadingWidget() {
    return SizedBox(
      height: 300,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  List<Widget> buildSellInfo(SellModel sell) {
    return [
      _buildTile(Icons.receipt, 'Sale ID', '#${sell.id}'),
      _buildTile(Icons.person, 'Customer ID', 'User #${sell.userId}'),
      _buildTile(Icons.calendar_today, 'Date', formatDateTime(sell.timestamp)),
      _buildTile(Icons.access_time, 'Time', formatTime(sell.timestamp)),
      _buildTile(
        Icons.attach_money,
        'Total Amount',
        '\$${sell.totalAmount.toStringAsFixed(2)}',
      ),
      _buildTile(Icons.inventory, 'Products', '${sell.products.length} items'),
      _buildTile(
        Icons.info_outline,
        'Type',
        sell.type.toString().split('.').last,
      ),

      const SizedBox(height: 10),
      if (sell.products.isNotEmpty) _soldItems(sell.products),
      const SizedBox(height: 16),
    ];
  }

  Column _soldItems(List<int> products) {
    return Column(
      children: [
        Text(
          'Sold Products(ID): ${products.join(', ')}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Widget> buildOrderInfo(OrderModel order) {
    return [
      _buildTile(Icons.receipt, 'Order ID', '#${order.id}'),
      _buildTile(
        Icons.local_shipping,
        'Supplier',
        'Supplier #${order.supplierId}',
      ),
      _buildTile(Icons.payment, 'Payment ID', order.paymentId),
      _buildTile(
        Icons.calendar_today,
        'Order Date',
        formatDateTime(order.timestamp),
      ),
      _buildTile(
        Icons.event_available,
        'Delivery Date',

        formatDateTime(order.deliveryDate),
      ),
      _buildTile(
        Icons.attach_money,
        'Total Amount',
        '\$${order.totalAmount.toStringAsFixed(2)}',
      ),
      _buildTile(
        Icons.format_list_numbered,
        'Quantity',
        '${order.quantity} units',
      ),
      _buildTile(
        Icons.category,
        'Category Id',
        order.categoryId.toString().split('.').last,
      ),

      _buildTile(
        Icons.info_outline,
        'Type',
        order.type.toString().split('.').last,
      ),
      _buildTile(
        Icons.local_shipping,
        'Delivery Status',
        order.isDelivered ? 'Delivered' : 'Pending',
      ),
      _buildTile(Icons.person, 'Ordered By', 'User #${order.userId}'),

      const SizedBox(height: 16),

      // Delivery status indicator
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: order.isDelivered ? Colors.green[50] : Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: order.isDelivered ? Colors.green : Colors.orange,
          ),
        ),
        child: Row(
          children: [
            Icon(
              order.isDelivered ? Icons.check_circle : Icons.pending,
              color: order.isDelivered ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              order.isDelivered ? 'Order Delivered' : 'Awaiting Delivery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: order.isDelivered ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  ListTile _buildTile(IconData icon, String label, String value) {
    return ListTile(
      minVerticalPadding: 10,
      leading: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Pallete.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(label),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
