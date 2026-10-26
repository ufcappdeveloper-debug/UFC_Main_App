import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_widgets/custom_snack_bar.dart';

/// Read-only, selectable value with a copy button.
/// Copies [copyValue] (or [value]) only, never the label.
class CopyableField extends StatelessWidget {
  final String label;
  final String value;
  final String? copyValue;
  final bool copyable;
  final Widget? trailingValue;

  const CopyableField({
    super.key,
    required this.label,
    required this.value,
    this.copyValue,
    this.copyable = true,
    this.trailingValue,
  });

  static const _green = Color(0xff78B833);

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: copyValue ?? value));
    if (context.mounted) {
      CustomSnackBar.show(context, 'Copied',
          backgroundColor: const Color(0xFF4D4D4D));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.tr(),
              style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF44444F))),
          const SizedBox(height: 4),
          Container(
            height: 46,
            padding: const EdgeInsetsDirectional.only(start: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFCFCFCF)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: trailingValue ??
                      SelectableText(
                        value,
                        maxLines: 1,
                        style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 13,
                            color: Color(0xDE000000)),
                      ),
                ),
                if (copyable)
                  IconButton(
                    tooltip: 'Copy'.tr(),
                    onPressed: () => _copy(context),
                    icon: const Icon(Icons.copy_rounded,
                        size: 18, color: _green),
                  )
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
