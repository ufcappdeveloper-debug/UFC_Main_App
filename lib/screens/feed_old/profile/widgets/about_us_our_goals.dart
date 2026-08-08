import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AboutUsOurGoals extends StatelessWidget {
  const AboutUsOurGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Our Goals'.tr(),
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
              "Contribute to maintaining the food security of Saudi Arabia. Increase the productivity of animal production sector. Empower local producers to obtain their needs. Enhance the economics of food industry in Saudi Arabia. Preserve the natural resources of Saudi Arabia."
                  .tr(),
        ),
      ],
    );
  }
}
