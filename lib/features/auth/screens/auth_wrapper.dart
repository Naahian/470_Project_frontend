import 'package:flutter/material.dart';
import 'package:inventory_management_app/features/home/screens/home_screen.dart';
import 'screens.dart';

class AuthWrapper extends StatelessWidget {
  Future<bool> checkAuthStatus() async {
    await Future.delayed(Duration(seconds: 2));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.hasData && snapshot.data == true) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
