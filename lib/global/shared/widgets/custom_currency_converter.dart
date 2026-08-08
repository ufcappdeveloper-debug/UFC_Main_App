library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ufc_mobile/global/shared/widgets/currency_api_service.dart';

/// [CurrencyConverter] Convert currency from one currency to another currency
/// [convert] It will call the api to server and get the latest currency rate and return the amount
/// [getMyCurrency] this function will return the your local currency.

class CustomCurrencyConverter {
  static Future<double?> convert({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      String url = "${CurrencyApiService.ENDPOINT}$from.json";
      double value = 0.0;

      /// get the latest currency rate
      Response? resp = (await CurrencyApiService.getConvertedAmount(url));
      if (resp != null) {
        double unitValue =
            double.parse(jsonDecode(resp.body)[from][to].toString());
        value = amount * unitValue;
      }
      return double.parse(value.toStringAsFixed(2));
    } catch (err) {
      if (kDebugMode) {
        print("convert err $err");
      }
      return 1.0;
    }
  }
}
