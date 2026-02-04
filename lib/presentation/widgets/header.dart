import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/home/home_screen.dart';
import 'package:sandu_app/presentation/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:sandu_app/presentation/widgets/button_width_text.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final ValueNotifier<bool> _isAvatarHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isAvatarPressed = ValueNotifier(false);
  final ValueNotifier<bool> _isNotifHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isNotifPressed = ValueNotifier(false);

  @override
  void dispose() {
    // ✅ Hanya dispose internal notifier
    _isAvatarHovered.dispose();
    _isAvatarPressed.dispose();
    _isNotifHovered.dispose();
    _isNotifPressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 First Row (Logo, Name, Notification, Profile)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Logo and User Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png', width: 60, height: 60),

                // User Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hallo,',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeL,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          'Dandy_tr2412',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeXS,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    // Verified Badge
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.orange5, AppColors.orange2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusFull,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s,
                        vertical: 2,
                      ),
                      child: Text(
                        'Terverifikasi',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSizeXS,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 🔹 Notification and Profile
            Row(
              children: [
                // Notification
                ValueListenableBuilder<bool>(
                  valueListenable: _isNotifHovered,
                  builder: (context, isHovered, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isNotifPressed,
                      builder: (context, isPressed, child) {
                        return MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isNotifHovered.value = true),
                          onExit: (_) => setState(() {
                            _isNotifHovered.value = false;
                            _isNotifPressed.value = false;
                          }),
                          child: GestureDetector(
                            onTapDown: (_) =>
                                setState(() => _isNotifPressed.value = true),
                            onTapUp: (_) =>
                                setState(() => _isNotifPressed.value = false),
                            onTapCancel: () =>
                                setState(() => _isNotifPressed.value = false),
                            onTap: () {},
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(AppSizes.xs),
                              decoration: BoxDecoration(
                                color: _getNotifBackgroundColor(
                                  isHovered,
                                  isPressed,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusFull,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Notification Icon
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return _getNotifIconGradient(
                                        isHovered,
                                        isPressed,
                                      ).createShader(bounds);
                                    },
                                    child: const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),

                                  // Notification Badge
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _getNotifBackgroundColor(
                                            isHovered,
                                            isPressed,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 15,
                                        minHeight: 15,
                                      ),
                                      child: Text(
                                        '3',
                                        style: GoogleFonts.poppins(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
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
                ),
                const SizedBox(width: AppSizes.s),
                // Profile
                ValueListenableBuilder<bool>(
                  valueListenable: _isAvatarHovered,
                  builder: (context, isHovered, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isAvatarPressed,
                      builder: (context, isPressed, child) {
                        return MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isAvatarHovered.value = true),
                          onExit: (_) =>
                              setState(() => _isAvatarHovered.value = false),
                          child: GestureDetector(
                            onTapDown: (_) =>
                                setState(() => _isAvatarPressed.value = true),
                            onTapUp: (_) =>
                                setState(() => _isAvatarPressed.value = false),
                            onTapCancel: () =>
                                setState(() => _isAvatarPressed.value = false),
                            onTap: () {
                              NavigationHelper.navigateWithSlideTransition(
                                context,
                                EditProfileScreen(),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _getBorderGradient(
                                  isHovered,
                                  isPressed,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: CircleAvatar(
                                  backgroundImage: const AssetImage(
                                    'assets/images/profile.jpg',
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: AppSizes.xs),

        // 🔹 Action Buttons Row
        Row(
          children: [
            // Buat Laporan Button
            ButtonWidthText(
              text: 'Buat Laporan',
              onPressed: () {},
              fontSize: 12,
              colors: [
                AppColors.primary,
                AppColors.cyan1,
                AppColors.background,
                AppColors.cyan1,
              ],
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              gradient: true,
              beginGradientAlignment: Alignment.centerLeft,
              endGradientAlignment: Alignment.centerRight,
              textColor: Colors.white,
              icon: const Icon(
                Icons.edit_square,
                size: 15,
                color: Colors.white,
              ),
              paddingHorizontal: AppSizes.s,
              paddingVertical: AppSizes.s,
            ),

            const SizedBox(width: AppSizes.s),

            // Panduan Button
            ButtonWidthText(
              text: 'Panduan',
              onPressed: () {},
              fontSize: 12,
              colors: [
                Colors.white,
                AppColors.white4,
                AppColors.cyan1,
                AppColors.white4,
              ],
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              gradient: true,
              beginGradientAlignment: Alignment.topCenter,
              endGradientAlignment: Alignment.bottomCenter,
              textColor: AppColors.primary,
              icon: const Icon(
                Icons.menu_book_rounded,
                size: 15,
                color: AppColors.primary,
              ),
              paddingHorizontal: AppSizes.s,
              paddingVertical: AppSizes.s,
            ),
          ],
        ),
      ],
    );
  }

  // for profile
  LinearGradient _getBorderGradient(bool isHovered, bool isPressed) {
    if (isPressed) {
      // Gradient saat ditekan (lebih terang/cerah)
      return LinearGradient(
        colors: [AppColors.orange4, AppColors.orange1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (isHovered) {
      // Gradient saat hover (lebih kontras)
      return LinearGradient(
        colors: [AppColors.orange4, AppColors.orange1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      // Gradient normal
      return LinearGradient(
        colors: [AppColors.primary, AppColors.white2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  // for notifikasi
  Color _getNotifBackgroundColor(bool isHovered, bool isPressed) {
    if (isPressed) {
      return AppColors.orange7;
    } else if (isHovered) {
      return AppColors.orange7;
    } else {
      return AppColors.white2;
    }
  }

  LinearGradient _getNotifIconGradient(bool isHovered, bool isPressed) {
    if (isPressed) {
      return LinearGradient(
        colors: [AppColors.orange2, AppColors.orange4],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );
    } else if (isHovered) {
      return LinearGradient(
        colors: [AppColors.orange2, AppColors.orange4],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );
    } else {
      return LinearGradient(
        colors: [AppColors.primary, AppColors.white2],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );
    }
  }
}
