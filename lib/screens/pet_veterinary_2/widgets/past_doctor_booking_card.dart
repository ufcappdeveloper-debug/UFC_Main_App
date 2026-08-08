import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat/chat_screen_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/doctor_card_2.dart';

class PastDoctorBookingCard extends StatelessWidget {
  final String name;
  final String timeRange;
  final String imageUrl;
  final String dateText;
  final String monthText;
  final AppointmentModel? appointment;
  final bool isFromFarm;

  const PastDoctorBookingCard({
    super.key,
    required this.name,
    required this.timeRange,
    required this.imageUrl,
    required this.dateText,
    required this.monthText,
    this.appointment,
    this.isFromFarm = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 24, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: isEnglish
              ? EdgeInsets.only(left: 8, right: 24)
              : EdgeInsets.only(left: 24, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateText,
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 14),
              ),
              Text(
                isEnglish && monthText.length > 4
                    ? monthText.substring(0, 3)
                    : monthText,
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 14),
              )
            ],
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 14.5,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? Image.asset(
                          'assets/new_design/icons/chat_user.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: PetVeterinaryFontstyles2.getMediumStyle(
                      context,
                      13,
                    ),
                  ),
                ),
                if (!isFromFarm)
                  circleIconButton(
                    context,
                    'assets/new_design/icons/chat_icon.png',
                    isNotAtHome: true,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen2(
                            doctor: appointment?.doctor!,
                            receiverId: appointment?.doctorId ?? 0,
                            senderId: appointment?.userId ?? 0,
                            bookingId: (appointment?.id ?? '').toString(),
                            roomId:
                                'room_${appointment?.doctorId}_${appointment?.userId}',
                            userId: appointment?.userId ?? 0,
                            appointment: appointment,
                            isPast: true,
                          ),
                        ),
                      );
                    },
                    radius: 20,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 14, color: PetVeterinaryColors.newPetDarkGray),
                const SizedBox(width: 4),
                Text(timeRange,
                    style: PetVeterinaryFontstyles2.getRegularStyle(
                      context,
                      11,
                    ).copyWith(color: PetVeterinaryColors.newPetDarkGray)),
              ],
            ),
          ],
        ))
      ]),
    );
  }
}
