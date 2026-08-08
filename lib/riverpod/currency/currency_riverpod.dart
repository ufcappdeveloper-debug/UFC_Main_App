import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_currency_converter.dart';

class CurrencyNotifier extends ChangeNotifier {
  Currency? selectedCurrency;
  double? selectedCurrencyRate;

  Future<void> changeSelectedCurrency(final Currency? data) async {
    selectedCurrency = data;
    // Note: Please ensure that both the 'from' and 'to' strings are in lowercase
    selectedCurrencyRate = data == null
        ? null
        : data.code.toLowerCase() == "sar"
            ? 1
            : await CustomCurrencyConverter.convert(
                from: "sar",
                to: data.code.toLowerCase(),
                amount: 1,
              );
    notifyListeners();
  }
}

final currencyProvider = ChangeNotifierProvider<CurrencyNotifier>((ref) {
  return CurrencyNotifier();
});
