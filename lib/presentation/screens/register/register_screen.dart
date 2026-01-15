import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/register/register_controller.dart';
import 'package:sandu_app/presentation/widgets/bubble_background.dart';
import 'package:sandu_app/presentation/widgets/custom_text_form_field.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';
import 'package:sandu_app/presentation/widgets/status_dropdown.dart';
import 'package:sandu_app/presentation/widgets/submit_button.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterController _controller;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nikController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(context);
    _controller.name = _nameController;
    _controller.phone = _phoneController;
    _controller.email = _emailController;
    _controller.nik = _nikController;
    _controller.address = _addressController;
    _controller.password = _passwordController;
    _controller.confirmPassword = _confirmPasswordController;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    await _controller.register(() {
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

          // 🔹 Main Content
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      // Logo
                      Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                      ),
                      // Title
                      Text(
                        'DAFTAR',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSizeHero,
                          fontWeight: FontWeight.bold,
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
                              // Nama & No Telepon
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      label: 'Nama',
                                      hintText: 'Nama sesuai KTP',
                                      controller: _nameController,
                                      errorText: _controller.nameError,
                                      fontSize: AppSizes.fontSizeM,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.s),
                                  Expanded(
                                    child: CustomTextFormField(
                                      label: 'No Telepon',
                                      hintText: 'No telepon/WA',
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(12),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: _phoneController,
                                      errorText: _controller.phoneError,
                                      fontSize: AppSizes.fontSizeM,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSizes.s),

                              // Email & NIK
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      label: 'Email',
                                      hintText: 'Email google',
                                      controller: _emailController,
                                      errorText: _controller.emailError,
                                      fontSize: AppSizes.fontSizeM,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.s),
                                  Expanded(
                                    child: CustomTextFormField(
                                      label: 'NIK (jika ada)',
                                      hintText: 'NIK anda',
                                      controller: _nikController,
                                      errorText: _controller.nikError,
                                      fontSize: AppSizes.fontSizeM,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSizes.s),

                              // Alamat & Status
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      label: 'Alamat',
                                      hintText: 'Alamat sesuai KTP',
                                      controller: _addressController,
                                      errorText: _controller.addressError,
                                      fontSize: AppSizes.fontSizeM,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.s),
                                  Expanded(
                                    child: StatusDropdown(
                                      label: 'Status',
                                      items: const [
                                        'Warga Asli',
                                        'Pendatang',
                                        'Domisili Sementara',
                                      ],
                                      hint: 'Pilih status',
                                      value: _controller.selectedStatus,
                                      onChanged: (value) {
                                        _controller.validateStatusOnChange(
                                          value,
                                        );
                                        if (mounted) setState(() {});
                                      },
                                      errorText: _controller.statusError,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSizes.s),

                              // Password
                              CustomTextFormField(
                                label: 'Password',
                                hintText: 'Buat password yang kuat',
                                isPassword: true,
                                controller: _passwordController,
                                errorText: _controller.passwordError,
                                fontSize: AppSizes.fontSizeM,
                                sizeIcon: AppSizes.l,
                              ),

                              const SizedBox(height: AppSizes.s),

                              // Confirm Password
                              CustomTextFormField(
                                label: 'Konfirmasi Password',
                                hintText: 'Konfirmasi password',
                                isPassword: true,
                                controller: _confirmPasswordController,
                                errorText: _controller.confirmPasswordError,
                                fontSize: AppSizes.fontSizeM,
                                sizeIcon: AppSizes.l,
                              ),

                              const SizedBox(height: AppSizes.m),

                              // Daftar Button
                              SubmitButton(
                                onPressed: _register,
                                text: 'DAFTAR',
                                fontSize: AppSizes.fontSizeXXL,
                                paddingVertical: 8,
                              ),

                              const SizedBox(height: AppSizes.m),

                              // Login Prompt
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  // Widget terpisah untuk hover effect
                                  _HoverableText(
                                    text: 'Login disini!',
                                    onTap: () => _controller.login(context),
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
