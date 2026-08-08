import 'package:ufc_mobile/models/survey/survey_quest_option_model.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

class SurveyQuestionModel {
  int? id;
  int? surveyId;
  String? questionText;
  String? questionTextAr;
  String? questionType;
  int? questionOrder;
  bool? isRequired;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<SurveyQuestionOptionModel>? options;

  SurveyQuestionModel({
    this.id,
    this.surveyId,
    this.questionText,
    this.questionType,
    this.questionOrder,
    this.isRequired,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.options,
    this.questionTextAr,
  });

  SurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    surveyId = parseInt(json['survey_id']);
    questionText = parseString(json['question_text']);
    questionType = parseString(json['question_type']);
    questionOrder = parseInt(json['question_order']);
    isRequired = parseBool(json['is_required']);
    isActive = parseBool(json['is_active']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    deletedAt = parseString(json['deleted_at']);
    questionTextAr = parseString(json['question_text_ar']);
    if (json['options'] != null) {
      options = <SurveyQuestionOptionModel>[];
      json['options'].forEach((v) {
        options!.add(SurveyQuestionOptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['survey_id'] = surveyId;
    data['question_text'] = questionText;
    data['question_type'] = questionType;
    data['question_order'] = questionOrder;
    data['is_required'] = isRequired;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['question_text_ar'] = questionTextAr;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
