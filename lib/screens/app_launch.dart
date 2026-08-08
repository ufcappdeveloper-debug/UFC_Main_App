import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../global/extensions/app_font_family.dart';
import '../global/extensions/app_images.dart';
import '../global/shared/constants/app_colors.dart';
import '../global/shared/constants/constants.dart';
import '../global/shared/widgets/custom_button.dart';
import '../global/shared/widgets/custom_widgets/custom_text.dart';

class AppLaunch extends StatelessWidget {
  const AppLaunch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(AppImages.lounchBackground),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height:
                        isArabic ? 60 : 40), // Adds breathing space at the top
                Image.asset(
                  'assets/new_design/animations/welcome.gif',
                  height: isUrdu ? 270 : 280,
                ),
                CustomText(
                  text: 'United Feeds App Officially Launched!'.tr(),
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontSize: isUrdu ? 29 : 31,
                  textAlign: TextAlign.center,
                ),
                isEnglish ? kHeight15 : kHeight20,
                CustomText(
                  text:
                      'We are proud to announce the launch of the United Feeds App, designed to make it easier for breeders and farmers across the Kingdom to access high-quality feed products.'
                          .tr(),
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  textAlign: TextAlign.center,
                ),
                isEnglish ? kHeight10 : kHeight20,
                CustomText(
                  text:
                      'This launch comes as part of our ongoing digital transformation efforts and our commitment to enhancing our services to meet customer needs efficiently and reliably — in line with Saudi Vision 2030, which aims to support and develop the agricultural sector.'
                          .tr(),
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  textAlign: TextAlign.center,
                ),
                kHeight20,
                CustomButton(
                  height: 48,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  width: MediaQuery.sizeOf(context).width,
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  title: 'Continue',
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
