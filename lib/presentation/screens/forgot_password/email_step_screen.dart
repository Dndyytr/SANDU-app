import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/core/models/forgot_password_data.dart';
import 'package:sandu_app/core/utils/navigator.dart';
import 'package:sandu_app/presentation/widgets/bubble_background.dart';
import 'package:sandu_app/presentation/widgets/custom_text_form_field.dart';
import 'package:sandu_app/presentation/widgets/submit_button.dart';

class EmailStepScreen extends StatefulWidget {
  const EmailStepScreen({super.key});

  @override
  State<EmailStepScreen> createState() => _EmailStepScreenState();
}

class _EmailStepScreenState extends State<EmailStepScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  // bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_formKey.currentState?.validate() ?? false) {
      final value = _emailPhoneController.text.trim();

      // Validasi format dasar di client-side
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      final phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]{7,}$');

      if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
        setState(() {
          _errorMessage = 'Format email atau nomor tidak valid';
        });
        return;
      }

      setState(() {
        // _isLoading = true;
        _errorMessage = null; // Reset error message
      });

      try {
        // 🔹 SIMULASI API CALL - GANTI DENGAN API ASLI ANDA
        // final response = await _simulateApiCall(value);

        if (value.isNotEmpty) {
          // 🔹 Navigasi ke halaman OTP dengan data
          AppNavigator.goToOTPScreen(
            // ignore: use_build_context_synchronously
            context,
            ForgotPasswordData(emailOrPhone: value),
          );
        } else {
          // 🔹 Tampilkan error dari API
          setState(() {
            _errorMessage = 'Gagal mengirim OTP. Silakan coba lagi.';
          });
        }
      } catch (e) {
        // 🔹 Tampilkan error jika terjadi exception
        setState(() {
          _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 40,
        centerTitle: false,
        title: Text(
          'Lupa Password',
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeL,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 40),
          onPressed: () => Navigator.pop(context),
          splashColor: Colors.transparent, // Menghilangkan efek percikan air
          highlightColor:
              Colors.transparent, // Menghilangkan efek warna saat ditekan lama
          hoverColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) return AppColors.cyan1;
              if (states.contains(WidgetState.hovered)) return AppColors.cyan1;
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
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // logo
                        const SizedBox(height: AppSizes.xl),
                        SvgPicture.asset(
                          'assets/svg/forgot_password.svg',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: AppSizes.xl),
                        Text(
                          'Masukkan Email atau No Telepon',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeL,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.s),
                        Text(
                          'Kami akan mengirimkan kode OTP untuk memverifikasi akun Anda',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeS,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.l),

                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.s,
                            ),
                            child: Column(
                              // Menambahkan Column atau widget layout lainnya
                              children: [
                                CustomTextFormField(
                                  label: 'Email atau No. Telepon',
                                  hintText:
                                      'contoh@email.com atau 081234567890',
                                  prefixIcon: Icons.email,
                                  controller: _emailPhoneController,
                                  errorText: _errorMessage,
                                  fontSize: AppSizes.fontSizeM,
                                  sizeIcon: AppSizes.l,
                                ),

                                const SizedBox(height: AppSizes.m),
                                SubmitButton(
                                  text: 'Kirim OTP',
                                  onPressed: _sendOTP,
                                  fontSize: AppSizes.fontSizeL,
                                  paddingVertical: 12,
                                ),
                              ],
                            ),
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
    );
  }
}
