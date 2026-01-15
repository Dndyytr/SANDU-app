import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/core/models/forgot_password_data.dart';
import 'package:sandu_app/presentation/widgets/bubble_background.dart';
import 'package:sandu_app/presentation/widgets/custom_text_form_field.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';
import 'package:sandu_app/presentation/widgets/submit_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final ForgotPasswordData data;

  const ResetPasswordScreen({super.key, required this.data});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorMessage;
  bool _showSuccessLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validasi: password harus sama dengan konfirmasi password
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'Password dan konfirmasi password tidak sama';
        });
        return;
      }

      // Validasi panjang password (minimal 8 karakter)
      if (_passwordController.text.length < 8) {
        setState(() {
          _errorMessage = 'Password minimal 8 karakter';
        });
        return;
      }

      setState(() {
        _errorMessage = null;
      });

      try {
        // 🔹 SIMULASI API CALL - GANTI DENGAN API ASLI ANDA
        await Future.delayed(const Duration(seconds: 2));

        // 🔹 TAMPILKAN OVERLAY LOADING SUKSES
        _showSuccessOverlay();
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        });
      }
    }
  }

  void _showSuccessOverlay() {
    setState(() {
      _showSuccessLoading = true;
    });

    // Tunggu 2 detik untuk memberi efek loading sukses
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Navigasi kembali ke login dengan menghapus semua halaman di stack
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    // **SOLUSI 1: Menggunakan pushNamedAndRemoveUntil (Rekomendasi)**
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // Nama route ke login
      (Route<dynamic> route) => false, // Hapus semua route di stack
    );

    // **SOLUSI 2: Jika menggunakan AppNavigator, tambahkan fungsi ini:**
    // AppNavigator.goToLoginWithClearStack(context);
  }

  // **Untuk Solusi 2: Tambahkan di AppNavigator**
  /*
  static Future<void> goToLoginWithClearStack(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            toolbarHeight: 40,
            centerTitle: false,
            title: Text(
              'Password Baru',
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeL,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 40),
              onPressed: () => Navigator.pop(context),
              splashColor:
                  Colors.transparent, // Menghilangkan efek percikan air
              highlightColor: Colors
                  .transparent, // Menghilangkan efek warna saat ditekan lama
              hoverColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed))
                    return AppColors.cyan1;
                  if (states.contains(WidgetState.hovered))
                    return AppColors.cyan1;
                  return AppColors.textPrimary; // Warna default
                }),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),

          body: Stack(
            children: [
              // 🔹 Bubbles Background
              const BubbleBackground(),

              // 🔹 Wave Background
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/svg/wave.svg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 203,
                ),
              ),

              // 🔹 Main Content
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.m,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSizes.l),
                            Text(
                              'Buat Password Baru',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeL,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.s),
                            Text(
                              'Pastikan password kuat dan mudah anda ingat',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSizes.l),

                            Form(
                              key: _formKey,
                              child: Column(
                                // Menambahkan Column atau widget layout lainnya
                                children: [
                                  CustomTextFormField(
                                    label: 'Password',
                                    hintText: 'Masukkan password baru',
                                    prefixIcon: Icons.lock,
                                    controller: _passwordController,
                                    isPassword: true,
                                    errorText: _errorMessage,
                                    fontSize: AppSizes.fontSizeM,
                                    sizeIcon: AppSizes.l,
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  CustomTextFormField(
                                    label: 'Konfirmasi Password',
                                    hintText: 'Konfirmasi password baru',
                                    prefixIcon: Icons.lock,
                                    controller: _confirmPasswordController,
                                    isPassword: true,
                                    errorText: _errorMessage,
                                    fontSize: AppSizes.fontSizeM,
                                    sizeIcon: AppSizes.l,
                                  ),

                                  const SizedBox(height: AppSizes.l),
                                  SubmitButton(
                                    text: 'Simpan Password',
                                    onPressed: _resetPassword,
                                    fontSize: AppSizes.fontSizeL,
                                    paddingVertical: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // 🔹 Overlay Loading Sukses (Minimalis)
        if (_showSuccessLoading)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(child: Loading()),
          ),
      ],
    );
  }
}
