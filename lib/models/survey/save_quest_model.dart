class SaveSurveyQuestionModel {
  int? questionId;
  int? surveyId;
  String? answerText;
  int? optionId;
  String? answerValues;
  int? ratingValue;

  SaveSurveyQuestionModel({
    this.questionId,
    this.surveyId,
    this.answerText,
    this.optionId,
    this.answerValues,
    this.ratingValue,
  });

  SaveSurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    surveyId = json['survey_id'];
    answerText = json['answer_text'];
    optionId = json['option_id'];
    answerValues = json['answer_values'];
    ratingValue = json['rating_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['survey_id'] = surveyId;
    data['answer_text'] = answerText;
    data['option_id'] = optionId;
    data['answer_values'] = answerValues;
    data['rating_value'] = ratingValue;
    return data;
  }
}
