import 'package:flutter/material.dart';

import '../shared/constants/app_colors.dart';
import '../shared/widgets/custom_widgets/custom_text.dart';

Future<bool> onWillPop(BuildContext context) async {
  // This dialog will exit your app on saying yes
  final value = await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: CustomText(text: 'Are you sure?'),
      content: CustomText(text: 'Do you want to exit an App'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: CustomText(
            text: 'No',
            color: primaryColor,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: CustomText(text: 'Yes', color: primaryColor),
        ),
      ],
    ),
  );
  return value ?? false;
}
