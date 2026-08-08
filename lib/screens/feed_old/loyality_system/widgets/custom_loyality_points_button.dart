import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomLoyalityPointsButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback onTap;
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;
  final List<BoxShadow>? boxShadow;

  const CustomLoyalityPointsButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textStyle,
    required this.onTap,
    this.height = 24.0,
    this.width = double.infinity,
    this.margin = const EdgeInsets.symmetric(horizontal: 22.5),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: backgroundColor,
          boxShadow: boxShadow,
        ),
        child: Text(text.tr(), style: textStyle),
      ),
    );
  }
}
