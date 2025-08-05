// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/core/widgets/bottomnavbar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current user info from your auth provider
    // final user = ref.read(authProvider.notifier).currentUser;
    final service = AuthService.instance;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: Pallete.primary,
        foregroundColor: Colors.white,
        actions: [_buildLogoutBtn(context)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Finished Features: PRODUCT, CATEGORY")],
        ),
      ),
    );
  }

  IconButton _buildLogoutBtn(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final response = await AuthService.instance.logout();
        context.go('/');
      },
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
    );
  }
}
