import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class PriceLabel extends StatelessWidget {
  final int qty;
  final double unitPrice;
  final bool isArOrUr;
  final bool isWide;

  const PriceLabel({
    super.key,
    required this.qty,
    required this.unitPrice,
    required this.isArOrUr,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArOrUr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              children: isArOrUr
                  ? [
                      // Arabic RTL layout
                      TextSpan(
                        text: '$qty ${qty > 1 ? 'Bags'.tr() : 'Bag'.tr()} X   ',
                        style: TextStyle(
                          fontSize: isWide ? 14 : 13,
                          fontWeight: FontWeight.w300,
                          color: PetVeterinaryColors.darkGray,
                        ),
                      ),
                      WidgetSpan(
                        child: SaudiRiyalIcon(
                          size: 13,
                          color: PetVeterinaryColors.darkGray,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          unitPrice.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: isWide ? 15 : 14,
                            fontWeight: FontWeight.w400,
                            color: PetVeterinaryColors.darkGray,
                          ),
                          textDirection: ui.TextDirection.ltr,
                        ),
                      ),
                    ]
                  : [
                      // English LTR layout
                      TextSpan(
                        text: '$qty ${qty > 1 ? 'Bags'.tr() : 'Bag'.tr()} X   ',
                        style: TextStyle(
                          fontSize: isWide ? 14 : 13,
                          fontWeight: FontWeight.w300,
                          color: PetVeterinaryColors.darkGray,
                        ),
                      ),
                      TextSpan(
                        text: unitPrice.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: isWide ? 15 : 14,
                          fontWeight: FontWeight.w400,
                          color: PetVeterinaryColors.darkGray,
                        ),
                      ),
                    ],
            ),
          ),
          if (!isArOrUr)
            SaudiRiyalIcon(
              size: isWide ? 14 : 13,
              color: PetVeterinaryColors.darkGray,
            ),
        ],
      ),
    );
  }
}
