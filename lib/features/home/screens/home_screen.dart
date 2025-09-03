// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';
import 'package:inventory_management_app/features/home/widgets/info_card.dart';
import 'package:inventory_management_app/features/products/widgets/product_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildCardSection(), _buildTitle(), _buildActivity()],
          ),
        ),
      ),
    );
  }

  ListView _buildActivity() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile();
      },
    );
  }

  Text _buildTitle() {
    return Text(
      "Recent Activity",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Container _buildCardSection() {
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
          InfoCard(type: InfoCardType.product, value: 12133),
          InfoCard(type: InfoCardType.revenue, value: 1233.11),
          InfoCard(type: InfoCardType.category, value: 33),
          InfoCard(type: InfoCardType.stock, value: 3),
        ],
      ),
    );
  }

  IconButton _buildLogoutBtn(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await AuthService.instance.logout();
        context.go('/');
      },
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
    );
  }
}
