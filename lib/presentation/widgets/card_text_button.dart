import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class CardTextButton extends StatelessWidget {
  final List<Color> color;
  final bool boxShadow;
  final String title;
  final String subTitle;
  final List<Color> textButtonColors;
  final String textButton;
  final bool gradient;
  final Widget? icon;
  final double textButtonSize;
  final Color titleColor;
  final Color subTitleColor;
  final double? maxHeight;

  const CardTextButton({
    super.key,
    required this.color,
    required this.boxShadow,
    required this.title,
    required this.subTitle,
    required this.textButtonColors,
    required this.textButton,
    this.gradient = false,
    this.icon,
    required this.textButtonSize,
    required this.titleColor,
    required this.subTitleColor,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : null,
      decoration: BoxDecoration(
        gradient: gradient
            ? LinearGradient(
                colors: color,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: gradient ? null : color[0],
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        boxShadow: boxShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),

      child: Stack(
        children: [
          // wave background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              // Tentukan radius di sini (contoh: 20)
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: SvgPicture.string(
                ''' <svg width="180" height="24" viewBox="0 0 180 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 20.0595C0 11.6948 9.78741 9.09845 18 7.51054C24 6.35044 30 -0.300139 36 0.0105419C42 0.321222 48 7.59347 54 7.51054C60 7.42761 66 -0.0101911 72 0.0105419C78 0.0312749 84 7.51054 90 7.51054C96 7.51054 102 0.0312749 108 0.0105419C114 -0.0101911 120 7.42761 126 7.51054C132 7.59347 138 0.321222 144 0.0105419C150 -0.300139 156 6.35044 162 7.51054C170.213 9.09845 180 11.6948 180 20.0595V80C180 88.2843 173.284 95 165 95C164 95 163 95 162 95C156 95 150 95 144 95C138 95 132 95 126 95C120 95 114 95 108 95C102 95 96 95 90 95C84 95 78 95 72 95C66 95 60 95 54 95C48 95 42 95 36 95C30 95 24 95 18 95C17 95 16 95 15 95C6.71573 95 0 88.2843 0 80V20.0595Z" fill="white" fill-opacity="0.12"/>
<path d="M0 23.4334C0 18.6152 2.21569 13.9345 6.33188 11.4299C10.2213 9.06336 14.1106 7.50848 18 8.2607C24 9.4208 30 16.0714 36 15.7607C42 15.4497 48 8.17777 54 8.2607C60 8.34332 66 15.7811 72 15.7607C78 15.74 84 8.2607 90 8.2607C96 8.2607 102 15.74 108 15.7607C114 15.7811 120 8.34332 126 8.2607C132 8.17777 138 15.4497 144 15.7607C150 16.0714 156 9.4208 162 8.2607C165.889 7.50848 169.779 9.06336 173.668 11.4299C177.784 13.9345 180 18.6152 180 23.4334V80C180 88.2843 173.284 95 165 95C164 95 163 95 162 95C156 95 150 95 144 95C138 95 132 95 126 95C120 95 114 95 108 95C102 95 96 95 90 95C84 95 78 95 72 95C66 95 60 95 54 95C48 95 42 95 36 95C30 95 24 95 18 95C17 95 16 95 15 95C6.71573 95 0 88.2843 0 80V23.4334Z" fill="white" fill-opacity="0.1"/>
<path d="M0 36.5595C0 28.1948 9.78741 25.5985 18 24.0105C24 22.8504 30 16.1999 36 16.5105C42 16.8212 48 24.0935 54 24.0105C60 23.9276 66 16.4898 72 16.5105C78 16.5313 84 24.0105 90 24.0105C96 24.0105 102 16.5313 108 16.5105C114 16.4898 120 23.9276 126 24.0105C132 24.0935 138 16.8212 144 16.5105C150 16.1999 156 22.8504 162 24.0105C170.213 25.5985 180 28.1948 180 36.5595V80C180 88.2843 173.284 95 165 95C164 95 163 95 162 95C156 95 150 95 144 95C138 95 132 95 126 95C120 95 114 95 108 95C102 95 96 95 90 95C84 95 78 95 72 95C66 95 60 95 54 95C48 95 42 95 36 95C30 95 24 95 18 95C17 95 16 95 15 95C6.71573 95 0 88.2843 0 80V36.5595Z" fill="white" fill-opacity="0.08"/>
</svg>

 ''',
                height: 95,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(6),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // icon
                  if (icon != null) icon!,

                  const SizedBox(height: AppSizes.xs),
                  // title
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: titleColor,
                      fontSize: AppSizes.fontSizeXS,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    subTitle,
                    style: GoogleFonts.poppins(
                      color: subTitleColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSizes.xs),

                  // button
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return textButtonColors[1];
                        } else if (states.contains(WidgetState.hovered)) {
                          return textButtonColors[1];
                        }
                        return textButtonColors[0];
                      }),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      textButton,
                      style: GoogleFonts.poppins(
                        color: textButtonColors[2],
                        fontWeight: FontWeight.w600,
                        fontSize: textButtonSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
