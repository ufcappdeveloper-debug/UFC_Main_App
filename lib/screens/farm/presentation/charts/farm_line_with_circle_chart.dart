import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_chart_component.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_circal_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_line_chart.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class FarmLineWithCircleChart extends StatelessWidget {
  const FarmLineWithCircleChart({
    super.key,
    required this.lineChartData,
    required this.percentageCircle,
    required this.title,
    required this.total,
  });

  final List<double> lineChartData;
  final double percentageCircle;
  final double total;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FarmChartComponent(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: NumberFormat.decimalPattern('en').format(total),
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
          kHeight15,
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 70, width: 70, child: FarmLineChart(lineChartData)),
                kWidth10,
                PercentageCircle(
                  percentage: percentageCircle,
                  secondColor: Colors.grey.shade200,
                  size: Size(53.5, 53.5),
                  isPlus: true,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
