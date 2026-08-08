import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/survey/save_ques_ans_async_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  final int currentIndex;
  final int totalSteps;
  final String questionTitle;
  final bool hideSkipButton;
  final Widget content;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const SurveyScreen({
    required this.currentIndex,
    required this.totalSteps,
    required this.questionTitle,
    required this.content,
    required this.onNext,
    required this.onSkip,
    required this.hideSkipButton,
    super.key,
  });

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    final saveQuestion = ref.watch(surveyAsyncProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.currentIndex + 1} ${'of'.tr()} ${widget.totalSteps}",
                      style: PetVeterinaryFontstyles.kanitMediumTextStyle12,
                    ),
                    if (!widget.hideSkipButton)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onSkip,
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0)),
                          child: Text(
                            "Skip".tr(),
                            style: PetVeterinaryFontstyles.nunitoBoldTextStyle14
                                .copyWith(
                              color: PetVeterinaryColors.borderLeftColor,
                            ),
                          ),
                        ),
                      )
                    else
                      kHeight25,
                    Row(
                      children: List.generate(widget.totalSteps, (index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12.5),
                          width: 29,
                          height: 5,
                          decoration: BoxDecoration(
                            color: index <= widget.currentIndex
                                ? PetVeterinaryColors.borderLeftColor
                                : PetVeterinaryColors.customGrayBackground2,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                kHeight50,
                Text(
                  "${'Question'.tr()}${widget.currentIndex + 1}",
                  style:
                      PetVeterinaryFontstyles.kanitRegularTextStyle13.copyWith(
                    color: PetVeterinaryColors.customGrayBackground,
                  ),
                ),
                kHeight5,
                Text(
                  widget.questionTitle,
                  style: PetVeterinaryFontstyles.kanitMediumTextStyle18,
                ),
                kHeight40,
                widget.content,
                Padding(
                  padding: const EdgeInsets.only(
                    top: 3,
                    left: 53,
                    right: 53,
                    bottom: 23,
                  ),
                  child: CustomButton(
                    width: double.infinity,
                    title: "Continue".tr(),
                    onTap: widget.onNext,
                    isLoading: saveQuestion.isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
