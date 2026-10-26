import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/vaccine_model.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/weight_chart.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/add_barn.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_text_field.dart';

import '../../../data/farm_reports_service.dart';
import '../../../global/extensions/app_colors.dart';
import '../../../riverpod/farm/vaccination/get_vaccination.dart';
import '../../feed/application/app_settings/app_setting_cubit.dart';
import '../../feed/application/app_settings/app_setting_state.dart';
import '../../feed/application/authentication/auth_cubit.dart';
import '../domain/entities/report_category.dart';
import '../../../riverpod/app_bar/app_bar_riverpod.dart';
import '../../../riverpod/farm/barn/barn_provider.dart';
import '../../../riverpod/farm/get_livestock_async.dart';
import '../../../riverpod/farm/report_category_questions_async.dart';
import '../../../global/shared/constants/constants.dart';
import '../../../global/shared/widgets/custom_indicator.dart';
import '../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../navigation/pages/bottom_nav_bar.dart';
import 'livestock/livestock_details_page.dart';
import 'widgets/add_option_button.dart';
import 'widgets/animal_ref_widget.dart';
import '../application/animal_dates/animal_dates_loader.dart';
import '../domain/services/farm_date_rules.dart';
import 'widgets/farm_appbar.dart';
import 'widgets/report_question_component.dart';
import 'widgets/type_of_vaccinations.dart';

class ReportQuestionsPage extends ConsumerStatefulWidget {
  final String title;
  final int id;
  final String? animalRef;
  final String? animalKey;
  final int? isAnimalRequired;
  final bool fromDetailsPage;
  const ReportQuestionsPage({
    super.key,
    required this.title,
    required this.id,
    this.animalRef,
    this.animalKey,
    this.isAnimalRequired,
    this.fromDetailsPage = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReportQuestionsPageState();
}

class _ReportQuestionsPageState extends ConsumerState<ReportQuestionsPage> {
  int _currentPage = 0;
  late PageController pageController;
  TextEditingController deathDateController = TextEditingController();
  TextEditingController deathReasonController = TextEditingController();
  List<int> pageKeys = [];
  Set<int> qustionIds = {};
  List<Map<String, dynamic>> answersList = [];
  bool saving = false;
  Set<int> requiredQustionIds = {};
  String? liveStocknumber;
  bool isLivestock = false;
  bool isVaccination = false;
  bool isDeath = false;
  bool isNewBorn = false;
  int? selectedBarn;
  String? animalUniqueKey;
  String? selectedAnimalCategory;
  String? gender;
  bool showButton = true;

  final GlobalKey<TypeOfVaccinationState> vaccinationKey = GlobalKey();

  List<VaccineSchedules>? vaccinationData;

  @override
  void initState() {
    pageController = PageController();
    // isLivestock = widget.id == 11;
    // isVaccination = widget.id == 12;
    // isDeath = widget.id == 20;
    Future(() {
      ref
          .read(getLivestockProvider.notifier)
          .setAnimalRef(widget.animalRef, selectedAnimalKey: widget.animalKey);
      _loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    deathDateController.dispose();
    deathReasonController.dispose();
    super.dispose();
  }

  void _loadData() async {
    await _checkReportType(context, widget.id);
    if (isNewBorn) {
      _loadMotherDates(widget.animalKey);
    } else {
      _loadAnimalDates(widget.animalKey);
    }
    await ref
        .read(reportCategoryQuestionsProvider.notifier)
        .getQuestions(widget.id, animalKey: widget.animalKey);
    if (isLivestock) {
      await ref.read(barnAsyncProvider.notifier).getBarn();
      animalUniqueKey = await getAnimalKey();
    }
    await ref.read(getLivestockProvider.notifier).getLiveStocks();
    if (isVaccination) {
      await ref.read(getVaccinationProvider.notifier).getGetVaccination();
    }
  }

  Future<void> _checkReportType(BuildContext context, int reportId) async {
    final appSettings =
        await context.read<AppSettingCubit>().fetchAppSettings();
    final keyAndValues = appSettings?.keyAndValues ?? [];

    final match = keyAndValues
        .firstWhereOrNull((item) => int.tryParse(item.value ?? "") == reportId);

    if (match == null) return;

    switch (match.key) {
      case 'LIVESTOCK_REPORT_ID':
        isLivestock = true;
        break;
      case 'VACCINATION_REPORT_ID':
        isVaccination = true;
        break;
      case 'DEATH_REPORT_ID':
        isDeath = true;
        break;
      case 'NEWBORNS_REPORT_ID':
        isNewBorn = true;
        break;
    }
  }

  Future<String?> getAnimalKey() async {
    try {
      return await FarmReportsService().getAnimalKey();
    } catch (e) {
      log('e: ${e.toString()}');
      return null;
    }
  }

  /// Known dates of the selected animal (for a newborn report: the mother;
  /// for Add Livestock: the mother's life span), used by the date rules.
  AnimalDates? _animalDates;
  String? _datesForKey;
  String? _motherKey;

  Future<void> _loadAnimalDates(String? animalKey) async {
    if (animalKey == null || animalKey == _datesForKey) return;
    _datesForKey = animalKey;
    final dates = await AnimalDatesLoader.load(animalKey);
    if (!mounted || _datesForKey != animalKey) return;
    setState(() => _animalDates = dates);
  }

  /// The mother chosen in the form (Add Livestock / newborn report).
  Future<void> _loadMotherDates(String? motherKey) async {
    if (motherKey == null || motherKey.isEmpty || motherKey == _motherKey) {
      return;
    }
    _motherKey = motherKey;
    final mother = await AnimalDatesLoader.load(motherKey);
    if (!mounted || _motherKey != motherKey) return;
    setState(() {
      // Newborn report: the birth date must fall within the mother's life,
      // so the mother is the reference animal. Add Livestock: keep the
      // mother's life span as limits for the new animal's birth date.
      _animalDates = isNewBorn
          ? mother
          : (_animalDates ?? AnimalDates.empty).withMother(mother);
    });
  }

  /// The animal's dates plus the birth date typed in this form (Add
  /// Livestock), so the form's other dates can't come before it.
  AnimalDates? get _formDates {
    if (isNewBorn) return _animalDates;
    final questions = ref.read(reportCategoryQuestionsProvider).value ?? [];
    for (final a in answersList) {
      if (a['answer_type'] != 'date_answer') continue;
      final q = _findQuestion(questions, a['report_question_id']);
      if (FarmDateRules.kindOf(q) != FarmDateKind.birth) continue;
      final birth = FarmDateRules.parse(a['answer']?.toString());
      if (birth != null) {
        return (_animalDates ?? AnimalDates.empty).withBirth(birth);
      }
    }
    return _animalDates;
  }

  /// Every date (and "Other" value) in the form, checked before anything
  /// is sent.
  String? _validateDates() {
    final dates = _formDates;
    if (isDeath) {
      final d = FarmDateRules.parse(deathDateController.text);
      if (d != null) {
        final error = FarmDateRules.validate(FarmDateKind.death, d, dates);
        if (error != null) return error;
      }
    }
    if (isVaccination) {
      final seen = <String>{};
      for (final v in vaccinationData ?? const <VaccineSchedules>[]) {
        if (v.isOther && (v.otherName?.trim().isEmpty ?? true)) {
          return 'Please enter the vaccine name for "Other"'.tr();
        }
        final error = FarmDateRules.validateWithdrawal(
            v.prohibitionPeriod?.toString());
        if (error != null) return error;
        final d = FarmDateRules.parse(v.vaccinationDate);
        if (d == null) continue;
        final dateError = FarmDateRules.validate(
            FarmDateKind.vaccination, d, dates,
            vaccineTypeId: v.vaccineTypeId);
        if (dateError != null) return dateError;
        // The same vaccine twice on the same day in this form.
        if (!seen.add('${v.vaccineTypeId}-${FarmDateRules.format(d)}')) {
          return 'vaccine_same_day'.tr();
        }
      }
    }
    final questions = ref.read(reportCategoryQuestionsProvider).value ?? [];
    // "Other" needs the user's own value.
    for (final a in answersList) {
      final contentId = a['report_question_content_id'];
      if (contentId == null) continue;
      final q = _findQuestion(questions, a['report_question_id']);
      final content =
          q?.contents?.where((c) => c.id == contentId).firstOrNull;
      if (content == null || !ReportQuestionComponent.isOtherOption(content)) {
        continue;
      }
      final followUp = ReportQuestionComponent.otherTextFollowUp(content);
      final typed = followUp == null
          ? a['answer']
          : answersList
              .where((x) => x['report_question_id'] == followUp.id)
              .firstOrNull?['answer'];
      if (typed?.toString().trim().isEmpty ?? true) {
        return 'Please specify the "Other" value'.tr();
      }
    }
    final mating = FarmDateRules.matingDateFrom(answersList);
    for (final a in answersList) {
      if (a['answer_type'] != 'date_answer') continue;
      final d = FarmDateRules.parse(a['answer']?.toString());
      if (d == null) continue;
      final q = _findQuestion(questions, a['report_question_id']);
      final kind = FarmDateRules.kindOf(q, isNewBornReport: isNewBorn);
      final error =
          FarmDateRules.validate(kind, d, dates, matingDate: mating);
      if (error != null) {
        final title = q == null
            ? ''
            : '${isArabic ? (q.questionTextAr ?? q.questionText) : q.questionText}: ';
        return '$title$error';
      }
    }
    return null;
  }

  ReportQuestion? _findQuestion(List<ReportQuestion> list, dynamic id) {
    for (final q in list) {
      if (q.id == id) return q;
      for (final c in q.contents ?? const <ReportQuestionContent>[]) {
        final f = c.followUpQuestion;
        if (f == null) continue;
        final found = _findQuestion([f], id);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Questions depend on the animal (its type's options, female-only
  /// reports...): reload them for the selected animal and drop old answers.
  void _onAnimalChanged(String? animalKey) {
    if (widget.isAnimalRequired != 1) return;
    if (ref.read(getLivestockProvider).isLoading) return;
    if (isNewBorn) {
      // Newborn report: the animal picked here is the mother.
      _loadMotherDates(animalKey);
    } else {
      _loadAnimalDates(animalKey);
    }
    final questions = ref.read(reportCategoryQuestionsProvider.notifier);
    if (animalKey == questions.loadedForAnimalKey) return;
    setState(() {
      answersList = [];
      qustionIds = {};
      requiredQustionIds = {};
    });
    questions.getQuestions(widget.id, animalKey: animalKey);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      getLivestockProvider.select((a) => a.valueOrNull?.selectedAnimalKey),
      (_, next) => _onAnimalChanged(next),
    );
    final reportCategoryQuestions = ref.watch(reportCategoryQuestionsProvider);
    final barnAsync = ref.watch(barnAsyncProvider);
    final user = context.read<AuthCubit>().currentUser;
    final livestockAsync = ref.watch(getLivestockProvider);
    return SafeArea(
      child: BlocBuilder<AppSettingCubit, AppSettingState>(
        builder: (context, state) {
          if (state is AppSettingLoading) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: AppColors.farmColor),
            ));
          } else if (state is AppSettingError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is AppSettingLoaded) {
            return Scaffold(
              appBar: CustomFarmAppBar(
                title: widget.title,
                onPop: () {
                  if (!pageController.hasClients || _currentPage == 0) {
                    Navigator.of(context).pop();
                  } else {
                    requiredQustionIds = {};
                    if (isVaccination && _currentPage == 1) {
                      if (vaccinationKey.currentState != null) {
                        vaccinationData =
                            vaccinationKey.currentState!.getVaccinationData();

                        if (vaccinationData?.isNotEmpty ?? false) {
                          // push updates vaccine data to state management
                          for (final v in vaccinationData!) {
                            ref
                                .read(getVaccinationProvider.notifier)
                                .updateVaccineData(
                                  v.vaccineTypeId,
                                  date: v.vaccinationDate,
                                  duration: v.prohibitionPeriod?.toString(),
                                );
                          }
                        }
                      }
                    }
                    pageController.previousPage(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  }
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              // Hidden while the keyboard is open, so it never covers the
              // field being typed in.
              floatingActionButton: showButton &&
                      MediaQuery.viewInsetsOf(context).bottom == 0
                  ? (widget.isAnimalRequired == 1 &&
                          (livestockAsync.asData?.value?.animals?.isEmpty ??
                              true))
                      ? CustomOutlinedContainer(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ReportQuestionsPage(
                                  title: 'Add Livestock'.tr(),
                                  id: 10,
                                ),
                              ),
                            );
                          },
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          title: 'Add Livestock',
                          fill: true,
                          fillColor: AppColors.farmColor,
                        )
                      : saving
                          ? CircularProgressIndicator(
                              color: AppColors.farmColor)
                          : CustomOutlinedContainer(
                              onTap: _handleNextButtonTap,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              title: pageController.hasClients && _isLastPage()
                                  ? 'Save'
                                  : 'Next',
                              fill: true,
                              fillColor: AppColors.farmColor,
                            )
                  : null,
              body: reportCategoryQuestions.when(
                data: (data) {
                  if (data == null) return const SizedBox();
                  // The report doesn't apply to this animal (e.g. productive
                  // status for a male): show why, hide the form and Save.
                  final unavailableReason = ref
                      .read(reportCategoryQuestionsProvider.notifier)
                      .unavailableReason;
                  if (unavailableReason != null) {
                    showButton = false;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (widget.isAnimalRequired == 1)
                            Expanded(
                              child: AnimalRefWidget(
                                needCategories: isVaccination,
                                selectedAnimalCtegory: selectedAnimalCategory,
                                onSelectCtegory: (category) => setState(
                                    () => selectedAnimalCategory = category),
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(.08),
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomText(text: unavailableReason),
                          ),
                        ],
                      ),
                    );
                  }
                  if (data.isEmpty &&
                      (!isVaccination && !isDeath && !isLivestock)) {
                    showButton = false;
                    return const SizedBox();
                  }
                  showButton = true;
                  final pageGroups = <int, List<ReportQuestion>>{};
                  for (var question in data) {
                    final page = question.page ?? 1;

                    // If from details page and key == animal_mother (or father)
                    if (widget.fromDetailsPage &&
                        (question.key?.toLowerCase() == 'animal_mother' || question.key?.toLowerCase() == 'animal_mother_new_born')) {
                      // updating the question automatically
                      final autoAnswer = [
                        {
                          "report_question_id": question.id,
                          "report_question_content_id": null,
                          "user_id": user?.id,
                          "answer": widget.animalKey,
                          "report_content_key": question.key,
                          "report_question_key": question.key,
                          "answer_type": 'string_answer',
                          'animal_ref': widget.animalRef,
                          'animal_unique_key': widget.animalKey,
                          'barn_id': null
                        }
                      ];

                      // Call handleAnswerTap once so it flows into answersList
                      handleAnswerTap(autoAnswer, question);

                      // Skip adding this question to UI
                      continue;
                    }

                    // Normal question → add to pageGroups
                    pageGroups.putIfAbsent(page, () => []).add(question);
                  }

                  // Remove empty pages after filtering
                  pageGroups.removeWhere((_, questions) => questions.isEmpty);

                  pageKeys = pageGroups.keys.toList();

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                        final keyIndex = _getPageKeyIndex(value);
                        if (keyIndex != null) {
                          final questions = pageGroups[pageKeys[keyIndex]]!;
                          requiredQustionIds = {};
                          requiredQustionIds = questions
                              .where((element) {
                                final type = element.answerType?.toLowerCase();
                                return element.isRequired == 1 &&
                                    element.id != null &&
                                    type != 'image_choice' &&
                                    type != 'file_upload';
                              })
                              .map((a) => a.id!)
                              .toSet();

                          questions.map(
                            (element) {
                              if (element.isRequired == 1 &&
                                  element.id != null) {
                                requiredQustionIds.add(element.id!);
                              }
                            },
                          );
                        }
                      },
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      itemCount: _totalPages,
                      itemBuilder: (context, index) {
                        if (widget.isAnimalRequired == 1 && index == 0) {
                          return AnimalRefWidget(
                            needCategories: isVaccination,
                            selectedAnimalCtegory: selectedAnimalCategory,
                            onSelectCtegory: (category) {
                              setState(() {
                                selectedAnimalCategory = category;
                              });
                            },
                          );
                        }
                        if (isVaccination &&
                            index == (widget.isAnimalRequired == 1 ? 1 : 0)) {
                          return TypeOfVaccination(
                              key: vaccinationKey, animalDates: _formDates);
                        }
                        if (isDeath &&
                            index == (widget.isAnimalRequired == 1 ? 1 : 0)) {
                          return deathWidget();
                        } else if (isLivestock && index == 0) {
                          return barnQuestion(barnAsync);
                        }
                        final keyIndex = _getPageKeyIndex(index);
                        if (keyIndex == null) return const SizedBox();
                        final questions = pageGroups[pageKeys[keyIndex]]!;
                        final userChoiceQuestion = questions
                            .where(
                              (q) =>
                                  (q.answerType?.toLowerCase() ==
                                          'user_multiple_choice' ||
                                      q.answerType?.toLowerCase() ==
                                          'user_multi_select') &&
                                  q.id != null &&
                                  q.isFollowUp != 1,
                            )
                            .toList();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...questions
                                          // 🔹 Filter out "animal_mother" when fromDetailsPage == true
                                          .where((q) =>
                                              !(widget.fromDetailsPage &&
                                                  (q.key?.toLowerCase() ==
                                                      'animal_mother' || q.key?.toLowerCase() == 'animal_mother_new_born')))
                                          .map((question) {
                                        final previousAnswers = answersList
                                            .where((a) =>
                                                a['report_question_id'] ==
                                                question.id)
                                            .toList();

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 24.0),
                                          child: ReportQuestionComponent(
                                            animalDates: _formDates,
                                            isNewBornReport: isNewBorn,
                                            allAnswers: answersList,
                                            onAnswerTap: handleAnswerTap,
                                            initialAnswers: previousAnswers,
                                            userId: user?.id,
                                            onTap: (answers) => handleAnswerTap(
                                                answers, question),
                                            question: question,
                                            allowMultipleSelection: question
                                                        .answerType
                                                        ?.toLowerCase() ==
                                                    'multi_select' ||
                                                question.answerType
                                                        ?.toLowerCase() ==
                                                    'user_multi_select',
                                          ),
                                        );
                                      }),
                                      SizedBox(height: 70)
                                    ]),
                              ),
                            ),
                            //buttons for add user options
                            if (userChoiceQuestion.isNotEmpty)
                              ...List.generate(
                                userChoiceQuestion.length,
                                (index) => AddOptionButton(
                                  reportid: widget.id,
                                  isLastButton:
                                      userChoiceQuestion.length - 1 == index,
                                  qid: userChoiceQuestion[index].id!,
                                  subText: userChoiceQuestion.length > 1
                                      ? userChoiceQuestion[index]
                                          .localizedQuestion(context)
                                      : null,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  );
                },
                error: (error, stack) => CustomReloadProvider(
                  height: 118,
                  onPressed: () => _loadData(),
                ),
                loading: () => const SizedBox(
                  height: 157,
                  child: Center(child: CustomIndicator(padding: 50)),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  // Navigation helper
  bool _isLastPage() => _currentPage == _totalPages - 1;

  void _navigateToNextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

//...........................Save functions...............................//

  // Main onTap handler
  void _handleNextButtonTap() {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 100), () async {
      if (!context.mounted || !pageController.hasClients) return;

      // Validation phase
      if (!_validateAnimalSelection()) return;
      if (!_validateRequiredQuestions()) return;
      if (!_validateVaccinationData()) return;
      if (!_validateDeathData()) return;

      // Navigation logic
      if (!_isLastPage()) {
        _navigateToNextPage();
        return;
      }

      // Save logic
      await _performSaveLogic();
    });
  }

  bool _validateAnimalSelection() {
    final animalRef =
        ref.read(getLivestockProvider).asData?.value?.selectedAnimalRef;

    if (animalRef == null &&
        widget.isAnimalRequired == 1 &&
        selectedAnimalCategory == null) {
      CustomSnackBar.error(context, 'Select livestock to continue.');
      return false;
    }

    if (selectedBarn == null && isLivestock) {
      CustomSnackBar.error(context, 'Please select a barn');
      return false;
    }

    return true;
  }

  bool _validateDeathData() {
    if (isDeath && _currentPage == 1 && deathDateController.text.isEmpty) {
      CustomSnackBar.error(context, 'Please enter the death date.');
      return false;
    }
    return true;
  }

  bool _validateRequiredQuestions() {
    final answeredQuestionIds = answersList
        .map((e) => e['report_question_id'])
        .whereType<int>()
        .toSet();

    final missingRequiredIds =
        requiredQustionIds.difference(answeredQuestionIds);

    if (missingRequiredIds.isNotEmpty) {
      CustomSnackBar.error(context, 'Please answer the required questions.');
      return false;
    }

    return true;
  }

  bool _validateVaccinationData() {
    if (!isVaccination) return true;

    if (vaccinationKey.currentState != null) {
      vaccinationData = vaccinationKey.currentState!.getVaccinationData();

      if (vaccinationData?.isEmpty ?? true) {
        CustomSnackBar.error(context, 'Please enter vaccine details');
        return false;
      }

      // push updates to state management
      for (final v in vaccinationData!) {
        ref.read(getVaccinationProvider.notifier).updateVaccineData(
              v.vaccineTypeId,
              date: v.vaccinationDate,
              duration: v.prohibitionPeriod?.toString(),
            );
      }
    }

    return true;
  }

  Future<void> _performSaveLogic() async {
    setState(() => saving = true);
    final animalRef = ref.read(getLivestockProvider).value?.selectedAnimalRef;
    final animalkey = ref.read(getLivestockProvider).value?.selectedAnimalKey;
    try {
      final errorMsg = await _performSaveOperation();
      if (mounted) {
        if (errorMsg == 'no_admin_qs') return;
        if (errorMsg == null) {
          final bulk =
              ref.read(getVaccinationProvider.notifier).lastBulkResult;
          if (isVaccination && bulk != null && bulk.skipped > 0) {
            CustomSnackBar.message(
                context,
                bulk.added != null
                    ? 'vaccine_added_skipped'.tr(namedArgs: {
                        'added': '${bulk.added}',
                        'skipped': '${bulk.skipped}'
                      })
                    : 'vaccine_skipped'
                        .tr(namedArgs: {'skipped': '${bulk.skipped}'}));
          }
          ref.read(getVaccinationProvider.notifier).clearVaccineData();
          saveBottomSheet(context, isLivestock ? liveStocknumber : animalRef,
              isLivestock ? animalUniqueKey : animalkey);
        } else {
          CustomSnackBar.error(context, errorMsg);
        }
      }
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  Future<String?> _performSaveOperation() async {
    if (answersList.isEmpty && isLivestock) {
      return "You didn't answer any questions.".tr();
    }

    // Never send an illogical date to the API.
    final dateError = _validateDates();
    if (dateError != null) return dateError;

    if (isVaccination) {
      return await _saveVaccinationData();
    } else if (isDeath) {
      return await _addDeath();
    } else {
      return await _saveReportAnswers();
    }
  }

  // Save logic methods
  Future<String?> _saveVaccinationData() async {
    if (vaccinationData?.isNotEmpty ?? false) {
      final animalKey =
          ref.read(getLivestockProvider).asData?.value?.selectedAnimalKey;

      return await ref.read(getVaccinationProvider.notifier).addVaccine(
          vaccinationData ?? [], animalKey ?? selectedAnimalCategory,
          isCategory: animalKey == null, gender: gender);
    } else {
      return 'Please enter vaccine details';
    }
  }

  Future<String?> _addDeath() async {
    final animalKey =
        ref.read(getLivestockProvider).asData?.value?.selectedAnimalKey;
    final animalRef =
        ref.read(getLivestockProvider).asData?.value?.selectedAnimalRef;

    return await ref.read(reportCategoryQuestionsProvider.notifier).addDeath({
      "animal_unique_key": animalKey,
      "animal_ref": animalRef,
      "death_date": deathDateController.text,
      "death_reason": deathReasonController.text,
    });
  }

  Future<String?> _saveReportAnswers() async {
    if (answersList.isEmpty) return 'no_admin_qs';
    final animalRef =
        ref.read(getLivestockProvider).asData?.value?.selectedAnimalRef;

    if (!isLivestock) {
      animalUniqueKey =
          ref.read(getLivestockProvider).asData?.value?.selectedAnimalKey;
    } else if (animalUniqueKey == null && isLivestock) {
      // if animalUniqueKey not got when initState assigning new key (only when add livestock)
      animalUniqueKey = await getAnimalKey();
    }

    var result =
        await ref.read(reportCategoryQuestionsProvider.notifier).addAnswers(
              widget.id,
              answersList,
              isLivestock ? liveStocknumber : animalRef,
              selectedBarn,
              animalKey: animalUniqueKey,
            );

    // if incase livestock not added or any got any error, taking new animal_uniqu_key (to restrict this error "this key already used")
    if (result != null && isLivestock) {
      animalUniqueKey = null;
      animalUniqueKey = await getAnimalKey();
    }

    return result;
  }

//...................................................................................................//

  void handleAnswerTap(
      List<Map<String, dynamic>> answers, ReportQuestion question) {
    final isMultiSelect =
        question.answerType?.toLowerCase() == 'multi_select' ||
            question.answerType?.toLowerCase() == 'user_multi_select';

    if (question.id == null) return;

    // Capture animal_number for livestock pages
    if (isLivestock &&
        (question.key?.toLowerCase() == 'animal_number' ||
            question.key?.toLowerCase() == 'animal_ref')) {
      if (answers.isNotEmpty) {
        liveStocknumber = answers.first['answer']?.toString();
        log('Captured livestock number: $liveStocknumber');
      }
    }

    // Capture gender from gender_qs
    if (question.key?.toLowerCase() == 'gender') {
      if (answers.isNotEmpty) {
        gender = answers.first['answer']?.toString();
        log('Captured livestock number: $liveStocknumber');
      }
    }

    // A new date (e.g. birth) changes the other pickers' limits.
    if (answers.any((a) => a['answer_type'] == 'date_answer')) {
      Future.microtask(() {
        if (mounted) setState(() {});
      });
    }

    // The mother decides the logical birth dates.
    final key = question.key?.toLowerCase();
    if ((key == 'animal_mother' || key == 'animal_mother_new_born') &&
        answers.isNotEmpty) {
      final motherKey = answers.first['answer']?.toString();
      // May run during build (auto-answer from the details page).
      Future.microtask(() => _loadMotherDates(motherKey));
    }

    // Collect IDs to remove: main question + any follow-up
    final idsToRemove = <int>{question.id!};
    idsToRemove.addAll(_collectFollowUps(question.id!));

    // Remove all answers matching these IDs
    answersList
        .removeWhere((a) => idsToRemove.contains(a['report_question_id']));

    // Add new answers
    answersList.addAll(answers);

    log('originalList: ${answersList.length}: $answersList');
  }

  Set<int> _collectFollowUps(int questionId) {
    final collected = <int>{};
    final stack = <int>[questionId];

    while (stack.isNotEmpty) {
      final currentId = stack.removeLast();
      final nextFollowUps = answersList
          .where((a) => a['report_question_id'] == currentId)
          .map((a) => a['followup_id'])
          .whereType<int>();

      for (final id in nextFollowUps) {
        if (!collected.contains(id)) {
          collected.add(id);
          stack.add(id); // check deeper followups
        }
      }
    }

    return collected;
  }

  Column deathWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget('Death Date'),
        kHeight10,
        CustomDatePicker(
          needFormat: false,
          minimumDate: FarmDateRules.range(FarmDateKind.death, _formDates).min,
          validateDate: (d) =>
              FarmDateRules.validate(FarmDateKind.death, d, _formDates),
          onDateSelect: (date) {},
          controller: deathDateController,
        ),
        kHeight20,
        titleWidget('Cause of Mortality (Optional)'),
        kHeight10,
        CustomTextFormField(
          context: context,
          controller: deathReasonController,
          isMsg: true,
        )
      ],
    );
  }

  CustomText titleWidget(String title) {
    return CustomText(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      text: title,
    );
  }

  Column barnQuestion(AsyncValue<List<BarnModel>> barnAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget('Select Barn'),
                kHeight10,
                barnAsync.when(
                  data: (data) {
                    return Column(
                      children: [
                        ...List.generate(
                          data.length,
                          (index) {
                            final barn = data[index];
                            return GestureDetector(
                              onTap: () => setState(() {
                                selectedBarn = barn.id;
                              }),
                              child: CustomSelectBox(
                                isSelected: selectedBarn == barn.id,
                                title:
                                    '${barn.barnNumber ?? ''} ${barn.barnNumber != null && barn.name.isNotEmpty ? '-' : ''} ${barn.name}',
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                  error: (error, stack) => CustomReloadProvider(
                    height: 118,
                    onPressed: () => _loadData(),
                  ),
                  loading: () => const SizedBox(
                    height: 157,
                    child: Center(child: CustomIndicator(padding: 50)),
                  ),
                )
              ],
            ),
          ),
        ),
        AddBarn(isAddBarn: true, fromQuestions: true),
        SizedBox(height: 70),
      ],
    );
  }

  Future<dynamic> saveBottomSheet(
      BuildContext context, String? animalref, String? animalkey) {
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      scrollControlDisabledMaxHeightRatio: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/svg/farm/farm_success.svg'),
              CustomText(
                  text: 'Added successfully',
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
              kHeight20,
              CustomOutlinedContainer(
                title: 'Livestock',
                fill: true,
                onTap: () {
                  ref
                      .read(reportCategoryQuestionsProvider.notifier)
                      .clearQuestions();
                  if (animalkey != null && animalref != null) {
                    if (widget.fromDetailsPage) {
                      Navigator.pop(context);
                    }
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LivestockDetailsPage(
                          animalUniqueKey: animalkey,
                          // animal: animal,
                        ),
                      ),
                    );
                  } else {
                    ref.read(selectedAppbarItem.notifier).state = 2;
                    ref.read(farmBodySelectedIndexProvider.notifier).state = 1;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomBar(initialIndex: 2)),
                      (route) => false,
                    );
                  }
                },
              ),
              kHeight20,
              CustomOutlinedContainer(
                title: 'Home',
                onTap: () {
                  ref
                      .read(reportCategoryQuestionsProvider.notifier)
                      .clearQuestions();
                  ref.read(selectedAppbarItem.notifier).state = 2;
                  ref.read(farmBodySelectedIndexProvider.notifier).state = 0;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const BottomBar(initialIndex: 2)),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        )),
      ),
    );
  }

  int get _reservedPages {
    int count = 0;
    if (widget.isAnimalRequired == 1) count++; // AnimalRefWidget
    if (isVaccination || isDeath) count++; // Vaccination/Death page
    if (isLivestock) count++; // Barn page
    return count;
  }

  int get _totalPages => pageKeys.length + _reservedPages;

  int? _getPageKeyIndex(int index) {
    final keyIndex = index - _reservedPages;
    if (keyIndex < 0 || keyIndex >= pageKeys.length) return null;
    return keyIndex;
  }
}
