import 'package:flutter/material.dart';
import 'dart:math';

import 'package:ufc_mobile/global/extensions/app_colors.dart';

class PercentageCircle extends StatelessWidget {
  final double percentage; // from 0 to 100
  final double strokeWidth;
  final Size size; // from 0 to 100
  final Color firstColor;
  final Color secondColor;
  final bool? isPlus;

  const PercentageCircle({
    super.key,
    required this.percentage,
    required this.size,
    this.firstColor = AppColors.farmColor,
    this.secondColor = Colors.grey,
    this.strokeWidth = 10,
    this.isPlus,
  });

  String get _isPlus {
    return isPlus != null
        ? isPlus!
            ? '+'
            : '-'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: CirclePainter(
        percentage,
        firstColor: firstColor,
        secondColor: secondColor,
        strokeWidth: strokeWidth,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "$_isPlus${percentage.toInt()}%",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color firstColor;
  final Color secondColor;

  CirclePainter(
    this.percentage, {
    required this.strokeWidth,
    required this.firstColor,
    required this.secondColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = secondColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = firstColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw percentage arc
    double angle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2 * pi / 4, //-pi / 2, // start from top
      angle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
