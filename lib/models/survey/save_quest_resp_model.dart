class SaveQuestResponseMOdel {
  int? id;
  int? questionId;
  int? orderId;
  int? userId;
  String? answerText;
  String? answerValues;
  Null ratingValue;
  String? createdAt;
  String? updatedAt;

  SaveQuestResponseMOdel(
      {this.id,
      this.questionId,
      this.orderId,
      this.userId,
      this.answerText,
      this.answerValues,
      this.ratingValue,
      this.createdAt,
      this.updatedAt});

  SaveQuestResponseMOdel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    answerText = json['answer_text'];
    answerValues = json['answer_values'];
    ratingValue = json['rating_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['answer_text'] = answerText;
    data['answer_values'] = answerValues;
    data['rating_value'] = ratingValue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
