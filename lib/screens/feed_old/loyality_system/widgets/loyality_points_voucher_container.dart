import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/custom_loyality_points_button.dart';

class LoyalityPointsVoucherContainer extends StatefulWidget {
  const LoyalityPointsVoucherContainer(
      {super.key,
      required this.voucherCode,
      required this.expiryDate,
      required this.amount,
      required this.onClaim,
      required this.isClaimed,
      required this.discountType
      // Add the isClaimed parameter
      });

  final String voucherCode;
  final String expiryDate;
  final String amount;
  final VoidCallback onClaim;
  final bool isClaimed;
  final String discountType;
  // Boolean to determine if voucher is claimed

  @override
  _LoyalityPointsVoucherContainerState createState() =>
      _LoyalityPointsVoucherContainerState();
}

class _LoyalityPointsVoucherContainerState
    extends State<LoyalityPointsVoucherContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 171,
      height: 150,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.voucherCode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: LoyalityPointsFontstyles
                              .lpProductTitleTextStyle
                              .copyWith(
                                  color: LoyalityPointsColors
                                      .lpSubHeadingTextColor)),
                      const SizedBox(height: 5),
                      // Text(
                      //     '${'Discount'.tr()}: ${widget.amount} ${(widget.discountType == 'fixed') ? "SAR" : '%'}',
                      //     maxLines: 2,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: LoyalityPointsFontstyles.lpProductDescTextStyle
                      //         .copyWith(
                      //             color: LoyalityPointsColors
                      //                 .lpProductDescTextColor)),
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: LoyalityPointsFontstyles.lpProductDescTextStyle
                              .copyWith(
                            color: LoyalityPointsColors.lpProductDescTextColor,
                          ),
                          children: [
                            TextSpan(
                                text: '${'Discount'.tr()}: ${widget.amount} '),
                            widget.discountType == 'fixed'
                                ? WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SaudiRiyalIcon(
                                      size: LoyalityPointsFontstyles
                                              .lpProductDescTextStyle
                                              .fontSize ??
                                          14,
                                      color: LoyalityPointsColors
                                          .lpProductDescTextColor,
                                    ),
                                  )
                                : const TextSpan(text: '%'),
                          ],
                        ),
                      ),

                      Text('${'Expiry date'.tr()}: ${widget.expiryDate}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: LoyalityPointsFontstyles.lpProductDescTextStyle
                              .copyWith(
                                  color: LoyalityPointsColors
                                      .lpProductDescTextColor)),
                    ],
                  ),
                ),
                CustomLoyalityPointsButton(
                  text: widget.isClaimed
                      ? 'UNCLAIM'.tr()
                      : 'CLAIM'.tr(), // Change text based on isClaimed
                  backgroundColor: widget.isClaimed
                      ? Colors.grey // Red background for unclaim
                      : LoyalityPointsColors
                          .lpCurrentPointsTextColor, // Original background for claim
                  textStyle: LoyalityPointsFontstyles.rewardScreenBtnTextStyle
                      .copyWith(color: Colors.white),
                  onTap: widget.onClaim,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
