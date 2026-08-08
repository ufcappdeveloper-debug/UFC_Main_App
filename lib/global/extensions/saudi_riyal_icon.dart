import 'package:flutter/material.dart';

class SaudiRiyalIcon extends StatelessWidget {
  final double size;
  final Color color;
  final TextStyle? style;

  const SaudiRiyalIcon({
    super.key,
    this.size = 24,
    this.color = Colors.black,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "\u{E900}",
      strutStyle: StrutStyle(height: 1.1),
      style: style ??
          TextStyle(
            fontSize: size,
            fontFamily: "SaudiRiyal",
            fontWeight: FontWeight.w300,
            color: color,
          ),
    );
  }
}
