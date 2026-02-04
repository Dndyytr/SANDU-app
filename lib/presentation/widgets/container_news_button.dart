import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class ContainerNewsButton extends StatefulWidget {
  final Color color;
  final bool boxShadow;
  final Image? image;
  final SvgPicture? svg;
  final String title;
  final String subTitle;
  final Color titleColor;
  final Color subTitleColor;
  final bool badge;
  final String? badgeText;
  final List<Color> textButtonColors;
  final String textButton;
  final double textButtonSize;
  final String? location;
  final Color? colorLocation;
  final String? dateCreated;
  final String? likes;
  final Function(BuildContext)? onPressed;

  const ContainerNewsButton({
    super.key,
    required this.color,
    this.boxShadow = true,
    this.image,
    this.svg,
    required this.title,
    required this.subTitle,
    required this.titleColor,
    required this.subTitleColor,
    this.badge = true,
    this.badgeText,
    required this.textButtonColors,
    required this.textButton,
    required this.textButtonSize,
    this.location,
    this.colorLocation,
    this.dateCreated,
    this.likes,
    this.onPressed,
  });

  @override
  State<ContainerNewsButton> createState() => _ContainerNewsButtonState();
}

class _ContainerNewsButtonState extends State<ContainerNewsButton> {
  final ValueNotifier<bool> _isLiked = ValueNotifier(false);

  @override
  void dispose() {
    _isLiked.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // constraints: BoxConstraints(maxHeight: 120),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        boxShadow: widget.boxShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),

      child: Padding(
        padding: EdgeInsets.all(AppSizes.xs),
        child:
            // header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.image != null)
                  Container(
                    constraints: BoxConstraints(maxHeight: 110),
                    child: AspectRatio(
                      aspectRatio: 2.5 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: widget.image!,
                      ),
                    ),
                  ),

                if (widget.svg != null) widget.svg!,

                if (widget.image != null) const SizedBox(width: AppSizes.xs),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          color: widget.titleColor,
                          fontSize: AppSizes.fontSizeXS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // subtitle
                      Text(
                        widget.subTitle,
                        style: GoogleFonts.poppins(
                          color: widget.subTitleColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSizes.xs),

                      // badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.badge)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.secondary,
                                    AppColors.orange4,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusFull,
                                ),
                              ),
                              child: Text(
                                widget.badgeText ?? 'Sektor',
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          if (widget.location != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: widget.colorLocation,
                                  size: 10,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.location!,
                                  style: GoogleFonts.poppins(
                                    color: widget.colorLocation,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.xs),

                      if (widget.dateCreated != null || widget.likes != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.background,
                                  size: 18,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.dateCreated!,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.cyan1,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.s),
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isLiked,
                                  builder: (context, isLiked, child) {
                                    return GestureDetector(
                                      child: Icon(
                                        _isLiked.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: AppColors.pink1,
                                        size: 20,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isLiked.value = !_isLiked
                                              .value; // Membalikkan status (true jadi false, vice versa)
                                        });
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.likes!,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return widget.textButtonColors[1];
                                      } else if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return widget.textButtonColors[1];
                                      }
                                      return widget.textButtonColors[0];
                                    }),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                                minimumSize: WidgetStateProperty.all(Size.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                widget.textButton,
                                style: GoogleFonts.poppins(
                                  color: widget.textButtonColors[2],
                                  fontWeight: FontWeight.w600,
                                  fontSize: widget.textButtonSize,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: widget.onPressed != null
                                ? () => widget.onPressed!(context)
                                : null,
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return widget.textButtonColors[1];
                                    } else if (states.contains(
                                      WidgetState.hovered,
                                    )) {
                                      return widget.textButtonColors[1];
                                    }
                                    return widget.textButtonColors[0];
                                  }),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              minimumSize: WidgetStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              widget.textButton,
                              style: GoogleFonts.poppins(
                                color: widget.textButtonColors[2],
                                fontWeight: FontWeight.w600,
                                fontSize: widget.textButtonSize,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
