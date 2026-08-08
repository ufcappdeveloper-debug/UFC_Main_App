import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/farm/farm_dashboard_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_card_model.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_bar_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_chart_component.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_circal_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_circle_with_pointers_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_line_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_line_with_circle_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/farm_pointer_indicator.dart';
import 'package:ufc_mobile/screens/farm/presentation/death_page.dart';

import '../mother_and_baby_page.dart';

class BuildDashboardCards extends StatefulWidget {
  final List<CardModel> cards;
  const BuildDashboardCards({super.key, required this.cards});

  @override
  State<BuildDashboardCards> createState() => _BuildDashboardCardsState();
}

class _BuildDashboardCardsState extends State<BuildDashboardCards> {
  bool isNavigating = false;
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    final List<CardModel> rowBuffer = [];

    for (final card in widget.cards) {
      if (card.type == 'stat_chart' ||
          card.type == 'pie_chart' ||
          card.type == 'donut_chart') {
        rowBuffer.add(card);

        if (rowBuffer.length == 2) {
          // flush two into a Row
          widgets.add(
            Row(
              children: rowBuffer
                  .map((c) => Expanded(
                        child: Padding(
                          padding: kall(8),
                          child: showCard(c),
                        ),
                      ))
                  .toList(),
            ),
          );
          rowBuffer.clear();
        }
      } else {
        // before adding full-width, flush any single leftover card
        if (rowBuffer.isNotEmpty) {
          widgets.add(
            Row(
              children: rowBuffer
                  .map((c) => Expanded(
                        child: Padding(
                          padding: kall(8),
                          child: showCard(c),
                        ),
                      ))
                  .toList(),
            ),
          );
          rowBuffer.clear();
        }

        // add full width
        widgets.add(
          Padding(
            padding: kall(8),
            child: showCard(card),
          ),
        );
      }
    }

    // flush last row if one card left
    if (rowBuffer.isNotEmpty) {
      widgets.add(
        Row(
          children: rowBuffer
              .map((c) => Expanded(
                    child: Padding(
                      padding: kall(8),
                      child: showCard(c),
                    ),
                  ))
              .toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget showCard(CardModel? card) {
    switch (card?.type) {
      case 'bar_chart':
        final data = FarmDashboardUtils.extractMonthsForBarChart(
            card?.barChartData?.months);
        return FarmBarCHart(
          title: card?.heading,
          months: data.months,
          firstValueCounts: data.firstValueCounts,
          secondValueCounts: data.secondValueCounts,
          legends: card?.barChartData?.legends ?? [],
        );
      case 'donut_chart':
        return donutOrPieChart(card);
      case 'pie_chart':
        return donutOrPieChart(card);
      case 'mixed_chart':
        return donutAndLineChart(card);
      case 'stat_chart':
        // mustafa informed to use percentageChange value not "percentage"
        return FarmLineWithCircleChart(
          title: card?.heading ?? '-',
          lineChartData: FarmDashboardUtils.getLineChartValue(card),
          percentageCircle: parseDouble(card?.percentageChange) ?? 0,
          total: parseDouble(card?.value) ?? 0,
        );
      case null:
        return SizedBox.shrink();
      default:
        debugPrint("Unknown chart type");
        return SizedBox.shrink();
    }
  }

  GestureDetector donutOrPieChart(CardModel? card) {
    return GestureDetector(
      onTap: () async {
        if (card?.id == null) return;
        if (!card!.id!.contains('mothers_babies')) return;
        // to prevent multiple taps
        if (isNavigating) return;
        isNavigating = true;
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => MotherAndBaby(),
          ),
        );
        isNavigating = false;
      },
      child: FarmCircleWithPointersChart(
        isPlus: card?.percentageChange?.toString().split('').firstOrNull != '-'
            ? true
            : null,
        title: card?.heading ?? '-',
        percentageCircle: parseDouble(card?.percentageChange) ?? 0,
        firstPointer: PointerIndicatorData(
          color: AppColors.farmColor,
          name: FarmDashboardUtils.cardLabelFirst(card),
          total: FarmDashboardUtils.cardLabelFirstValue(card),
        ),
        secondPointer: PointerIndicatorData(
          color: Colors.cyan,
          name: FarmDashboardUtils.cardLabelSecond(card),
          total: FarmDashboardUtils.cardLabelSecondValue(card),
        ),
      ),
    );
  }

  Widget donutAndLineChart(CardModel? card) {
    return GestureDetector(
      onTap: () async {
        if (card?.id == 'death') {
          // to prevent multiple taps
          if (isNavigating) return;
          isNavigating = true;
          await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => DeathPage(),
            ),
          );

          isNavigating = false;
        }
      },
      child: FarmChartComponent(
        title: card?.heading ?? '',
        height: 120,
        child: Row(
          children: [
            PercentageCircle(
              percentage: parseDouble(card?.donutChartData?.percentageChange) ??
                  parseDouble(card?.percentageChange) ??
                  0,
              firstColor: AppColors.purpleColor,
              secondColor: Colors.grey.shade200,
              size: const Size(53.5, 53.5),
            ),
            kWidth10,
            Expanded(
              child: CustomText(
                text: card?.subtitle ?? '-',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            kWidth5,
            SizedBox(
              height: 60,
              width: 80,
              child: FarmLineChart(
                FarmDashboardUtils.getLineChartValue(card),
                color: AppColors.purpleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
