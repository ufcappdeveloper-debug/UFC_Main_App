import 'package:ufc_mobile/models/common/link_model.dart';
import 'package:ufc_mobile/models/survey/survey_quest_model.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

class SurveyQuestionsResModel {
  int? currentPage;
  List<SurveyQuestionModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  SurveyQuestionsResModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  SurveyQuestionsResModel.fromJson(Map<String, dynamic> json) {
    currentPage = parseInt(json['current_page']);
    if (json['data'] != null) {
      data = <SurveyQuestionModel>[];
      json['data'].forEach((v) {
        data!.add(SurveyQuestionModel.fromJson(v));
      });
    }
    firstPageUrl = parseString(json['first_page_url']);
    from = parseInt(json['from']);
    lastPage = parseInt(json['last_page']);
    lastPageUrl = parseString(json['last_page_url']);
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = parseString(json['next_page_url']);
    path = parseString(json['path']);
    perPage = parseInt(json['per_page']);
    prevPageUrl = parseString(json['prev_page_url']);
    to = parseInt(json['to']);
    total = parseInt(json['total']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}
