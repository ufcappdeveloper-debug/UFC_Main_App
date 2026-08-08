import 'dart:ui' as ui;

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_functions.dart';

// TextSpan countryCodeTextSpan(Currency? currencyData, {bool isOffer = false}) =>
//     TextSpan(
//         text: " ${currencyData?.code ?? 'SAR'}",
//         style: TextStyle(
//             color: Colors.black,
//             // fontFamily: 'Kanit',
//             fontSize: isOffer ? 8 : 10,
//             fontWeight: FontWeight.w300,
//             decoration: isOffer ? TextDecoration.lineThrough : null));

InlineSpan countryCodeTextSpan(Currency? currencyData, {bool isOffer = false}) {
  final isSAR = currencyData?.code == null || currencyData?.code == 'SAR';

  return TextSpan(
    children: [
      isSAR
          ? WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SaudiRiyalIcon(
                size: isOffer ? 8 : 10,
                color: Colors.black,
              ),
            )
          : TextSpan(
              text: " ${currencyData!.code}",
              style: TextStyle(
                color: Colors.black,
                fontSize: isOffer ? 8 : 10,
                fontWeight: FontWeight.w300,
                decoration: isOffer ? TextDecoration.lineThrough : null,
              ),
            ),
    ],
  );
}

Widget addressDetails({required String title, required String value}) =>
    Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(children: [
          SizedBox(
              width: 125,
              child: CustomText(
                  text: title,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(160, 160, 160, 1))),
          CustomText(text: value, fontWeight: FontWeight.w500),
        ]));

// Widget to display Sadad user information
Directionality sadadUserInfoWidget(BuildContext context,
    SadadUserInfo? sadadUserData, BoxConstraints constraints,
    {VoidCallback? onPressed}) {
  return Directionality(
    textDirection: ui.TextDirection.ltr,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: sadadUserData?.customerFullName ?? "User Name",
                fontWeight: FontWeight.w500,
                color: isSadadInfoExist(sadadUserData) ? null : Colors.grey,
              ),
              kHeight10,
              CustomText(
                text: sadadIdNumberFormate(sadadUserData) ?? "ID Number",
                fontWeight: FontWeight.w500,
                color: isSadadInfoExist(sadadUserData) ? null : Colors.grey,
              ),
              kHeight10,
              CustomText(
                text: sadadPhoneFormat(sadadUserData) ?? "Phone Number",
                fontWeight: FontWeight.w500,
                color: isSadadInfoExist(sadadUserData) ? null : Colors.grey,
              ),
            ],
          ),
          TextButton(
            onPressed: onPressed,
            child: CustomText(
              text: sadadUserData == null ? "Add" : "Edit",
              fontWeight: FontWeight.w500,
              color: onPressed == null
                  ? Color.fromARGB(255, 236, 236, 236)
                  : const Color(0xff78B833),
            ),
          )
        ],
      ),
    ),
  );
}

Widget checkoutDetails(
        {String? amount,
        double? totalPrice,
        int? vatPercentage,
        bool showVat = false,
        String? currencyCode,
        required String title,
        String? amountCurrency}) =>
    Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                CustomText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color.fromRGBO(143, 155, 179, 1)),
                if (vatPercentage != null && vatPercentage > 0 && showVat)
                  CustomText(
                      text: " ${"(Including VAT $vatPercentage%)".tr()}",
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFFC7C7C7)),
              ]),
              amount != null
                  ? CustomText(text: amount, fontWeight: FontWeight.w300)
                  : amountCurrency != null
                      ? Text.rich(TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: amountCurrency,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Kanit",
                                  fontWeight: FontWeight.w300)),
                          // TextSpan(
                          //     text: currencyCode,
                          //     style: const TextStyle(
                          //         fontSize: 8,
                          //         fontFamily: 'Kanit',
                          //         fontWeight: FontWeight.w300)),
                          const WidgetSpan(child: SaudiRiyalIcon(size: 8)),
                        ]))
                      : totalPrice != null
                          ? Text.rich(TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text: (totalPrice.isNegative
                                          ? 0.00
                                          : totalPrice)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Kanit",
                                      fontWeight: FontWeight.w500)),
                              // TextSpan(
                              //     text: currencyCode,
                              //     style: const TextStyle(
                              //         fontSize: 8,
                              //         fontFamily: 'Kanit',
                              //         fontWeight: FontWeight.w300)),

                              const WidgetSpan(child: SaudiRiyalIcon(size: 8)),
                            ]))
                          : const SizedBox.shrink(),
            ]));

Container checkoutItem(BuildContext context,
    {int? quantity,
    Currency? currencyData,
    double currencyRate = 1,
    CartItemModel? cartItem,
    ProductModel? productItem}) {
  assert((cartItem != null && productItem == null) ||
      (cartItem == null && productItem != null));
  if (cartItem == null) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Row(
              children: [
                CustomImage(
                  imageUrl: productItem?.images?.first.location,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  noImagePlaceholderWidget: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.11),
                    ),
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: ProductUtils.productName(productItem),
                          ),
                          if (productItem?.variants?.first.originalPrice !=
                              null)
                            Container(
                              width: 45,
                              height: 16,
                              margin:
                                  const EdgeInsetsDirectional.only(start: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color(0xffFF5732),
                                  borderRadius: BorderRadius.circular(3)),
                              child: CustomText(
                                text:
                                    '${getDiscountPercentage(((productItem?.variants?.first.price ?? 0.0) * currencyRate), ((productItem?.variants?.first.originalPrice ?? 0.0) * currencyRate))}% ${"Off".tr()}',
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                      CustomText(
                        text: ProductUtils.productDescription(productItem)??'',
                        maxLines: 2,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.w300,
                      ),
                      kHeight10,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text.rich(TextSpan(children: <InlineSpan>[
              TextSpan(
                text: productItem?.variants == null ||
                        productItem!.variants!.isEmpty ||
                        productItem.variants?.first.price == null
                    ? "0.00"
                    : ((productItem.variants?.first.price ?? 0.00) *
                            currencyRate)
                        .toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              countryCodeTextSpan(currencyData),
              if (productItem?.variants?.first.originalPrice != null)
                TextSpan(
                    text:
                        "\n${((productItem?.variants?.first.originalPrice ?? 0.0) * currencyRate).toStringAsFixed(1)}",
                    style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "Kanit",
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough)),
              if (productItem?.variants?.first.originalPrice != null)
                countryCodeTextSpan(currencyData, isOffer: true),
            ])),
            CustomText(
                text: "${"Qty".tr()} ${(quantity ?? 0).toString()}",
                fontSize: 14,
                color: const Color.fromRGBO(207, 207, 207, 1)),
          ]),
        ]));
  } else {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Row(children: [
            CustomImage(
              imageUrl: cartItem.variant?.product?.images?[0].location,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              noImagePlaceholderWidget: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withValues(alpha: 0.11),
                ),
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    CustomText(
                        text: (isEnglish
                                ? cartItem.variant?.product?.nameEn
                                : isArabic
                                    ? cartItem.variant?.product?.nameAr
                                    : cartItem.variant?.product?.nameUr) ??
                            ""),
                    if (cartItem.variant?.originalPrice != null)
                      Container(
                          width: 45,
                          height: 16,
                          margin: const EdgeInsetsDirectional.only(start: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xffFF5732),
                              borderRadius: BorderRadius.circular(3)),
                          child: CustomText(
                              text:
                                  '${getDiscountPercentage(((cartItem.variant?.price ?? 0.0) * currencyRate), ((cartItem.variant?.originalPrice ?? 0.0) * currencyRate))}% ${"Off".tr()}',
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                  ]),
                  CustomText(
                      text: (isEnglish
                              ? cartItem.variant?.product?.descriptionEn
                              : isArabic
                                  ? cartItem.variant?.product?.descriptionAr
                                  : cartItem.variant?.product?.descriptionUr) ??
                          "",
                      maxLines: 2,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      overflow: TextOverflow.clip),
                  const SizedBox(height: 10),
                ])),
          ])),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text.rich(
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                      text: cartItem.variant?.price == null
                          ? "0.00"
                          : ((cartItem.variant?.price ?? 0.00) * currencyRate)
                              .toStringAsFixed(2),
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  countryCodeTextSpan(currencyData),
                  if (cartItem.variant?.originalPrice != null)
                    TextSpan(
                        text:
                            "\n${((cartItem.variant?.originalPrice ?? 0.0) * currencyRate).toStringAsFixed(1)}",
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Kanit",
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough)),
                  if (cartItem.variant?.originalPrice != null)
                    countryCodeTextSpan(currencyData, isOffer: true),
                ]),
                textAlign: TextAlign.end),
            CustomText(
                text: "${"Qty".tr()} ${cartItem.quantity.toString()}",
                fontSize: 14,
                color: const Color.fromRGBO(207, 207, 207, 1)),
          ]),
        ]));
  }
}
