import 'package:flutter/material.dart';

/// Palette warna utama aplikasi Sandu App
/// Sesuaikan dengan desain Figma Anda (misal: primary = ungu)
class AppColors {
  // 🔹 Warna Utama
  static const Color primary = Color(0xFF194D4D);
  static const Color secondary = Color(0xFFE8AC00);
  static const Color tertiary = Color(0xFFD7D7D7);

  // Orange
  static const Color orange1 = Color(0xFFF9D75C);
  static const Color orange2 = Color(0xFF916F27);
  static const Color orange3 = Color(0xFFF9D75C);
  static const Color orange4 = Color(0xFFF7BD42);
  static const Color orange5 = Color(0xFFFBBC05);
  static const Color orange6 = Color(0xFFFFDB5B);
  static const Color orange7 = Color(0xFFFFF2C3);
  static const Color orange8 = Color(0xFFFFF8E1);
  static const Color orange9 = Color(0xFFFFE68B);
  static const Color orange10 = Color(0xFFFFF7E2);

  // White
  static const Color white1 = Color(0xFFE9FFFD);
  static const Color white2 = Color(0xFFCEF3EF);
  static const Color white3 = Color(0xFFE0F7F4);
  static const Color white4 = Color(0xFFC1F6F0);

  // Cyan
  static const Color cyan1 = Color(0xFF50AA9E);
  static const Color cyan2 = Color(0xFF9BDDD4);
  static const Color cyan3 = Color(0xFF2D6868);

  // gray
  static const Color gray1 = Color(0xFFB1B5B4);

  // red
  static const Color red1 = Color(0xFFCD0000);
  static const Color red2 = Color(0xFFFFD0D0);
  static const Color red3 = Color(0xFFFF9696);

  // pink
  static const Color pink1 = Color(0xFFFF386A);

  // green
  static const Color green1 = Color(0xFF80D108);
  static const Color green2 = Color(0xFFEFFFD6);

  static const Color hint = Color(0xFF697773);
  static const Color background = Color(0xFF74DED0);
  static const Color background2 = Color(0xFFF7FFFE);
  static const Color divider = Color(0xFF74DED0);

  // Warna Text
  static const Color textPrimary = Color(0xFF3C4240);
  static const Color textSecondary = Color(0xFF697773);

  // 🔹 Status
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;

  // 🔹 Gradient (opsional, untuk background splash/login)
  static const List<Color> gradientPurple = [
    Color(0xFFE0B0FF), // light purple
    Color(0xFF9C47C1), // medium purple
  ];
}
