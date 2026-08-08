import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double horizontalPadding;
  final double thickness;
  final Color color;

  const CustomDivider({
    super.key,
    this.horizontalPadding = 16.0,
    this.thickness = 0.1,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Divider(
        thickness: thickness,
        color: color,
      ),
    );
  }
}
