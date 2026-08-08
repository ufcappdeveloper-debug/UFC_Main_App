import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/onboarding/onboarding_3.dart';
import 'package:ufc_mobile/global/shared/widgets/circular_page_step_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../../global/shared/constants/app_colors.dart';
import '../../landing_page.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/on_boarding/purchase.png',
              ),
              const SizedBox(height: 15),
              Text(
                'Order Management'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const CircularPageStepIndicator(selectedIndex: 1),
              const SizedBox(height: 15),
              CustomButton(
                title: 'Next',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnBoardingScreen3()),
                ),
                height: 50,
                width: 287,
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LandingPage()),
                      (route) => false);
                },
                child: CustomText(
                    text: 'Skip',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ));
  }
}
