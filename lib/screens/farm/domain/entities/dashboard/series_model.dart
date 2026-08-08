import 'package:ufc_mobile/global/util/common/common_utils.dart';

class SeriesModel {
  int? totalMothers;
  int? totalBabies;

  SeriesModel({this.totalMothers, this.totalBabies});

  SeriesModel.fromJson(Map<String, dynamic> json) {
    totalMothers = parseInt(json['Total Mothers']);
    totalBabies = parseInt(json['Total Babies']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Total Mothers'] = totalMothers;
    data['Total Babies'] = totalBabies;
    return data;
  }
}
