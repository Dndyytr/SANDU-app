import 'package:flutter/material.dart';
import 'package:sandu_app/core/utils/navigator.dart';
import 'dart:async';

class LoginController {
  final BuildContext context;
  bool rememberMe = false;
  TextEditingController? username;
  TextEditingController? password;

  bool _isLoading = false;
  bool _showSuccessLoading = false;
  String? _apiErrorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error messages per field
  String? _usernameError;
  String? _passwordError;

  LoginController(this.context);

  GlobalKey<FormState> get formKey => _formKey;

  // Getter
  bool get isLoading => _isLoading;
  bool get showSuccessLoading => _showSuccessLoading;
  String? get apiErrorMessage => _apiErrorMessage;

  // Getter
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;

  // Clear semua error
  void _clearAllErrors() {
    _usernameError = null;
    _passwordError = null;
    _apiErrorMessage = null;
  }

  // Validasi individual field
  String? validateUsername(String? value) {
    _usernameError = null;

    if (value == null || value.isEmpty) {
      return _usernameError = 'Username harus diisi';
    }
    if (value.length < 3) {
      return _usernameError = 'Username minimal 3 karakter';
    }

    return null;
  }

  String? validatePassword(String? value) {
    _passwordError = null;

    if (value == null || value.isEmpty) {
      return _passwordError = 'Password harus diisi';
    }
    if (value.length < 8) {
      return _passwordError = 'Password minimal 8 karakter';
    }
    return null;
  }

  // Validasi semua field sekaligus
  bool validateAllFields() {
    _clearAllErrors();

    // Validasi individual fields
    final usernameError = validateUsername(username?.text);
    final passwordError = validatePassword(password?.text);

    // Check if any field has error
    final hasError = usernameError != null || passwordError != null;

    return !hasError;
  }

  Future<void> login(VoidCallback onStateUpdate) async {
    // Validasi semua field
    if (!validateAllFields()) {
      onStateUpdate();
      return;
    }

    // Set loading state untuk tombol
    _isLoading = true;
    onStateUpdate();

    try {
      // 🔹 SIMULASI API CALL - GANTI DENGAN API ASLI ANDA
      await Future.delayed(const Duration(seconds: 0));

      // Simulasi response API
      final success = await _simulateApiCall();

      if (success) {
        // 🔹 Registrasi berhasil - tampilkan loading sukses
        _isLoading = false;
        _showSuccessLoading = true;
        onStateUpdate();

        // Tunggu 2 detik untuk memberi efek loading sukses
        await Future.delayed(const Duration(seconds: 2));

        if (context.mounted) {
          // Navigasi kembali ke login
          AppNavigator.goToHomeScreen(context);
        }
      } else {
        // 🔹 Registrasi gagal (email sudah terdaftar)
        _isLoading = false;
        onStateUpdate();
      }
    } catch (e) {
      // 🔹 Error koneksi atau lainnya
      _isLoading = false;
      _apiErrorMessage = 'Terjadi kesalahan. Periksa koneksi internet Anda.';
      onStateUpdate();
    }
  }

  Future<bool> _simulateApiCall() async {
    // Simulasi API call
    await Future.delayed(const Duration(seconds: 1));

    return true; // login berhasil
  }

  void loginWithGoogle() {
    // TODO: Implementasi Google Sign-In
    print('Login dengan Google');
  }

  void register() {
    // Navigasi ke halaman registrasi
    AppNavigator.goToRegister(context); // Tambahkan di navigator.dart nanti
  }

  void forgotPassword() {
    // Navigasi ke halaman lupa password
    AppNavigator.goToForgotPassword(
      context,
    ); // Tambahkan di navigator.dart nanti
  }

  // Clear semua field
  void clearFields() {
    username?.clear();
    password?.clear();
    _clearAllErrors();
  }

  // Dispose controllers (dipanggil dari screen)
  void dispose() {
    username?.dispose();
    password?.dispose();
  }
}
