import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class ContainerInfoButton extends StatelessWidget {
  final Color color;
  final bool boxShadow;
  final IconData? iconHeader;
  final Color? colorIconHeader;
  final double? sizeIconHeader;
  final String title;
  final String subTitle;
  final Color titleColor;
  final Color subTitleColor;
  final IconData? iconFooter;
  final Color? colorIconFooter;
  final double? sizeIconFooter;
  final String? footerText;
  final Color? footerTextColor;
  final bool footer;
  final List<Color> textButtonColors;
  final String textButton;
  final double textButtonSize;
  final double? maxHeight;

  const ContainerInfoButton({
    super.key,
    required this.color,
    this.boxShadow = true,
    this.iconHeader,
    this.colorIconHeader,
    this.sizeIconHeader,
    required this.title,
    required this.subTitle,
    required this.titleColor,
    required this.subTitleColor,
    this.iconFooter,
    this.colorIconFooter,
    this.sizeIconFooter,
    this.footerText,
    this.footerTextColor,
    this.footer = true,
    required this.textButtonColors,
    required this.textButton,
    required this.textButtonSize,
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
        color: color,
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

          Padding(
            padding: EdgeInsets.all(AppSizes.s),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (iconHeader != null)
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconHeader!,
                          color: colorIconHeader ?? Colors.white,
                          size: sizeIconHeader ?? 24,
                        ),
                      ),

                    if (iconHeader != null) const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: titleColor,
                              fontSize: AppSizes.fontSizeXS,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // subtitle
                          Text(
                            subTitle,
                            style: GoogleFonts.poppins(
                              color: subTitleColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.s),

                // footer
                if (footer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Icon + Footer Text dengan Expanded dan Wrap
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (iconFooter != null)
                              Icon(
                                iconFooter,
                                color: colorIconFooter ?? Colors.white,
                                size: sizeIconFooter ?? 20,
                              ),

                            if (iconFooter != null) const SizedBox(width: 5),

                            if (footerText != null)
                              Expanded(
                                child: Text(
                                  footerText!,
                                  style: GoogleFonts.poppins(
                                    color: footerTextColor ?? Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Button
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.pressed)) {
                                  return textButtonColors[1];
                                } else if (states.contains(
                                  WidgetState.hovered,
                                )) {
                                  return textButtonColors[1];
                                }
                                return textButtonColors[0];
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
                          textButton,
                          style: GoogleFonts.poppins(
                            color: textButtonColors[2],
                            fontWeight: FontWeight.w600,
                            fontSize: textButtonSize,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Tanpa footer (hanya button)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return textButtonColors[1];
                            } else if (states.contains(WidgetState.hovered)) {
                              return textButtonColors[1];
                            }
                            return textButtonColors[0];
                          },
                        ),
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
                        textButton,
                        style: GoogleFonts.poppins(
                          color: textButtonColors[2],
                          fontWeight: FontWeight.w600,
                          fontSize: textButtonSize,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
