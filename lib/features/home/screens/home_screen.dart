// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/category/controllers/category_controller.dart';
import 'package:inventory_management_app/features/home/widgets/info_card.dart';
import 'package:inventory_management_app/features/products/controllers/product_controller.dart';
import 'package:inventory_management_app/features/transaction/controller/transaction_controller.dart';
import 'package:inventory_management_app/features/transaction/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionControllerProvider);
    final productState = ref.watch(productControllerProvider);
    final categoryState = ref.watch(categoryControllerProvider);

    final totalProducts = productState.products.length;
    final totalCategories = categoryState.categories.length;
    final revenue = calculateRevenue(transactionState);
    final lowStockCount = checkLowStock(categoryState);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        title: const Text('DASHBOARD'),
        centerTitle: true,
        backgroundColor: Pallete.primary,
        foregroundColor: Colors.white,
        actions: [_buildLogoutBtn(context)],
      ),
      body: SingleChildScrollView(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Pallete.background],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCardSection(
                revenue.toInt(),
                totalProducts,
                totalCategories,
                lowStockCount.toInt(),
              ),
              _buildTitle(context),
              _buildActivity(transactionState),
            ],
          ),
        ),
      ),
    );
  }

  ListView _buildActivity(TransactionState state) {
    final transactions = state.transactions.reversed.toList().sublist(
      0,
      state.transactions.length < 5 ? state.transactions.length : 5,
    );
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: transactions.length,
      padding: EdgeInsets.all(20),
      itemBuilder: (context, index) {
        return TransactionItem(transaction: transactions[index]);
      },
    );
  }

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recent Activity",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => context.go("/transactions"),
            child: Text("See More"),
          ),
        ],
      ),
    );
  }

  Container _buildCardSection(
    int revenue,
    int totalProducts,
    int totalCategories,
    int lowStockCount,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 320,
      decoration: BoxDecoration(
        color: Pallete.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 4 / 3,
        ),
        children: [
          InfoCard(type: InfoCardType.product, value: totalProducts.toDouble()),
          InfoCard(type: InfoCardType.revenue, value: revenue.toDouble()),
          InfoCard(
            type: InfoCardType.category,
            value: totalCategories.toDouble(),
          ),
          InfoCard(type: InfoCardType.stock, value: lowStockCount.toDouble()),
        ],
      ),
    );
  }

  IconButton _buildLogoutBtn(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await AuthService.instance.logout();
        if (context.mounted) {
          context.go('/');
        }
      },
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
    );
  }

  double calculateRevenue(TransactionState state) {
    double total = 0;
    for (var item in state.transactions) {
      if (item.type == "SELL") {
        total += double.parse(item.total_amount);
      } else if (item.type == "ORDER") {
        total -= double.parse(item.total_amount);
      }
    }
    return total;
  }

  double checkLowStock(CategoryState state) {
    int count = 0;
    state.categories.forEach((cat) {
      if (cat.quantity < 50) count++;
    });

    return count.toDouble();
  }
}
