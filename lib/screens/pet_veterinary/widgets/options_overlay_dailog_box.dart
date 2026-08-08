import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/riverpod/schedule/schedule_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/appoinment_screen.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

class OptionsOverlayDailogBox extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  final bool isPastAppointment;
  final Future<void> Function()? onTap;
  const OptionsOverlayDailogBox(
    this.appointment, {
    super.key,
    required this.isPastAppointment,
    this.onTap,
  });

  @override
  ConsumerState<OptionsOverlayDailogBox> createState() =>
      _OptionsOverlayDailogBoxState();
}

class _OptionsOverlayDailogBoxState
    extends ConsumerState<OptionsOverlayDailogBox> {
  OverlayEntry? overlayEntry;

  void showPopup(BuildContext context, Offset offset) {
    closePopup();

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: closePopup,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            left: isRTL ? null : offset.dx - 140,
            right: isRTL
                ? MediaQuery.of(context).size.width - offset.dx - 190
                : MediaQuery.of(context).size.width - offset.dx - 24,
            top: offset.dy + 30,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 0,
              child: SizedBox(
                width: 163,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                      child: Align(
                        alignment:
                            isRTL ? Alignment.topLeft : Alignment.topRight,
                        child: GestureDetector(
                          onTap: closePopup,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.all(2.6),
                            child: const Icon(Icons.close,
                                size: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          closePopup();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentScreen(
                                doctorId: widget.appointment.doctor?.id ?? 0,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Re - Book".tr(),
                            style: PetVeterinaryFontstyles
                                .poppinsRegularTextStyle13
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    if (!widget.isPastAppointment) ...[
                      const Divider(
                        thickness: 1,
                        color: PetVeterinaryColors.dividerLinecolor3,
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            closePopup();
                            showCancelDialog(context, widget.appointment);
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Cancel".tr(),
                              style: PetVeterinaryFontstyles
                                  .poppinsRegularTextStyle13
                                  .copyWith(
                                      color:
                                          PetVeterinaryColors.customRedColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void showCancelDialog(BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              kHeight16,
              Image.asset(
                "assets/images/exclamation_img.png",
                width: 57,
                height: 57,
              ),
              kHeight16,
              SizedBox(
                width: 225,
                child: Text(
                  "Are you sure you want to cancel your booking?".tr(),
                  textAlign: TextAlign.center,
                  style: PetVeterinaryFontstyles.kanitMediumTextStyle14,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
              kHeight40,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PetVeterinaryColors.borderLeftColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(108, 39),
                      maximumSize: const Size(117, 39),
                    ),
                    child: Text(
                      "No".tr(),
                      style: PetVeterinaryFontstyles.kanitMediumTextStyle14,
                    ),
                  ),
                  kWidth16,
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        EasyLoading.show();
                        final data = await ref
                            .read(appointmentAsyncProvider.notifier)
                            .cancelAppointMent(appointment.id ?? 0);
                        if (!context.mounted) return;
                        EasyLoading.dismiss();
                        if (data != null) {
                          CustomSnackBar.success(context,
                              data.message ?? 'Cancelled successfully');
                          Navigator.pop(context);
                        } else {
                          CustomSnackBar.error(context, "Cancellation failed");
                        }
                      } catch (e) {
                        EasyLoading.dismiss();

                        CustomSnackBar.error(context, e.toString());
                      } finally {
                        if (EasyLoading.isShow) {
                          EasyLoading.dismiss();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PetVeterinaryColors.customRedBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(108, 39),
                      maximumSize: const Size(117, 39),
                    ),
                    child: Text(
                      "Yes".tr(),
                      style: PetVeterinaryFontstyles.kanitMediumTextStyle14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void closePopup() {
    overlayEntry?.remove();
    overlayEntry = null;
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      closePopup();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      // onPressed: () {
      //   widget.onTap?.call();
      //   RenderBox renderBox = context.findRenderObject() as RenderBox;
      //   Offset offset = renderBox.localToGlobal(Offset.zero);
      //   showPopup(context, offset);
      // },
      onPressed: () async {
        await widget.onTap?.call();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final renderBox = context.findRenderObject() as RenderBox;
          final offset = renderBox.localToGlobal(Offset.zero);
          showPopup(context, offset);
        });
      },
    );
  }
}
