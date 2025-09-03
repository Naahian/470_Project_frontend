import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';

// Login state model
@immutable
class LoginState {
  const LoginState({
    this.isLoading = false,
    this.isPasswordObscured = true,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isPasswordObscured;
  final String? errorMessage;

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordObscured,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Login controller
class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(const LoginState());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await AuthService.instance.login(
        emailController.text,
        passwordController.text,
      );

      if (response == null) {
        // Login successful
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        // Login failed
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Login failed: $response',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    } finally {
      // Ensure loading state is always set to false
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
}

// Provider
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
      (ref) => LoginController(),
    );
