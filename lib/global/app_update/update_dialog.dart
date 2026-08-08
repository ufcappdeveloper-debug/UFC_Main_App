import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_update.dart';

class UpdateDialog extends StatelessWidget {
  final bool mandatory;
  const UpdateDialog({super.key, required this.mandatory});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          "New version available".tr(),
          style: const TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w700),
        ),
        content: Text(
          mandatory
              ? "please update your application. otherwise you will not be able to use the app"
                  .tr()
              : "Would you like to update your application?".tr(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        actions: [
          mandatory
              ? const SizedBox.shrink()
              : TextButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.redAccent)),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'UPDATE LATER'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(primaryColor)),
            onPressed: () => launchUrl(Uri.parse(AppUpdate.storeUrl ?? ''),
                mode: LaunchMode.externalApplication),
            child: Text(
              "UPDATE".tr(),
              style: const TextStyle(color: Colors.white),
            ),
          )
        ]);
  }
}
