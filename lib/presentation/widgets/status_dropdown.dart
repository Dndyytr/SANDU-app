import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class StatusDropdown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String label;
  final String hint;
  final double? width;
  final FormFieldValidator<String>? validator;
  final String? errorText;

  const StatusDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label = 'Status',
    this.hint = 'Pilih status',
    this.width,
    this.validator,
    this.errorText,
  });

  @override
  State<StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  late String? selectedValue;
  String? hoveredItem;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant StatusDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeM,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.s),

        // Container utama
        SizedBox(
          width: widget.width, // ⬅️ Atur lebar container induk
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true, // ⬅️ Ini yang penting!
              hint: Text(
                widget.hint,
                style: GoogleFonts.poppins(
                  fontSize: AppSizes.fontSizeM,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),

              selectedItemBuilder: (context) {
                return widget.items.map((item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSizeM,
                        color: Colors.white, // ⬅️ Warna berbeda untuk selected
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,

                  child: _DropdownItem(
                    item: item,
                    isSelected: selectedValue == item,
                    onHoverChanged: () {
                      // Kosongkan, tidak perlu karena state diatur di dalam
                    },
                  ),
                );
              }).toList(),
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
                widget.onChanged?.call(value);
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(right: AppSizes.s, left: AppSizes.m),
                elevation: 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: widget.errorText != null
                      ? Border.all(color: AppColors.error, width: 2)
                      : null,
                ),
              ),
              iconStyleData: IconStyleData(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 30,
                iconEnabledColor: Colors.white,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: widget.width,
                padding: EdgeInsets.zero,
                elevation: 0,
                decoration: BoxDecoration(color: Colors.transparent),
              ),
              menuItemStyleData: const MenuItemStyleData(
                // height: 48,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        // Tampilkan error text jika ada
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontSizeS,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// Widget terpisah untuk setiap item dengan state sendiri
class _DropdownItem extends StatefulWidget {
  final String item;
  final bool isSelected;
  final VoidCallback onHoverChanged;

  const _DropdownItem({
    required this.item,
    required this.isSelected,
    required this.onHoverChanged,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isHovered,
      builder: (context, isHovered, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered.value = true),
          onExit: (_) => setState(() => _isHovered.value = false),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.m,
              vertical: AppSizes.s,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              color: _getItemBackgroundColor(isHovered),
              border: Border.all(color: AppColors.primary, width: 2.0),
            ),
            child: Text(
              widget.item,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeM,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Color _getItemBackgroundColor(bool isHovered) {
    if (widget.isSelected) {
      return AppColors.orange4;
    }
    if (isHovered) {
      return AppColors.orange4;
    }
    return AppColors.cyan1;
  }
}
