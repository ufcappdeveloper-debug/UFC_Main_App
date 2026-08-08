import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/analytics_filter_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_card_model.dart';

class DashboardModel {
  List<AnalyticsFilterModel>? filters;
  List<CardModel>? cards;

  DashboardModel({this.filters, this.cards});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['filters'] != null) {
      filters = (json['filters'] as List)
          .map((v) => AnalyticsFilterModel.fromJson(v))
          .toList();
    }

    if (json['cards'] != null) {
      cards = <CardModel>[];
      json['cards'].forEach((v) {
        cards!.add(CardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filters'] = filters;
    if (cards != null) {
      data['cards'] = cards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
