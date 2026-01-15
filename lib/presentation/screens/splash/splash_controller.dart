import 'package:flutter/material.dart';
import 'package:sandu_app/core/utils/navigator.dart';

class SplashController {
  final BuildContext context;

  SplashController(this.context);

  // Navigasi ke login setelah delay
  Future<void> navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    AppNavigator.goToLogin(context); // ← pakai AppNavigator. (bukan navigator.)
  }
}
