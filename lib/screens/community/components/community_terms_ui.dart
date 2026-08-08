import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_style.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/community/pages/rules.dart';

class CommunityTermsAndConditionScreen extends StatefulWidget {
  const CommunityTermsAndConditionScreen({super.key});

  @override
  State<CommunityTermsAndConditionScreen> createState() =>
      _CommunityTermsAndConditionScreenState();
}

class _CommunityTermsAndConditionScreenState
    extends State<CommunityTermsAndConditionScreen> {
  bool agreed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Center(
            child: CustomText(
              text: "Please Confirm!".tr(),
              textStyle: AppFontStyle.getRegularStyle(
                fontSize: 18,
                color: Colors.black,
                weight: FontWeight.bold,
              ),
            ),
          ),
          kHeight20,

          /// Link to read terms
          Center(
            child: CustomText(
              text:
                  "Please agree to the Terms & Conditions to continue chatting",
              textStyle: AppFontStyle.getRegularStyle(
                fontSize: 13,
                color: textGrey,
              ),
            ),
          ),
          kHeight20,

          /// Checkbox
          Row(
            children: [
              Checkbox(
                value: agreed,
                activeColor: AppColors.purpleColor,
                onChanged: (v) {
                  setState(() => agreed = v ?? false);
                },
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Navigate to full Terms & Conditions page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Rules(),
                      ),
                    );
                  },
                  child: CustomText(
                    text: "I agree to the Terms & Conditions",
                    textStyle: AppFontStyle.getRegularStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          kHeight20,

          /// Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: CustomText(
                    text: "Cancel",
                    fontSize: 15,
                  ),
                ),
              ),
              kWidth10,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: agreed
                      ? () {
                          Navigator.pop(context, true);
                        }
                      : null, // disabled until checked
                  child: CustomText(
                    text: "confirm",
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          kHeight20,
        ],
      ),
    );
  }
}
