import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final double fontSize;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? errorText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Color? focusedFillColor;
  final Color? normalFillColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? sizeIcon;
  final double borderRadius;
  final int? minLines;
  final Color enabledBorder;
  final Color focusedBorder;

  const CustomTextField({
    super.key,
    this.label,
    required this.fontSize,
    required this.hintText,
    this.errorText,
    this.prefixIcon,
    this.isPassword = false,
    required this.controller,
    this.onChanged,
    this.focusedFillColor,
    this.normalFillColor,
    this.keyboardType,
    this.inputFormatters,
    this.sizeIcon,
    required this.borderRadius,
    this.minLines,
    required this.enabledBorder,
    required this.focusedBorder,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final ValueNotifier<bool> _showPassword = ValueNotifier(false);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  Color get _fillColor {
    if (_isFocused.value) {
      return widget.focusedFillColor ?? AppColors.white3;
    }
    return widget.normalFillColor ?? AppColors.white2;
  }

  @override
  void dispose() {
    _showPassword.dispose();
    _isFocused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.poppins(
              fontSize: widget.fontSize,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.s),
        ],
        ValueListenableBuilder(
          valueListenable: _showPassword,
          builder: (context, showPassword, child) {
            return ValueListenableBuilder(
              valueListenable: _isFocused,
              builder: (context, isFocused, child) {
                return Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isFocused.value = hasFocus;
                    });
                  },
                  child: TextField(
                    maxLines: null,
                    minLines: widget.minLines,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    controller: widget.controller,
                    obscureText: widget.isPassword && !_showPassword.value,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      prefixIcon: widget.prefixIcon != null
                          ? Padding(
                              padding: EdgeInsets.only(left: AppSizes.s),
                              child: Icon(
                                widget.prefixIcon,
                                color: AppColors.textPrimary,
                                size: widget.sizeIcon,
                              ),
                            )
                          : null,
                      suffixIcon: widget.isPassword
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword.value = !_showPassword.value;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: AppSizes.s),
                                child: Icon(
                                  _showPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textPrimary,
                                  size: widget.sizeIcon,
                                ),
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: _fillColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.m,
                        vertical: AppSizes.s,
                      ),
                      isDense: true,
                      border: _buildBorder(),
                      enabledBorder: _buildBorder(
                        color: widget.enabledBorder,
                        width: 2,
                      ),
                      focusedBorder: _buildBorder(
                        color: widget.focusedBorder,
                        width: 2,
                      ),
                      errorBorder: _buildBorder(
                        color: AppColors.error,
                        width: 2,
                      ),
                      errorText: widget.errorText,
                      errorStyle: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSizeS,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: widget.fontSize,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color ?? Colors.transparent, width: width),
    );
  }
}
