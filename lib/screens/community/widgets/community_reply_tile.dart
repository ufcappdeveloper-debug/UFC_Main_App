import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CommunityReplyTile extends StatelessWidget {
  const CommunityReplyTile({
    super.key,
    this.senderName,
    this.message,
    required this.onTap,
  });

  final String? senderName;
  final String? message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: ksymmetric(0, 5),
          child: Row(
            children: [
              kWidth50,
              kWidth5,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Sender Name
                    CustomText(
                      text: senderName ?? '-',
                      // fontFamily: 'Graphik Arabic',
                      fontFamily: isEnglish
                          ? AppFontsFamily.english
                          : AppFontsFamily.arabic,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: textGrey,
                    ),
                    kHeight5,

                    /// Msg replying for
                    CustomText(
                      text: message ?? '',
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      // fontFamily: 'Graphik Arabic',
                      fontFamily: isEnglish
                          ? AppFontsFamily.english
                          : AppFontsFamily.arabic,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
