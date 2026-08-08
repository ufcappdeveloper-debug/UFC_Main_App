import 'package:ufc_mobile/global/shared/constants/constants.dart';

class MothersBabiesChart {
  final String? id;
  final String? title;
  final String? titleAr;
  final String? titleUr;
  final String? type;
  final String? chartType;
  final double? percentageChange;
  final List<MothersBabiesData>? data;

  MothersBabiesChart({
    this.id,
    this.title,
    this.titleAr,
    this.titleUr,
    this.type,
    this.chartType,
    this.percentageChange,
    this.data,
  });

  factory MothersBabiesChart.fromJson(Map<String, dynamic> json) {
    return MothersBabiesChart(
      id: json['id'] as String?,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      titleUr: json['title_ur'] as String?,
      type: json['type'] as String?,
      chartType: json['chartType'] as String?,
      percentageChange:
          double.tryParse(json['percentageChange']?.toString() ?? ''),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MothersBabiesData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'title_ur': titleUr,
      'type': type,
      'chartType': chartType,
      'percentageChange': percentageChange,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class MothersBabiesData {
  final String? label;
  final String? labelAr;
  final String? labelUr;
  final double? value;

  MothersBabiesData({
    this.label,
    this.labelAr,
    this.labelUr,
    this.value,
  });

  factory MothersBabiesData.fromJson(Map<String, dynamic> json) {
    return MothersBabiesData(
      label: json['label'] as String?,
      labelAr: json['label_ar'] as String?,
      labelUr: json['label_ur'] as String?,
      value: double.tryParse(json['value']?.toString() ?? ''),
    );
  }

  String get title => isArabic
      ? labelAr ?? label ?? ''
      : isUrdu
          ? labelUr ?? label ?? ''
          : label ?? '';

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'label_ar': labelAr,
      'label_ur': labelUr,
      'value': value,
    };
  }
}
