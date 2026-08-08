import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class ReportCategory {
  final int? id;
  final String? key;
  final String? name;
  final String? nameAr;
  final String? nameUr;
  final String? description;
  final String? descriptionAr;
  final String? descriptionUr;
  final int? isAnimalRequired;

  ReportCategory({
    this.id,
    this.key,
    this.name,
    this.nameAr,
    this.nameUr,
    this.description,
    this.descriptionAr,
    this.descriptionUr,
    this.isAnimalRequired,
  });

  factory ReportCategory.fromJson(Map<String, dynamic> json) {
    return ReportCategory(
      id: int.tryParse(json['id']?.toString() ?? ''),
      key: json['key'],
      name: json['name'],
      nameAr: json['name_ar'],
      nameUr: json['name_ur'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      descriptionUr: json['description_ur'],
      isAnimalRequired:
          int.tryParse(json['is_animal_required']?.toString() ?? ''),
    );
  }

  String? localizedName(BuildContext context) {
    final langCode = context.locale.languageCode;

    if (langCode == 'ar') return nameAr ?? name;
    if (langCode == 'ur') return nameUr ?? name;
    return name;
  }
}

class ReportQuestion {
  final int? id;
  final int? reportCategoryId;
  final String? key;
  final String? questionText;
  final String? questionTextAr;
  final String? questionTextUr;
  final String? answerType;
  final int? isRequired;
  final int? isActive;
  final int? questionOrder;
  final int? page;
  final int? isFollowUp;
  List<ReportQuestionContent>? contents;
  String? selectedAnimalRef;
  String? selectedAnimalKey;

  ReportQuestion({
    this.id,
    this.reportCategoryId,
    this.key,
    this.questionText,
    this.questionTextAr,
    this.questionTextUr,
    this.answerType,
    this.isRequired,
    this.isActive,
    this.questionOrder,
    this.page,
    this.isFollowUp,
    this.contents,
    this.selectedAnimalRef,
  });

  factory ReportQuestion.fromJson(Map<String, dynamic> json) {
    final base = json['question'] ?? json;

    return ReportQuestion(
      id: int.tryParse(base['id']?.toString() ?? ''),
      reportCategoryId:
          int.tryParse(base['report_category_id']?.toString() ?? ''),
      key: base['key'],
      questionText: base['question_text'],
      questionTextAr: base['question_text_ar'],
      questionTextUr: base['question_text_ur'],
      answerType: base['answer_type'],
      isRequired: int.tryParse(base['is_required']?.toString() ?? ''),
      isActive: int.tryParse(base['is_active']?.toString() ?? ''),
      questionOrder: int.tryParse(base['question_order']?.toString() ?? ''),
      page: int.tryParse(base['page']?.toString() ?? ''),
      isFollowUp: int.tryParse(base['is_follow_up']?.toString() ?? ''),
      contents: json['report_question_contents'] != null
          ? (json['report_question_contents'] as List)
              .map((e) => ReportQuestionContent.fromJson(e))
              .toList()
          : json['contents'] != null
              ? (json['contents'] as List)
                  .map((e) => ReportQuestionContent.fromJson(e))
                  .toList()
              : [],
    );
  }

  String? localizedQuestion(BuildContext context) {
    final langCode = context.locale.languageCode;

    if (langCode == 'ar') return questionTextAr ?? questionText;
    if (langCode == 'ur') return questionTextUr ?? questionText;
    return questionText;
  }
}

class ReportQuestionContent {
  final int? id;
  final int? reportQuestionId;
  final String? userId;
  final String? key;
  final String? content;
  final String? contentAr;
  final String? contentUr;
  final int? contentOrder;
  ReportQuestion? followUpQuestion;
  final String? icon;

  ReportQuestionContent({
    this.id,
    this.reportQuestionId,
    this.userId,
    this.key,
    this.content,
    this.contentAr,
    this.contentUr,
    this.contentOrder,
    this.followUpQuestion,
    this.icon
  });

  factory ReportQuestionContent.fromJson(Map<String, dynamic> json) {
    return ReportQuestionContent(
      id: int.tryParse(json['id']?.toString() ?? ''),
      reportQuestionId:
          int.tryParse(json['report_question_id']?.toString() ?? ''),
      userId: json['user_id']?.toString(),
      key: json['key'],
      content: json['content'],
      contentAr: json['content_ar'],
      contentUr: json['content_ur'],
      contentOrder: int.tryParse(json['content_order']?.toString() ?? ''),
      followUpQuestion: json['follow_up_question'] != null &&
              json['follow_up_question'] is Map
          ? ReportQuestion.fromJson(json['follow_up_question'])
          : null,
      icon: json['icon'],
    );
  }

  String? localizedcontent(BuildContext context) {
    final langCode = context.locale.languageCode;

    if (langCode == 'ar') return contentAr ?? content;
    if (langCode == 'ur') return contentUr ?? content;
    return content;
  }
}
