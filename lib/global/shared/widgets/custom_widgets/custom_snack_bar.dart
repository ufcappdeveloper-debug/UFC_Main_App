import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';

class CustomSnackBar {
  static void show(BuildContext context, String title,
      {Color? backgroundColor,
      Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 1,
        content: Text(title.tr()),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static void message(BuildContext context, String title) {
    show(context, title, duration: const Duration(seconds: 5));
  }

  static void success(BuildContext context, String title) {
    show(context, title, backgroundColor: Colors.green);
  }

  static void error(BuildContext context, String title) {
    show(context, title,
        backgroundColor: Colors.red, duration: const Duration(seconds: 7));
  }

  static void richError(BuildContext context, String message) {
    final parts = message.split('{currency}');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white),
            children: [
              TextSpan(text: parts[0]),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SaudiRiyalIcon(size: 14, color: Colors.white),
              ),
              TextSpan(text: parts.length > 1 ? parts[1] : ''),
            ],
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
