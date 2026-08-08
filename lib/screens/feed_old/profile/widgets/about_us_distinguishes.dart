import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AboutUsDistinguishes extends StatelessWidget {
  const AboutUsDistinguishes({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment:
          (isArOrUr) ? Alignment.centerRight : Alignment.centerLeft,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'What Distinguishes Us?'.tr(),
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
              "${"• Leader in the Market".tr()}\n${"• Largest Storage capacity in Saudi Arabia".tr()}\n${"• Supports Food Security in Saudi Arabia".tr()}\n${"• Available in 7 stations".tr()}\n${"• ERP and advanced formulation systems".tr()}\n${"• Imported products from best farms".tr()}\n${"• Fast services".tr()}\n${"• Stable prices".tr()}\n${"• Close to customers".tr()}\n${"• Well Experienced team in all levels".tr()}",
        ),
      ],
    );
  }
}
