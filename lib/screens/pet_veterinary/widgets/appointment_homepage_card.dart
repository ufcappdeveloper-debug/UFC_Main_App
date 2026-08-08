import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';

class AppointmentHomepageCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String appointmentTime;
  final VoidCallback onTap;
  final AppointmentModel appointment;
  const AppointmentHomepageCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.appointmentTime,
    required this.onTap,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        height: 120,
        padding: const EdgeInsets.only(left: 16, right: 24, top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (appointment.doctor?.profileImage?.isNotEmpty ?? false)
                      ? Image.network(
                          appointment.doctor!.profileImage!,
                          width: 80,
                          height: 110,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 80,
                          height: 110,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        doctorName,
                        style: PetVeterinaryFontstyles.kanitRegular16
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        specialty,
                        style: PetVeterinaryFontstyles.poppinsRegularTextStyle12
                            .copyWith(
                                color: PetVeterinaryColors.customBlackColor),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: PetVeterinaryColors.borderLeftColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          appointmentTime,
                          style: PetVeterinaryFontstyles.poppinsMedium10
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: PetVeterinaryColors.borderLeftColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
