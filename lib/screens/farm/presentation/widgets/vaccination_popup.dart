import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/weight_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_text_field.dart';

import '../../../../global/shared/constants/text_filed_input_formatters.dart'
    as filteringtextinputformatter;
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../../../../global/shared/widgets/show_confirmation_dailog.dart';
import '../../application/get_question/get_question_cubit.dart';
import '../../application/livestock_details/livestock_details_cubit.dart';

class VaccinationPopup extends StatefulWidget {
  final int id;
  final String animalKey;
  const VaccinationPopup(
      {super.key, required this.id, required this.animalKey});

  @override
  State<VaccinationPopup> createState() => _VaccinationPopupState();
}

class _VaccinationPopupState extends State<VaccinationPopup> {
  late TextEditingController dateController;
  late TextEditingController durationController;

  @override
  void initState() {
    dateController = TextEditingController();
    durationController = TextEditingController();
    super.initState();
  }
//* sinan mentioned to remove pop up, bcz after adding one vaccination tried to edit vaccine throws error
  // @override
  // void dispose() {
  //   dateController.dispose();
  //   durationController.dispose();
  //   super.dispose();
  // }

  String? errorMsg;
  bool isLoading = false;

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
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                            text: 'History of vaccination',
                          ),
                          kHeight10,
                          CustomDatePicker(
                              needFormat: false,
                              hintText: 'Enter the date'.tr(),
                              onDateSelect: (date) {},
                              controller: dateController),
                          kHeight20,
                          CustomText(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                            text: 'Duration of prohibition',
                          ),
                          kHeight10,
                          CustomTextFormField(
                              inputFormatters: [
                                filteringtextinputformatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: 'day'.tr(),
                                      textAlign: TextAlign.center,
                                    )
                                  ]),
                              context: context,
                              controller: durationController),
                          if (errorMsg != null)
                            CustomText(
                              text: errorMsg!,
                              color: Colors.red,
                            ),
                          kHeight20,
                          isLoading
                              ? CupertinoActivityIndicator()
                              : CustomOutlinedContainer(
                                  fill: true,
                                  title: 'Update'.tr(),
                                  onTap: () async {
                                    final param = {
                                      "id": widget.id,
                                      "vaccination_date": dateController.text,
                                      "prohibition_period":
                                          durationController.text
                                    };
                                    setModalState(() {
                                      errorMsg = null;
                                      isLoading = true;
                                    });
                                    errorMsg = await context
                                        .read<GetQuestionCubit>()
                                        .editVaccine(param);

                                    setModalState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pop(context);
                                    await context
                                        .read<LiveStockDetailsCubit>()
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
              durationController.clear();
              errorMsg = null;
            },
          );
        } else if (value == 1) {
          final confirm = await showConfirmationDialog(
            context: context,
            title: 'Delete vaccine'.tr(),
            content: 'Are you sure you want to delete this vaccine?'.tr(),
            fromFarm: true,
          );

          if (!confirm) return;
          var future =
              context.read<GetQuestionCubit>().deleteVaccine(widget.id);
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
      child: const Icon(Icons.more_vert, color: Colors.black),
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
