import 'package:flutter/material.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:inventory_management_app/features/auth/screens/screens.dart';
import 'package:inventory_management_app/features/category/screens/category_screen.dart';
import 'package:inventory_management_app/features/home/screens/home_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/features/products/screens/product_screen.dart';
import 'package:inventory_management_app/features/transaction/model/payment_model.dart';
import 'package:inventory_management_app/features/transaction/screens/payment_screen.dart';
import 'package:inventory_management_app/features/transaction/screens/shipment_screen.dart';
import 'package:inventory_management_app/features/transaction/screens/transaction_screen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String products = '/products';
  static const String category = '/category';
  static const String transactions = '/transactions';
  static const String shipment = '/shipment';
  static const String payment = '/payment';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    redirect: _handleRedirect,
    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: products,
        builder: (context, state) => const ProductScreen(),
      ),
      GoRoute(path: category, builder: (context, state) => CategoryScreen()),
      GoRoute(
        path: transactions,
        builder: (context, state) => TransactionsScreen(),
      ),
      GoRoute(
        path: payment,
        builder: (context, state) {
          final orderDetails = state.extra as OrderDetails?;
          if (orderDetails == null) {
            // Handle null case - redirect to previous screen or show error
            return const Scaffold(
              body: Center(child: Text('Invalid order details')),
            );
          }
          return PaymentScreen(orderDetails: orderDetails);
        },
      ),
      GoRoute(path: shipment, builder: (context, state) => ShipmentScreen()),
    ],
  );

  static void navigateToLogin() {
    navigatorKey.currentContext?.go('/login');
  }

  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      final isAuth = await AuthService.instance.authenticated();
      final currentPath = state.path;

      // If user is NOT authenticated and trying to access protected routes
      if (!isAuth) {
        // Allow access to login and signup pages
        if (currentPath == login || currentPath == signup) {
          return null; // No redirect needed
        }
        // Redirect to login for any other page
        return login;
      }

      // If user IS authenticated
      if (isAuth) {
        // If trying to access auth pages (login/signup), redirect to home
        if (currentPath == login || currentPath == signup) {
          return home;
        }
      }

      return null; // No redirect needed
    } catch (e) {
      // If there's any error, redirect to login for safety
      return login;
    }
  }
}
