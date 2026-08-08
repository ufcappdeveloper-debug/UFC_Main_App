import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../global/extensions/app_colors.dart';

class DeathLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double? height;
  final double? width;
  final double? maxY;
  final double? maxX;
  const DeathLineChart({
    super.key,
    required this.spots,
    this.height = 70,
    this.width = 100,
    required this.maxX,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(show: false),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: AppColors.purpleColor,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  spots: spots,
                  isStrokeCapRound: true,
                  barWidth: 3,
                ),
              ],
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: maxY,
            ),
          ),
        ),
      ],
    );
  }
}
