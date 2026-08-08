import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/series_model.dart';

import '../../../../../global/shared/constants/constants.dart';

class ChartDataModel {
  String? label;
  String? labelAr;
  String? labelUr;
  int? value;
  SeriesModel? series;

  ChartDataModel({this.label, this.value, this.series});

  ChartDataModel.fromJson(Map<String, dynamic> json) {
    label = parseString(json['label']);
    labelAr = parseString(json['label_ar']);
    labelUr = parseString(json['label_ur']);
    value = parseInt(json['value']);
    series =
        json['series'] != null ? SeriesModel.fromJson(json['series']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    if (series != null) {
      data['series'] = series!.toJson();
    }
    return data;
  }

  String get labelTr => isArabic
      ? labelAr ?? label ?? ''
      : isUrdu
          ? labelUr ?? label ?? ''
          : label ?? '';
}
