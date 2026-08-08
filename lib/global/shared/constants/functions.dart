import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

Size size(BuildContext context) => MediaQuery.of(context).size;

String getDiscountPercentage(final double price, final double originalPrice) {
  if (originalPrice == 0) return '0.0';
  return (((originalPrice - price) / originalPrice) * 100).toStringAsFixed(1);
}

String hideUserName(String name) {
  if (name.length > 6) {
    return name.replaceRange(4, name.length, '*' * (name.length - 1));
  } else if (name.length > 1 && name.length <= 6) {
    return name.replaceRange(1, name.length, '*' * (name.length - 1));
  } else {
    return name.replaceRange(0, name.length, '*');
  }
}

String? phoneFormat(UserModel? data, {bool withoutCode = false}) {
  if (data == null ||
      data.phone == null ||
      data.phone?.countryCode == null ||
      data.phone!.countryCode!.isEmpty ||
      data.phone?.phoneNumber == null ||
      data.phone!.phoneNumber!.isEmpty) {
    return null;
  }

  final phone = data.phone?.phoneNumber?.replaceAllMapped(
      RegExp(r'^(\d{2})(\d{3})(\d{4})$'),
      (match) => '${match[1]} ${match[2]} ${match[3]}');

  return "${data.phone?.countryCode} $phone";
}
