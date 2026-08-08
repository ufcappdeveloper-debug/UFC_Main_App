import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AboutUsOurValue extends StatelessWidget {
  const AboutUsOurValue({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Our Values'.tr(),
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
      childrenPadding:
          const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 15,
          children: ourValueDataList
              .map(
                (data) => AboutUsOurValueContainer(ourValueData: data),
              )
              .toList(),
        ),
      ],
    );
  }
}

class AboutUsOurValueContainer extends StatelessWidget {
  const AboutUsOurValueContainer({
    super.key,
    required this.ourValueData,
  });
  final Map<String, dynamic> ourValueData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 220,
      padding: const EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 0),
              color: const Color(0xFF0176bb).withValues(alpha: 0.1)),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1875b6),
            ),
            child: Image.asset(
              ourValueData["icon"],
              color: const Color(0xFFfec95a),
            ),
          ),
          kHeight15,
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: "${ourValueData["bold_text"]}".tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "${ourValueData["text"]}".tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> ourValueDataList = [
  {
    "icon": "assets/images/support/about_us_img_1.png",
    "bold_text": "Quality and Authenticity",
    "text":
        " a constant, uncompromising essence with the passage of time and data differences.",
  },
  {
    "icon": "assets/images/support/about_us_img_2.png",
    "bold_text": "Integrity",
    "text":
        " is the foundation and the bedrock upon which everything else is built.",
  },
  {
    "icon": "assets/images/support/about_us_img_3.png",
    "bold_text": "Teamwork",
    "text": " the fastest and most successful way to achieve the goal.",
  },
  {
    "icon": "assets/images/support/about_us_img_4.png",
    "bold_text": "Commitment",
    "text":
        " is the effort, the quality of performance and the fulﬁllment of the promise.",
  },
  {
    "icon": "assets/images/support/about_us_img_5.png",
    "bold_text": "Building strong relationships",
    "text": " a sail of trust that leads us to the meaning of life.",
  },
  {
    "icon": "assets/images/support/about_us_img_6.png",
    "bold_text": "Promoting a sense of healthy living",
    "text": " the most important principle, purpose and destination.",
  },
];
