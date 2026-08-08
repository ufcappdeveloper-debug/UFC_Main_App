import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/chat_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/options_overlay_dailog_box.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/extension/date_extenstions.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool isPastAppointment;
  final Future<void> Function()? onTapOptions;
  final Key? cardKey;
  final TabController? tabController;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isPastAppointment,
    this.onTapOptions,
    this.cardKey,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: cardKey,
      margin: const EdgeInsets.only(bottom: 24, left: 6.5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isArabic
            ? Border(
                right: BorderSide(
                  color: Colors.green,
                  width: 1.5,
                ),
              )
            : Border(
                left: BorderSide(
                  color: Colors.green,
                  width: 1.5,
                ),
              ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, -3),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Appointment date".tr(),
                style: PetVeterinaryFontstyles.poppinsRegularTextStyle12,
              ),

              /// Action Button (cancle, re-book)
              OptionsOverlayDailogBox(
                appointment,
                isPastAppointment: isPastAppointment,
                onTap: onTapOptions,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Doctor Image
              // CircleAvatar(
              //   radius: 20.5,
              //   backgroundImage:
              //       NetworkImage(appointment.doctor?.profileImage ?? ''),
              // ),
              CircleAvatar(
                radius: 20.5,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    (appointment.doctor?.profileImage?.isNotEmpty ?? false)
                        ? NetworkImage(appointment.doctor!.profileImage!)
                        : null,
                child: (appointment.doctor?.profileImage?.isEmpty ?? true)
                    ? Icon(
                        Icons.person,
                        size: 20.0,
                        color: Colors.grey,
                      )
                    : null,
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drName(appointment.doctor!, context),
                      style: PetVeterinaryFontstyles.poppinsMediumTextStyle15,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization(appointment.doctor!, context),
                      style: PetVeterinaryFontstyles.poppinsRegularTextStyle12
                          .copyWith(
                        color: PetVeterinaryColors.customBlackColor,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: Image.asset(
                  'assets/images/pv_msg_icon.png',
                  width: 20,
                  height: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        doctor: appointment.doctor!,
                        receiverId: appointment.doctorId ?? 0,
                        senderId: appointment.userId ?? 0,
                        bookingId: (appointment.id ?? '').toString(),
                        roomId:
                            'room_${appointment.doctorId}_${appointment.userId}',
                        userId: appointment.userId ?? 0,
                        appointment: appointment,
                        tabController: tabController,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          kHeight5,
          SizedBox(
            width: double.infinity,
            child: Divider(
              thickness: 1,
              color: PetVeterinaryColors.dividerLinecolor2,
            ),
          ),
          kHeight5,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconWithText(
                  "assets/images/pv_calendar_icon.png",
                  appointment.startTime
                          ?.toDateTime()
                          ?.toLocal()
                          .toFormattedDateWithDay(LanguageManager.locale) ??
                      '',
                ),
                Icon(
                  isArabic
                      ? Icons.keyboard_arrow_left
                      : Icons.keyboard_arrow_right,
                  size: 20,
                ),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: _iconWithText(
                    "assets/images/pv_time.png",
                    formatTimeRange(
                      appointment.startTime?.toDateTime()?.toLocal(),
                      appointment.endTime?.toDateTime()?.toLocal(),
                      LanguageManager.locale,
                    ),
                    haveIcon: false,
                  ),
                )
              ],
            ),
          ),
          kHeight5,
          SizedBox(
            width: double.infinity,
            child: Divider(
              thickness: 1,
              color: PetVeterinaryColors.dividerLinecolor2,
            ),
          ),
          kHeight5,
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconWithText("assets/images/pv_time.png",
                      "${appointment.duration ?? '0'} ${'minutes'.tr()}"),
                  _iconWithText("assets/images/pv_session_icon.png",
                      "${appointment.sessions ?? '0'} ${'sessions'.tr()}"),
                ],
              )),
        ],
      ),
    );
  }

  String drName(Doctor doctor, BuildContext context) {
    final nameEn = doctor.nameEn?.trim();
    final nameAr = doctor.nameAr?.trim();

    if (isEnglish) {
      return (nameEn?.isNotEmpty ?? false)
          ? nameEn!
          : (nameAr?.isNotEmpty ?? false)
              ? nameAr!
              : 'Unavailable'.tr();
    } else {
      return (nameAr?.isNotEmpty ?? false)
          ? nameAr!
          : (nameEn?.isNotEmpty ?? false)
              ? nameEn!
              : 'Unavailable'.tr();
    }
  }

  String specialization(Doctor doctor, BuildContext context) {
    final specializationEn = doctor.specializationEn?.trim();
    final specializationAr = doctor.specializationAr?.trim();

    if (isEnglish) {
      return (specializationEn?.isNotEmpty ?? false)
          ? specializationEn!
          : (specializationAr?.isNotEmpty ?? false)
              ? specializationAr!
              : '';
    } else {
      return (specializationAr?.isNotEmpty ?? false)
          ? specializationAr!
          : (specializationEn?.isNotEmpty ?? false)
              ? specializationEn!
              : '';
    }
  }

  /// icon with text
  Widget _iconWithText(String imagePath, String value, {bool haveIcon = true}) {
    return Row(
      children: [
        if (haveIcon) Image.asset(imagePath, width: 19, height: 19),
        const SizedBox(width: 8),
        Text(
          value,
          style: PetVeterinaryFontstyles.poppinsRegularTextStyle14,
        ),
      ],
    );
  }

  String formatTimeRange(DateTime? start, DateTime? end, String locale) {
    if (start == null || end == null) return '';

    final DateFormat timeFormat = DateFormat('hh:mm a', locale);

    String formattedStart = timeFormat.format(start);
    String formattedEnd = timeFormat.format(end);

    if (locale == 'ar') {
      const arabicNums = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      for (int i = 0; i <= 9; i++) {
        formattedStart = formattedStart.replaceAll(arabicNums[i], i.toString());
        formattedEnd = formattedEnd.replaceAll(arabicNums[i], i.toString());
      }
    }

    return "$formattedStart - $formattedEnd";
  }
}
