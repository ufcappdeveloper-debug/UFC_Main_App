import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/enum/delivery_option.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class FeedDeliveryWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final String icon;
  final double? height;
  final double? width;
  final String title;

  final Widget? iconwidget;

  final DeliveryOptionsEnum selectedDevliveryOption;

  const FeedDeliveryWidget({
    super.key,
    this.isSelected = false,
    this.onTap,
    required this.icon,
    required this.selectedDevliveryOption,
    this.height,
    this.width,
    required this.title,
    this.iconwidget,
  });

  @override
  Widget build(BuildContext context) {
    final isWideLess = ScreenWidthUtils.isWideLess(context);
    final isSmall = ScreenWidthUtils.isSmall(context);
    final isMiddle = ScreenWidthUtils.isMiddle(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 81,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedDevliveryOption == DeliveryOptionsEnum.pickup
                  ? primaryColor.withAlpha(40)
                  : selectedDevliveryOption == DeliveryOptionsEnum.delivery
                      ? yellowColor.withAlpha(25)
                      : Colors.white)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? (selectedDevliveryOption == DeliveryOptionsEnum.pickup
                    ? PetVeterinaryColors.mainColorUFC
                    : selectedDevliveryOption == DeliveryOptionsEnum.delivery
                        ? yellowColor
                        : Colors.grey.shade300)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isArOrUr ? 0 : math.pi),
              child: SvgPicture.asset(icon,
                  width: width ?? 39,
                  height: width ?? 39,
                  colorFilter: isSelected
                      ? (selectedDevliveryOption == DeliveryOptionsEnum.pickup
                          ? svgGreenColor
                          : selectedDevliveryOption ==
                                  DeliveryOptionsEnum.delivery
                              ? svgYellowColor2
                              : svgBlackColor)
                      : svgBlackColor),
            ),
            if (title == 'Delivery'.tr())
              SizedBox(
                width: 8,
              ),
            if (title == 'Pickup from\nStation'.tr())
              SizedBox(
                width: 12,
              ),
            Flexible(
              // fit: FlexFit.loose,
              child: CustomText(
                text: title,
                fontSize: (title == 'Pickup from\nStation'.tr() && isSmall)
                    ? 11
                    : (title == 'Pickup from\nStation'.tr() && isMiddle)
                        ? 12
                        : (title == 'Pickup from\nStation'.tr() && isWideLess)
                            ? 13
                            : 14,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
