import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.secondary, AppColors.orange4],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isSelected ? null : AppColors.white2,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s,
          vertical: 4,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeXS,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.cyan1,
          ),
        ),
      ),
    );
  }
}
