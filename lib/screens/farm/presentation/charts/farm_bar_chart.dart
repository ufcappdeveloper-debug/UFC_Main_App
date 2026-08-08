import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_style.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/bar_chart_month_model.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_pointer_indicator.dart';

class FarmBarCHart extends StatelessWidget {
  final List<String> months;
  final List<int> firstValueCounts;
  final List<int> secondValueCounts;
  final String? title;
  final List<Legends> legends;

  const FarmBarCHart({
    super.key,
    required this.months,
    required this.firstValueCounts,
    required this.secondValueCounts,
    required this.title,
    required this.legends,
  });

  //Pick last 7 months including current month
  List<T> _last7<T>(List<T> data) {
    if (data.isEmpty) return data;

    // current month index (0-based: Jan=0)
    int currentIndex = DateTime.now().month - 1;

    List<T> last7 = [];

    // Pick 7 months ending at current month, wrapping around
    for (int i = 6; i >= 0; i--) {
      int index = (currentIndex - i) % data.length;
      if (index < 0) index += data.length; // handle negative modulo
      last7.add(data[index]);
    }

    return last7;
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current locale is RTL
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    // Slice to last 7 months including current month
    final displayMonths = _last7(months);
    final displayFirstValues = _last7(firstValueCounts);
    final displaySecondValues = _last7(secondValueCounts);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300, // subtle shadow
            offset: const Offset(0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 6.0,
          bottom: 6.0,
          left: 10,
          right: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeight10,
            CustomText(
              text: title ?? '-',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            kHeight15,
            Row(
              children: [
                PointerIndicator(
                  pointerIndicatorData: PointerIndicatorData(
                    color: AppColors.feedGreen,
                    name: firstIndicatorName,
                    total: firstIndicatorValue,
                  ),
                ),
                kWidth15,
                PointerIndicator(
                  pointerIndicatorData: PointerIndicatorData(
                    color: AppColors.buttonBlue,
                    name: secondIndicatorName,
                    total: secondIndicatorValue,
                  ),
                ),
              ],
            ),
            kHeight25,
            Transform(
              alignment: Alignment.center,
              transform: isRTL
                  ? (Matrix4.identity()
                    ..scale(-1.0, 1.0)) // Flip horizontally for RTL
                  : Matrix4.identity(),
              child: AspectRatio(
                aspectRatio: 2.5,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxSecondValue(displayFirstValues),
                    minY: -_getMaxFirstValue(displaySecondValues),
                    borderData: FlBorderData(show: false),
                    barTouchData: const BarTouchData(enabled: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _getHorizontalLevel(
                          displayFirstValues, displaySecondValues),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade400,
                        strokeWidth: .5,
                        dashArray: null,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: reservedWidth,
                          getTitlesWidget: (value, meta) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: isRTL
                                  ? (Matrix4.identity()
                                    ..scale(
                                        -1.0, 1.0)) // Flip text back for RTL
                                  : Matrix4.identity(),
                              child: CustomText(
                                text: value.abs().toInt().toString(),
                                textStyle: AppFontStyle.getRegularStyle(
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < displayMonths.length) {
                              return Transform(
                                alignment: Alignment.center,
                                transform: isRTL
                                    ? (Matrix4.identity()
                                      ..scale(
                                          -1.0, 1.0)) // Flip text back for RTL
                                    : Matrix4.identity(),
                                child: CustomText(
                                  text: displayMonths[value.toInt()],
                                  textStyle: AppFontStyle.getRegularStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(displayMonths.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        groupVertically: true,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: displayFirstValues[index].toDouble(),
                            width: 7,
                            color: AppColors.feedGreen,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          // Male (downwards)
                          BarChartRodData(
                            fromY: 0,
                            toY: -displaySecondValues[index].toDouble(),
                            width: 7,
                            color: AppColors.buttonBlue,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods with parameters since we're using reversed data
  double _getMaxSecondValue(List<int> values) {
    return values.isEmpty
        ? 1
        : values.reduce((a, b) => a > b ? a : b).toDouble();
  }

  double _getMaxFirstValue(List<int> values) {
    return values.isEmpty
        ? 1
        : values.reduce((a, b) => a > b ? a : b).toDouble();
  }

  double _getHorizontalLevel(List<int> firstValues, List<int> secondValues) {
    final maxFirst = _getMaxFirstValue(secondValues);
    final maxSecond = _getMaxSecondValue(firstValues);
    final value = (maxSecond > maxFirst ? maxSecond : maxFirst) / 5;
    return value != 0 ? value : 1;
  }

  double get maxSecondValue {
    return firstValueCounts.isEmpty
        ? 1
        : firstValueCounts.reduce((a, b) => a > b ? a : b).toDouble();
  }

  double get maxFirstValue {
    return secondValueCounts.isEmpty
        ? 1
        : secondValueCounts.reduce((a, b) => a > b ? a : b).toDouble();
  }

  int get maxLabelValue => [
        maxFirstValue.toInt(),
        maxSecondValue.toInt(),
      ].reduce((a, b) => a > b ? a : b);

  int get maxLabelLength => maxLabelValue.toString().length;

  // Scale reserved size based on digit length
  double get reservedWidth {
    final value = (maxLabelLength * 8).toDouble() + 16;

    return value;
  }

  /// 1st indicator title
  String get firstIndicatorName {
    return legends.isNotEmpty ? legends[0].nameTr ?? '-' : '-';
  }

  /// 1st indicator value
  double get firstIndicatorValue {
    return legends.isNotEmpty ? parseDouble(legends[0].total) ?? 0 : 0;
  }

  /// second indicator title
  String get secondIndicatorName {
    return legends.length > 1 ? legends[1].name ?? '-' : '-';
  }

  /// second indicator value
  double get secondIndicatorValue {
    return legends.length > 1 ? parseDouble(legends[1].total) ?? 0 : 0;
  }
}
