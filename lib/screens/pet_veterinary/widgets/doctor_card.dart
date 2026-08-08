import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/appoinment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(doctorId: doctor.id ?? 0),
          ),
        );
      },
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22.5,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (doctor.profileImage?.isNotEmpty ?? false)
                      ? NetworkImage(doctor.profileImage!)
                      : null,
                  child: (doctor.profileImage?.isEmpty ?? true)
                      ? Icon(
                          Icons.person,
                          size: 20.0,
                          color: Colors.grey,
                        )
                      : null,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(drName(doctor, context),
                          style: PetVeterinaryFontstyles.pvBoldTextStyle),
                      const SizedBox(height: 4),
                      Text(drSpecialasation(doctor, context),
                          style: PetVeterinaryFontstyles.kanitLightTextStyle
                              .copyWith(
                                  color:
                                      PetVeterinaryColors.customGrayTextColor)),
                      const SizedBox(height: 8),
                      Text(aboutDoctor(doctor, context),
                          maxLines: 3,
                          style: PetVeterinaryFontstyles.poppinsRegularTextStyle
                              .copyWith(
                                  color: PetVeterinaryColors
                                      .customGray2TextColor)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Divider(
                thickness: 1,
                color: PetVeterinaryColors.dividerLinecolor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _iconWithText(
                    'assets/images/calendar_icon.png',
                    "Available in".tr(),
                    availableTime(doctor.nearestAvailabletime, context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: _iconWithText(
                      'assets/images/rating_star_icon.png',
                      "Rates".tr(),
                      (doctor.rating ?? 0.0).toString(),
                      isRating: true,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Divider(
                thickness: 1,
                color: PetVeterinaryColors.dividerLinecolor,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                doctor.feePerMin ?? 'Free'.tr(),
                style: PetVeterinaryFontstyles.poppinsMediumTextStyle
                    .copyWith(color: PetVeterinaryColors.borderLeftColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  String availableTime(String? dateString, BuildContext context) {
    if (dateString == null) return 'Time unavailable'.tr();
    DateTime dateTime =
        DateFormat("yyyy-MM-dd HH:mm", 'en').parseUtc(dateString).toLocal();
    String dayNum = DateFormat('d', 'en').format(dateTime);
    String time =
        DateFormat('hh:mm', 'en').format(dateTime); // Use 'en' to keep digits
    String month = DateFormat('MMM', 'en').format(dateTime);
    String amOrPm = DateFormat('a', 'en').format(dateTime);

    return "$dayNum$month.$time$amOrPm";
  }

  String aboutDoctor(Doctor doctor, BuildContext context) {
    final aboutEn = doctor.aboutEn?.trim();
    final aboutAr = doctor.aboutAr?.trim();

    if (isEnglish) {
      return (aboutEn?.isNotEmpty ?? false)
          ? aboutEn!
          : (aboutAr?.isNotEmpty ?? false)
              ? aboutAr!
              : 'Unavailable'.tr();
    } else {
      return (aboutAr?.isNotEmpty ?? false)
          ? aboutAr!
          : (aboutEn?.isNotEmpty ?? false)
              ? aboutEn!
              : 'Unavailable'.tr();
    }
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

  String drSpecialasation(Doctor doctor, BuildContext context) {
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

  Widget _iconWithText(String imagePath, String title, String value,
      {bool isRating = false}) {
    return isRating
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: PetVeterinaryFontstyles.poppinsLightTextStyle
                        .copyWith(
                            color: PetVeterinaryColors.customGrayTextColor),
                  ),
                  const SizedBox(height: 4),
                  Text(value,
                      style: PetVeterinaryFontstyles
                          .poppinsRegularSmallTextStyle2),
                ],
              ),
              const SizedBox(width: 6),
              Image.asset(imagePath, width: 15, height: 15),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Image.asset(imagePath, width: 15, height: 15),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: PetVeterinaryFontstyles.poppinsLightTextStyle
                      .copyWith(color: PetVeterinaryColors.customGrayTextColor),
                ),
              ]),
              const SizedBox(height: 4),
              Text(value,
                  style: PetVeterinaryFontstyles.poppinsRegularSmallTextStyle2),
            ],
          );
  }
}
