import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/core/constants.dart';
import 'package:inventory_management_app/features/auth/controllers/signup_controller.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupControllerProvider);
    final signupController = ref.read(signupControllerProvider.notifier);

    // Listen to state changes and show error messages or navigate on success
    ref.listen<SignupState>(signupControllerProvider, (previous, current) {
      if (current.errorMessage != null &&
          current.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: Form(
        key: signupController.formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset("assets/background.png", fit: BoxFit.cover),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                margin: const EdgeInsets.only(top: 120),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(Icons.person_add, size: 80, color: Colors.blue),
                    const SizedBox(height: 20),
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildNameInput(signupController),
                    const SizedBox(height: 16),
                    _buildUsernameInput(signupController),
                    const SizedBox(height: 16),
                    _buildEmailInput(signupController),
                    const SizedBox(height: 16),
                    _buildPasswordInput(signupController, signupState),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordInput(signupController, signupState),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: signupState.isLoading
                          ? null
                          : () async {
                              final success = await signupController.signup();
                              if (success && context.mounted) {
                                context.go('/login');
                              }
                            },
                      child: signupState.isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account? Login'),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameInput(SignupController controller) {
    return TextFormField(
      controller: controller.nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: controller.validateName,
      onChanged: (_) => controller.clearError(),
    );
  }

  Widget _buildUsernameInput(SignupController controller) {
    return TextFormField(
      controller: controller.usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        prefixIcon: Icon(Icons.account_circle),
        border: OutlineInputBorder(),
      ),
      validator: controller.validateUsername,
      onChanged: (_) => controller.clearError(),
    );
  }

  Widget _buildEmailInput(SignupController controller) {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      validator: controller.validateEmail,
      onChanged: (_) => controller.clearError(),
    );
  }

  Widget _buildPasswordInput(SignupController controller, SignupState state) {
    return TextFormField(
      controller: controller.passwordController,
      obscureText: state.isPasswordObscured,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: controller.togglePasswordVisibility,
          icon: Icon(
            state.isPasswordObscured ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      validator: controller.validatePassword,
      onChanged: (_) => controller.clearError(),
    );
  }

  Widget _buildConfirmPasswordInput(
    SignupController controller,
    SignupState state,
  ) {
    return TextFormField(
      controller: controller.confirmPasswordController,
      obscureText: state.isConfirmPasswordObscured,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: controller.toggleConfirmPasswordVisibility,
          icon: Icon(
            state.isConfirmPasswordObscured
                ? Icons.visibility
                : Icons.visibility_off,
          ),
        ),
      ),
      validator: controller.validateConfirmPassword,
      onChanged: (_) => controller.clearError(),
    );
  }
}
