import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/pages/login_with_number_page.dart';

import '../global/extensions/app_colors.dart';
import '../global/extensions/app_images.dart';
import '../global/shared/constants/app_colors.dart';
import '../global/shared/constants/constants.dart';
import '../global/shared/widgets/app/auto_login.dart';
import '../global/shared/widgets/custom_widgets/custom_text.dart';
import '../global/util/common/common_utils.dart';
import '../global/util/storage/local_storage.dart';
import '../main.dart';
import 'pet_veterinary/service/chat_socket_manager.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    Future(() async => await preferences.setString('no_onboard', 'true'));
    _initChat();
    Future.microtask(_init);
    super.initState();
  }

  Future<void> _initChat() async {
    ChatSocketManager.init();
  }

  Future<void> _init() async {
    final int? langIndex = preferences.getInt(LocalStorage.language);

    Future(() {
      if (mounted) {
        if (langIndex != null) {
          context.read<LanguageCubit>().switchLanguage(
                context: context,
                localeString: L10n.all[langIndex].languageCode.toString(),
              );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<_Category> categories = [
      _Category(
        title: "United Feed Store",
        description:
            "Everything you need from high-quality feed\nall in one place.",
        image: AppImages.feedLanding,
        color: const Color(0xFF78B943),
        appType: AppType.feed,
      ),
      _Category(
        title: "Veterinary Consultations",
        description:
            "Trusted healthcare for your animals\navailable around the clock.",
        image: AppImages.veterinaryLanding,
        color: AppColors.veterinaryColor,
        appType: AppType.veterinary,
      ),
      _Category(
        title: "Breeding Management",
        description:
            "Track farm conditions, keep activity logs,\nand manage everything with ease.",
        image: AppImages.farmLanding,
        color: AppColors.farmColor,
        appType: AppType.farm,
      ),
      _Category(
        title: "Community Management",
        description:
            "Connect with fellow farmers,\nlnand share experiences and advice.",
        image: AppImages.communityLanding,
        color: primaryPurple,
        appType: AppType.community,
      ),
    ];

    return AutoLogin(
        needBackground: false,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                kHeight50,
                CustomText(
                  text: 'Welcome!',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  color: Color(0xFF78B943),
                ),
                kHeight10,
                if (!isEnglish) kHeight10,
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: CustomText(
                      text: 'Please select the category you prefer:',
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      fontFamily: isEnglish
                          ? AppFontsFamily.english
                          : AppFontsFamily.arabic,
                    )),
                kHeight50,
                kHeight10,
                ...List.generate(
                  categories.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginWithNumber(
                                    appType: categories[index].appType,
                                    isNotFromStart: true,
                                  )),
                          (route) => false,
                        );
                      },
                      child: Container(
                        height: 120,
                        margin: EdgeInsets.only(bottom: 15),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                        decoration: BoxDecoration(
                            color: categories[index].color,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                alignment: Alignment.centerLeft,
                                image: AssetImage(categories[index].image))),
                        child: Row(
                          mainAxisAlignment: isEnglish
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  //  isEnglish
                                  //     ? CrossAxisAlignment.end
                                  //     :
                                  CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: categories[index].title,
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: isEnglish
                                      ? AppFontsFamily.english
                                      : AppFontsFamily.arabic,
                                ),
                                kHeight10,
                                SizedBox(
                                  child: CustomText(
                                    textAlign:
                                        // isEnglish
                                        //     ? TextAlign.end
                                        //     :
                                        TextAlign.start,
                                    text: categories[index].description,
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: isEnglish
                                        ? AppFontsFamily.english
                                        : AppFontsFamily.arabic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                kHeight40,
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: CustomText(
                    text: 'All rights reserved. United Feed – 2025',
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}

class _Category {
  final String title;
  final String description;
  final String image;
  final Color color;
  final AppType appType;

  const _Category({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    required this.appType,
  });
}
