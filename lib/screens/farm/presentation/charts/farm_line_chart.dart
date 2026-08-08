import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';

class FarmLineChart extends StatelessWidget {
  final List<double> data;
  final Color? color;

  const FarmLineChart(this.data, {super.key, this.color});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(data, color: color),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<double> data;
  final Color? color;

  LinePainter(this.data, {this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? AppColors.farmColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    if (data.length < 2) return;

    double maxData = data.reduce((a, b) => a > b ? a : b);
    double minData = data.reduce((a, b) => a < b ? a : b);
    double range = maxData - minData == 0 ? 1 : maxData - minData;

    // Horizontal spacing between points
    double stepX = size.width / (data.length - 1);

    // Generate points from data
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = size.height - ((data[i] - minData) / range) * size.height;
      points.add(Offset(x, y));
    }

    // Draw lines between points
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
