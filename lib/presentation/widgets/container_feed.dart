import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class ContainerFeed extends StatefulWidget {
  final Color color;
  final bool boxShadow;
  final double? maxHeight;
  final Image image;
  final String title;
  final Color titleColor;
  final String subTitle;
  final Color subTitleColor;
  final bool badge;
  final String? badgeText;
  final String createdAt;
  final Color colorCreatedAt;
  final String creator;
  final Color creatorColor;
  final String dateCreated;
  final String likes;
  final String comment;
  final List<Color> textButtonColors;
  final String textButton;
  final double textButtonSize;

  const ContainerFeed({
    super.key,
    required this.color,
    this.boxShadow = true,
    this.maxHeight,
    required this.image,
    required this.title,
    required this.titleColor,
    required this.subTitle,
    required this.subTitleColor,
    this.badge = true,
    this.badgeText,
    required this.createdAt,
    required this.colorCreatedAt,
    required this.creator,
    required this.creatorColor,
    required this.dateCreated,
    required this.likes,
    required this.comment,
    required this.textButtonColors,
    required this.textButton,
    required this.textButtonSize,
  });

  @override
  State<ContainerFeed> createState() => _ContainerFeedState();
}

class _ContainerFeedState extends State<ContainerFeed> {
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
      constraints: widget.maxHeight != null
          ? BoxConstraints(maxHeight: widget.maxHeight!)
          : null,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // header
            Row(
              children: [
                // icon
                Container(
                  constraints: BoxConstraints(maxHeight: 30),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      child: widget.image,
                    ),
                  ),
                ),

                const SizedBox(width: 2),

                //  creator & created at
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // creator
                      Text(
                        widget.creator,
                        style: GoogleFonts.poppins(
                          color: widget.creatorColor,
                          fontSize: AppSizes.fontSizeXS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.badge)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
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

                          Text(
                            widget.createdAt,
                            style: GoogleFonts.poppins(
                              color: widget.colorCreatedAt,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // title & subtitle
            // title
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                color: widget.titleColor,
                fontSize: 12,
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
              maxLines: 4,
            ),

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
                  widget.dateCreated,
                  style: GoogleFonts.poppins(
                    color: AppColors.cyan1,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                      widget.likes,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: AppSizes.xs),

                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.comment,
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
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      Set<WidgetState> states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return widget.textButtonColors[1];
                      } else if (states.contains(WidgetState.hovered)) {
                        return widget.textButtonColors[1];
                      }
                      return widget.textButtonColors[0];
                    }),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            ),
          ],
        ),
      ),
    );
  }
}
