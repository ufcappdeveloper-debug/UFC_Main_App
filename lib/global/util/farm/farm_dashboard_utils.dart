import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/bar_chart_month_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_card_model.dart';

class FarmDashboardUtils {
  static String cardLabelFirst(CardModel? card) {
    final first = (card?.data?.isNotEmpty ?? false) ? card?.data![0] : null;
    return first?.labelTr ?? '';
  }

  static double cardLabelFirstValue(CardModel? card) {
    final first = (card?.data?.isNotEmpty ?? false) ? card?.data![0] : null;
    return parseDouble(first?.value) ?? 0;
  }

  static String cardLabelSecond(CardModel? card) {
    final second = (card?.data?.length ?? 0) > 1 ? card?.data![1] : null;
    return second?.labelTr ?? '';
  }

  static double cardLabelSecondValue(CardModel? card) {
    final second = (card?.data?.length ?? 0) > 1 ? card?.data![1] : null;
    return parseDouble(second?.value) ?? 0;
  }

  static ({
    List<String> months,
    List<int> firstValueCounts,
    List<int> secondValueCounts,
  }) extractMonthsForBarChart(List<BarChartMonths>? chartMonth) {
    final months = <String>[];
    final firstValues = <int>[];
    final secondValues = <int>[];

    if (chartMonth != null) {
      for (final item in chartMonth) {
        months.add(item.monthTr ?? "-");
        firstValues.add(item.firstValue ?? 0);
        secondValues.add(item.secondValue ?? 0);
      }
    }

    return (
      months: months,
      firstValueCounts: firstValues,
      secondValueCounts: secondValues
    );
  }

  static List<double> getLineChartValue(CardModel? card) {
    List<double>? values = [];

    values = card?.data?.map((chart) => parseDouble(chart.value) ?? 0).toList();
    return values ?? [];
  }

  static String getLocalizedValue(
    Map<String, dynamic> json,
    String fieldBase,
  ) {
    if (isArabic) {
      return parseString(json['${fieldBase}_ar']) ??
          parseString(json['${fieldBase}_en']) ??
          parseString(json['${fieldBase}_ur']) ??
          parseString(json[fieldBase]) ??
          '';
    } else if (isUrdu) {
      return parseString(json['${fieldBase}_ur']) ??
          parseString(json['${fieldBase}_en']) ??
          parseString(json['${fieldBase}_ar']) ??
          parseString(json[fieldBase]) ??
          '';
    } else {
      return parseString(json['${fieldBase}_en']) ??
          parseString(json['${fieldBase}_ar']) ??
          parseString(json['${fieldBase}_ur']) ??
          parseString(json[fieldBase]) ??
          '';
    }
  }
}
