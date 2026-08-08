import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({
    super.key,
    this.text,
    this.margin,
    this.decoration,
    required this.height,
  });
  final String? text;
  final double height;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Text(
        (text ?? 'No Data Found').tr(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primaryColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
