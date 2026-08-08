import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'custom_widgets/custom_text.dart';

class WillPopScopeWidget extends StatelessWidget {
  final Widget child;
  const WillPopScopeWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: child,
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    // This dialog will exit your app on saying yes
    final value = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: CustomText(
          text: 'Are you sure?',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        content: CustomText(text: 'Do you wish to exit the app?'),
        contentPadding:
            const EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 20),
        titlePadding:
            const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 0),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: CustomText(
              text: "No".tr(),
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              backgroundColor: Colors.white,
            ),
            child: CustomText(
              text: "Yes".tr(),
              fontSize: 14,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
    return value ?? false;
  }
}
