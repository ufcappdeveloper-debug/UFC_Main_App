import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? textColor;
  final String? image;
  final bool? hasImage;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final double? height;
  final double? radius;
  final FontWeight? fontWeight;
  final double? fontSize;
  final EdgeInsetsGeometry? imagePadding;
  final double? width;
  final String? fontFamily;
  final List<BoxShadow>? boxShadow;
  final bool isLoading;
  final bool disabled;
  final Widget? child;
  const CustomButton(
      {super.key,
      required this.title,
      this.color,
      this.textColor,
      this.image,
      this.boxShadow,
      this.hasImage = false,
      this.disabled = false,
      required this.onTap,
      this.border,
      this.height = 42,
      this.radius,
      this.fontWeight,
      this.fontSize,
      this.imagePadding,
      this.width = 287,
      this.fontFamily,
      this.isLoading = false,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading || disabled ? () {} : onTap,
        splashColor: Colors.green[300],
        borderRadius: BorderRadius.circular(radius ?? 9.0),
        child: Ink(
          height: height ?? 59,
          width: width,
          decoration: BoxDecoration(
            color: disabled ? primaryGrey : color ?? const Color(0xff78B833),
            borderRadius: BorderRadius.circular(radius ?? 9.0),
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      color: Colors.black.withValues(alpha: 0.1))
                ],
            border:
                border ?? Border.all(width: 0, color: const Color(0xffeeeeee)),
          ),
          child: isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                )
              : child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Expanded(child: SizedBox(width: 5)),
                      // Expanded(child: SizedBox(width: 0)),
                      if (hasImage ?? false) const SizedBox(width: 12),
                      if (hasImage ?? false)
                        Expanded(
                          flex: 1,
                          child: Visibility(
                              visible: hasImage ?? false,
                              child: Padding(
                                padding:
                                    imagePadding ?? const EdgeInsets.all(0),
                                child: Image.asset(
                                  image ?? "",
                                  height: 35,
                                  width: 35,
                                ),
                              )),
                        ),
                      Expanded(
                        flex: hasImage == true ? 1 : 3,
                        child: Center(
                          child: Text(
                            title.tr(),
                            style: TextStyle(
                              fontFamily: fontFamily ??
                                  (isEnglish
                                      ? AppFontsFamily.english
                                      : AppFontsFamily.arabic),
                              fontSize: fontSize ?? 15.5,
                              color: textColor ?? const Color(0xffffffff),
                              letterSpacing: 0.007,
                              fontWeight: fontWeight ?? FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (hasImage ?? false)
                        const Expanded(flex: 1, child: SizedBox(width: 15)),
                      // SizedBox(width: 80)
                      // const Expanded(flex: 1, child: SizedBox(width: 10)),
                    ],
                  ),
        ),
      ),
    );
  }
}
