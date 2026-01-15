import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class LogoutButton extends StatefulWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
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
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  width: double.infinity, // ⬅️ WIDTH INFINITY
                  height: 47,
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
                      Transform.flip(
                        flipX: true,
                        child: Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: AppSizes.xs),
                      Text(
                        'LOGOUT',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSizeL,
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
      return [const Color.fromARGB(255, 255, 85, 85), AppColors.orange3];
    } else if (isPressed) {
      return [const Color.fromARGB(255, 255, 85, 85), AppColors.orange3];
    } else {
      // Warna normal
      return [AppColors.red1, AppColors.orange4];
    }
  }
}
