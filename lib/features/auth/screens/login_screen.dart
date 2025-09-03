import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: loginState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go("/signup"),
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
