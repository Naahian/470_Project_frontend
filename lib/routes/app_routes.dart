import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:inventory_management_app/features/auth/screens/screens.dart';
import 'package:inventory_management_app/features/category/screens/category_screen.dart';
import 'package:inventory_management_app/features/home/screens/home_screen.dart';
import 'package:inventory_management_app/features/order/screens/order_screen.dart';
import 'package:inventory_management_app/features/products/screens/product_screen.dart';
import 'package:inventory_management_app/features/order/models/payment_model.dart';
import 'package:inventory_management_app/features/order/screens/payment_screen.dart';
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
  static const String order = '/order';
  static const String payment = '/payment';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey, // Add this line
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
            // Instead of showing error screen, redirect back
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(order); // or wherever you want to redirect
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return PaymentScreen(orderDetails: orderDetails);
        },
      ),
      GoRoute(path: order, builder: (context, state) => OrderScreen()),
    ],
  );

  static void navigateToLogin() {
    router.go(login); // Use router.go instead of context
  }

  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      final currentPath = state.path ?? state.matchedLocation;

      // Don't redirect during splash screen or initial loading
      if (currentPath == null) {
        return null;
      }

      final isAuth = await AuthService.instance.authenticated();

      print("Auth status: $isAuth, Current path: $currentPath");

      // If user is NOT authenticated
      if (!isAuth) {
        // Allow access to login and signup pages
        if (currentPath == login || currentPath == signup) {
          return null;
        }
        // For initial route (home), redirect to login
        if (currentPath == home) {
          print("Redirecting unauthenticated user to login");
          return login;
        }
        // For other protected routes, redirect to login
        print("Redirecting to login from $currentPath");
        return login;
      }

      // If user IS authenticated
      if (isAuth) {
        print("##### User authenticated! Current path: $currentPath ########");
        // If trying to access auth pages, redirect to home
        if (currentPath == login || currentPath == signup) {
          print("Redirecting authenticated user from $currentPath to home");
          return home;
        }
        // Allow access to all other pages when authenticated
        return null;
      }

      return null;
    } catch (e) {
      print("Redirect error: $e");
      // Only redirect to login if we're not already on login/signup
      final currentPath = state.path ?? state.matchedLocation;
      if (currentPath != login && currentPath != signup) {
        return login;
      }
      return null;
    }
  }
}
