import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/services/time_format.dart';
import 'package:inventory_management_app/features/transaction/model/transaction_model.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';
import 'package:inventory_management_app/features/transaction/widgets/widgets.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.all(color: Pallete.surface),
      ),
      child: ListTile(
        onTap: () => _showDetail(context),
        leading: _buildIcon(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildId(), const SizedBox(height: 4), _buildInfo()],
        ),
        subtitle: Text(
          formatDateTime(DateTime.now()), //TODO
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: Text(
          "${transaction.type == "SELL" ? '+' : '-'}${transaction.total_amount}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: transaction.type == "SELL" ? Pallete.success : Pallete.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return TransactionDetail(transactionId: transaction.id);
      },
    );
  }

  Text _buildInfo() {
    return transaction.type == 'order'
        ? Text(
            'Category: CATEGORY', //TODO
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          )
        : Text(
            'By: ${transaction.user_id}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          );
  }

  Text _buildId() {
    return Text(
      '#${transaction.id}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Container _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(transaction),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getTransactionIcon(transaction),
        color: _getIconColor(transaction),
        size: 20,
      ),
    );
  }

  Color _getIconBackgroundColor(TransactionModel transaction) {
    if (transaction.type == 'SELL') {
      return Colors.greenAccent.withAlpha(70);
    } else {
      return Colors.orangeAccent.withAlpha(70);
    }
  }

  Color _getIconColor(TransactionModel transaction) {
    if (transaction.type == 'SELL') {
      return Colors.greenAccent.shade400;
    } else {
      return Colors.orangeAccent.shade400;
    }
  }

  IconData _getTransactionIcon(TransactionModel transaction) {
    if (transaction.type == 'SELL') {
      return Icons.attach_money;
    } else {
      return Icons.shopping_cart;
    }
  }
}
