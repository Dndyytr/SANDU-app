import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/core/utils/navigator.dart';
import 'package:sandu_app/presentation/widgets/button_width_text.dart';
import 'package:sandu_app/presentation/widgets/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool)? onLoadingChanged;
  const ProfileScreen({super.key, this.onLoadingChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // List Buttons
  final List<Map<String, dynamic>> buttonList = [
    {'icon': Icons.person_rounded, 'name': 'Edit Profil', 'onTap': () {}},
    {'icon': Icons.description_rounded, 'name': 'Dokumen Saya', 'onTap': () {}},
    {
      'icon': Icons.storefront_outlined,
      'name': 'UMKM atau Toko',
      'onTap': () {},
    },
    {'icon': Icons.groups_rounded, 'name': 'Grup Komunitas', 'onTap': () {}},
    {
      'icon': Icons.history_edu_rounded,
      'name': 'Riwayat Laporan & Pengajuan',
      'onTap': () {},
    },
    {'icon': Icons.settings, 'name': 'Pengaturan', 'onTap': () {}},
    {'icon': Icons.help_rounded, 'name': 'Bantuan & Support', 'onTap': () {}},
  ];

  // Logout
  Future<void> _logout() async {
    // Set loading ke true via callback
    widget.onLoadingChanged?.call(true);

    // Simulasi proses logout
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Set loading ke false
      widget.onLoadingChanged?.call(false);
      AppNavigator.goToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.cyan1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Stack(
              children: [
                // wave background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.string(
                      ''' <svg width="392" height="106" viewBox="0 0 392 106" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M0 22.072C0 13.5633 9.85915 9.08992 16.8838 13.8913C25.7743 19.968 34.6649 23.7854 43.5558 21.7742C58.0742 18.489 72.5925 -0.3386 87.1109 0.540492C101.63 1.41958 116.148 22.0054 130.667 21.7742C145.185 21.5422 159.703 0.493972 174.222 0.540492C188.741 0.587012 203.259 21.7276 217.778 21.7742C232.297 21.82 246.815 0.771724 261.333 0.540492C275.852 0.30926 290.37 20.8951 304.889 21.7742C319.407 22.6526 333.926 3.82495 348.444 0.540492C361.779 -2.47604 375.113 7.61821 388.447 18.7825C390.705 20.6731 392 23.4733 392 26.4184V95.0738C392 100.597 387.523 105.074 382 105.074C370.815 105.074 359.63 105.074 348.444 105.074C333.926 105.074 319.407 105.074 304.889 105.074C290.37 105.074 275.852 105.074 261.333 105.074C246.815 105.074 232.297 105.074 217.778 105.074C203.259 105.074 188.741 105.074 174.222 105.074C159.703 105.074 145.185 105.074 130.667 105.074C116.148 105.074 101.63 105.074 87.1109 105.074C72.5925 105.074 58.0742 105.074 43.5558 105.074C32.3702 105.074 21.1851 105.074 10 105.074C4.47716 105.074 0 100.597 0 95.0738V22.072Z" fill="white" fill-opacity="0.1"/>
                    <path d="M0 46.2582C0 43.1758 1.41742 40.2598 3.85777 38.3768C17.0902 28.1662 30.3227 19.0107 43.5558 21.7742C58.0742 24.8055 72.5925 42.1849 87.1109 41.3735C101.63 40.5628 116.148 21.56 130.667 21.7742C145.185 21.9876 159.703 41.4166 174.222 41.3735C188.741 41.3311 203.259 21.8166 217.778 21.7742C232.297 21.7311 246.815 41.1601 261.333 41.3735C275.852 41.5876 290.37 22.5849 304.889 21.7742C319.407 20.9628 333.926 38.3422 348.444 41.3735C357.458 43.2559 366.473 39.6077 375.486 33.8628C382.508 29.3878 392 33.9203 392 42.2464V95.0738C392 100.597 387.523 105.074 382 105.074C370.815 105.074 359.63 105.074 348.444 105.074C333.926 105.074 319.407 105.074 304.889 105.074C290.37 105.074 275.852 105.074 261.333 105.074C246.815 105.074 232.297 105.074 217.778 105.074C203.259 105.074 188.741 105.074 174.222 105.074C159.703 105.074 145.185 105.074 130.667 105.074C116.148 105.074 101.63 105.074 87.1109 105.074C72.5925 105.074 58.0742 105.074 43.5558 105.074C32.3702 105.074 21.1851 105.074 10 105.074C4.47716 105.074 0 100.597 0 95.0738V46.2582Z" fill="white" fill-opacity="0.08"/>
                    <path d="M0 62.9058C0 54.397 9.85948 49.9235 16.8842 54.7249C25.7746 60.8014 34.6651 64.6184 43.5558 62.6072C58.0742 59.3227 72.5925 40.4951 87.1109 41.3735C101.63 42.2526 116.148 62.8384 130.667 62.6072C145.185 62.3759 159.703 41.3276 174.222 41.3735C188.741 41.42 203.259 62.5606 217.778 62.6072C232.297 62.6537 246.815 41.6054 261.333 41.3735C275.852 41.1422 290.37 61.7281 304.889 62.6072C319.407 63.4862 333.926 44.6586 348.444 41.3735C361.779 38.357 375.113 48.4517 388.447 59.6154C390.705 61.5061 392 64.3063 392 67.2515V95.0738C392 100.597 387.523 105.074 382 105.074C370.815 105.074 359.63 105.074 348.444 105.074C333.926 105.074 319.407 105.074 304.889 105.074C290.37 105.074 275.852 105.074 261.333 105.074C246.815 105.074 232.297 105.074 217.778 105.074C203.259 105.074 188.741 105.074 174.222 105.074C159.703 105.074 145.185 105.074 130.667 105.074C116.148 105.074 101.63 105.074 87.1109 105.074C72.5925 105.074 58.0742 105.074 43.5558 105.074C32.3702 105.074 21.1851 105.074 10 105.074C4.47716 105.074 0 100.597 0 95.0738V62.9058Z" fill="white" fill-opacity="0.1"/>
                    </svg>
                     ''',
                      height: 105.07,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/profile.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Name & Status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Dandy_tr2412',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontSizeL,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),

                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.cyan1,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
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
                                          'Warga Asli',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeXS,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'dandy.taufiqurrochman@gmail.com',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Dusun Wetan, RT 06/ RW 02',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 2),
                                  // Verified Badge
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.orange5,
                                          AppColors.orange2,
                                        ],
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
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSizes.s),

                        Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusFull,
                                    ),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.6,
                                  child: Container(
                                    height: 15,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.orange1,
                                          AppColors.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusFull,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSizes.s),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profil 60% Lengkap - Lengkapi Sekarang',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeXS,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            ButtonWidthText(
                              text: 'Lengkapi',
                              onPressed: () {},
                              fontSize: 12,
                              colors: [
                                AppColors.cyan1,
                                AppColors.background,
                                AppColors.background,
                                AppColors.white4,
                              ],
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusS,
                              ),
                              gradient: true,
                              beginGradientAlignment: Alignment.topLeft,
                              endGradientAlignment: Alignment.bottomRight,
                              textColor: Colors.white,
                              paddingHorizontal: AppSizes.s,
                              paddingVertical: AppSizes.s,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSizes.m),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.background2),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    children: [
                      for (
                        int index = 0;
                        index < buttonList.length;
                        index++
                      ) ...[
                        _ProfileMenuItem(
                          icon: buttonList[index]['icon'],
                          name: buttonList[index]['name'],
                          onTap: buttonList[index]['onTap'],
                        ),
                        if (index < buttonList.length - 1)
                          const SizedBox(height: AppSizes.s),
                      ],

                      const SizedBox(height: AppSizes.s),

                      LogoutButton(
                        onPressed: () {
                          _logout();
                        },
                      ),

                      const SizedBox(height: AppSizes.s),

                      Text(
                        'SANDU',
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: AppSizes.xs),

                      Text(
                        'v.1.10',
                        style: GoogleFonts.syne(
                          fontSize: AppSizes.fontSizeL,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      // 🔹 BOTTOM PADDING UNTUK SCROLL
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatefulWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  State<_ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<_ProfileMenuItem> {
  // ✅ ValueNotifier untuk state hover dan pressed per-item
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
              onTapDown: (_) => _isPressed.value = true,
              onTapUp: (_) => _isPressed.value = false,
              onTapCancel: () => _isPressed.value = false,
              onTap: () {
                _isPressed.value = false;
                widget.onTap();
              },
              child: MouseRegion(
                onEnter: (_) => _isHovered.value = true,
                onExit: (_) => _isHovered.value = false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _getItemColor(isHovered, isPressed),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isPressed ? 0.1 : 0.4),
                        blurRadius: 0.5,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.s,
                    vertical: AppSizes.s,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: AppColors.primary, size: 25),
                      const SizedBox(width: AppSizes.xs),

                      Expanded(
                        child: Text(
                          widget.name,
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontSizeS,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.primary,
                        size: 30,
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

  // ✅ Helper method untuk warna
  Color _getItemColor(bool isHovered, bool isPressed) {
    if (isHovered || isPressed) {
      return AppColors.white1;
    } else {
      return Colors.white;
    }
  }
}
