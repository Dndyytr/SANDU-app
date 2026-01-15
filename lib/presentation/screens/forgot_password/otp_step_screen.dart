import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/core/models/forgot_password_data.dart';
import 'package:sandu_app/core/utils/navigator.dart';
import 'package:sandu_app/presentation/widgets/bubble_background.dart';
import 'package:sandu_app/presentation/widgets/submit_button.dart';

class OTPStepScreen extends StatefulWidget {
  final ForgotPasswordData data;
  final Color? focusedFillColor;
  final Color? normalFillColor;

  const OTPStepScreen({
    super.key,
    required this.data,
    this.focusedFillColor,
    this.normalFillColor,
  });

  @override
  State<OTPStepScreen> createState() => _OTPStepScreenState();
}

class _OTPStepScreenState extends State<OTPStepScreen> {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  String _enteredOTP = '';
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Setup listeners untuk otomatis update _enteredOTP
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        _updateEnteredOTP();
      });
    }
  }

  Color get _fillColor {
    if (_isFocused) {
      return widget.focusedFillColor ?? AppColors.white3;
    }
    return widget.normalFillColor ?? AppColors.white2;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _updateEnteredOTP() {
    final otp = _controllers.map((c) => c.text).join();
    setState(() {
      _enteredOTP = otp;
    });
  }

  Future<void> _verifyOTP() async {
    // Validasi: semua field harus terisi
    final isComplete = _enteredOTP.length == 5;

    if (!isComplete) {
      setState(() {
        _errorMessage = 'Harap lengkapi semua digit kode OTP';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      // 🔹 SIMULASI API CALL - GANTI DENGAN API ASLI ANDA
      await Future.delayed(const Duration(seconds: 2)); // Simulasi delay

      // Contoh validasi sederhana
      if (_enteredOTP == '12345') {
        // 🔹 OTP benar, navigasi ke reset password
        final updatedData = widget.data.copyWith(otp: _enteredOTP);
        // ignore: use_build_context_synchronously
        AppNavigator.goToResetPasswordScreen(context, updatedData);
      } else {
        setState(() {
          _errorMessage = 'Kode OTP tidak valid. Coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      });
    }
  }

  void _handleOTPInput(String value, int index) {
    // Update controller
    _controllers[index].text = value;

    // Auto-focus ke next field
    if (value.isNotEmpty && index < 4) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }

    // Auto-focus ke previous field jika dihapus
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    _updateEnteredOTP();
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
          'Verifikasi Kode OTP',
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // logo
                        const SizedBox(height: AppSizes.xl),
                        SvgPicture.asset(
                          'assets/svg/verification_code.svg',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: AppSizes.xl),
                        Text(
                          'Verifikasi Kode OTP',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeL,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.s),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Kode verifikasi telah dikirim ke:',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(width: AppSizes.xs),
                            Text(
                              widget.data.emailOrPhone,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSizes.l),

                        Form(
                          key: _formKey,
                          child: Column(
                            // Menambahkan Column atau widget layout lainnya
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.m,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: List.generate(
                                    5,
                                    (index) => SizedBox(
                                      width: 50,
                                      height: 55,
                                      child: Focus(
                                        onFocusChange: (hasFocus) {
                                          setState(() {
                                            _isFocused = hasFocus;
                                          });
                                        },
                                        child: TextFormField(
                                          controller: _controllers[index],
                                          focusNode: _focusNodes[index],
                                          onChanged: (value) =>
                                              _handleOTPInput(value, index),
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeXL,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "0",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeXL,
                                              color: AppColors.textSecondary
                                                  .withOpacity(0.5),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppSizes.radiusS,
                                                  ),
                                              borderSide: BorderSide(
                                                color: _enteredOTP.length == 4
                                                    ? AppColors.success
                                                    : AppColors.primary,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppSizes.radiusS,
                                                  ),
                                              borderSide: const BorderSide(
                                                color: AppColors.primary,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppSizes.radiusS,
                                                  ),
                                              borderSide: BorderSide(
                                                color: _enteredOTP.length == 4
                                                    ? AppColors.success
                                                    : AppColors.cyan1,
                                                width: 2,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppSizes.radiusS,
                                                  ),
                                              borderSide: const BorderSide(
                                                color: AppColors.error,
                                                width: 2,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: _fillColor,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                            isCollapsed: true,
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 🔹 Error Message
                              if (_errorMessage != null) ...[
                                const SizedBox(height: AppSizes.m),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppSizes.s),
                                    Text(
                                      _errorMessage!,
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeS,
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: AppSizes.m),
                              SubmitButton(
                                text: 'Konfirmasi Kode',
                                onPressed: _verifyOTP,
                                fontSize: AppSizes.fontSizeL,
                                paddingVertical: 12,
                              ),
                              const SizedBox(height: AppSizes.m),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '00:30',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.s),
                                  Text(
                                    'Kirim ulang kode verifikasi',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
    );
  }
}
