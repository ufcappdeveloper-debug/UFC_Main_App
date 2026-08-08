import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../domain/entities/report_category.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import 'add_option_button.dart';
import 'animal_ref_widget.dart';
import 'arabic_number.dart';
import 'custom_file_picker.dart';
import 'farm_text_field.dart';

class ReportQuestionComponent extends StatefulWidget {
  final ReportQuestion? question;
  final bool allowMultipleSelection;
  final Function(List<Map<String, dynamic>> answers) onTap;
  final int? userId;
  final List<Map<String, dynamic>>? initialAnswers;
  final List<Map<String, dynamic>>? allAnswers;
  final bool isFollowUp;
  final bool isNewBornReport;
  final bool fromDetailsPage;

  final void Function(
      List<Map<String, dynamic>> answers, ReportQuestion question)? onAnswerTap;

  const ReportQuestionComponent({
    super.key,
    this.question,
    this.allowMultipleSelection = false,
    required this.onTap,
    this.userId,
    this.initialAnswers,
    this.onAnswerTap,
    this.allAnswers,
    this.isFollowUp = false,
    this.fromDetailsPage = false,
    this.isNewBornReport = false,
  });

  @override
  State<ReportQuestionComponent> createState() =>
      _ReportQuestionComponentState();
}

class _ReportQuestionComponentState extends State<ReportQuestionComponent> {
  Set<int> selected = {};
  List<Map<String, dynamic>> answers = [];
  late TextEditingController _textController;
  bool _isTextInputType = false;
  late FocusNode _focusNode;
  String? selectedAnimalCategory;
  @override
  void initState() {
    super.initState();

    final answerType = widget.question?.answerType?.toLowerCase();
    _isTextInputType = answerType == 'user_input' ||
        answerType == 'text' ||
        answerType == 'numeric' ||
        answerType == 'date_time' ||
        answerType == 'value';

    // If this question is already answered, fetch the answer
    answers = widget.initialAnswers != null
        ? List<Map<String, dynamic>>.from(widget.initialAnswers!)
        : [];

    if (_isTextInputType) {
      _textController = TextEditingController(
        text: answers.isNotEmpty ? (answers.first['answer'] ?? '') : '',
      );
      _focusNode = FocusNode();

      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          _triggerAnswerSubmit(
              answerType == 'numeric'); // When keyboard dismissed
        }
      });
    }

    // Initialize selected IDs for multiple-choice selections
    selected = answers
        .map((e) => e["report_question_content_id"])
        .whereType<int>()
        .toSet();
    log('selectedselected: $selected');
  }

  @override
  void dispose() {
    if (_isTextInputType) {
      _textController.dispose();
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _triggerAnswerSubmit(bool isNumeric) {
    if (!mounted) return;
    final answer = _textController.text.trim();
    if (answer.isNotEmpty) {
      final data = {
        "report_question_id": widget.question?.id,
        "report_question_content_id": null,
        "user_id": widget.userId,
        "answer": isNumeric ? convertNumbersToEnglish(answer) : answer,
        "report_content_key": "text",
        "report_question_key": widget.question?.key,
        "answer_type": widget.question?.key == 'animal_mother' ||
                widget.question?.key == 'animal_father'
            ? 'string_answer'
            : isNumeric
                ? "number_answer"
                : "string_answer"
      };

      answers = [data];
      widget.onTap(answers);
    }
  }

  @override
  Widget build(BuildContext context) {
    final answerType = widget.question?.answerType?.toLowerCase();

    return !widget.isFollowUp && // checking this is a followup widget
            widget.question?.isFollowUp ==
                1 && // checking this is a followup question (If this is NOT a follow-up widget, AND the current question is marked as a follow-up question, then we skip rendering the question (return an empty SizedBox))
            !widget.fromDetailsPage
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionText(
                  context,
                  widget.question?.localizedQuestion(context) ?? '',
                  widget.question?.isRequired != 1),
              kHeight10,

              // showing select animal widget if if the question is about parents
              if (widget.question?.key == 'animal_mother' ||
                  widget.question?.key == 'animal_father'||
                  widget.question?.key == 'animal_mother_new_born')
                AnimalRefWidget(
                  isNewBornReport: widget.isNewBornReport,
                  selectedAnimalRefFromQuestionsPage:
                      widget.question?.selectedAnimalRef,
                  selectedAnimalKeyFromQuestionsPage:
                      widget.question?.selectedAnimalKey,
                  fromQuestions: true,
                  needCategories: false,
                  selectedAnimalCtegory: selectedAnimalCategory,
                  onSelectanimal: (animalKeyString, animalRefNumber) {
                    final data = {
                      "report_question_id": widget.question?.id,
                      "report_question_content_id": null,
                      "user_id": widget.userId,
                      "answer": animalKeyString,
                      "report_content_key": widget.question?.key,
                      "report_question_key": widget.question?.key,
                      "answer_type": 'string_answer'
                    };
                    setState(() {
                      widget.question?.selectedAnimalRef = animalRefNumber;
                      widget.question?.selectedAnimalKey = animalKeyString;
                    });
                    answers = [data];
                    widget.onTap(answers);
                  },
                  onSelectCtegory: (category) {
                    setState(() {
                      selectedAnimalCategory = category;
                    });
                  },
                )
              else if (answerType == 'user_input' ||
                  answerType == 'text' ||
                  answerType == 'numeric' ||
                  answerType == 'value')
                CustomTextFormField(
                  suffixIcon: widget.question?.key == 'animal_weight' ||
                          widget.question?.key == 'weight'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Kg',
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : null,
                  focusNode: _focusNode,
                  onFieldSubmitted: (_) =>
                      _triggerAnswerSubmit(answerType == 'numeric'),
                  controller: _textController,
                  context: context,
                  keyboardType: answerType == 'numeric'
                      ? TextInputType.number
                      : TextInputType.name,
                )
              else if (answerType == 'date_time')
                CustomDatePicker(
                  needFormat: false,
                  onDateSelect: (date) {
                    final data = {
                      "report_question_id": widget.question?.id,
                      "report_question_content_id": null,
                      "user_id": widget.userId,
                      "answer": date,
                      "report_content_key": "date",
                      "report_question_key": widget.question?.key,
                      "answer_type": widget.question?.key == 'animal_mother' ||
                              widget.question?.key == 'animal_father'
                          ? 'string_answer'
                          : "date_answer"
                    };

                    answers = [data];
                    widget.onTap(answers);
                  },
                  controller: _textController,
                )
              else if (answerType == 'image_choice' ||
                  answerType == 'file_upload')
                CustomFilePicker(onlyImage: answerType == 'image_choice')
              else if (widget.question?.contents?.isNotEmpty ?? false) ...{
                ...widget.question!.contents!.map((content) {
                  return content.id != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Map<String, dynamic> data = {
                                  "report_question_id": widget.question?.id,
                                  "report_question_content_id": content.id,
                                  "user_id": widget.userId,
                                  "answer": widget.question?.key == 'gender'
                                      ? content.content?.toLowerCase()
                                      : content.content,
                                  "report_content_key": answerType == 'yes_no'
                                      ? content.content?.toLowerCase()
                                      : content.key,
                                  "report_question_key": widget.question?.key,
                                  "followup_id": content.followUpQuestion?.id,
                                  "answer_type":
                                      widget.question?.key == 'animal_mother' ||
                                              widget.question?.key ==
                                                  'animal_father'
                                          ? 'string_answer'
                                          : 'string_answer'
                                };
                                setState(() {
                                  if (widget.allowMultipleSelection) {
                                    if (selected.contains(content.id)) {
                                      selected.remove(content.id);
                                      answers.removeWhere((element) =>
                                          element[
                                              "report_question_content_id"] ==
                                          content.id);
                                    } else {
                                      selected.add(content.id!);
                                      answers.add(data);
                                    }
                                  } else {
                                    selected = {content.id!};
                                    answers = [data];
                                  }
                                });
                                widget.onTap(answers);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selected.contains(content.id)
                                        ? AppColors.farmColor
                                        : AppColors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: selected.contains(content.id)
                                      ? AppColors.farmColor.withOpacity(0.08)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 250),
                                            curve: Curves.easeInOut,
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 1,
                                                color: selected
                                                        .contains(content.id)
                                                    ? AppColors.farmColor
                                                    : AppColors.grey,
                                              ),
                                              color:
                                                  selected.contains(content.id)
                                                      ? AppColors.farmColor
                                                      : Colors.transparent,
                                            ),
                                            child: selected.contains(content.id)
                                                ? Icon(Icons.done,
                                                    color: Colors.white,
                                                    size: 18)
                                                : null,
                                          ),
                                          kWidth10,
                                          Expanded(
                                            child: CustomText(
                                              text: content.localizedcontent(
                                                      context) ??
                                                  "",
                                              fontSize: 15,
                                              maxLines: null,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          if (content.icon != null)
                                            SizedBox(
                                              height: 33,
                                              child: content.icon
                                                          ?.split('.')
                                                          .lastOrNull ==
                                                      'svg'
                                                  ? SvgPicture.network(
                                                      content.icon ?? "",
                                                      height: 33,
                                                    )
                                                  : CachedNetworkImage(
                                                      height: 33,
                                                      imageUrl:
                                                          content.icon ?? "",
                                                      placeholder:
                                                          (context, url) =>
                                                              SizedBox.shrink(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          SizedBox.shrink(),
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (content.content?.toLowerCase() ==
                                        'male')
                                      SvgPicture.asset(
                                          'assets/svg/farm/male.svg',
                                          width: 15),
                                    if (content.content?.toLowerCase() ==
                                        'female')
                                      SvgPicture.asset(
                                          'assets/svg/farm/female.svg',
                                          width: 15),
                                  ],
                                ),
                              ),
                            ),
                            // showing this same question widget for followup qs
                            if (selected.contains(content.id) &&
                                content.followUpQuestion != null &&
                                !widget.fromDetailsPage)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 24.0),
                                    child: ReportQuestionComponent(
                                      isNewBornReport: widget.isNewBornReport,
                                      isFollowUp: true,
                                      userId: widget.userId,
                                      allAnswers: widget.allAnswers,
                                      question: content.followUpQuestion!,
                                      initialAnswers: widget.allAnswers
                                          ?.where((a) =>
                                              a['report_question_id'] ==
                                              content.followUpQuestion?.id)
                                          .toList(),
                                      allowMultipleSelection: content
                                                  .followUpQuestion?.answerType
                                                  ?.toLowerCase() ==
                                              'multi_select' ||
                                          content.followUpQuestion?.answerType
                                                  ?.toLowerCase() ==
                                              'user_multi_select',
                                      onTap: (answers) {
                                        widget.onAnswerTap?.call(
                                            answers, content.followUpQuestion!);
                                      },
                                      onAnswerTap: widget.onAnswerTap,
                                    ),
                                  ),
                                  // BUtton for add options by user
                                  if (content.followUpQuestion?.id != null &&
                                      (content.followUpQuestion?.answerType
                                                  ?.toLowerCase() ==
                                              'user_multiple_choice' ||
                                          content.followUpQuestion?.answerType
                                                  ?.toLowerCase() ==
                                              'user_multi_select'))
                                    AddOptionButton(
                                      contentId: content.id,
                                      parentQuestionId: widget.question?.id,
                                      qid: content.followUpQuestion!.id!,
                                      reportid:
                                          widget.question?.reportCategoryId,
                                      subText: null,
                                    ),
                                ],
                              ),
                          ],
                        )
                      : SizedBox();
                }),
              }
            ],
          );
  }

  Row questionText(BuildContext context, String text, bool isOptional) {
    return Row(
      children: [
        CustomText(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          text: text,
        ),
        if (isOptional)
          CustomText(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            text: (' (${'Optional'.tr()})'),
          ),
      ],
    );
  }
}
