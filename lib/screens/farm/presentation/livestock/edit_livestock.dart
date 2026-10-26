import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';

import '../../../../riverpod/farm/get_livestock_async.dart';
import '../../application/get_question/get_question_cubit.dart';
import '../../application/livestock_details/livestock_details_cubit.dart';
import '../../application/animal_dates/animal_dates_loader.dart';
import '../../domain/services/farm_date_rules.dart';
import '../../domain/entities/livestock/live_stock_details_model.dart';
import '../charts/weight_chart.dart';
import '../widgets/report_question_component.dart';

class EditLivestock extends StatefulWidget {
  final String animalKey;
  const EditLivestock({super.key, required this.animalKey});

  @override
  State<EditLivestock> createState() => _EditLivestockState();
}

class _EditLivestockState extends State<EditLivestock> {
  List<Map<String, dynamic>> selectedAnswer = [];

  /// The mother's dates: a birth date must fall within her life.
  AnimalDates? _motherDates;
  String? _motherKey;

  /// The animal's dates plus its mother's, for the edited date's limits.
  AnimalDates _animalDates() => (AnimalDatesLoader.fromState(
              context.read<LiveStockDetailsCubit>().state) ??
          AnimalDates.empty)
      .withMother(_motherDates);

  void _loadMother(String? key) {
    if (key == null || key.isEmpty || key == _motherKey) return;
    _motherKey = key;
    AnimalDatesLoader.load(key).then((dates) {
      if (mounted && _motherKey == key) setState(() => _motherDates = dates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomFarmAppBar(title: 'Edit Livestock'),
        body: BlocBuilder<LiveStockDetailsCubit, LiveStockDetailsState>(
          builder: (context, state) {
            if (state is LiveStockDetailsLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (state is! LiveStockDetailsLoaded) {
              return const SizedBox();
            }

            final details = state.liveStockDetails;
            final animalTypeName =
                details?.predefinedAnimalDetails?.firstOrNull?.animalTypeName;
            final animalType =
                details?.animalDetailsAsAnswer?.firstOrNull?.animalType;
            final birthDate =
                details?.animalDetailsAsAnswer?.firstOrNull?.birthDate;
            final gender = details?.animalDetailsAsAnswer?.firstOrNull?.gender;
            final animalRef =
                details?.animalDetailsAsAnswer?.firstOrNull?.animalRef;
            final animalMother =
                details?.predefinedAnimalDetails?.firstOrNull?.animalMother;
            final animalMotherQs =
                details?.animalDetailsAsAnswer?.firstOrNull?.animalMother;
            _loadMother(animalMother);

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // hiding for latest build due to api issue
                  // if (animalRef != null) ...{
                  //   _EditableInfoRow(
                  //     label: 'Cattle Number',
                  //     value: animalRef.answer?.toString() ?? '-',
                  //     onEdit: () {
                  //       if (animalRef.reportCategoryId != null &&
                  //           animalRef.questionId != null) {
                  //         _showEditBottomSheet(
                  //           context: context,
                  //           categoryId: animalRef.reportCategoryId!,
                  //           questionId: animalRef.questionId!,
                  //           answerId: animalRef.answerId,
                  //           details: details,
                  //         );
                  //       }
                  //     },
                  //   ),
                  //   const Divider(height: 25),
                  // },
                  if (birthDate != null) ...{
                    _EditableInfoRow(
                      label: 'Date of Birth',
                      value: birthDate.answer ?? '-',
                      onEdit: () {
                        if (birthDate.reportCategoryId != null &&
                            birthDate.questionId != null) {
                          _showEditBottomSheet(
                            context: context,
                            categoryId: birthDate.reportCategoryId!,
                            questionId: birthDate.questionId!,
                            answerId: birthDate.answerId,
                            details: details,
                          );
                        }
                      },
                    ),
                    const Divider(height: 25),
                  },
                  // hiding for latest build due to api issue
                  // if (animalType != null) ...{
                  //   _EditableInfoRow(
                  //     label: 'Animal Type',
                  //     value: animalTypeName ?? '-',
                  //     onEdit: () {
                  //       if (animalType.reportCategoryId != null &&
                  //           animalType.questionId != null) {
                  //         _showEditBottomSheet(
                  //           isAnimalType: true,
                  //           context: context,
                  //           categoryId: animalType.reportCategoryId!,
                  //           questionId: animalType.questionId!,
                  //           answerId: animalType.answerId,
                  //           details: details,
                  //         );
                  //       }
                  //     },
                  //   ),
                  //   const Divider(height: 25),
                  // },
                  if (gender != null) ...{
                    _EditableInfoRow(
                      label: 'Gender',
                      value: '${gender.answer ?? '-'}',
                      onEdit: () {
                        if (gender.reportCategoryId != null &&
                            gender.questionId != null) {
                          _showEditBottomSheet(
                            context: context,
                            categoryId: gender.reportCategoryId!,
                            questionId: gender.questionId!,
                            answerId: gender.answerId,
                            details: details,
                          );
                        }
                      },
                    ),
                    const Divider(height: 25),
                  },
                  if (animalMotherQs != null)
                    Consumer(builder: (context, ref, _) {
                      return _EditableInfoRow(
                        label: 'Animal Mother',
                        value: animalMother ?? '-',
                        onEdit: () async {
                          if (animalMotherQs.reportCategoryId != null &&
                              animalMotherQs.questionId != null) {
                            await ref
                                .read(getLivestockProvider.notifier)
                                .getLiveStocks();
                            if (!context.mounted) return;
                            _showEditBottomSheet(
                              context: context,
                              categoryId: animalMotherQs.reportCategoryId!,
                              questionId: animalMotherQs.questionId!,
                              answerId: animalMotherQs.answerId,
                              details: details,
                            );
                          }
                        },
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Bottom sheet for editing a question answer
  void _showEditBottomSheet({
    required BuildContext context,
    required int categoryId,
    required int questionId,
    required int? answerId,
    required LiveStockDetailsModel? details,
    bool isAnimalType = false,
  }) async {
    context.read<GetQuestionCubit>().getQuestion(categoryId, questionId);

    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        String errorMsg = '';
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    top: 20,
                  ),
                  child: BlocBuilder<GetQuestionCubit, GetQuestionState>(
                    builder: (context, state) {
                      if (state is QuestionLoading) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Center(child: CupertinoActivityIndicator()),
                          ],
                        );
                      }

                      if (state is QuestionsError) {
                        return Center(child: CustomText(text: state.message));
                      }

                      if (state is! QuestionLoaded) return const SizedBox();

                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          child: Icon(Icons.close),
                                          onTap: () => Navigator.pop(context))),
                                          kHeight5,
                                  ReportQuestionComponent(
                                    fromDetailsPage: true,
                                    animalDates: _animalDates(),
                                    question: state.question,
                                    onTap: (answers) {
                                      _selectAnswer(answers, details);
                                    },
                                    onAnswerTap: (answers, question) {
                                      _selectAnswer(answers, details);
                                    },
                                  ),
                                  kHeight20,
                                  if (errorMsg.isNotEmpty)
                                    CustomText(
                                        text: errorMsg, color: Colors.red),
                                  kHeight20,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: isLoading
                                ? const CupertinoActivityIndicator()
                                : CustomOutlinedContainer(
                                    title: 'Save'.tr(),
                                    fill: true,
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      await Future.delayed(const Duration(milliseconds: 100));
                                      if (selectedAnswer.isEmpty ||
                                          answerId == null) {
                                        return;
                                      }

                                      setModalState(() {
                                        isLoading = true;
                                        errorMsg = '';
                                      });

                                      errorMsg = await context
                                              .read<GetQuestionCubit>()
                                              .editAnswer(selectedAnswer.first,
                                                  answerId) ??
                                          '';

                                      setModalState(() => isLoading = false);

                                      if (errorMsg.isEmpty && context.mounted) {
                                        Navigator.pop(context);
                                        await context
                                            .read<LiveStockDetailsCubit>()
                                            .getLivestockDetails(
                                                widget.animalKey);
                                      }
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      selectedAnswer.clear();
    });
  }

  void _selectAnswer(List<Map<String, dynamic>> answers,
      LiveStockDetailsModel? liveStockDetails) {
    Map<String, dynamic> params = {
      "answer_type": answers.firstOrNull?['answer_type'] ?? '',
      "answer": answers.firstOrNull?['answer'] ?? '',
      "report_content_key": answers.firstOrNull?['report_content_key'] ?? '',
      "animal_ref":
          liveStockDetails?.predefinedAnimalDetails?.firstOrNull?.animalRef ??
              '',
      if (liveStockDetails?.barn?.id != null)
        "barn_id": liveStockDetails?.barn?.id,
    };
    if (answers.firstOrNull?['report_question_content_id'] != null) {
      params["report_question_content_id"] =
          answers.firstOrNull?['report_question_content_id'];
    }
    selectedAnswer = [params];
  }
}

// use this when can edit followup also

//   /// Selects and prepares answer params
//   void _selectAnswer(
//       List<Map<String, dynamic>> answers, LiveStockDetailsModel? details) {
//     for (final ans in answers) {
//       // Check if this question is already in selectedAnswer
//       final index = selectedAnswer.indexWhere(
//         (element) => element['report_question_id'] == ans['report_question_id'],
//       );

//       if (index != -1) {
//         // Replace the old answer for this question
//         selectedAnswer.removeWhere(
//           (element) =>
//               element['report_question_id'] ==
//               selectedAnswer[index]['followup_id'],
//         );
//         selectedAnswer[index] = ans;
//       } else {
//         // Add new answer
//         selectedAnswer.add(ans);
//       }
//       log('selectedAnswer: ${selectedAnswer.length}, $selectedAnswer');
//     }
//   }
// }

/// Simple reusable widget for editable info rows
class _EditableInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _EditableInfoRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onEdit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              kHeight5,
              CustomText(
                text: value,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
          SvgPicture.asset('assets/svg/farm/edit.svg'),
        ],
      ),
    );
  }
}
