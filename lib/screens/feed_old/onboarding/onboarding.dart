import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/screens/feed_old/onboarding/onboarding_2.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/global/shared/widgets/circular_page_step_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/will_popscope_widget.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';
import '../../landing_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int? langIndex = preferences.getInt(LocalStorage.language);
      final locale = L10n.all[langIndex ?? 0];
      context.setLocale(locale);

      if (mounted && langIndex != null) {
        context.read<LanguageCubit>().switchLanguage(
          context: context,
          localeString: locale.languageCode,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/on_boarding/discover.png',
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: "Explore Our Product Catalog",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 15),
                const CircularPageStepIndicator(),
                const SizedBox(height: 15),
                CustomButton(
                  title: 'Next',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnBoardingScreen2()),
                  ),
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
          )),
    );
  }
}
