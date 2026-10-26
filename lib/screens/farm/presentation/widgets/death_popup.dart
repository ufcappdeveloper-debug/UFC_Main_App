import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/weight_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_text_field.dart';

import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../../../../global/shared/widgets/show_confirmation_dailog.dart';
import '../../application/get_question/get_question_cubit.dart';
import '../../application/livestock_details/livestock_details_cubit.dart';
import '../../application/animal_dates/animal_dates_loader.dart';
import '../../domain/services/farm_date_rules.dart';

class DeathPopup extends StatefulWidget {
  final int id;
  final String animalKey;
  const DeathPopup({super.key, required this.id, required this.animalKey});

  @override
  State<DeathPopup> createState() => _DeathPopupState();
}

class _DeathPopupState extends State<DeathPopup> {
  late TextEditingController dateController;
  late TextEditingController reasonController;

  @override
  void initState() {
    dateController = TextEditingController();
    reasonController = TextEditingController();
    super.initState();
  }

  String? errorMsg;
  bool isLoading = false;

  /// The animal's known dates (birth, records): a death can't come before.
  AnimalDates? get _dates =>
      AnimalDatesLoader.fromState(context.read<LiveStockDetailsCubit>().state);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) async {
        if (value == 0) {
          showModalBottomSheet(
            scrollControlDisabledMaxHeightRatio: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            context: context,
            builder: (context) {
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                            text: 'Death Date',
                          ),
                          kHeight10,
                          CustomDatePicker(
                            needFormat: false,
                            minimumDate:
                                FarmDateRules.range(FarmDateKind.death, _dates)
                                    .min,
                            validateDate: (d) => FarmDateRules.validate(
                                FarmDateKind.death, d, _dates),
                            onDateSelect: (date) {},
                            controller: dateController,
                          ),
                          kHeight20,
                          CustomText(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                            text: 'Cause of Mortality (Optional)',
                          ),
                          kHeight10,
                          CustomTextFormField(
                            context: context,
                            controller: reasonController,
                            isMsg: true,
                          ),
                          if (errorMsg != null)
                            CustomText(
                              text: errorMsg!,
                              color: Colors.red,
                            ),
                          kHeight20,
                          isLoading
                              ? Center(child: CupertinoActivityIndicator())
                              : CustomOutlinedContainer(
                                  fill: true,
                                  title: 'Update'.tr(),
                                  onTap: () async {
                                    if (dateController.text.isEmpty) {
                                      setModalState(() => errorMsg =
                                          'Please enter the date'.tr());
                                      return;
                                    }
                                    final picked = FarmDateRules.parse(
                                        dateController.text);
                                    final dateError = picked == null
                                        ? null
                                        : FarmDateRules.validate(
                                            FarmDateKind.death, picked, _dates);
                                    if (dateError != null) {
                                      setModalState(() => errorMsg = dateError);
                                      return;
                                    }
                                    final param = {
                                      "death_date": dateController.text,
                                      if (reasonController.text.isNotEmpty)
                                        "death_reason": reasonController.text
                                    };
                                    final questionCubit =
                                        context.read<GetQuestionCubit>();
                                    final detailsCubit =
                                        context.read<LiveStockDetailsCubit>();
                                    setModalState(() {
                                      errorMsg = null;
                                      isLoading = true;
                                    });
                                    final error = await questionCubit
                                        .updateDeath(param, widget.id);
                                    if (!context.mounted) return;

                                    // Keep the sheet open on a validation
                                    // error (e.g. death before the latest
                                    // record) so the message is visible.
                                    if (error != null) {
                                      setModalState(() {
                                        isLoading = false;
                                        errorMsg = error;
                                      });
                                      return;
                                    }
                                    setModalState(() => isLoading = false);
                                    Navigator.pop(context);
                                    await detailsCubit
                                        .getLivestockDetails(widget.animalKey);
                                  },
                                ),
                          kHeight20
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ).whenComplete(
            () {
              dateController.clear();
              reasonController.clear();
              errorMsg = null;
            },
          );
        } else if (value == 1) {
          final confirm = await showConfirmationDialog(
            context: context,
            title: 'Delete death'.tr(),
            content: 'Are you sure you want to delete this death?'.tr(),
            fromFarm: true,
          );

          if (!confirm) return;
          var future = context.read<GetQuestionCubit>().deleteDeath(widget.id);
          final errorMsg = await LoadingDialog.show(context, future);
          if (!context.mounted) return;
          if (errorMsg != null) {
            CustomSnackBar.error(context, errorMsg);
          } else {
            await context
                .read<LiveStockDetailsCubit>()
                .getLivestockDetails(widget.animalKey);
          }
        }
      },
      itemBuilder: (context) => [
        popupMenuItem(0, 'assets/svg/farm/edit.svg', "Edit"),
        popupMenuItem(1, 'assets/svg/farm/delete.svg', "Delete"),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            text: text,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
