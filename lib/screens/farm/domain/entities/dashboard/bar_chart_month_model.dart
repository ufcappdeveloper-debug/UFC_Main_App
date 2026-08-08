import 'package:ufc_mobile/global/shared/constants/constants.dart';

class FarmBarChartModel {
  String? title;
  List<Legends>? legends;
  List<BarChartMonths>? months;

  FarmBarChartModel({this.title, this.legends, this.months});

  FarmBarChartModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['legends'] != null) {
      legends = <Legends>[];
      json['legends'].forEach((v) {
        legends!.add(Legends.fromJson(v));
      });
    }
    if (json['months'] != null) {
      months = <BarChartMonths>[];
      json['months'].forEach((v) {
        months!.add(BarChartMonths.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (legends != null) {
      data['legends'] = legends!.map((v) => v.toJson()).toList();
    }
    if (months != null) {
      data['months'] = months!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Legends {
  String? name;
  String? nameAr;
  String? nameUr;
  int? total;

  Legends({this.name, this.total});

  Legends.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameAr = json['name_ar'];
    nameUr = json['name_ur'];
    total = json['total'];
  }

  String? get nameTr => isArabic
      ? nameAr ?? name
      : isUrdu
          ? nameUr ?? name
          : name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['total'] = total;
    return data;
  }
}

class BarChartMonths {
  String? month;
  String? monthAr;
  String? monthUr;
  int? firstValue;
  int? secondValue;

  BarChartMonths({this.month, this.firstValue, this.secondValue});

  BarChartMonths.fromJson(Map<String, dynamic> json) {
    /// current getting the keyword male & female, but it can be anything motive & unMotive or mother & babies
    month = json['month'];
    monthAr = json['month_ar'];
    monthUr = json['month_ur'];
    firstValue = json['male'];
    secondValue = json['female'];
  }

  String? get monthTr => isArabic
      ? monthAr ?? month
      : isUrdu
          ? monthUr ?? month
          : month;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['male'] = firstValue;
    data['female'] = secondValue;
    return data;
  }
}
