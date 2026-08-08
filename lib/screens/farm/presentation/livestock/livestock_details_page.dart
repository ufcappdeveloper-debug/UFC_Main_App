import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/custom_loading_dialog.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/extension/date_extenstions.dart';
import 'package:ufc_mobile/global/util/farm/farm_dashboard_utils.dart';
import 'package:ufc_mobile/global/util/farm/farm_utils.dart';
import 'package:ufc_mobile/riverpod/farm/report_categories_async.dart';
import 'package:ufc_mobile/screens/farm/application/livestock_details/livestock_details_cubit.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/predefined_animal_list_model.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/report_question_component.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../global/shared/widgets/show_confirmation_dailog.dart';
import '../../../../riverpod/app_bar/app_bar_riverpod.dart';
import '../../../feed/domain/entities/app_setting/app_settings_model.dart';
import '../../../navigation/pages/bottom_nav_bar.dart';
import '../../application/barn_details/barn_details_cubit.dart';
import '../../application/get_question/get_question_cubit.dart';
import '../../domain/entities/livestock/live_stock_vaccine_model.dart';
import '../charts/weight_chart.dart';
import '../report_questions_page.dart';
import '../widgets/custome_container.dart';
import '../widgets/death_popup.dart';
import '../widgets/farm_appbar.dart';
import '../widgets/vaccination_popup.dart';
import 'edit_livestock.dart';

class LivestockDetailsPage extends ConsumerStatefulWidget {
  final String animalUniqueKey;
  final String? category;
  final bool fromBarn;
  // final bool fromReport;
  const LivestockDetailsPage(
      {super.key,
      required this.animalUniqueKey,
      this.category,
      this.fromBarn = false
      // required this.fromReport,
      });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LivestockDetailsPageState();
}

class _LivestockDetailsPageState extends ConsumerState<LivestockDetailsPage> {
  Map<String, dynamic>? editedAnswer;

  @override
  void initState() {
    Future(() async {
      if (mounted) {
        if (!isStringEmpty(widget.animalUniqueKey)) {
          await context
              .read<LiveStockDetailsCubit>()
              .getLivestockDetails(widget.animalUniqueKey);
        }
        await ref
            .read(reportCategoriesAsyncProvider.notifier)
            .getReportCategories();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomFarmAppBar(
          title: 'Livestock Details',
          actionButton:
              BlocBuilder<LiveStockDetailsCubit, LiveStockDetailsState>(
            builder: (context, state) {
              if (state is LiveStockDetailsLoaded &&
                  state.liveStockDetails?.barn?.id != null) {
                return _showPopupMenu(
                    context, state.liveStockDetails!.barn!.id!);
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<LiveStockDetailsCubit, LiveStockDetailsState>(
              builder: (context, state) {
                if (state is LiveStockDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LiveStockDetailsLoaded) {
                  final reportsMap = {
                    for (AppSettingsKeyAndValue e in state.reportsKeyAndValue)
                      e.key: e.value,
                  };
                  return buildContent(
                    livestock: state.liveStockDetails,
                    report: state.livestockReportModel,
                    reportsKeyAndValue: reportsMap,
                  );
                } else if (state is LiveStockDetailsError) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<LiveStockDetailsCubit>()
                            .getLivestockDetails(widget.animalUniqueKey);
                      },
                      child: Column(
                        children: [
                          CustomText(
                            text: state.message,
                            color: AppColors.grey,
                            fontSize: 10,
                          ),
                          kHeight10,
                          CustomText(
                            text: 'Retry',
                            color: primaryColor,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContent({
    LiveStockDetailsModel? livestock,
    ReportResponse? report,
    Map<String?, String?>? reportsKeyAndValue,
  }) {
    final vaccinationReportId = reportsKeyAndValue?["VACCINATION_REPORT_ID"];
    final deathReportId = reportsKeyAndValue?["DEATH_REPORT_ID"];
    final weightReportId = reportsKeyAndValue?["WEIGHT_REPORT_ID"];
    final newBornReportId = reportsKeyAndValue?["NEWBORNS_REPORT_ID"];

    return livestock != null
        ? Column(
            children: [
              kHeight10,
              idBox(
                  livestock
                      .predefinedAnimalDetails?.firstOrNull?.animalTypeIcon,
                  livestock.predefinedAnimalDetails?.firstOrNull?.animalRef),
              kHeight20,
              detailsWidget(livestock),
              kHeight20,
              kHeight20,
              Column(
                children: (report?.data ?? [])
                    .expand((categoryMap) => categoryMap.entries)
                    .map((entry) {
                  final reportName = entry.key; // e.g. "Add Weight"
                  final category = entry.value; // ReportCategory
                  final reportId = category.reportCategoryId;

                  return medicineDetails(
                    onTap: () {
                      if (reportId != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReportQuestionsPage(
                              fromDetailsPage: true,
                              isAnimalRequired: 0,
                              title: reportName,
                              id: reportId,
                              animalRef: livestock.predefinedAnimalDetails
                                  ?.firstOrNull?.animalRef,
                              animalKey: widget.animalUniqueKey,
                            ),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Something went wrong'.tr(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    barnId: livestock.barn?.id,
                    reportId: reportId,
                    answersMap: category.answers,
                    addButton: reportName,
                    vaccinations: reportId?.toString() == vaccinationReportId
                        ? livestock.vaccinations
                        : null,
                    deathRecord: reportId?.toString() == deathReportId
                        ? livestock.deathRecord
                        : null,
                    initWeight:
                        livestock.predefinedAnimalDetails?.firstOrNull?.weight,
                    isWeightReport: reportId?.toString() == weightReportId,
                    isNewBornReport: reportId?.toString() == newBornReportId,
                  );
                }).toList(),
              ),
              kHeight20,
              // noteWidget(reports),
            ],
          )
        : Column(
            children: [
              CustomText(
                text: 'No livestock found',
                color: AppColors.grey,
              ),
              kHeight10,
              CustomReloadProvider(
                height: 118,
                onPressed: () async {
                  if (!isStringEmpty(widget.animalUniqueKey)) {
                    await context
                        .read<LiveStockDetailsCubit>()
                        .getLivestockDetails(widget.animalUniqueKey);
                  }
                },
              ),
            ],
          );
  }

  /// medicineDetails reused for reports/vaccines etc.
  CustomFarmContainer medicineDetails({
    Map<String, List<Answer>>? answersMap,
    bool needAttachment = false,
    String addButton = 'Add',
    List<Vaccinations>? vaccinations,
    DeathRecord? deathRecord,
    int? barnId,
    int? reportId,
    bool isWeightReport = false,
    bool isNewBornReport = false,
    Weight? initWeight,
    Function()? onTap,
    String? animalRef,
  }) {
    return CustomFarmContainer(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          if (vaccinations != null)
            ...vaccinations.map((vaccination) {
              final value = vaccination.vaccineType?.vaccineName;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: titleText('Vaccination')),
                      Expanded(
                        child: titleText(value ?? '',
                            color: true, textAlign: TextAlign.end),
                      ),
                      if (vaccination.id != null)
                        VaccinationPopup(
                            id: vaccination.id!,
                            animalKey: widget.animalUniqueKey)
                    ],
                  ),
                  Divider(color: Colors.grey[400], thickness: 0.8),
                  if (vaccination.vaccinationDate != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: isArOrUr ? 5 : 0),
                      child: medicineDate(
                          'Start date', vaccination.vaccinationDate ?? '',
                          needBorder: false, animalRef: animalRef),
                    ),
                  if (vaccination.prohibitionPeriod != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: isArOrUr ? 5 : 0),
                      child: medicineDate('Duration of prohibition',
                          vaccination.prohibitionPeriod.toString(),
                          needBorder: false, animalRef: animalRef),
                    ),
                  kHeight10,
                ],
              );
            })
          else if (deathRecord != null)
            Column(
              children: [
                medicineDate(
                    'Death Date',
                    deathId: deathRecord.id,
                    deathRecord.date.toFormattedDate() ?? '',
                    needAttachment: needAttachment,
                    needBorder: false,
                    animalRef: animalRef),
                if (deathRecord.reason != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: medicineDate(
                        'Cause of Mortality', deathRecord.reason ?? '',
                        needAttachment: needAttachment,
                        needBorder: false,
                        animalRef: animalRef),
                  ),
              ],
            )
          else if (isWeightReport)
            WeightChart(answers: answersMap ?? {}, initWeight: initWeight)
          else if (answersMap != null)
            ...answersMap.entries.expand<Widget>((entry) {
              final groupAnswers = entry.value;

              return [
                ...groupAnswers.map((answer) {
                  if (isNewBornReport &&
                      answer.questionKey == 'animal_mother_new_born') {
                    return SizedBox.shrink();
                  }
                  final question = FarmDashboardUtils.getLocalizedValue(
                      answer.toJson(), 'question');
                  final value = FarmDashboardUtils.getLocalizedValue(
                      answer.toJson(), 'answer');
                  return medicineDate(question, value,
                      needAttachment: needAttachment,
                      questionId: answer.questionId,
                      barnId: barnId,
                      reportId: reportId,
                      answerId: answer.answerId,
                      needBorder: false,
                      needOptions: true,
                      animalRef: animalRef);
                }),
                Divider(color: Colors.grey[400], thickness: 0.8),
              ];
            }),
          CustomOutlinedContainer(
            title: addButton,
            onTap: onTap,
          )
        ],
      ),
    );
  }

  Column medicineDate(String title, String value,
      {bool needAttachment = false,
      bool needOptions = false,
      bool needBorder = true,
      int? deathId,
      int? reportId,
      int? answerId,
      int? barnId,
      int? questionId,
      String? animalRef}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: text13w300(
                '${title.tr()} ',
                textAlign: TextAlign.start,
              ),
            ),
            if (needAttachment)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/farm/attachment.svg',
                    width: 12,
                  ),
                  text13w300(
                    ' Attachment ',
                    color: AppColors.farmColor,
                  ),
                ],
              ),
            Expanded(
              child: text13w300(
                '${value.tr()} ',
                textAlign: TextAlign.end,
              ),
            ),
            if (needOptions && reportId != null && questionId != null)
              reportPopup(
                  context, reportId, questionId, answerId, barnId, animalRef),
            if (deathId != null)
              DeathPopup(id: deathId, animalKey: widget.animalUniqueKey)
          ],
        ),
        if (needBorder)
          Divider(color: Colors.grey[400], thickness: 0.8)
        else
          kHeight5,
      ],
    );
  }

  CustomText text13w300(String text, {Color? color, TextAlign? textAlign}) {
    return CustomText(
      text: text,
      textAlign: textAlign,
      fontSize: 13,
      // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: FontWeight.w300,
      color: color,
    );
  }

  /// Notes widget built from reports
  Container noteWidget(Map<String, dynamic> reports) {
    final notes = <Map<String, String>>[];

    reports.forEach((key, value) {
      if (value is Map) {
        notes.add({
          'date': value['date']?.toString() ?? '',
          'value': value['text']?.toString() ?? '',
        });
      }
    });

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [customBoxShadow]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText('Notes'),
          kHeight10,
          if (notes.isEmpty)
            titleText('No Notes Yet')
          else
            ...List.generate(
              notes.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(notes[index]['date'] ?? ''),
                  titleText(notes[index]['value'] ?? ''),
                  if (index != notes.length - 1)
                    Divider(color: Colors.grey, thickness: 1)
                ],
              ),
            ),
          kHeight10,
          CustomOutlinedContainer(
            title: 'Add New Notes',
            onTap: () {
              Fluttertoast.showToast(
                msg: 'Not available at the moment'.tr(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
          )
        ],
      ),
    );
  }

  Container infoStatusCard(Map<String, String> data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [customBoxShadow],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleText(data['title'] ?? ''),
              titleText(data['value'] ?? '', color: true),
            ],
          ),
          kHeight10,
          CustomOutlinedContainer(
            onTap: () {},
            title: '${'Add'.tr()} ${(data['title'] ?? '').tr()}',
          )
        ],
      ),
    );
  }

  CustomText titleText(String text,
      {bool color = false, TextAlign? textAlign}) {
    return CustomText(
        text: text,
        fontSize: 15,
        textAlign: textAlign,
        fontWeight: FontWeight.w400,
        // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
        fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        color: color ? AppColors.farmColor : Colors.black);
  }

  Row detailsWidget(LiveStockDetailsModel? livestock) {
    final barn = livestock?.barn;
    final predefined = livestock?.predefinedAnimalDetails ?? [];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 250,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [customBoxShadow],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (livestock?.predefinedAnimalDetails?.firstOrNull
                            ?.animalTypeName !=
                        null)
                      detailText(
                          'Name (Optional)',
                          livestock?.predefinedAnimalDetails?.firstOrNull
                                  ?.animalTypeName ??
                              ''),
                    if (isArabic) kHeight10 else kHeight5,
                    detailText(
                        'Date of Birth',
                        livestock?.predefinedAnimalDetails?.firstOrNull
                                ?.birthDate ??
                            '-'),
                    if (isArabic) kHeight10 else kHeight5,
                    detailText(
                        'Barn',
                        '${barn?.barnNumber ?? ''} ${barn?.barnNumber != null && barn?.name.isNotEmpty == true ? '-' : ''} ${barn?.name ?? ''}'
                            .trim()),
                  ],
                ),
                if (predefined.firstOrNull?.animalFather != null ||
                    predefined.firstOrNull?.animalMother != null)
                  Divider(thickness: 1, color: Colors.grey),
                if (predefined.firstOrNull?.animalFather != null ||
                    predefined.firstOrNull?.animalMother != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Parent's Info",
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                      if (predefined.firstOrNull?.animalFather != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            valueText('Father'),
                            valueText(
                                '#${predefined.firstOrNull?.animalFather ?? ''}')
                          ],
                        ),
                      if (isArabic) kHeight10 else kHeight5,
                      if (predefined.firstOrNull?.animalMother != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            valueText('Mother'),
                            valueText(
                                '#${predefined.firstOrNull?.animalMother ?? ''}')
                          ],
                        ),
                    ],
                  )
              ],
            ),
          ),
        ),
        kWidth20,
        SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              genderAndAge(isAge: false, predefineKeys: predefined),
              genderAndAge(
                  isAge: true, predefineKeys: predefined, livestock: livestock),
            ],
          ),
        )
      ],
    );
  }

  Container genderAndAge({
    bool isAge = true,
    List<PredefinedAnimalDetails>? predefineKeys,
    LiveStockDetailsModel? livestock,
  }) {
    final gender = getGender(predefineKeys);

    // --- Age calculation ---
    String ageText = "0";

    if (isAge) {
      final birthDateStr = predefineKeys?.firstOrNull?.birthDate;
      if (birthDateStr != null) {
        final birthDate = DateTime.tryParse(birthDateStr);

        if (birthDate != null) {
          final endDate = livestock?.deathRecord?.date ?? DateTime.now();
          final duration = endDate.difference(birthDate);
          final years = duration.inDays ~/ 365;
          ageText = years.toString();
        }
      }
    }

    return Container(
      alignment: Alignment.center,
      width: 120,
      height: 112,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [customBoxShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isAge)
            CustomText(
              text: ageText,
              fontSize: 42,
              textAlign: TextAlign.center,
              height: 1,
            )
          else
            SvgPicture.asset(
              FarmUtils.isMale(gender)
                  ? 'assets/svg/farm/male.svg'
                  : 'assets/svg/farm/female.svg',
            ),
          CustomText(
            text: isAge
                ? 'Years'
                : FarmUtils.isMale(gender)
                    ? 'Male'
                    : 'Female',
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontSize: 13,
            color: isAge
                ? Colors.black
                : FarmUtils.isMale(gender)
                    ? Colors.blue
                    : Colors.red,
          ),
        ],
      ),
    );
  }

  String? getGender(List<PredefinedAnimalDetails>? predefineKeys) {
    return predefineKeys
        ?.firstWhereOrNull((data) => !isStringEmpty(data.gender))
        ?.gender;
  }

  Column detailText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 9,
          color: Colors.grey,
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
        if (isArabic) kHeight5,
        valueText(value),
      ],
    );
  }

  CustomText valueText(String value) => CustomText(
        text: value,
        fontSize: 14,
        // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
        fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      );

  Container idBox(String? animalType, String? animalRef) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [customBoxShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (animalType != null)
            SizedBox(
              height: 30,
              child: animalType.split('.').lastOrNull == 'svg'
                  ? SvgPicture.network(
                      animalType,
                      height: 30,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: animalType,
                      height: 30,
                      placeholder: (context, url) => SizedBox.shrink(),
                      errorWidget: (context, url, error) => SizedBox.shrink(),
                      fit: BoxFit.cover,
                    ),
            ),
          CustomText(text: '#${animalRef ?? ''}', fontSize: 20)
        ],
      ),
    );
  }

  PopupMenuButton<int> _showPopupMenu(BuildContext context, int barn) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) async {
        if (value == 3) {
          final confirm = await showConfirmationDialog(
            context: context,
            title: 'Delete livestock'.tr(),
            content: 'Are you sure you want to delete this livestock?'.tr(),
            fromFarm: true,
          );

          if (!confirm) return;
          var future = context
              .read<LiveStockDetailsCubit>()
              .deleteLivestock(widget.animalUniqueKey);
          final errorMsg = await LoadingDialog.show(context, future);
          if (!context.mounted) return;
          if (errorMsg != null) {
            CustomSnackBar.error(context, errorMsg);
          } else {
            context.read<BarnDetailsCubit>().filter = {};
            if (!widget.fromBarn) {
              ref.read(selectedAppbarItem.notifier).state = 2;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const BottomBar(initialIndex: 2)),
                (route) => false,
              );
            } else {
              Navigator.pop(context);
            }
            await context.read<BarnDetailsCubit>().fetchBarnDetails(
                  barn,
                  animalCategory: widget.category,
                  allBarn: !widget.fromBarn ? true : false,
                  loadMore: false,
                );
          }
        } else if (value == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditLivestock(animalKey: widget.animalUniqueKey),
              ));
        } else {
          Fluttertoast.showToast(
            msg: 'Not available at the moment'.tr(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      itemBuilder: (context) => [
        // popupMenuItem(0, 'assets/svg/farm/sale.svg', "Sell"),
        popupMenuItem(1, 'assets/svg/farm/edit.svg', "Edit"),
        // popupMenuItem(2, 'assets/svg/farm/excel.svg', "Excel"),
        popupMenuItem(3, 'assets/svg/farm/delete.svg', "Delete"),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Icon(Icons.more_horiz, color: Colors.black),
      ),
    );
  }

  PopupMenuButton<int> reportPopup(BuildContext context, int reportId,
      int questionId, int? answerId, int? barnId, String? animalRef,
      {bool isVaccination = false, bool isDeath = false}) {
    String errorMsg = '';
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) async {
        if (value == 0) {
          context.read<GetQuestionCubit>().getQuestion(reportId, questionId);
          showModalBottomSheet(
            scrollControlDisabledMaxHeightRatio: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            context: context,
            builder: (context) {
              bool isLoading = false;
              return StatefulBuilder(builder: (context, setModalState) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 20,
                      ),
                      child: BlocBuilder<GetQuestionCubit, GetQuestionState>(
                        builder: (context, state) {
                          if (state is QuestionLoaded) {
                            return Column(
                              children: [
                                ReportQuestionComponent(
                                  fromDetailsPage: true,
                                  question: state.question,
                                  onTap: (answers) {
                                    Map<String, dynamic> params = {
                                      "answer_type":
                                          answers.firstOrNull?['answer_type'] ??
                                              '',
                                      "answer":
                                          answers.firstOrNull?['answer'] ?? '',
                                      "report_content_key":
                                          answers.firstOrNull?[
                                                  'report_content_key'] ??
                                              '',
                                      "animal_ref": animalRef,
                                      if (barnId != null) "barn_id": barnId,
                                    };

                                    if (answers.firstOrNull?[
                                            'report_question_content_id'] !=
                                        null) {
                                      params["report_question_content_id"] =
                                          answers.firstOrNull?[
                                              'report_question_content_id'];
                                    }

                                    setState(() {
                                      editedAnswer = params;
                                    });
                                  },
                                ),
                                if (errorMsg.isNotEmpty)
                                  CustomText(
                                    text: errorMsg,
                                    color: Colors.red,
                                  ),
                                kHeight20,
                                isLoading
                                    ? CupertinoActivityIndicator()
                                    : CustomOutlinedContainer(
                                        title: 'Update'.tr(),
                                        fill: true,
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () async {
                                            if (!context.mounted) return;
                                            if (editedAnswer != null &&
                                                answerId != null) {
                                              setModalState(() {
                                                isLoading = true;
                                                errorMsg = '';
                                              });

                                              errorMsg = await context
                                                      .read<GetQuestionCubit>()
                                                      .editAnswer(editedAnswer!,
                                                          answerId) ??
                                                  '';

                                              setModalState(() {
                                                isLoading = false;
                                              });

                                              if (!context.mounted) return;
                                              if (errorMsg.isEmpty) {
                                                Navigator.pop(context);
                                                await context
                                                    .read<
                                                        LiveStockDetailsCubit>()
                                                    .getLivestockDetails(
                                                        widget.animalUniqueKey);
                                              }
                                            }
                                          });
                                        },
                                      ),
                                kHeight20,
                              ],
                            );
                          } else if (state is QuestionLoading) {
                            return Center(child: CupertinoActivityIndicator());
                          } else if (state is QuestionsError) {
                            return Center(
                                child: CustomText(text: state.message));
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                );
              });
            },
          ).whenComplete(
            () {
              editedAnswer = null;
            },
          );
        } else if (value == 1 && answerId != null) {
          final confirm = await showConfirmationDialog(
            context: context,
            title: 'Delete answer'.tr(),
            content: 'Are you sure you want to delete this answer?'.tr(),
            fromFarm: true,
          );

          if (!confirm) return;
          var future = context.read<GetQuestionCubit>().deleteAnswers(answerId);
          final errorMsg = await LoadingDialog.show(context, future);
          if (!context.mounted) return;
          if (errorMsg != null) {
            CustomSnackBar.error(context, errorMsg);
          } else {
            await context
                .read<LiveStockDetailsCubit>()
                .getLivestockDetails(widget.animalUniqueKey);
          }
        }
      },
      itemBuilder: (context) => [
        popupMenuItem(0, 'assets/svg/farm/edit.svg', "Edit"),
        popupMenuItem(1, 'assets/svg/farm/delete.svg', "Delete"),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: const Icon(Icons.more_vert, color: Colors.black),
      ),
    );
  }

  PopupMenuItem<int> popupMenuItem(int value, String svg, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          SvgPicture.asset(svg, width: 16, height: 16),
          kWidth10,
          CustomText(
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            text: text,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
