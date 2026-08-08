import 'package:flutter/services.dart';

class SaudiPhoneFormatter extends TextInputFormatter {
  final String prefix = '+966 ';
  final int maxLength = 9;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.isEmpty && oldValue.text.isEmpty) {
      return newValue;
    }

    bool hasPrefix = text.startsWith(prefix);
    String afterPrefix;

    bool prefixAddedNow = false;

    if (hasPrefix) {
      afterPrefix = text.substring(prefix.length);
    } else {
      if (oldValue.text.isEmpty) {
        afterPrefix = text;
        text = prefix + afterPrefix;
        hasPrefix = true;
        prefixAddedNow = true;
      } else {
        afterPrefix = text;
      }
    }

    // Remove non-digit characters
    afterPrefix = afterPrefix.replaceAll(RegExp(r'[^0-9]'), '');

    // ✅ Force first digit to be 5 if not empty
    if (afterPrefix.isNotEmpty && afterPrefix[0] != '5') {
      afterPrefix = '5${afterPrefix.substring(1)}';
    }

    // Limit to maxLength digits
    if (afterPrefix.length > maxLength) {
      afterPrefix = afterPrefix.substring(0, maxLength);
    }

    final formatted = hasPrefix ? prefix + afterPrefix : afterPrefix;

    int offset = newValue.selection.baseOffset;

    if (prefixAddedNow) {
      offset = formatted.length;
    } else {
      if (hasPrefix && offset < prefix.length) {
        offset = prefix.length;
      }
      if (offset > formatted.length) {
        offset = formatted.length;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
