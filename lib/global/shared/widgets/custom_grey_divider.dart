import 'package:flutter/material.dart';

class CustomGreyDivider extends StatelessWidget {
  const CustomGreyDivider({
    super.key,
    this.top,
    this.bottom,
  });
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: top ?? 11.97),
        const Divider(
          height: 0,
          thickness: 1,
          color: Color(0xFFE1E1E1),
        ),
        SizedBox(height: bottom ?? 13),
      ],
    );
  }
}
