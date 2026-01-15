import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class GoogleLoginButton extends StatefulWidget {
  final VoidCallback onPressed;

  const GoogleLoginButton({super.key, required this.onPressed});

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
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
                  height: 50,
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
                      SvgPicture.string(
                        // SVG Google
                        '''<svg width="25" height="26" viewBox="0 0 25 26" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_416_1075)">
<path d="M24.9868 13.2432C24.9868 12.178 24.9018 11.4007 24.7177 10.5946H12.749V15.4024H19.7744C19.6328 16.5972 18.8679 18.3966 17.1682 19.6057L17.1444 19.7666L20.9286 22.746L21.1908 22.7726C23.5987 20.5126 24.9868 17.1874 24.9868 13.2432Z" fill="#4285F4"/>
<path d="M12.749 25.9107C16.1908 25.9107 19.0803 24.7591 21.1908 22.7726L17.1682 19.6057C16.0917 20.3686 14.647 20.9012 12.749 20.9012C9.37797 20.9012 6.51684 18.6413 5.49692 15.5176L5.34743 15.5305L1.41248 18.6254L1.36102 18.7708C3.45729 23.0029 7.7632 25.9107 12.749 25.9107Z" fill="#34A853"/>
<path d="M5.49691 15.5177C5.22779 14.7116 5.07205 13.8478 5.07205 12.9554C5.07205 12.0628 5.22779 11.1992 5.48275 10.3931L5.47562 10.2214L1.49136 7.07678L1.361 7.1398C0.497031 8.89599 0.00128174 10.8681 0.00128174 12.9554C0.00128174 15.0426 0.497031 17.0146 1.361 18.7708L5.49691 15.5177Z" fill="#FBBC05"/>
<path d="M12.749 5.00937C15.1427 5.00937 16.7574 6.06018 17.6781 6.93833L21.2758 3.36839C19.0662 1.28114 16.1908 0 12.749 0C7.7632 0 3.45729 2.90773 1.36102 7.13978L5.48277 10.3931C6.51684 7.26938 9.37797 5.00937 12.749 5.00937Z" fill="#EB4335"/>
</g>
<defs>
<clipPath id="clip0_416_1075">
<rect width="25" height="26" fill="white"/>
</clipPath>
</defs>
</svg>''',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: AppSizes.s),
                      Text(
                        'Login dengan Google',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSizeM,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
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
      return [AppColors.white1, AppColors.cyan1];
    } else if (isPressed) {
      return [AppColors.white1, AppColors.cyan1];
    } else {
      // Warna normal
      return [AppColors.white1, AppColors.orange1];
    }
  }
}
