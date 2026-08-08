import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/global/shared/widgets/circular_page_step_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../landing_page.dart';

class OnBoardingScreen3 extends StatefulWidget {
  const OnBoardingScreen3({super.key});

  @override
  State<OnBoardingScreen3> createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
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
                'assets/images/on_boarding/shipping.png',
              ),
              const SizedBox(height: 60),
              Text(
                'Fast and Reliable Delivery'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              //   child: Text(
              //     textAlign: TextAlign.center,
              //     softWrap: true,
              //     'Sit back and relax while we take care of the delivery. We pride ourselves on providing fast and reliable shipping services.'
              //         .tr(),
              //     style: const TextStyle(fontSize: 11, height: 1.5),
              //   ),
              // ),
              // const SizedBox(height: 15),
              const CircularPageStepIndicator(selectedIndex: 2),
              const SizedBox(height: 15),
              CustomButton(
                title: 'Next',
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LandingPage()),
                    (route) => false),
                height: 50,
                width: 287,
              ),
              const SizedBox(height: 15),
              TextButton(
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
