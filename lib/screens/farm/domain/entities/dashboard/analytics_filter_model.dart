import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../../../global/shared/constants/constants.dart';

class AnalyticsFilterModel {
  String? key;
  String? content;
  String? contentAr;
  String? contentUr;

  AnalyticsFilterModel(
      {this.key, this.content, this.contentAr, this.contentUr});

  AnalyticsFilterModel.fromJson(Map<String, dynamic> json) {
    key = parseString(json['key']);
    content = parseString(json['content']);
    contentAr = parseString(json['content_ar']);
    contentUr = parseString(json['content_ur']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['content'] = content;
    data['content_ar'] = contentAr;
    data['content_ur'] = contentUr;
    return data;
  }

  String? get contentText => isArabic
      ? contentAr ?? content
      : isUrdu
          ? contentUr ?? content
          : content;
}
