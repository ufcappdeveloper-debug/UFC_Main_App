import 'package:flutter/services.dart';

final digitsOnly = FilteringTextInputFormatter.digitsOnly;
final denySpecialCharacters =
    FilteringTextInputFormatter.deny(RegExp(r'[^\p{L}\p{N}\s]', unicode: true));
final denyDigits = FilteringTextInputFormatter.deny(RegExp(r'\d'));
final denyEmptySpace = FilteringTextInputFormatter.deny(RegExp(r'\s'));
final allowWholeNumbersOnly = FilteringTextInputFormatter.allow(
  RegExp(r'[0-9٠-٩۰-۹]'), // English, Arabic, and Urdu digits only
);