import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AboutUsOurMission extends StatelessWidget {
  const AboutUsOurMission({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Our Mission'.tr(),
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
      childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      children: [
        CustomText(
          text:
              "Is to build an integrated and sustainable system that aims to guarantee food security while also being able to adapt to continuous changes, maintain the excellence of our brand and product quality, and continue to earn our customers’ trust through commitment, trust, and responsibility."
                  .tr(),
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
