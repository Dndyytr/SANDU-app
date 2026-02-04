import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandu_app/core/themes/app_theme.dart'; // ← tambahkan import
import 'presentation/routes.dart' as routes;

void main() async {
  // 1. Pastikan binding framework sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Kunci orientasi ke Portrait Up (dan Down jika perlu)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown, // Opsional jika ingin mendukung posisi terbalik
  ]);
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
