import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AboutUsOurServices extends StatelessWidget {
  const AboutUsOurServices({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment:
          (isArOrUr) ? Alignment.centerRight : Alignment.centerLeft,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Our Services'.tr(),
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
          fontWeight: FontWeight.w300,
          text:
              "${"• Redesigning Formulas".tr()}\n${"• Storage".tr()}\n${"• Logistic".tr()}\n${"• Feeds (Including Complete Feeds)".tr()}\n${"• Animal Feed Raw Materials".tr()}",
        ),
      ],
    );
  }
}
