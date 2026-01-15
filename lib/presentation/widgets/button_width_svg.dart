import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonWidthSVG extends StatefulWidget {
  final Function(BuildContext) onPressed;
  final List<Color> colors;
  final BorderRadius borderRadius;
  final String icon;
  final bool gradient;
  final Alignment? beginGradientAlignment;
  final Alignment? endGradientAlignment;
  final double paddingHorizontal;
  final double paddingVertical;
  final bool boxShadow;
  final double widthIcon;
  final double heightIcon;
  final List<Color> colorSvg;

  const ButtonWidthSVG({
    super.key,
    required this.onPressed,
    required this.colors,
    required this.borderRadius,
    required this.gradient,
    required this.icon,
    this.beginGradientAlignment,
    this.endGradientAlignment,
    required this.paddingHorizontal,
    required this.paddingVertical,
    this.boxShadow = true,
    required this.widthIcon,
    required this.heightIcon,
    required this.colorSvg,
  });

  @override
  State<ButtonWidthSVG> createState() => _ButtonWidthSVGState();
}

class _ButtonWidthSVGState extends State<ButtonWidthSVG> {
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
                widget.onPressed(context);
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered.value = true),
                onExit: (_) => setState(() => _isHovered.value = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
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
                    boxShadow: _getBoxShadow(isPressed),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.paddingHorizontal,
                    vertical: widget.paddingVertical,
                  ),

                  child: SvgPicture.string(
                    widget.icon,
                    width: widget.widthIcon,
                    height: widget.heightIcon,
                    color: _getSvgColor(isHovered, isPressed),
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

  List<BoxShadow>? _getBoxShadow(bool isPressed) {
    if (!widget.boxShadow) {
      return null;
    }

    if (isPressed) {
      return []; // Tidak ada shadow ketika ditekan
    } else {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 1.5,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];
    }
  }

  Color _getSvgColor(bool isHovered, bool isPressed) {
    if (widget.colorSvg.length > 1) {
      if (isHovered) {
        // Warna ketika hover
        return widget.colorSvg[1];
      } else if (isPressed) {
        // Warna ketika ditekan
        return widget.colorSvg[1];
      } else {
        // Warna normal
        return widget.colorSvg[0];
      }
    } else {
      return widget.colorSvg[0];
    }
  }
}
