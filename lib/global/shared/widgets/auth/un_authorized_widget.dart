import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class UnAuthorizedWidget extends StatelessWidget {
  const UnAuthorizedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            color: Colors.redAccent,
            size: 48,
          ),
          const SizedBox(height: 16),
          CustomText(text:
            'Access Denied'.tr(),
            textAlign: TextAlign.center,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
          ),
          const SizedBox(height: 8),
          CustomText(text: 
            'You are not authorized.\nPlease sign in to continue.'.tr(),
            textAlign: TextAlign.center,
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic
        
          ),
        ],
      ),
    );
  }
}
