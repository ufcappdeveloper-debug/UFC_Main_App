import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/functions/dio.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../../../../global/shared/widgets/show_confirmation_dailog.dart';
import '../../../../riverpod/farm/barn/barn_provider.dart';
import '../../application/barn_details/barn_details_cubit.dart';
import '../../application/dashbaord/dashboard_cubit.dart';
import '../../domain/entities/barn/barn_model.dart';
import '../charts/weight_chart.dart';
import 'arabic_number.dart';
import 'farm_text_field.dart';

class BarnPopupMenu extends StatefulWidget {
  final BarnModel? selectedBarn;
  final WidgetRef ref;
  final Function(BarnModel?) onBarnChanged;

  const BarnPopupMenu({
    super.key,
    required this.selectedBarn,
    required this.ref,
    required this.onBarnChanged,
  });

  @override
  State<BarnPopupMenu> createState() => _BarnPopupMenuState();
}

class _BarnPopupMenuState extends State<BarnPopupMenu> {
  late TextEditingController barnNameController;
  late TextEditingController barnArNameController;
  late TextEditingController barnNumber;

  @override
  void initState() {
    super.initState();
    barnNameController =
        TextEditingController(text: widget.selectedBarn?.barnNameEn ?? '');
    barnArNameController =
        TextEditingController(text: widget.selectedBarn?.barnNameAr ?? '');
    barnNumber = TextEditingController(
        text: widget.selectedBarn?.barnNumber?.toString() ?? '');
  }

  @override
  void dispose() {
    barnNameController.dispose();
    barnArNameController.dispose();
    barnNumber.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BarnPopupMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBarn?.id != widget.selectedBarn?.id) {
      barnNameController.text = widget.selectedBarn?.barnNameEn ?? '';
      barnArNameController.text = widget.selectedBarn?.barnNameAr ?? '';
      barnNumber.text = widget.selectedBarn?.barnNumber?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      icon: const Icon(Icons.more_horiz, color: Colors.black),
      onSelected: (value) async {
        if (value == 0) {
          _showEditBottomSheet(context);
        } else if (value == 2) {
          if (widget.selectedBarn?.id != null) {
            LoadingDialog.show(
              context,
              Future(() async {
                if (!context.mounted) return;

                final confirm = await showConfirmationDialog(
                  context: context,
                  title: 'Delete Barn'.tr(),
                  content: 'Are you sure you want to delete this barn?'.tr(),
                  fromFarm: true,
                );

                if (!confirm) return;

                await widget.ref
                    .read(barnAsyncProvider.notifier)
                    .deleteBarn(widget.selectedBarn!.id!);

                // Reload barns
                await widget.ref.read(barnAsyncProvider.notifier).getBarn();

                // Update selected barn
                final barns = widget.ref.read(barnAsyncProvider).value ?? [];

                if (barns.isNotEmpty) {
                  widget.onBarnChanged(barns.first);
                  if (context.mounted) {
                    await context
                        .read<BarnDetailsCubit>()
                        .fetchBarnDetails(barns.first.id!);
                  }
                } else {
                  widget.onBarnChanged(null);
                }

                //update dashboard
                if (context.mounted) {
                  context.read<FarmDashboardCubit>().getDashboardDetails();
                }
              }),
            );
          }
        }
      },
      itemBuilder: (context) => [
        popupItem('assets/svg/farm/edit.svg', 'Edit', 0),
        popupItem(
          'assets/svg/farm/delete.svg',
          'Delete barn (with livestock)',
          2,
          color: Colors.red,
        ),
      ],
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    bool isLoading = false;

    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          CustomText(
                            text: 'Edit Barn',
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close),
                          )
                        ],
                      ),
                      kHeight30,
                      CustomTextFormField(
                        controller: barnNumber,
                        keyboardType: TextInputType.number,
                        hintText: 'Barn number'.tr(),
                        context: context,
                      ),
                      kHeight20,
                      CustomTextFormField(
                        controller: barnNameController,
                        hintText: 'Name of the barn'.tr(),
                        context: context,
                      ),
                      kHeight20,
                      CustomTextFormField(
                        controller: barnArNameController,
                        hintText: "Name of the barn in Arabic".tr(),
                        context: context,
                      ),
                      kHeight40,
                      isLoading
                          ? CircularProgressIndicator(
                              color: AppColors.farmColor,
                            )
                          : CustomOutlinedContainer(
                              title: 'Save',
                              fill: true,
                              onTap: () async {
                                setModalState(() {
                                  isLoading = true;
                                });

                                var barnNum = int.tryParse(
                                    convertNumbersToEnglish(barnNumber.text));
                                try {
                                  await widget.ref
                                      .read(barnAsyncProvider.notifier)
                                      .addBarn({
                                    "barn_number": barnNum,
                                    "barn_name_en": barnNameController.text,
                                    "barn_name_ar": barnArNameController.text,
                                  }, editBarnId: widget.selectedBarn?.id);
                                } on DioException catch (e) {
                                  if (context.mounted) {
                                    CustomSnackBar.error(context,
                                        extractErrorMessage(e.response?.data));
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    CustomSnackBar.error(context, e.toString());
                                  }
                                }

                                setModalState(() {
                                  isLoading = false;
                                });

                                widget.onBarnChanged(widget.selectedBarn
                                  ?..barnNameEn = barnNameController.text
                                  ..barnNameAr = barnArNameController.text
                                  ..barnNumber = int.tryParse(barnNumber.text));

                                barnArNameController.clear();
                                barnNameController.clear();
                                barnNumber.clear();

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                      kHeight20,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      barnNameController.text = widget.selectedBarn?.barnNameEn ?? '';
      barnArNameController.text = widget.selectedBarn?.barnNameAr ?? '';
      barnNumber.text = widget.selectedBarn?.barnNumber?.toString() ?? '';
    });
  }

  PopupMenuItem<int> popupItem(String svg, String title, int value,
      {Color? color}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          SvgPicture.asset(svg),
          kWidth10,
          CustomText(
            text: title,
            color: color,
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
