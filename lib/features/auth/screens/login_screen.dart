import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management_app/core/constants.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControllerProvider);
    final loginController = ref.read(loginControllerProvider.notifier);

    // Listen to state changes and show error messages
    ref.listen<LoginState>(loginControllerProvider, (previous, current) {
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/background.png", fit: BoxFit.cover),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(top: 200.0),

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
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Form(
                key: loginController.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.inventory, size: 80, color: Colors.blue),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: loginController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: loginController.validateEmail,
                      onChanged: (_) => loginController.clearError(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: loginController.passwordController,
                      obscureText: loginState.isPasswordObscured,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: loginController.togglePasswordVisibility,
                          icon: Icon(
                            loginState.isPasswordObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: loginController.validatePassword,
                      onChanged: (_) => loginController.clearError(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: loginState.isLoading
                          ? null
                          : () async {
                              final success = await loginController.login();
                              if (success && context.mounted) {
                                context.go("/");
                              }
                            },

                      child: loginState.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: const CircularProgressIndicator(),
                            )
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),
                    Text("Don't have an account?", textAlign: TextAlign.center),
                    OutlinedButton(
                      onPressed: () => context.go("/signup"),
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
