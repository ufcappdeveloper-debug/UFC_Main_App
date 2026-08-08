import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AboutUsOurVision extends StatelessWidget {
  const AboutUsOurVision({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Our Vision'.tr(),
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
              "Is to set new standards and develop innovative ideas to redeﬁne quality and excellence in the barley and feed trade to always remain the ﬁrst choice locally and globally."
                  .tr(),
        ),
      ],
    );
  }
}
