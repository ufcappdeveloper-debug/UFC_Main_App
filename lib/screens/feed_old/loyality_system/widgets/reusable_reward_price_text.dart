import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class ReusableRewardPriceText extends StatelessWidget {
  final String originalPrice;
  final String discountedPrice;
  final bool isBig;
  final bool isInCartList;

  const ReusableRewardPriceText(
      {super.key,
      this.isBig = true,
      this.isInCartList = false,
      required this.originalPrice,
      required this.discountedPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: isInCartList ? originalPrice : discountedPrice,
                    style: isBig
                        ? LoyalityPointsFontstyles.lpTierNumberTextStyle
                            .copyWith(
                                color:
                                    LoyalityPointsColors.lpSubHeadingTextColor)
                        : LoyalityPointsFontstyles.rewardProductOgPriceTextStyle
                            .copyWith(
                            color: LoyalityPointsColors.lpSubHeadingTextColor,
                          ),
                  ),
                  // TextSpan(
                  //   text: ' SAR',
                  //   style:
                  //       LoyalityPointsFontstyles.lpTierDescTextStyle.copyWith(
                  //     color: LoyalityPointsColors.lpSubHeadingTextColor,
                  //   ),
                  // ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: SaudiRiyalIcon(
                      size: LoyalityPointsFontstyles
                              .lpTierDescTextStyle.fontSize ??
                          14,
                      color: LoyalityPointsColors.lpSubHeadingTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF5732),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: CustomText(
                    text: '100% OFF',
                    fontSize: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isInCartList ? discountedPrice : originalPrice,
                        style: LoyalityPointsFontstyles
                            .lpProductOgPriceTextStyle
                            .copyWith(
                          color: LoyalityPointsColors.lpSubHeadingTextColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      // TextSpan(
                      //   text: ' SAR',
                      //   style: LoyalityPointsFontstyles.lpTierDescTextStyle
                      //       .copyWith(
                      //     color: LoyalityPointsColors.lpSubHeadingTextColor,
                      //   ),
                      // ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SaudiRiyalIcon(
                          size: LoyalityPointsFontstyles
                                  .lpTierDescTextStyle.fontSize ??
                              14,
                          color: LoyalityPointsColors.lpSubHeadingTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
