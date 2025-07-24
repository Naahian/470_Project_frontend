import 'package:flutter/material.dart';
import 'package:inventory_management_app/features/auth/screens/auth_wrapper.dart';
import 'package:inventory_management_app/features/auth/screens/screens.dart';
import 'package:inventory_management_app/features/home/screens/home_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    // redirect: _handleRedirect,
    routes: [
      GoRoute(path: root, builder: (context, state) => AuthWrapper()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
    ],
  );

  // Simulate auth check (replace with real logic)
  static Future<bool> isAuthenticated() async {
    await Future.delayed(const Duration(seconds: 2));
    return false; // change to true to simulate a logged-in user
  }

  // Redirect logic
  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuth = await isAuthenticated();

    final loggingIn = state.path == login || state.path == signup;

    if (!isAuth) {
      return loggingIn ? null : login;
    }

    if (isAuth && loggingIn) {
      return home;
    }

    return null;
  }
}
