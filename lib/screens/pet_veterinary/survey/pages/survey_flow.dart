import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/models/survey/save_quest_model.dart';
import 'package:ufc_mobile/models/survey/survey_quest_model.dart';
import 'package:ufc_mobile/models/survey/survey_quest_option_model.dart';
import 'package:ufc_mobile/riverpod/survey/save_ques_ans_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/survey/survey__ques_async_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/pages/survey_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/checkbox_tile_with_comments_field.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/comments_text_field.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/emoji_rating_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/radio_tile.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/yes_no_with_description_field.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/yes_no_with_emoji_rating.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class SurveyFlow extends ConsumerStatefulWidget {
  final VoidCallback? onSurveyCompleted;

  const SurveyFlow({
    super.key,
    required this.onSurveyCompleted,
  });

  @override
  ConsumerState<SurveyFlow> createState() => _SurveyFlowState();
}

class _SurveyFlowState extends ConsumerState<SurveyFlow>
    with ScreenEngagementTracker {
  int currentIndex = 0;
  int totalSteps = 0;

  final TextEditingController textQuestionController = TextEditingController();
  final TextEditingController _yesNoTextController = TextEditingController();

  Set<SurveyQuestionOptionModel> selectedOptions = {};
  SurveyQuestionOptionModel? selectedOption;
  bool isYesSelected = false;
  bool isNoSelected = false;
  List<SurveyQuestionModel>? surveyQuestions;

  @override
  void initState() {
    super.initState();
    Future(() {
      init();
    });
  }

  Future<void> init() async {
    await ref
        .read(getSurveyQuestionsAsyncProvider.notifier)
        .getSurveyQuestions();
    surveyQuestions =
        ref.read(getSurveyQuestionsAsyncProvider).value?.data ?? [];
    totalSteps = surveyQuestions?.length ?? 0;
    if (surveyQuestions?.isEmpty ?? true) {
      widget.onSurveyCompleted?.call();
      debugPrint("No survey questions available");
    }
  }

  void canContinue() async {
    String? questionType =
        surveyQuestions?[currentIndex].questionType?.toLowerCase();
    bool isRequired = surveyQuestions?[currentIndex].isRequired ?? false;

    try {
      if (questionType == 'select' || questionType == 'radio') {
        if (selectedOption == null) {
          if (isRequired) {
            CustomSnackBar.show(
              context,
              "Please select an option before proceeding",
            );
            return;
          }
        } else {
          await ref.read(surveyAsyncProvider.notifier).saveQuestion(
                SaveSurveyQuestionModel(
                  surveyId: surveyQuestions![currentIndex].surveyId,
                  questionId: surveyQuestions![currentIndex].id,
                  optionId: selectedOption?.id,
                ),
              );
        }
        selectedOption = null;
      } else if (questionType == 'checkbox') {
        if (selectedOptions.isEmpty) {
          if (isRequired) {
            CustomSnackBar.show(
              context,
              "Please select at least one option before proceeding",
            );
            return;
          }
        } else {
          await ref.read(surveyAsyncProvider.notifier).saveQuestion(
                SaveSurveyQuestionModel(
                  surveyId: surveyQuestions![currentIndex].surveyId,
                  questionId: surveyQuestions![currentIndex].id,
                  answerValues: json.encode([
                    selectedOptions
                        .map((option) => option.id.toString())
                        .join(',')
                  ]),
                ),
              );
        }
        selectedOptions.clear();
      } else if (questionType == 'text') {
        if (textQuestionController.text.isEmpty && isRequired) {
          CustomSnackBar.show(
            context,
            "Please enter a response before proceeding",
          );
          return;
        } else {
          await ref.read(surveyAsyncProvider.notifier).saveQuestion(
                SaveSurveyQuestionModel(
                  surveyId: surveyQuestions![currentIndex].surveyId,
                  questionId: surveyQuestions![currentIndex].id,
                  answerText: textQuestionController.text.trim(),
                ),
              );
        }
        textQuestionController.clear();
      } else if (questionType == 'yes_or_no') {
        await ref.read(surveyAsyncProvider.notifier).saveQuestion(
              SaveSurveyQuestionModel(
                surveyId: surveyQuestions![currentIndex].surveyId,
                questionId: surveyQuestions![currentIndex].id,
                answerText: isYesSelected ? 'Yes' : 'No',
                answerValues: _yesNoTextController.text.trim(),
                ratingValue: isYesSelected ? 5 : 1, // todo
              ),
            );
        isYesSelected = false;
        isNoSelected = false;
        _yesNoTextController.clear();
      } else if (questionType == 'yes_no_with_emoji_rating' ||
          questionType == 'emoji_rating') {
        // Assuming you will handle saving rating/selection similarly
        await ref.read(surveyAsyncProvider.notifier).saveQuestion(
              SaveSurveyQuestionModel(
                surveyId: surveyQuestions![currentIndex].surveyId,
                questionId: surveyQuestions![currentIndex].id,
                answerText: isYesSelected ? 'Yes' : 'No',
                ratingValue: isYesSelected ? 5 : 1,
                // todo (in dashboard emoji or yes or no qn type not available)
              ),
            );
        isYesSelected = false;
        isNoSelected = false;
      }

      // Move to next question only if saving was successful
      if (currentIndex < totalSteps - 1) {
        setState(() => currentIndex++);
      } else {
        if (!mounted) return;
        FocusScope.of(context).unfocus();
        widget.onSurveyCompleted?.call();
        debugPrint("Survey completed");
      }
    } catch (e) {
      debugPrint("Error saving question: $e");
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        "Failed to save response. Please try again.",
      );
    }
  }

  Widget buildContent(String? questionType) {
    switch (questionType?.toLowerCase()) {
      case 'select':
        if (surveyQuestions![currentIndex].options?.isEmpty ?? true) {
          return const SizedBox();
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: CheckboxOptionsWithCommentsField(
            selectAll: false,
            options: surveyQuestions![currentIndex].options ?? [],
            onChanged: (selectedOptions, otherText) {
              selectedOption =
                  selectedOptions.isNotEmpty ? selectedOptions.first : null;
            },
          ),
        );

      case 'checkbox':
        if (surveyQuestions![currentIndex].options?.isEmpty ?? true) {
          return const SizedBox();
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: CheckboxOptionsWithCommentsField(
            options: surveyQuestions![currentIndex].options ?? [],
            onChanged: (options, otherText) {
              selectedOptions = options.toSet();
              setState(() {});
            },
          ),
        );
      case 'radio':
        if (surveyQuestions![currentIndex].options?.isEmpty ?? true) {
          return const SizedBox();
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: RadioTileListView(
            options: surveyQuestions![currentIndex].options ?? [],
            onChanged: (option) {
              selectedOption = option;
              setState(() {});
            },
          ),
        );
      case 'text':
        return Padding(
          padding: EdgeInsets.only(bottom: 96, right: 40),
          child: CommentsTextField(
            placeholder: 'Answer',
            controller: textQuestionController,
            onChanged: (value) => debugPrint("Q4 text: $value"),
          ),
        );

      case 'yes_or_no':
        return Padding(
          padding: EdgeInsets.only(bottom: 80),
          child: YesNoWithDescriptionField(
            isYesSelected: isYesSelected,
            isNoSelected: isNoSelected,
            onYesTap: () {
              setState(() {
                isYesSelected = true;
                isNoSelected = false;
              });
            },
            onNoTap: () {
              setState(() {
                isYesSelected = false;
                isNoSelected = true;
              });
            },
            controller: _yesNoTextController,
            onTextChanged: (text) => debugPrint("Yes/No Description: $text"),
          ),
        );

      case 'yes_no_with_emoji_rating':
        return YesNoWithEmojiRating(
          isYesSelected: isYesSelected,
          isNoSelected: isNoSelected,
          onYesTap: () {
            setState(() {
              isYesSelected = true;
              isNoSelected = false;
            });
          },
          onNoTap: () {
            setState(() {
              isYesSelected = false;
              isNoSelected = true;
            });
          },
        );
      case 'emoji_rating':
        return Padding(
          padding: EdgeInsets.only(bottom: 96),
          child: EmojiRatingWidget(),
        );

      default:
        return const SizedBox();
    }
  }

  void skip() {
    if (currentIndex < totalSteps - 1) {
      setState(() => currentIndex++);
    } else {
      FocusScope.of(context).unfocus();

      try {
        widget.onSurveyCompleted?.call();
        debugPrint("Survey completed");
      } catch (e, st) {
        debugPrint("Error completing survey: $e\n$st");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final surveyQuestionsRes = ref.watch(getSurveyQuestionsAsyncProvider);

    if (surveyQuestionsRes.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (surveyQuestionsRes.hasError) {
      return Center(
        child: CustomText(
          text: AppConfig.isProduction
              ? 'something_wrong'.tr()
              : 'Error: ${surveyQuestionsRes.error}',
        ),
      );
    }

    surveyQuestions = surveyQuestionsRes.value?.data ?? [];
    totalSteps = surveyQuestions?.length ?? 0;

    final currentQuestionType = (currentIndex < (surveyQuestions ?? []).length)
        ? surveyQuestions![currentIndex].questionType
        : null;
    String currentQuestion = currentQuestionText(currentQuestionType);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        CustomSnackBar.show(
          context,
          "Please complete the survey before leaving",
        );
      },
      child: SurveyScreen(
        currentIndex: currentIndex,
        totalSteps: totalSteps,
        questionTitle: currentQuestion,
        content: buildContent(currentQuestionType),
        onNext: canContinue,
        onSkip: skip,
        hideSkipButton: (surveyQuestions?[currentIndex].isRequired ?? false),
      ),
    );
  }

  String currentQuestionText(String? currentQuestionType) {
    SurveyQuestionModel model = surveyQuestions![currentIndex];

    if (currentQuestionType != null) {
      if (isArabic) {
        return model.questionTextAr ?? model.questionText ?? '';
      } else {
        return model.questionText ?? model.questionTextAr ?? '';
      }
    }
    return '';
  }
}
