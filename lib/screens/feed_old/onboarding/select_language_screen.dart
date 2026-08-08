import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/screens/feed_old/onboarding/onboarding.dart';
import 'package:ufc_mobile/screens/feed_old/onboarding/widgets/select_language_button.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';

import '../../../global/language_cubit/language_cubit.dart';

class SelectLanguageScreen extends ConsumerStatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  ConsumerState<SelectLanguageScreen> createState() =>
      _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends ConsumerState<SelectLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/logo/logo.svg"),
            const SizedBox(height: 118),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Select Language",
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        text: "اختر اللغه",
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 52),
                  SelectLanguageButton(
                    title: "English",
                    flag: "assets/images/on_boarding/english_icon.svg",
                    onPressed: () async {
                      final future = selectLanguage(context, 0);
                      if (!mounted) return;
                      await LoadingDialog.show(context, future);
                      if (!mounted) return;

                      setState(() {});
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnBoardingScreen(),
                          ));
                    },
                  ),
                  const SizedBox(height: 24),
                  SelectLanguageButton(
                    title: "عربي",
                    flag: "assets/images/on_boarding/arabic_icon.svg",
                    onPressed: () async {
                      final future = selectLanguage(context, 1);
                      await LoadingDialog.show(context, future);
                      if (!mounted) return;

                      setState(() {});
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnBoardingScreen(),
                          ));
                    },
                  ),
                  const SizedBox(height: 24),
                  SelectLanguageButton(
                    title: "اردو",
                    flag: "assets/images/on_boarding/urudu_icon.svg",
                    onPressed: () async {
                      final future = selectLanguage(context, 2);
                      await LoadingDialog.show(context, future);
                      if (!mounted) return;

                      setState(() {});
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnBoardingScreen(),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> selectLanguage(BuildContext context, int index) async {
  final locale = L10n.all[index];
  await context.setLocale(locale);
  context.read<LanguageCubit>().switchLanguage(
    context: context,
    localeString: locale.languageCode,
  );
  await preferences.setInt(LocalStorage.language, index);

  debugPrint("Saved language index: $index");
}

