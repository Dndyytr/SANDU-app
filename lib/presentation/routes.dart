import 'package:flutter/material.dart';
import 'package:sandu_app/core/models/forgot_password_data.dart';
import 'package:sandu_app/presentation/screens/forgot_password/otp_step_screen.dart';
import 'package:sandu_app/presentation/screens/forgot_password/reset_password_screen.dart';
import 'package:sandu_app/presentation/screens/home/home_wrapper.dart';
import 'package:sandu_app/presentation/screens/quick_report/quick_report_screen.dart';
import 'screens/forgot_password/email_step_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        // 🔹 Slide-up transition
        return _buildSlideYRoute(() => const RegisterScreen());

      case '/forgot-password':
        final args = settings.arguments;

        // 🔹 Tahap 2: OTP
        if (args is Map<String, dynamic> &&
            args['step'] == 'otp' &&
            args['data'] is ForgotPasswordData) {
          final data = args['data'] as ForgotPasswordData;
          return _buildSlideXRoute(() => OTPStepScreen(data: data));
        }

        // 🔹 Tahap 3: Reset Password
        if (args is Map<String, dynamic> &&
            args['step'] == 'reset' &&
            args['data'] is ForgotPasswordData) {
          final data = args['data'] as ForgotPasswordData;
          return _buildSlideXRoute(() => ResetPasswordScreen(data: data));
        }

        // 🔹 Default: Tahap 1 (Email/Phone)
        return _buildSlideXRoute(() => const EmailStepScreen());

      case '/home-screen':
        return _buildSlideYRoute(() => const HomeWrapper());
      case '/quick-report':
        return _buildSlideYRoute(() => const QuickReportScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('404'))),
        );
    }
  }

  /// Helper: reusable slide-up route
  static PageRouteBuilder _buildSlideXRoute(Widget Function() builder) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => builder(),
      transitionsBuilder: (_, animation, __, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: slideAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 500),
    );
  }

  static PageRouteBuilder _buildSlideYRoute(Widget Function() builder) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => builder(),
      transitionsBuilder: (_, animation, __, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: slideAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 900),
      reverseTransitionDuration: const Duration(milliseconds: 700),
    );
  }
}
