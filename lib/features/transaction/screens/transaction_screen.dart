import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';
import 'package:inventory_management_app/features/transaction/widgets/widgets.dart';
import '../model/transaction_model.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(transactionControllerProvider.notifier);
    final state = ref.watch(transactionControllerProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 3),

      appBar: _buildAppBar(),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Pallete.background],
          ),
        ),
        child: Stack(
          children: [
            _bgIcon(),
            Positioned.fill(
              child: Column(
                children: [
                  HeaderSection(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.isLoading
                        ? CircularProgressIndicator()
                        : _buildContent(state, controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    TransactionState state,
    TransactionController controller,
  ) {
    return state.filteredTransactions.isEmpty
        ? _buildEmptyState(controller)
        : _buildTransactionList(state.filteredTransactions);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Pallete.primary,
      elevation: 0,
      title: const Text(
        'Transactions',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  ListView _buildTransactionList(List<TransactionModel> filteredTransactions) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        return TransactionItem(transaction: filteredTransactions[index]);
      },
    );
  }

  Center _buildEmptyState(TransactionController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => controller.loadInitials(),
            child: Text("Reload"),
          ),
        ],
      ),
    );
  }

  Positioned _bgIcon() {
    return Positioned(
      right: -70,
      bottom: 40,
      child: Icon(
        Icons.receipt_long_rounded,
        color: Pallete.secondary,
        size: 320,
      ),
    );
  }
}
