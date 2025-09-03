import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/auth/auth_service.dart';

// Signup state model
@immutable
class SignupState {
  const SignupState({
    this.isLoading = false,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final String? errorMessage;

  SignupState copyWith({
    bool? isLoading,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    String? errorMessage,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Signup controller
class SignupController extends StateNotifier<SignupState> {
  SignupController() : super(const SignupState());

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
    );
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  Future<bool> signup() async {
    if (!formKey.currentState!.validate()) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await AuthService.instance.register(
        usernameController.text,
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      state = state.copyWith(isLoading: false);

      if (response == null) {
        // Signup successful
        return true;
      } else {
        // Signup failed
        state = state.copyWith(errorMessage: response);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
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
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

// Provider
final signupControllerProvider =
    StateNotifierProvider<SignupController, SignupState>(
      (ref) => SignupController(),
    );
