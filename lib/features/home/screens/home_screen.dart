// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/core/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current user info from your auth provider
    // final user = ref.read(authProvider.notifier).currentUser;
    final service = AuthService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final response = await AuthService.instance.logout();
              context.go('/');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appIcon(),
            const SizedBox(height: 30),
            appName(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => service.storeToken("ABJHsd@@1212"),
              child: Text("Store Token"),
            ),
            ElevatedButton(
              onPressed: () => service.getToken().then((value) => print(value)),
              child: Text("Get Token"),
            ),
            ElevatedButton(
              onPressed: () => service.clearTokens(),
              child: Text("Clear Token"),
            ),
          ],
        ),
      ),
    );
  }

  Text appName() {
    return const Text(
      'Inventory Manager',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Container appIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.inventory_2, size: 80, color: Colors.blue.shade700),
    );
  }
}
