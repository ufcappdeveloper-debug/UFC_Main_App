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
import '../../domain/services/farm_date_rules.dart';
import '../../domain/services/camel_age.dart';

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

  /// The selected animal's known dates, for the logical date limits.
  final AnimalDates? animalDates;

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
    this.animalDates,
  });

  /// True for the "Other / أخرى" option, which needs the user's own value.
  static bool isOtherOption(ReportQuestionContent c) {
    final values = [c.key, c.content, c.contentAr, c.contentUr]
        .whereType<String>()
        .map((v) => v.trim().toLowerCase());
    return values.any((v) =>
        v == 'other' ||
        v == 'others' ||
        v.startsWith('other ') ||
        v.startsWith('other(') ||
        v == 'أخرى' ||
        v == 'اخرى' ||
        v == 'أخري' ||
        v == 'اخري' ||
        v.startsWith('أخرى') ||
        v.startsWith('اخرى') ||
        v == 'دیگر');
  }

  /// The API's own text question under "Other" (e.g. "Mention the disease"),
  /// which receives the typed value. Null when the option has none.
  static ReportQuestion? otherTextFollowUp(ReportQuestionContent c) {
    final f = c.followUpQuestion;
    final type = f?.answerType?.toLowerCase();
    if (f?.id == null) return null;
    return (type == 'text' || type == 'user_input' || type == 'value')
        ? f
        : null;
  }

  @override
  State<ReportQuestionComponent> createState() =>
      _ReportQuestionComponentState();
}

class _ReportQuestionComponentState extends State<ReportQuestionComponent> {
  Set<int> selected = {};
  List<Map<String, dynamic>> answers = [];

  /// Free-text value for "Other" options, by content id.
  final Map<int, TextEditingController> _otherControllers = {};

  ReportQuestionContent? _content(int contentId) =>
      widget.question?.contents?.where((c) => c.id == contentId).firstOrNull;

  /// Starts empty (so the "Other" placeholder shows). The only text ever
  /// restored is what the user typed into the API's follow-up question.
  TextEditingController _otherController(int contentId) =>
      _otherControllers.putIfAbsent(contentId, () {
        final content = _content(contentId);
        final followUp = content == null
            ? null
            : ReportQuestionComponent.otherTextFollowUp(content);
        final typed = followUp == null
            ? null
            : widget.allAnswers
                ?.where((a) => a['report_question_id'] == followUp.id)
                .firstOrNull?['answer']
                ?.toString();
        return TextEditingController(text: typed ?? '');
      });

  /// Typing in an "Other" field. With an API follow-up text question the
  /// text is that question's answer; otherwise it is the option's answer.
  void _onOtherChanged(int contentId, String text) {
    final value = text.trim();
    final content = _content(contentId);
    final followUp = content == null
        ? null
        : ReportQuestionComponent.otherTextFollowUp(content);
    if (followUp != null) {
      widget.onAnswerTap?.call(
        value.isEmpty
            ? []
            : [
                {
                  "report_question_id": followUp.id,
                  "report_question_content_id": null,
                  "user_id": widget.userId,
                  "answer": value,
                  "report_content_key": "text",
                  "report_question_key": followUp.key,
                  "answer_type": "string_answer",
                }
              ],
        followUp,
      );
      return;
    }
    for (final a in answers) {
      if (a['report_question_content_id'] == contentId) a['answer'] = value;
    }
    widget.onTap(answers);
  }

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
    for (final c in _otherControllers.values) {
      c.dispose();
    }
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
                  widget.question?.key == 'animal_father' ||
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
                Builder(builder: (context) {
                  final isParentKey = widget.question?.key == 'animal_mother' ||
                      widget.question?.key == 'animal_father';
                  final kind = FarmDateRules.kindOf(widget.question,
                      isNewBornReport: widget.isNewBornReport);
                  final mating =
                      FarmDateRules.matingDateFrom(widget.allAnswers);
                  final range = isParentKey
                      ? (min: null, max: null)
                      : FarmDateRules.range(kind, widget.animalDates,
                          matingDate: mating);
                  final picker = CustomDatePicker(
                    needFormat: false,
                    allowFuture: kind == FarmDateKind.expected,
                    minimumDate: range.min,
                    maximumDate: range.max,
                    validateDate: isParentKey
                        ? null
                        : (date) => FarmDateRules.validate(
                            kind, date, widget.animalDates,
                            matingDate: mating),
                    onDateSelect: (date) {
                      final data = {
                        "report_question_id": widget.question?.id,
                        "report_question_content_id": null,
                        "user_id": widget.userId,
                        "answer": date,
                        "report_content_key": "date",
                        "report_question_key": widget.question?.key,
                        "answer_type":
                            widget.question?.key == 'animal_mother' ||
                                    widget.question?.key == 'animal_father'
                                ? 'string_answer'
                                : "date_answer"
                      };

                      answers = [data];
                      widget.onTap(answers);
                    },
                    controller: _textController,
                  );
                  // Newborn of a camel: show its age name (Hawar, ...).
                  if (kind != FarmDateKind.newbornBirth ||
                      !(widget.animalDates?.isCamel ?? false)) {
                    return picker;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      picker,
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _textController,
                        builder: (context, value, _) {
                          final name =
                              CamelAge.nameFor(FarmDateRules.parse(value.text));
                          if (name == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: CustomText(
                              text: '${'Camel age name'.tr()}: $name',
                              fontSize: 13,
                              color: AppColors.farmColor,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                })
              else if (answerType == 'image_choice' ||
                  answerType == 'file_upload')
                CustomFilePicker(onlyImage: answerType == 'image_choice')
              else if (widget.question?.contents?.isNotEmpty ?? false) ...{
                ...widget.question!.contents!.map((content) {
                  void toggle() {
                    Map<String, dynamic> data = {
                      "report_question_id": widget.question?.id,
                      "report_question_content_id": content.id,
                      "user_id": widget.userId,
                      // "Other" without an API text question carries the
                      // typed value itself; otherwise its normal label.
                      "answer":
                          ReportQuestionComponent.isOtherOption(content) &&
                                  ReportQuestionComponent.otherTextFollowUp(
                                          content) ==
                                      null
                              ? _otherController(content.id!).text.trim()
                              : widget.question?.key == 'gender'
                                  ? content.content?.toLowerCase()
                                  : content.content,
                      "report_content_key": answerType == 'yes_no'
                          ? content.content?.toLowerCase()
                          : content.key,
                      "report_question_key": widget.question?.key,
                      "followup_id": content.followUpQuestion?.id,
                      "answer_type": widget.question?.key == 'animal_mother' ||
                              widget.question?.key == 'animal_father'
                          ? 'string_answer'
                          : 'string_answer'
                    };
                    setState(() {
                      if (widget.allowMultipleSelection) {
                        if (selected.contains(content.id)) {
                          selected.remove(content.id);
                          answers.removeWhere((element) =>
                              element["report_question_content_id"] ==
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
                  }

                  return content.id != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: toggle,
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
                                            // "Other": the user types the
                                            // value in place of the label.
                                            child: ReportQuestionComponent
                                                    .isOtherOption(content)
                                                ? TextField(
                                                    scrollPadding:
                                                        const EdgeInsets
                                                            .fromLTRB(
                                                            20, 20, 20, 120),
                                                    controller:
                                                        _otherController(
                                                            content.id!),
                                                    onTap: () {
                                                      if (!selected.contains(
                                                          content.id)) {
                                                        toggle();
                                                      }
                                                    },
                                                    onChanged: (v) {
                                                      if (!selected.contains(
                                                          content.id)) {
                                                        toggle();
                                                      }
                                                      _onOtherChanged(
                                                          content.id!, v);
                                                    },
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    decoration: InputDecoration(
                                                      hintText: 'Other'.tr(),
                                                      isDense: true,
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                  )
                                                : CustomText(
                                                    text: content
                                                            .localizedcontent(
                                                                context) ??
                                                        "",
                                                    fontSize: 15,
                                                    maxLines: null,
                                                    overflow:
                                                        TextOverflow.visible,
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
                            // ("Other": its text question is the inline
                            // field above, so it isn't shown again here.)
                            if (selected.contains(content.id) &&
                                content.followUpQuestion != null &&
                                !(ReportQuestionComponent.isOtherOption(
                                        content) &&
                                    ReportQuestionComponent.otherTextFollowUp(
                                            content) !=
                                        null) &&
                                !widget.fromDetailsPage)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 24.0),
                                    child: ReportQuestionComponent(
                                      isNewBornReport: widget.isNewBornReport,
                                      animalDates: widget.animalDates,
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
