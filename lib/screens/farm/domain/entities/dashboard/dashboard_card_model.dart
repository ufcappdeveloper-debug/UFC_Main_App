import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/bar_chart_month_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/chart_data_model.dart';

import '../../../../../global/shared/constants/constants.dart';
import '../donut_chart_model.dart';

class CardModel {
  String? id;
  String? title;
  String? titleAr;
  String? titleUr;
  String? type;
  String? chartType;
  int? value;
  int? percentageChange;
  List<ChartDataModel>? data;
  FarmBarChartModel? barChartData;
  String? subTitle;
  String? subTitleAr;
  String? subTitleUr;
  int? percentage;
  DonutChartModel? donutChartData;

  CardModel({
    this.id,
    this.title,
    this.titleAr,
    this.titleUr,
    this.type,
    this.chartType,
    this.value,
    this.percentageChange,
    this.data,
    this.subTitle,
    this.subTitleAr,
    this.subTitleUr,
    this.percentage,
    this.barChartData,
    this.donutChartData,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    id = parseString(json['id']);
    title = parseString(json['title']);
    titleAr = parseString(json['title_ar']);
    titleUr = parseString(json['title_ur']);
    type = parseString(json['type']);
    chartType = parseString(json['chartType']);
    value = parseInt(json['value']);
    percentageChange = json['percentageChange'];
    if (type == 'bar_chart') {
      if (json['data'] != null) {
        barChartData = FarmBarChartModel.fromJson(json['data']);
      }
    } else {
      if (json['data'] != null) {
        data = <ChartDataModel>[];
        json['data'].forEach((v) {
          data!.add(ChartDataModel.fromJson(v));
        });
      }
    }
    if (json['donut_chart'] != null) {
      donutChartData = DonutChartModel.fromJson(json['donut_chart']);
    }
    subTitle = parseString(json['subTitle']);
    subTitleAr = parseString(json['subTitle_ar']);
    subTitleUr = parseString(json['subTitle_ur']);
    percentage = parseInt(json['percentage']);
  }

  String get subtitle => isArabic
      ? subTitleAr ?? subTitle ?? ''
      : isUrdu
          ? subTitleUr ?? subTitle ?? ''
          : subTitle ?? '';
  String get heading => isArabic
      ? titleAr ?? title ?? ''
      : isUrdu
          ? titleUr ?? title ?? ''
          : title ?? '';
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['chartType'] = chartType;
    data['value'] = value;
    data['percentageChange'] = percentageChange;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['subTitle'] = subTitle;
    data['percentage'] = percentage;
    return data;
  }
}
