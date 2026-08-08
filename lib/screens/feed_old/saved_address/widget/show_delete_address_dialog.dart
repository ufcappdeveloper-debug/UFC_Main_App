import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Future<bool> showDeleteAddressDialog({
  required BuildContext context,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.delete_forever, color: Colors.red),
          const SizedBox(width: 8),
          CustomText(
            text: 'Delete Address',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ],
      ),
      content: CustomText(
        text: 'Are you sure you want to permanently delete this address?',
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      titlePadding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
      actionsPadding: const EdgeInsets.only(right: 25, bottom: 10, left: 25),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
          ),
          child: CustomText(
            text: "Cancel".tr(),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
          child: CustomText(
            text: "Delete".tr(),
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
