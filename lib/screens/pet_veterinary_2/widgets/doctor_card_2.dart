import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat/chat_screen_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_appointment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_details_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat/chat_app_bar_2.dart';

enum DoctorCardType { booked, available }

class DoctorCard2 extends StatelessWidget {
  final int? doctorId;
  final DoctorCardType type;
  final String doctorName;
  final String specialty;
  final String time;
  final String dateText;
  final String monthText;
  final String imageUrl;
  final double rating;
  final bool isAvailable;
  final bool isNotAtHome;
  final AppointmentModel? appointment;
  final bool isFromFarm;

  const DoctorCard2(
      {super.key,
      required this.type,
      required this.doctorName,
      required this.specialty,
      required this.time,
      required this.dateText,
      required this.monthText,
      required this.imageUrl,
      required this.rating,
      required this.isAvailable,
      this.isNotAtHome = false,
      this.appointment,
      this.doctorId,
      this.isFromFarm = false});

  @override
  Widget build(BuildContext context) {
    final isBooked = type == DoctorCardType.booked;

    final screenWidth = MediaQuery.of(context).size.width;

    final double containerWidth = screenWidth > 360 ? 109 : 100;

    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.fromLTRB(
        isBooked ? 16 : 14,
        isBooked ? 16 : 24,
        isBooked ? 16 : 14,
        isBooked ? 16 : 24,
      ),
      decoration: BoxDecoration(
        gradient: isBooked && !isNotAtHome
            ? LinearGradient(
                begin: isEnglish ? Alignment.topRight : Alignment.topLeft,
                end: isEnglish ? Alignment.bottomLeft : Alignment.bottomRight,
                colors: [
                  PetVeterinaryColors.newPetBookedCardBackground,
                  Colors.white,
                ],
                stops: [0.1, 0.8],
              )
            : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Colors.white],
              ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isBooked)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dateText,
                    style:
                        PetVeterinaryFontstyles2.getRegularStyle(context, 14),
                  ),
                  Text(
                    isEnglish && monthText.length > 4
                        ? monthText.substring(0, 3)
                        : monthText,
                    style:
                        PetVeterinaryFontstyles2.getRegularStyle(context, 14),
                  )
                ],
              ),
            )
          else
            Padding(
                padding: isEnglish
                    ? EdgeInsets.only(right: 4)
                    : EdgeInsets.only(left: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 85,
                            height: 85,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Image.asset(
                                'assets/new_design/icons/chat_user.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 85,
                          height: 85,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Image.asset(
                              'assets/new_design/icons/chat_user.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                )),
          SizedBox(width: isBooked ? 16 : 10),

          /// MAIN CONTENT & ACTIONS
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isBooked)
                            Transform.translate(
                                offset: Offset(
                                  isEnglish ? -2 : 2,
                                  0,
                                ),
                                child: CircleAvatar(
                                  radius: 14.5,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: (imageUrl.isNotEmpty)
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? Image.asset(
                                          'assets/new_design/icons/chat_user.png',
                                          width: 18,
                                          height: 18,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                )),
                          if (isBooked) const SizedBox(width: 6),
                          Expanded(
                              child: Text(
                            _formatDoctorName(doctorName),
                            style: PetVeterinaryFontstyles2.getRegularStyle(
                              context,
                              13,
                              weight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        specialty.tr(),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                            context, 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isBooked ? 12 : 16),
                      isBooked
                          ? Transform.translate(
                              offset: Offset(
                                isEnglish ? -2 : 2,
                                0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: PetVeterinaryColors.newPetDarkGray,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    time,
                                    style: PetVeterinaryFontstyles2
                                            .getRegularStyle(context, 11)
                                        .copyWith(
                                      color: PetVeterinaryColors.newPetDarkGray,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Transform.translate(
                              offset: Offset(
                                isEnglish ? -2 : 2,
                                0,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isAvailable
                                          ? PetVeterinaryColors
                                              .newPetMainColorVeterinary
                                          : PetVeterinaryColors.newPetLightGray,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                    isAvailable
                                        ? 'Available today'.tr()
                                        : 'Not available'.tr(),
                                    style: PetVeterinaryFontstyles2
                                        .getRegularStyle(
                                      context,
                                      11,
                                    ).copyWith(
                                      color: PetVeterinaryColors.newPetDarkGray,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ],
                              )),
                    ],
                  ),
                ),
                if (!isBooked) const SizedBox(width: 4),
                if (isBooked && !isFromFarm)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            circleIconButton(
                              context,
                              'assets/new_design/icons/chat_icon.png',
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen2(
                                      doctor: appointment?.doctor!,
                                      receiverId: appointment?.doctorId ?? 0,
                                      senderId: appointment?.userId ?? 0,
                                      bookingId:
                                          (appointment?.id ?? '').toString(),
                                      roomId:
                                          'room_${appointment?.doctorId}_${appointment?.userId}',
                                      userId: appointment?.userId ?? 0,
                                      appointment: appointment,
                                    ),
                                  ),
                                );
                              },
                              isNotAtHome: isNotAtHome,
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                            circleIconButton(
                              context,
                              'assets/new_design/icons/video_call.png',
                              isNotAtHome: isNotAtHome,
                              onPressed: () async {
                                final agora = AgoraEngineSingleton();
                                String? doctorId =
                                    appointment?.doctor!.id.toString();
                                if (agora.remoteUid != null &&
                                    doctorId != agora.remoteUid.toString()) {
                                  CustomSnackBar.error(
                                      context, 'You are already in a call');
                                  return;
                                }
                                await VideoCallHelper.startVideoCall(
                                    context: context,
                                    doctorId: doctorId ?? '',
                                    userId:
                                        appointment?.userId.toString() ?? '',
                                    doctor: appointment?.doctor,
                                    appointment: appointment,
                                    isFromDoctorCard: true);
                              },
                              radius: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomPetButton(
                        text: 'Reschedule'.tr(),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => DoctorAppointmentScreen(
                                doctorId: doctorId ?? 0,
                                doctorName: doctorName,
                                specialization: specialty,
                                doctorImage: imageUrl,
                                rating: rating,
                                forEditBooking: true,
                                bookingId: appointment?.id ?? 0,
                              ),
                            ),
                          );
                        },
                        backgroundColor:
                            PetVeterinaryColors.newPetMainColorVeterinary,
                        textStyle: PetVeterinaryFontstyles2.getRegularStyle(
                          context,
                          12,
                          color: Colors.white,
                        ),
                        borderRadius: 8,
                        horizontalPadding: 12,
                        verticalPadding: 4,
                        width: 109,
                        height: 27,
                      ),
                    ],
                  )
                else if (isFromFarm)
                  SizedBox.shrink()
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: isEnglish
                              ? EdgeInsets.only(right: 8)
                              : EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Icon(Icons.star,
                                  color: PetVeterinaryColors.yellowBackground,
                                  size: 16),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: PetVeterinaryFontstyles2.getRegularStyle(
                                    context, 13),
                              ),
                            ],
                          )),
                      const SizedBox(height: 40),
                      CustomPetButton(
                        text: 'Book Now'.tr(),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailsScreen(
                                doctorId: doctorId ?? 0,
                              ),
                            ),
                          );
                        },
                        backgroundColor:
                            PetVeterinaryColors.newPetMainColorVeterinary,
                        textStyle: PetVeterinaryFontstyles2.getRegularStyle(
                          context,
                          12,
                          color: Colors.white,
                        ),
                        borderRadius: 8,
                        horizontalPadding: 8,
                        verticalPadding: 4,
                        width: containerWidth,
                        height: 27,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget circleIconButton(
  BuildContext context,
  String assetPath, {
  required VoidCallback onPressed,
  double radius = 22,
  bool isNotAtHome = false,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: isNotAtHome
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 5,
                  spreadRadius: 1.0,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: radius,
          height: radius,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

class CustomPetButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double? width;
  final double? height;

  const CustomPetButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textStyle,
    this.borderRadius = 8,
    this.horizontalPadding = 12,
    this.verticalPadding = 8,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}

class DoctorGridCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final double rating;
  final VoidCallback onRebook;

  const DoctorGridCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 51,
                    height: 51,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 51,
                      height: 51,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Image.asset(
                          'assets/new_design/icons/chat_user.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 51,
                    height: 51,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Image.asset(
                        'assets/new_design/icons/chat_user.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 14),
          Text(
            doctorName,
            style: PetVeterinaryFontstyles2.getRegularStyle(
              context,
              13,
              weight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Text(
            specialty,
            style: PetVeterinaryFontstyles2.getRegularStyle(
              context,
              11,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 11),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 16, color: Colors.amber),
            ],
          ),
          const SizedBox(height: 8),
          CustomPetButton(
            text: 'Book Now'.tr(),
            onPressed: onRebook,
            backgroundColor: PetVeterinaryColors.newPetMainColorVeterinary,
            textStyle: PetVeterinaryFontstyles2.getRegularStyle(
              context,
              12,
              color: Colors.white,
            ),
            borderRadius: 8,
            horizontalPadding: 8,
            verticalPadding: 4,
            width: 109,
            height: 27,
          ),
        ],
      ),
    );
  }
}

String _formatDoctorName(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length > 2) {
    return '${words.first} ${words.last}';
  }
  return name;
}
