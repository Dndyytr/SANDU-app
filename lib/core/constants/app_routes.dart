/// Nama rute aplikasi — hindari string literal seperti '/login'
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String homeScreen = '/home-screen';
  static const String quickReport = '/quick-report';

  // 🔹 Helper untuk push/navigate (opsional, bisa dipindah ke utils/navigator.dart nanti)
  static String loginRoute() => login;
}
