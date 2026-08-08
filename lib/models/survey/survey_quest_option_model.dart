import 'package:ufc_mobile/global/util/common/common_utils.dart';

class SurveyQuestionOptionModel {
  int? id;
  int? questionId;
  String? optionText;
  String? optionTextAr;
  int? optionOrder;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SurveyQuestionOptionModel({
    this.id,
    this.questionId,
    this.optionText,
    this.optionOrder,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.optionTextAr,
  });

  SurveyQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    questionId = parseInt(json['question_id']);
    optionText = parseString(json['option_text']);
    optionOrder = parseInt(json['option_order']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    deletedAt = parseString(json['deleted_at']);
    optionTextAr = parseString(json['option_text_ar']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['option_text'] = optionText;
    data['option_order'] = optionOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['option_text_ar'] = optionTextAr;
    return data;
  }
}
