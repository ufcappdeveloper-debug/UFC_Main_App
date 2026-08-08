import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';

Future<void> rewardAddToCartButtonAction(BuildContext context,
    {required VoidCallback onButtonPressed,
    required bool isSuccessful,
    String? remainingPoints}) {
  return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return SizedBox(
          height: 280,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              if (!isSuccessful)
                Container(
                  width: 124,
                  height: 83,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image:
                          AssetImage('assets/images/loyality_points/oops.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (isSuccessful)
                Container(
                  width: 124,
                  height: 83,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/images/loyality_points/success_check.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              if (!isSuccessful)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sorry, you need'.tr(),
                              style: LoyalityPointsFontstyles
                                  .lpSubHeadingTextStyle
                                  .copyWith(
                                color:
                                    LoyalityPointsColors.lpSubHeadingTextColor,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' ${NumberFormat.decimalPattern('en').format(int.tryParse(remainingPoints ?? '0') ?? 0)} ${'points'.tr()}',
                              style: LoyalityPointsFontstyles
                                  .lpSubHeadingTextStyle
                                  .copyWith(
                                      color: LoyalityPointsColors
                                          .lpCurrentPointsTextColor),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'to be eligible for the claim'.tr(),
                        style: LoyalityPointsFontstyles.lpSubHeadingTextStyle
                            .copyWith(
                                color:
                                    LoyalityPointsColors.lpSubHeadingTextColor),
                      ),
                    ]),
              if (isSuccessful)
                Text(
                  '${'Added to cart'.tr()}!',
                  style:
                      LoyalityPointsFontstyles.lpSubHeadingTextStyle.copyWith(
                    color: LoyalityPointsColors.lpSubHeadingTextColor,
                  ),
                ),
              if (isSuccessful) const SizedBox(height: 20),
              const SizedBox(height: 20),
              InkWell(
                onTap: onButtonPressed,
                splashColor: Colors.green[300],
                borderRadius: BorderRadius.circular(9.0),
                child: Ink(
                  height: 42,
                  width: 260,
                  decoration: BoxDecoration(
                    color: const Color(0xff78B833),
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Center(
                    child: Text(
                      isSuccessful ? 'VIEW MY CART'.tr() : 'GO BACK'.tr(),
                      style: LoyalityPointsFontstyles.bottomSheetButtonTextStyle
                          .copyWith(
                              color: LoyalityPointsColors.lpMainTitleTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
