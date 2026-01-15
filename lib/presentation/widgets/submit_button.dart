import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double fontSize;
  final Widget? icon;
  final double paddingVertical;

  const SubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    this.icon,
    required this.paddingVertical,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isHovered,
      builder: (context, isHovered, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isPressed,
          builder: (context, isPressed, child) {
            return GestureDetector(
              onTapDown: (_) => setState(() => _isPressed.value = true),
              onTapUp: (_) => setState(() => _isPressed.value = false),
              onTapCancel: () => setState(() => _isPressed.value = false),
              onTap: () {
                setState(() => _isPressed.value = false);
                widget.onPressed();
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered.value = true),
                onExit: (_) => setState(() => _isHovered.value = false),
                child: AnimatedContainer(
                  padding: EdgeInsets.symmetric(
                    vertical: widget.paddingVertical,
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(isHovered, isPressed),
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: _isPressed.value
                        ? [] // Tidak ada shadow ketika ditekan
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.11),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: AppSizes.m),
                      ],
                      Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ⬅️ FUNGSI UNTUK GRADIENT BERUBAH SAAT HOVER
  List<Color> _getGradientColors(bool isHovered, bool isPressed) {
    if (isHovered) {
      // Warna ketika hover (lebih terang)
      return [AppColors.orange2, AppColors.orange3];
    } else if (isPressed) {
      // Warna ketika ditekan (lebih gelap)
      return [AppColors.orange2, AppColors.orange3];
    } else {
      // Warna normal
      return [AppColors.primary, AppColors.cyan1];
    }
  }
}
