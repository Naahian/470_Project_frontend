import 'package:flutter/material.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';
import 'package:inventory_management_app/features/auth/screens/screens.dart';
import 'package:inventory_management_app/features/category/category_screen.dart';
import 'package:inventory_management_app/features/home/screens/home_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/features/products/screens/product_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String products = '/products';
  static const String category = '/category';

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
    ],
  );

  // Redirect logic
  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuth = await AuthService.instance.authenticated();
    final loggingIn = state.path == login || state.path == signup;

    if (!isAuth && !loggingIn) {
      return login;
    }

    if (isAuth && loggingIn) {
      return home;
    }

    return null;
  }
}
