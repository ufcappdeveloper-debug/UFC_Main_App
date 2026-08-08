import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class AppointmentSuccessScreen extends StatefulWidget {
  const AppointmentSuccessScreen({super.key});

  @override
  State<AppointmentSuccessScreen> createState() =>
      _AppointmentSuccessScreenState();
}

class _AppointmentSuccessScreenState extends State<AppointmentSuccessScreen>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 88),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/loyality_points/success_check2.png",
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Your appointment has been\nssuccessfully booked".tr(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: PetVeterinaryFontstyles.kanitMedium23.copyWith(
                          color: PetVeterinaryColors.customDarkText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 287,
                height: 42,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: PetVeterinaryColors.borderLeftColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Back to Home".tr(),
                    style: PetVeterinaryFontstyles.kanitMediumTextStyle14
                        .copyWith(color: PetVeterinaryColors.borderLeftColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
