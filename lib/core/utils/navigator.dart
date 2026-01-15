import 'package:flutter/material.dart';
import 'package:sandu_app/core/constants/app_routes.dart';
import 'package:sandu_app/core/models/forgot_password_data.dart';

/// 🧭 Navigator terpusat — semua navigasi lewat sini
/// Manfaat:
/// - Hindari string literal rute
/// - Mudah tambah parameter nanti
/// - Bisa tambah analytics/log di sini
class AppNavigator {
  // Login
  static Future<void> goToLogin(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  // Register
  static Future<void> goToRegister(BuildContext context) {
    return Navigator.of(context).pushNamed(AppRoutes.register);
  }

  // Forgot Password
  static Future<void> goToForgotPassword(BuildContext context) {
    return Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  static Future<void> goToOTPScreen(
    BuildContext context,
    ForgotPasswordData data,
  ) {
    return Navigator.of(context).pushNamed(
      AppRoutes.forgotPassword,
      arguments: {'step': 'otp', 'data': data},
    );
  }

  static Future<void> goToResetPasswordScreen(
    BuildContext context,
    ForgotPasswordData data,
  ) {
    return Navigator.of(context).pushNamed(
      AppRoutes.forgotPassword,
      arguments: {'step': 'reset', 'data': data},
    );
  }

  // Home Screen
  static Future<void> goToHomeScreen(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
  }

  // Lapor Cepat
  static Future<void> goToQuickReport(BuildContext context) {
    return Navigator.of(context).pushNamed(AppRoutes.quickReport);
  }

  /// 🔹 Push ke rute baru (tambah ke stack)
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.of(context).pushNamed(routeName);
  }

  /// 🔹 Replace current route (misal: splash → login)
  static Future<T?> replace<T extends Object?>(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.of(context).pushReplacementNamed(routeName);
  }

  /// 🔹 Pop (kembali ke halaman sebelumnya)
  static void pop(BuildContext context, [Object? result]) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }

  // 🔹 Helper spesifik — ini yang membuat kode lebih aman & readable
  // static Future<void> goToLogin(BuildContext context) {
  //   return replace(context, AppRoutes.login);
  // }

  static Future<void> goToHome(BuildContext context) {
    return replace(context, AppRoutes.homeScreen);
  }

  // 🔹 Opsional: splash → login (dipakai di splash_controller)
  static Future<void> finishSplash(BuildContext context) {
    return replace(context, AppRoutes.login);
  }
}
