import 'dart:async';
import 'package:flutter/material.dart';

class RegisterController {
  final BuildContext context;
  String? selectedStatus;
  TextEditingController? name;
  TextEditingController? phone;
  TextEditingController? email;
  TextEditingController? nik;
  TextEditingController? address;
  TextEditingController? password;
  TextEditingController? confirmPassword;

  bool _isLoading = false;
  bool _showSuccessLoading = false;
  String? _apiErrorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error messages per field
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _nikError;
  String? _addressError;
  String? _statusError;
  String? _passwordError;
  String? _confirmPasswordError;

  RegisterController(this.context);

  bool get isLoading => _isLoading;
  bool get showSuccessLoading => _showSuccessLoading;
  String? get apiErrorMessage => _apiErrorMessage;

  GlobalKey<FormState> get formKey => _formKey;

  // Getters untuk error per field
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get emailError => _emailError;
  String? get nikError => _nikError;
  String? get addressError => _addressError;
  String? get statusError => _statusError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // Clear semua error
  void _clearAllErrors() {
    _nameError = null;
    _phoneError = null;
    _emailError = null;
    _nikError = null;
    _addressError = null;
    _statusError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _apiErrorMessage = null;
  }

  // Validasi individual field
  String? validateName(String? value) {
    _nameError = null;

    if (value == null || value.isEmpty) {
      return _nameError = 'Nama harus diisi';
    }
    if (value.length < 3) {
      return _nameError = 'Nama minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return _nameError = 'Nama hanya boleh mengandung huruf';
    }
    return null;
  }

  String? validatePhone(String? value) {
    _phoneError = null;

    if (value == null || value.isEmpty) {
      return _phoneError = 'Nomor telepon harus diisi';
    }
    if (!RegExp(r'^\+?[0-9\s\-\(\)]{7,}$').hasMatch(value)) {
      return _phoneError = 'Format nomor telepon tidak valid';
    }
    if (value.length < 10) {
      return _phoneError = 'Nomor telepon minimal 10 digit';
    }
    return null;
  }

  String? validateEmail(String? value) {
    _emailError = null;

    if (value == null || value.isEmpty) {
      return _emailError = 'Email harus diisi';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return _emailError = 'Format email tidak valid';
    }
    return null;
  }

  String? validateNIK(String? value) {
    _nikError = null;

    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
        return _nikError = 'NIK harus 16 digit angka';
      }
    }
    return null;
  }

  String? validateAddress(String? value) {
    _addressError = null;

    if (value == null || value.isEmpty) {
      return _addressError = 'Alamat harus diisi';
    }
    if (value.length < 10) {
      return _addressError = 'Alamat terlalu pendek';
    }
    return null;
  }

  String? validateStatus(String? value) {
    _statusError = null;

    if (value == null || value.isEmpty) {
      return _statusError = 'Status harus dipilih';
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
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
      return _passwordError =
          'Password harus mengandung huruf besar, kecil, dan angka';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    _confirmPasswordError = null;

    if (value == null || value.isEmpty) {
      return _confirmPasswordError = 'Konfirmasi password harus diisi';
    }
    if (password?.text != value) {
      return _confirmPasswordError = 'Password tidak sama';
    }
    return null;
  }

  // Validasi semua field sekaligus
  bool validateAllFields() {
    _clearAllErrors();

    // Validasi individual fields
    final nameError = validateName(name?.text);
    final phoneError = validatePhone(phone?.text);
    final emailError = validateEmail(email?.text);
    final nikError = validateNIK(nik?.text);
    final addressError = validateAddress(address?.text);
    final statusError = validateStatus(selectedStatus);
    final passwordError = validatePassword(password?.text);
    final confirmPasswordError = validateConfirmPassword(confirmPassword?.text);

    // Check if any field has error
    final hasError =
        nameError != null ||
        phoneError != null ||
        emailError != null ||
        nikError != null ||
        addressError != null ||
        statusError != null ||
        passwordError != null ||
        confirmPasswordError != null;

    return !hasError;
  }

  void validateStatusOnChange(String? value) {
    selectedStatus = value;
    validateStatus(value);
  }

  Future<void> register(VoidCallback onStateUpdate) async {
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
          _navigateToLogin();
        }
      } else {
        // 🔹 Registrasi gagal (email sudah terdaftar)
        _isLoading = false;
        _emailError = 'Email sudah terdaftar';
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

    // Contoh skenario gagal
    if (email?.text == 'existing@example.com') {
      return false; // Email sudah terdaftar
    }

    return true; // Registrasi berhasil
  }

  void _navigateToLogin() {
    // Hapus semua halaman di stack dan navigasi ke login
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  void login(BuildContext context) {
    // 🔹 Pop back to login (otomatis trigger slide-down)
    Navigator.pop(context);
  }

  // Clear semua field
  void clearFields() {
    name?.clear();
    phone?.clear();
    email?.clear();
    nik?.clear();
    address?.clear();
    password?.clear();
    confirmPassword?.clear();
    selectedStatus = null;
    _clearAllErrors();
  }

  // Dispose controllers (dipanggil dari screen)
  void dispose() {
    name?.dispose();
    phone?.dispose();
    email?.dispose();
    nik?.dispose();
    address?.dispose();
    password?.dispose();
    confirmPassword?.dispose();
  }
}
