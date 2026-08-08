import 'package:ufc_mobile/global/util/common/common_utils.dart';

class LiveStockReportRespModel {
  final String? status;
  final String? message;
  final List<Map<String, dynamic>>? data;

  LiveStockReportRespModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LiveStockReportRespModel.fromJson(Map<String, dynamic> json) {
    return LiveStockReportRespModel(
      status: parseString(json['status']),
      message: parseString(json['message']),
      data: json['data'] != null
          ? List<Map<String, dynamic>>.from(
              json['data'].map((e) => Map<String, dynamic>.from(e)),
            )
          : null,
    );
  }
}

class ReportResponse {
  String? status;
  String? message;
  List<Map<String, ReportCategory>>? data;

  ReportResponse({this.status, this.message, this.data});

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  ReportCategory.fromJson(value as Map<String, dynamic>),
                ),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data
          ?.map((map) => map.map((key, value) => MapEntry(key, value.toJson())))
          .toList(),
    };
  }
}

class ReportCategory {
  int? reportCategoryId;
  Map<String, List<Answer>>? answers;

  ReportCategory({this.reportCategoryId, this.answers});

  factory ReportCategory.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'];

    Map<String, List<Answer>>? parsedAnswers;

    if (rawAnswers is Map<String, dynamic>) {
      parsedAnswers = rawAnswers.map(
        (key, value) => MapEntry(
          key,
          (value as List?)
                  ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
        ),
      );
    } else {
      // answers can also be []
      parsedAnswers = {};
    }

    return ReportCategory(
      reportCategoryId: json['report_category_id'] as int?,
      answers: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_category_id': reportCategoryId,
      'answers': answers?.map(
        (key, value) => MapEntry(
          key,
          value.map((e) => e.toJson()).toList(),
        ),
      ),
    };
  }
}

class Answer {
  String? questionKey;
  int? questionId;
  int? answerId;
  int? reportCategoryId;
  String? questionEn;
  String? questionAr;
  String? questionUr;
  dynamic answer; // can be String or int

  Answer({
    this.questionKey,
    this.questionId,
    this.answerId,
    this.reportCategoryId,
    this.questionEn,
    this.questionAr,
    this.questionUr,
    this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: int.tryParse(json['question_id']?.toString() ?? ''),
      answerId: int.tryParse(json['answer_id']?.toString() ?? ''),
      reportCategoryId: int.tryParse(json['report_category_id']?.toString() ?? ''),
      questionKey: json['question_key'] as String?,
      questionEn: json['question_en'] as String?,
      questionAr: json['question_ar'] as String?,
      questionUr: json['question_ur'] as String?,
      answer: json['answer'] ?? json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_key': questionKey,
      'question_en': questionEn,
      'question_ar': questionAr,
      'question_ur': questionUr,
      'answer': answer,
    };
  }
}
