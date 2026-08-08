import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/about_us_distinguishes.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/about_us_our_goals.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/about_us_our_mission.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/about_us_our_services.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/about_us_our_value.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/about_us_our_vision.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
            elevation: 8,
            title: CustomText(
              text: 'About UFC'.tr(),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            centerTitle: true,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            ),
          ),
          body: Theme(
            data: ThemeData(
              primaryColor: Colors.green,
              primarySwatch: Colors.green,
              dividerColor: Colors.transparent,
              listTileTheme: ListTileTheme.of(context).copyWith(
                dense: true,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 16,
                                color: const Color(0xFFe5e5e5)
                                    .withValues(alpha: 0.7)),
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: CustomText(
                              text:
                                  "United Feed Company is one of the leading companies globally and locally in the field of importing and trading barley and bulk grains for animal feed uses. It operates through all its seven stations in its strategic areas by distributing and packaging barley and feed to spread throughout the Kingdom, recognizing the importance of enabling local producers to obtain their needs, raising the efficiency of animal production, and supporting food security in Saudi Arabia."
                                      .tr(),
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const AboutUsOurMission(),
                          const AboutUsOurVision(),
                          const AboutUsOurGoals(),
                          const AboutUsOurServices(),
                          const AboutUsDistinguishes(),
                          const AboutUsOurValue(),
                          /*ExpansionTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Story'.tr(),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  const Divider(
                                    color: Color(0xffE5E5E5),
                                    thickness: 1,
                                    height: 10,
                                  ),
                                ],
                              ),
                              textColor: Colors.black,
                              iconColor: Colors.grey,
                              collapsedIconColor: Colors.grey,
                              childrenPadding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              children: [
                                CustomText(
                                    fontWeight: FontWeight.w300,
                                    text:
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                              ],
                            ),*/
                        ],
                      )),
                ],
              ),
            ),
          ));
    });
  }
}
