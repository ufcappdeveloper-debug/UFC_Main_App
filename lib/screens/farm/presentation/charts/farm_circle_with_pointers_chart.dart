import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_chart_component.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_circal_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_pointer_indicator.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class FarmCircleWithPointersChart extends StatelessWidget {
  const FarmCircleWithPointersChart(
      {super.key,
      required this.percentageCircle,
      required this.title,
      required this.firstPointer,
      required this.secondPointer,
      this.fromDetailsPage = true,
      this.isPlus});

  final double percentageCircle;
  final String? title;
  final PointerIndicatorData firstPointer;
  final PointerIndicatorData secondPointer;
  final bool fromDetailsPage;
  final bool? isPlus;

  @override
  Widget build(BuildContext context) {
    return FarmChartComponent(
      needBorder: fromDetailsPage,
      title: title,
      child: Column(
        crossAxisAlignment: !fromDetailsPage
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 83.5,
              width: 81.5,
              child: PercentageCircle(
                percentage: percentageCircle,
                secondColor: Colors.cyan,
                size: Size(81.5, 83.5),
                strokeWidth: 14,
                isPlus: isPlus,
              ),
            ),
          ),
          kHeight15,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PointerIndicator(
                pointerIndicatorData: firstPointer,
              ),
              if (isArabic) kHeight10 else kHeight5,
              PointerIndicator(
                pointerIndicatorData: secondPointer,
              ),
            ],
          )
        ],
      ),
    );
  }
}
