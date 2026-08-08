import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';

class CustomReloadProvider extends StatelessWidget {
  const CustomReloadProvider({
    super.key,
    this.margin,
    this.decoration,
    required this.height,
    required this.onPressed,
    this.txtColor = primaryColor,
  });

  final double height;
  final Color txtColor;
  final Decoration? decoration;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        alignment: Alignment.center,
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: decoration ??
            BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 16,
                color: txtColor.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            kWidth10,
            Icon(
              Icons.replay_rounded,
              color: txtColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomReloadProviderV2 extends StatelessWidget {
  const CustomReloadProviderV2({
    super.key,
    this.margin,
    this.decoration,
    required this.height,
    required this.onPressed,
    this.txtColor = primaryColor,
    this.error,
  });

  final double height;
  final Color txtColor;
  final Decoration? decoration;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 111,
        alignment: Alignment.center,
        margin: margin ??
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),
        decoration: decoration ??
            BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                ErrorHandler.getErrorMessage(error ?? 'Something Went Wrong'),
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.replay_rounded,
              color: txtColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
