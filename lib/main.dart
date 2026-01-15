import 'package:flutter/material.dart';
import 'package:sandu_app/core/themes/app_theme.dart'; // ← tambahkan import
import 'presentation/routes.dart' as routes;

void main() {
  runApp(const SanduApp());
}

class SanduApp extends StatelessWidget {
  const SanduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandu App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, // ← gunakan tema di sini!
      onGenerateRoute: routes.AppRoutes.generateRoute,
      initialRoute: '/',
    );
  }
}
