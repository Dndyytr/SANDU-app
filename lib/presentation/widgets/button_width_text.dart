import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class ButtonWidthText extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double fontSize;
  final Color textColor;
  final List<Color> colors;
  final BorderRadius borderRadius;
  final Widget? icon;
  final bool gradient;
  final Alignment? beginGradientAlignment;
  final Alignment? endGradientAlignment;
  final double paddingHorizontal;
  final double paddingVertical;

  const ButtonWidthText({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    required this.textColor,
    required this.colors,
    required this.borderRadius,
    required this.gradient,
    this.icon,
    this.beginGradientAlignment,
    this.endGradientAlignment,
    required this.paddingHorizontal,
    required this.paddingVertical,
  });

  @override
  State<ButtonWidthText> createState() => _ButtonWidthTextState();
}

class _ButtonWidthTextState extends State<ButtonWidthText> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    _isPressed.dispose();
    super.dispose();
  }

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
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: widget.gradient
                        ? LinearGradient(
                            colors: _getGradientColors(isHovered, isPressed),
                            begin:
                                widget.beginGradientAlignment ??
                                Alignment.centerLeft,
                            end:
                                widget.endGradientAlignment ??
                                Alignment.centerRight,
                          )
                        : null,
                    color: !widget.gradient
                        ? _getSolidColor(isHovered, isPressed)
                        : null, // Hanya warna solid jika gradient false
                    borderRadius: widget.borderRadius,
                    boxShadow: _isPressed.value
                        ? [] // Tidak ada shadow ketika ditekan
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1.5,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.paddingHorizontal,
                    vertical: widget.paddingVertical,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: AppSizes.xs),
                      ],
                      Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w600,
                          color: widget.textColor,
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
      return [widget.colors[2], widget.colors[3]];
    } else if (isPressed) {
      // Warna ketika ditekan (lebih gelap)
      return [widget.colors[2], widget.colors[3]];
    } else {
      // Warna normal
      return [widget.colors[0], widget.colors[1]];
    }
  }

  // ⬅️ FUNGSI UNTUK SOLID COLOR BERUBAH SAAT HOVER
  Color _getSolidColor(bool isHovered, bool isPressed) {
    if (isHovered) {
      // Warna ketika hover
      return widget.colors[1];
    } else if (isPressed) {
      // Warna ketika ditekan
      return widget.colors[1];
    } else {
      // Warna normal
      return widget.colors[0];
    }
  }
}
