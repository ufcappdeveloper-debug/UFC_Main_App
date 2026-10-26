import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import '../../domain/entities/livestock/livestock_reports_model.dart';
import '../../domain/entities/livestock/predefined_animal_list_model.dart';

class WeightChart extends StatefulWidget {
  final Map<String, List<Answer>> answers;
  final Weight? initWeight;

  const WeightChart({
    super.key,
    required this.answers,
    this.initWeight,
  });

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  late List<double> weights;
  late List<String> dates;

  @override
  void initState() {
    super.initState();
    _processData();
  }

  void _processData() {
    final pairs = <Map<String, dynamic>>[];

    //  Add initWeight first
    if (widget.initWeight != null &&
        widget.initWeight?.weight != null &&
        widget.initWeight?.weightDate != null) {
      pairs.add({
        "date": widget.initWeight!.weightDate!,
        "weight": widget.initWeight!.weight!,
      });
    }

    //  Add from answers
    widget.answers.forEach((key, value) {
      final weightItem = value.firstWhere(
        (e) => e.questionKey == "animal_weight",
        orElse: () => Answer(),
      );
      final dateItem = value.firstWhere(
        (e) => e.questionKey == "weight_date",
        orElse: () => Answer(),
      );

      if (weightItem.answer != null && dateItem.answer != null) {
        pairs.add({
          "date": dateItem.answer.toString(),
          "weight": double.tryParse(weightItem.answer.toString()) ?? 0,
        });
      }
    });

    //  Sort by date
    pairs.sort(
      (a, b) => DateTime.parse(a["date"]).compareTo(DateTime.parse(b["date"])),
    );

    //  Keep only last 3 entries
    final latestThree =
        pairs.length > 3 ? pairs.sublist(pairs.length - 3) : pairs;

    dates = latestThree.map((e) => e["date"]?.toString() ?? '').toList();
    weights = latestThree
        .map((e) => double.tryParse(e["weight"]?.toString() ?? '') ?? 0)
        .toList();
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.tryParse(rawDate);
      return date != null ? DateFormat("dd/MM/yy").format(date) : '';
    } catch (_) {
      return rawDate;
    }
  }

  double _calculateInterval(double maxValue) {
    if (maxValue <= 0) return 10;

    // Target about 5 steps
    double rough = maxValue / 10;

    // Round rough to "nice" numbers
    if (rough <= 10) return 10;
    if (rough <= 20) return 20;
    if (rough <= 25) return 25;
    if (rough <= 50) return 50;
    if (rough <= 100) return 100;
    if (rough <= 200) return 200;
    if (rough <= 500) return 500;

    // For very large numbers → round to nearest 1000
    return (rough / 1000).ceil() * 1000;
  }

  @override
  Widget build(BuildContext context) {
    final latestWeight =
        weights.isNotEmpty ? weights.last.toStringAsFixed(0) : "0";

    final maxWeight =
        weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) : 50.0;

    final interval = _calculateInterval(maxWeight);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                text: 'Weight',
                textStyle: PetVeterinaryFontstyles.kanitRegular16.copyWith(fontFamily: AppFontsFamily.alexandria)),
            Row(
              children: [
                CustomText(
                  text: '$latestWeight ',
                  fontSize: 21,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  fontWeight: FontWeight.w400,
                  color: AppColors.farmColor,
                ),
                CustomText(
                  text: 'Kg',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.farmColor,
                ),
              ],
            ),
          ],
        ),
        kHeight10,
        // Chart
        SizedBox(
          height: 230,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (weights.isNotEmpty
                      ? (weights.reduce((a, b) => a > b ? a : b))
                      : 50) +
                  20,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 35,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < dates.length) {
                        return Text(
                          _formatDate(dates[index]),
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 40,
                    showTitles: true,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      // Only show whole tens (like 100, 110, 120)
                      if (value % interval == 0) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink(); // hide in-between values
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  );
                },
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true,
              ),
              borderData: FlBorderData(show: false),
              barGroups: weights.asMap().entries.map((entry) {
                int index = entry.key;
                double value = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      width: 50,
                      borderRadius: BorderRadius.circular(0),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.farmColor, Colors.white],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        kHeight10,
      ],
    );
  }
}

class CustomOutlinedContainer extends StatelessWidget {
  const CustomOutlinedContainer({
    super.key,
    this.fillColor,
    required this.title,
    this.fill = false,
    this.width,
    this.onTap,
    this.margin,
    this.subText,
  });
  final String title;
  final bool fill;
  final Color? fillColor;
  final double? width;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        alignment: Alignment.center,
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: fill ? fillColor ?? AppColors.farmColor : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: AppColors.farmColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  textAlign: TextAlign.center,
                  text: title,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: fill ? Colors.white : AppColors.farmColor,
                ),
              ],
            ),
            if (subText != null)
              CustomText(
                textAlign: TextAlign.center,
                text: subText ?? "",
                // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: fill ? Colors.white : AppColors.farmColor,
              ),
          ],
        ),
      ),
    );
  }
}
