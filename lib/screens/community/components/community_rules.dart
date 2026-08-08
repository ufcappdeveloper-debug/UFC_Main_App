import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/screens/community/pages/rules.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CommunityRulesComponent extends ConsumerStatefulWidget {
  const CommunityRulesComponent({super.key});

  @override
  ConsumerState<CommunityRulesComponent> createState() =>
      _CommunityRulesComponentState();
}

class _CommunityRulesComponentState
    extends ConsumerState<CommunityRulesComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: communityRuleBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kHeight10,
          CustomText(
            text: "Welcome to the Farmers' Community!".tr(),
            color: Colors.black,
            fontWeight: FontWeight.w600,
            // fontFamily: 'Graphik Arabic',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontSize: 16,
          ),
          kHeight10,

          ///* Hiding as per the issue raised on #1417
          Visibility(
            visible: false,
            child: CustomText(
              text: subTitle,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              // fontFamily: 'Graphik Arabic',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              fontSize: 14,
            ),
          ),
          kHeight10,

          ///* Read rule button
          GestureDetector(
            onTap: () {
              // Navigating to rules page
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => Rules()),
              );
            },
            child: CustomText(
              text: "Read the rules".tr(),
              // fontFamily: 'Graphik Arabic',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              color: Color(0xff9D4EDD),
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              height: 1,
              fontSize: 16,
            ),
          ),
          kHeight10,
        ],
      ),
    );
  }

  String get subTitle {
    return "We're glad to have you with us. This is your space to connect, share experiences, and grow together. Whether you're experienced or just starting your agricultural journey, you'll find support, knowledge, and inspiration from fellow members here."
        .tr();
  }

  BoxDecoration communityRuleBoxDecoration() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          blurRadius: 10,
          color: Colors.black.withValues(alpha: 0.1),
        )
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      color: Colors.white,
    );
  }
}
