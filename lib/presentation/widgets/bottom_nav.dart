import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Colors.white,
        elevation: 0,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left side items
            _buildNavItem(
              icon: Icons.home_rounded,
              label: 'Beranda',
              index: 0,
              isActive: currentIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.description_rounded,
              label: 'Layanan',
              index: 1,
              isActive: currentIndex == 1,
            ),

            // Spacer untuk FAB di tengah
            const SizedBox(width: 40),

            // Right side items
            _buildNavItem(
              icon: Icons.groups_rounded,
              label: 'Komunitas',
              index: 2,
              isActive: currentIndex == 2,
            ),
            _buildNavItem(
              icon: Icons.person_rounded,
              label: 'Profil',
              index: 3,
              isActive: currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return _NavItem(
      icon: icon,
      label: label,
      index: index,
      isActive: isActive,
      onTap: onTap,
    );
  }
}

// ✅ NavItem sebagai StatefulWidget dengan ValueNotifier
class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  // ✅ ValueNotifier untuk state hover dan pressed
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
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed.value = true),
      onTapUp: (_) => setState(() => _isPressed.value = false),
      onTapCancel: () => setState(() => _isPressed.value = false),
      onTap: () => widget.onTap(widget.index),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered.value = true),
        onExit: (_) => setState(() => _isHovered.value = false),
        child: AnimatedSlide(
          offset: widget.isActive ? const Offset(0, -0.05) : Offset.zero,
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isHovered,
            builder: (context, isHovered, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: _isPressed,
                builder: (context, isPressed, child) {
                  final color = _getColor(isHovered, isPressed);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: color, size: 30),
                      const SizedBox(height: 2),
                      Text(
                        widget.label,
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSizeXS,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ✅ Helper method untuk menentukan warna
  Color _getColor(bool isHovered, bool isPressed) {
    if (isPressed || isHovered) return AppColors.cyan1;
    if (widget.isActive) return AppColors.cyan1;
    return AppColors.gray1;
  }
}

// 🎯 Floating Action Button untuk ditambahkan di Scaffold
class CenterFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final int currentIndex;

  const CenterFAB({
    super.key,
    required this.onPressed,
    required this.currentIndex,
  });

  @override
  State<CenterFAB> createState() => _CenterFABState();
}

class _CenterFABState extends State<CenterFAB> {
  // ✅ ValueNotifier untuk state hover dan pressed
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
        child: ValueListenableBuilder<bool>(
          valueListenable: _isHovered,
          builder: (context, isHovered, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isPressed,
              builder: (context, isPressed, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _getGradientColors(isHovered, isPressed),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getShadowColor(isHovered, isPressed),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5),
                  child: FloatingActionButton(
                    onPressed: widget.onPressed,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    disabledElevation: 0,
                    child: Icon(Icons.send, size: 30, color: Colors.white),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Color> _getGradientColors(bool isHovered, bool isPressed) {
    if (isPressed || isHovered) {
      return [AppColors.orange1, AppColors.secondary];
    }
    return [AppColors.background, AppColors.cyan1];
  }

  Color _getShadowColor(bool isHovered, bool isPressed) {
    if (isHovered || isPressed) {
      return AppColors.orange1;
    }
    return AppColors.background;
  }
}
