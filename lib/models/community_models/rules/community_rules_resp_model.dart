import 'package:ufc_mobile/models/community_models/rules/community_rules_model.dart';
import 'package:ufc_mobile/models/pagination/pagination_model.dart';

class CommunityRulesResponseModel {
  String? status;
  List<CommunityRulesModel>? rulesList;
  Pagination? pagination;

  CommunityRulesResponseModel({
    this.status,
    this.rulesList,
    this.pagination,
  });

  CommunityRulesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      rulesList = <CommunityRulesModel>[];
      json['data'].forEach((v) {
        rulesList!.add(CommunityRulesModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (rulesList != null) {
      data['data'] = rulesList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}
