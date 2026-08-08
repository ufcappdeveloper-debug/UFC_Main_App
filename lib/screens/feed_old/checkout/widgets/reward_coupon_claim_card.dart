// import 'package:flutter/material.dart';
// import 'package:dotted_decoration/dotted_decoration.dart';
// import 'package:ufc_mobile/screens/loyality_system/extensions/loyality_points_colors.dart';
// import 'package:ufc_mobile/screens/loyality_system/extensions/loyality_points_fontstyles.dart';

// Widget rewardCouponClaimCardWidget({
//   required String couponAmount,
// }) {
//   return Container(
//       width: 370,
//       height: 56,
//       decoration: DottedDecoration(
//           shape: Shape.box,
//           borderRadius: BorderRadius.circular(20),
//           color: LoyalityPointsColors.lpTierMessageBoxBgColor),
//       padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Voucher',
//                     style: LoyalityPointsFontstyles.rewardVoucherTitleTextStyle
//                         .copyWith(
//                             color:
//                                 LoyalityPointsColors.lpTierMessageBoxBgColor)),
//                 const SizedBox(
//                   height: 3,
//                 ),
//                 Text(couponAmount,
//                     style: LoyalityPointsFontstyles.rewardVoucherAmountTextStyle
//                         .copyWith(
//                       color: LoyalityPointsColors.lpTierMessageBoxBgColor,
//                     ))
//               ],
//             ),
//             Center(
//               child: Text('Get now',
//                   style: LoyalityPointsFontstyles.rewardVoucherBtnTextStyle
//                       .copyWith(
//                           color: LoyalityPointsColors.lpTierMessageBoxBgColor)),
//             ),
//           ]));
// }

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';

Widget rewardCouponClaimCardWidget({
  required String couponAmount,
  required Function(bool) onClaimedChanged,
}) {
  return _RewardCouponClaimCard(
    couponAmount: couponAmount,
    onClaimedChanged: onClaimedChanged,
  );
}

class _RewardCouponClaimCard extends StatefulWidget {
  final String couponAmount;
  final Function(bool) onClaimedChanged;

  const _RewardCouponClaimCard({
    required this.couponAmount,
    required this.onClaimedChanged,
  });

  @override
  State<_RewardCouponClaimCard> createState() => _RewardCouponClaimCardState();
}

class _RewardCouponClaimCardState extends State<_RewardCouponClaimCard>
    with SingleTickerProviderStateMixin {
  bool _isClaimed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  // late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // _colorAnimation = ColorTween(
    //   begin: LoyalityPointsColors.lpTierMessageBoxBgColor.withValues(alpha:0.8),
    //   end: Colors.greenAccent.withValues(alpha:0.8),
    // ).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      setState(() {
        _isClaimed = !_isClaimed;
      });
      widget.onClaimedChanged(_isClaimed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 370,
        height: 56,
        decoration: DottedDecoration(
          shape: Shape.box,
          borderRadius: BorderRadius.circular(20),
          color: LoyalityPointsColors.lpTierMessageBoxBgColor,
        ),
        // padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Animation duration
          curve: Curves.easeInOut,
          // Apply the animated background color inside the container
          width: 370,
          height: 56,
          decoration: BoxDecoration(
            color: !_isClaimed
                ? Colors.greenAccent.withValues(alpha: 0)
                : LoyalityPointsColors.lpTierMessageBoxBgColor
                    .withValues(alpha: 0.1), // Background color animation
            borderRadius: BorderRadius.circular(20), // Matches the outer border
          ),
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voucher'.tr(),
                    style: LoyalityPointsFontstyles.rewardVoucherTitleTextStyle
                        .copyWith(
                            color:
                                LoyalityPointsColors.lpTierMessageBoxBgColor),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.couponAmount,
                    style: LoyalityPointsFontstyles.rewardVoucherAmountTextStyle
                        .copyWith(
                            color:
                                LoyalityPointsColors.lpTierMessageBoxBgColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _onTap,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            if (_isClaimed) ...[
                              Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: LoyalityPointsColors
                                          .lpTierMessageBoxBgColor,
                                      size: 20),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Remove'.tr(),
                                    style: LoyalityPointsFontstyles
                                        .rewardVoucherBtnTextStyle
                                        .copyWith(
                                            color: LoyalityPointsColors
                                                .lpTierMessageBoxBgColor),
                                  ),
                                ],
                              )
                            ] else ...[
                              Text(
                                'Get now'.tr(),
                                style: LoyalityPointsFontstyles
                                    .rewardVoucherBtnTextStyle
                                    .copyWith(
                                        color: LoyalityPointsColors
                                            .lpTierMessageBoxBgColor),
                              )
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
