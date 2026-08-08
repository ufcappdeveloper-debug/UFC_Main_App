import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Widget checkoutDetails({
  required String title,
  String? subtitle,
  String? amount,
  String? amountCurrency,
  String? totalPrice,
  FontWeight? fontWeight,
  Color? priceColor,
  bool? currency = true,
  double? fontSize,
  double? titleFontSize,
  double? amountFontSize,
  double? statusSize,
  Color? statusColor,
  Color? titleColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: RichText(
            maxLines: 1,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
                fontSize: titleFontSize ?? 14,
                overflow: TextOverflow.ellipsis,
                color: titleColor ?? const Color.fromRGBO(143, 155, 179, 1),
              ),
              children: [
                TextSpan(text: title.tr()),
                if (subtitle != null) TextSpan(text: subtitle.tr()),
              ],
            ),
          ),
        ),
        amount != null
            ? CustomText(
                text: amount,
                fontSize: statusSize ?? 14,
                fontWeight: fontWeight ?? FontWeight.w300,
                color: statusColor)
            : amountCurrency != null
                ? Text.rich(TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: amountCurrency,
                        style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: fontWeight ?? FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                      if (currency == true)
                        //  TextSpan(
                        //   text: ' SAR',

                        //   style: TextStyle(
                        //       fontSize: 10,
                        //       fontFamily: 'Kanit',
                        //       fontWeight: FontWeight.w300),
                        // ),
                        WidgetSpan(
                          child: SaudiRiyalIcon(
                            size: 10,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'SaudiRiyal',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                    ],
                  ))
                : totalPrice != null
                    ? Text.rich(TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: totalPrice,
                            style: TextStyle(
                                color: priceColor,
                                fontFamily: "Kanit",
                                fontWeight: fontWeight ?? FontWeight.w500,
                                fontSize: fontSize ?? 18),
                          ),
                          if (currency == true)
                            // TextSpan(
                            //   text: ' SAR',
                            //   style: TextStyle(
                            //       fontSize: 10,
                            //       fontFamily: 'Kanit',
                            //       fontWeight: FontWeight.w300,
                            //       color: priceColor),
                            // ),
                            WidgetSpan(
                              child: SaudiRiyalIcon(
                                size: 10,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'SaudiRiyal',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                        ],
                      ))
                    : const SizedBox.shrink(),
      ],
    ),
  );
}
