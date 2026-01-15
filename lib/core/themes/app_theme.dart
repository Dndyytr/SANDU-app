import 'package:flutter/material.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class AppTheme {
  /// 🌞 Tema Light (default)
  static final ThemeData light = _buildLightTheme();

  /// 🌙 Tema Dark (opsional — bisa dikembangkan nanti)
  static final ThemeData dark = _buildDarkTheme();

  // 🔹 Builder untuk tema light
  static ThemeData _buildLightTheme() {
    final base = ThemeData.light(); // mulai dari tema dasar Flutter

    return base.copyWith(
      // 🔸 Warna dasar aplikasi
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        // secondary: AppColors.primaryLight,
        // background: AppColors.background,
        // surface: AppColors.surface,
        // onPrimary: Colors.white,
        // onSecondary: Colors.white,
        // onBackground: AppColors.textPrimary,
        // onSurface: AppColors.textPrimary,
        onError: Colors.white,
        error: AppColors.error,
      ),

      // 🔸 Typography (gunakan AppSizes & Google Fonts nanti)
      textTheme: _buildTextTheme(base.textTheme),

      // 🔸 Komponen khusus
      appBarTheme: AppBarTheme(
        // backgroundColor: AppColors.surface,
        // foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: AppSizes.appBarHeight,
        titleTextStyle: TextStyle(
          fontSize: AppSizes.fontSizeL,
          fontWeight: FontWeight.bold,
          // color: AppColors.textPrimary,
        ),
      ),

      // 🔸 Tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          elevation: 0,
          textStyle: TextStyle(
            fontSize: AppSizes.fontSizeM,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 🔸 Input field
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.m,
          vertical: AppSizes.s,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        labelStyle: TextStyle(
          color: AppColors.hint,
          fontSize: AppSizes.fontSizeS,
        ),
        hintStyle: TextStyle(
          color: AppColors.hint,
          fontSize: AppSizes.fontSizeM,
        ),
      ),

      // 🔸 Scaffold background
      scaffoldBackgroundColor: AppColors.background,

      // 🔸 Divider
      dividerColor: AppColors.divider,

      // 🔸 Icon
      iconTheme: IconThemeData(color: AppColors.textSecondary),
      primaryIconTheme: IconThemeData(color: Colors.white),
    );
  }

  // 🔹 Builder untuk tema dark (placeholder — bisa dikembangkan nanti)
  static ThemeData _buildDarkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      // Sesuaikan nanti jika butuh dark mode
      scaffoldBackgroundColor: Colors.grey.shade900,
    );
  }

  // 🔹 Text theme yang konsisten
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: AppSizes.fontSizeXXL,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: AppSizes.fontSizeL,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: AppSizes.fontSizeM,
        color: AppColors.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: AppSizes.fontSizeS,
        color: AppColors.textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: AppSizes.fontSizeM,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
