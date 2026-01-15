import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/login/login_controller.dart';
import 'package:sandu_app/presentation/widgets/bubble_background.dart';
import 'package:sandu_app/presentation/widgets/custom_text_form_field.dart';
import 'package:sandu_app/presentation/widgets/google_login_button.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';
import 'package:sandu_app/presentation/widgets/submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final LoginController _controller;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animController;

  // Animasi Fade in
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(context);
    _controller.username = _usernameController;
    _controller.password = _passwordController;

    // 🔹 Inisialisasi controller & animasi
    _animController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    // 🔹 Jalankan setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    await _controller.login(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // Isi Konten Utama
          FadeTransition(
            opacity: _fadeInAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        // Logo
                        Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 120,
                        ),
                        // Title
                        Text(
                          'LOGIN',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeHero,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Masukkan akun anda',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),

                        // Form
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.m,
                          ),
                          child: Form(
                            key: _controller.formKey,
                            child: Column(
                              children: [
                                // Username Field
                                CustomTextFormField(
                                  label: 'Username',
                                  hintText: 'Masukkan Username Anda',
                                  prefixIcon: Icons.person,
                                  controller: _usernameController,
                                  errorText: _controller.usernameError,
                                  fontSize: AppSizes.fontSizeM,
                                  sizeIcon: AppSizes.l,
                                ),

                                const SizedBox(height: AppSizes.m),

                                // Password Field
                                CustomTextFormField(
                                  label: 'Password',
                                  hintText: 'Masukkan Password Anda',
                                  prefixIcon: Icons.lock,
                                  isPassword: true,
                                  controller: _passwordController,
                                  errorText: _controller.passwordError,
                                  fontSize: AppSizes.fontSizeM,
                                  sizeIcon: AppSizes.l,
                                ),

                                const SizedBox(height: AppSizes.s),

                                // Remember me & Forgot password
                                Row(
                                  children: [
                                    // Checkbox tanpa background lingkaran
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor:
                                            AppColors.textPrimary,
                                      ),

                                      child: Checkbox(
                                        value: _controller.rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _controller.rememberMe =
                                                value ?? false;
                                          });
                                        },
                                        activeColor: AppColors.primary,
                                        checkColor: Colors.white,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: AppColors.textPrimary,
                                          width: 2,
                                        ),
                                      ),
                                    ),

                                    // Text yang bisa diklik
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _controller.rememberMe =
                                              !_controller.rememberMe;
                                        });
                                      },
                                      child: Text(
                                        'Ingatkan Saya',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontSizeS,
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    _ForgotPassword(
                                      text: 'Lupa password?',
                                      onTap: _controller.forgotPassword,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.m),

                                // Login Button
                                SubmitButton(
                                  onPressed: _login,
                                  text: 'LOGIN',
                                  fontSize: AppSizes.fontSizeXXL,
                                  paddingVertical: 8,
                                ),

                                const SizedBox(height: AppSizes.s),

                                Text(
                                  'OR',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeM,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: AppSizes.s),

                                // Google Login
                                GoogleLoginButton(
                                  onPressed: _controller.loginWithGoogle,
                                ),

                                const SizedBox(height: AppSizes.m),

                                // Registration Prompt
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Belum punya akun? ',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeS,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    // Widget terpisah untuk hover effect
                                    _HoverableText(
                                      text: 'Daftar disini!',
                                      onTap: _controller.register,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Overlay Loading Sukses (Minimalis)
          if (_controller.showSuccessLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(child: Loading()),
            ),
        ],
      ),
    );
  }
}

// Widget terpisah di luar build method
class _HoverableText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverableText({required this.text, required this.onTap});

  @override
  State<_HoverableText> createState() => __HoverableTextState();
}

class __HoverableTextState extends State<_HoverableText> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Text(
          widget.text,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeS,
            color: _getTextColor(),
            fontWeight: FontWeight.bold,
            decoration: _getTextDecoration(),
            decorationColor: _getDecorationColor(),
          ),
        ),
      ),
    );
  }

  Color _getTextColor() {
    if (_isPressed) {
      return AppColors.cyan1; // Saat ditekan
    }
    if (_isHovered) {
      return AppColors.cyan1; // Saat hover
    }
    return AppColors.primary; // Normal
  }

  TextDecoration? _getTextDecoration() {
    if (_isHovered || _isPressed) {
      return TextDecoration.underline; // Garis bawah saat hover/ditekan
    }
    return TextDecoration.none; // Normal
  }

  Color? _getDecorationColor() {
    if (_isPressed) {
      return AppColors.cyan1;
    }
    if (_isHovered) {
      return AppColors.cyan1;
    }
    return null;
  }
}

class _ForgotPassword extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _ForgotPassword({required this.text, required this.onTap});

  @override
  State<_ForgotPassword> createState() => __ForgotPasswordState();
}

class __ForgotPasswordState extends State<_ForgotPassword> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Text(
          widget.text,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeS,
            color: _getTextColor(),
            fontWeight: FontWeight.w600,
            decoration: _getTextDecoration(),
            decorationColor: _getDecorationColor(),
          ),
        ),
      ),
    );
  }

  Color _getTextColor() {
    if (_isPressed) {
      return AppColors.cyan1; // Saat ditekan
    }
    if (_isHovered) {
      return AppColors.cyan1; // Saat hover
    }
    return AppColors.textPrimary; // Normal
  }

  TextDecoration? _getTextDecoration() {
    if (_isHovered || _isPressed) {
      return TextDecoration.none; // Garis bawah saat hover/ditekan
    }
    return TextDecoration.underline; // Normal
  }

  Color? _getDecorationColor() {
    if (_isPressed) {
      return AppColors.cyan1;
    }
    if (_isHovered) {
      return AppColors.cyan1;
    }
    return null;
  }
}
