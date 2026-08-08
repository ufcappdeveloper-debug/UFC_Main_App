import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/screens/loyality_points_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/utilities/points_calculator.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/progress_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class LoyaltyProgressBarCard extends ConsumerStatefulWidget {
  const LoyaltyProgressBarCard({
    super.key,
    this.barHeight = 4.0,
    this.orderPoints = 0,
    required this.height,
    this.pointerSize = 11.0,
    required this.isInCheckOutPage,
    required this.parentPaddingSize,
  });
  final double height;
  final double barHeight;
  final double pointerSize;
  final double orderPoints;
  final bool isInCheckOutPage;
  final double parentPaddingSize;

  @override
  ConsumerState<LoyaltyProgressBarCard> createState() =>
      _LoyaltyProgressBarState();
}

class _LoyaltyProgressBarState extends ConsumerState<LoyaltyProgressBarCard> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(userPointsProvider.notifier).fetchUserTierPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(userPointsProvider);

    int tierMinPoints = 0;
    if ((points.value?.data?.tiers ?? []).isNotEmpty) {
      tierMinPoints = points.value?.data?.tiers?.last.tierMinPoints ?? 0;
    }

    int tierMaxPoints = 0;
    if ((points.value?.data?.tiers ?? []).isNotEmpty) {
      tierMaxPoints = points.value?.data?.tiers?.last.tierMaxPoints ?? 0;
    }

    final int userPoints = points.value?.data?.userPoints ?? 0;

    final double progress = calculateUserPointsPercentage(
      userPoints,
      tierMinPoints,
      tierMaxPoints,
    );

    String tierName = '';
    if ((points.value?.data?.tiers ?? []).isNotEmpty) {
      tierName = points.value?.data?.tiers?.last.name ?? '';
    }

    final int remainingPoints =
        calculateRemainingPoints(userPoints, tierMaxPoints);
    return GestureDetector(
      onTap: () {
        if (!widget.isInCheckOutPage) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoyalityPointsPage(),
            ),
          );
        } else {}
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                height: widget.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LoyalityPointsColors.lpBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isInCheckOutPage)
                      ...checkoutPage
                    else ...[
                      const SizedBox(height: 4),
                      CustomText(
                        text: tierName.tr(),
                        textStyle: LoyalityPointsFontstyles.lpTierBoldTextStyle
                            .copyWith(
                          color: LoyalityPointsColors.lpMainTitleTextColor,
                        ),
                      ),
                      const SizedBox(height: 21)
                    ],
                    ProgressBar(
                      progress: progress,
                      barHeight: widget.barHeight,
                      pointerSize: widget.pointerSize,
                      isInLoyalityScreen: false,
                      tierMinPoints: tierMinPoints,
                      pointerPositionHelper: ((8 * 2) +
                          (32 * 2) +
                          (widget.parentPaddingSize * 2) +
                          10.5),
                      currentPoints: userPoints,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        CustomText(
                          text: NumberFormat.decimalPattern('en')
                              .format(tierMaxPoints.toInt()),
                          textStyle: LoyalityPointsFontstyles
                              .lpMaxPointsBoldTextStyle
                              .copyWith(
                            color:
                                LoyalityPointsColors.lpTierPointsScaleTextColor,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Earn'.tr(),
                            style: LoyalityPointsFontstyles
                                .lpRemainingPointsIndicatorTextStyle
                                .copyWith(
                              color: LoyalityPointsColors.lpMainTitleTextColor,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' ${NumberFormat.decimalPattern('en').format(remainingPoints)} ',
                            style: LoyalityPointsFontstyles
                                .lpPointsNumberTextStyle
                                .copyWith(
                                    color: LoyalityPointsColors
                                        .lpMainTitleTextColor),
                          ),
                          TextSpan(
                            text: 'Points more to get to next Tier'.tr(),
                            style: LoyalityPointsFontstyles
                                .lpRemainingPointsIndicatorTextStyle
                                .copyWith(
                                    color: LoyalityPointsColors
                                        .lpMainTitleTextColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2.5),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: heightForUpperImage,
                  width: widthForUpperImage,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/loyality_points/image_upper.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  height: heightForLowerImage,
                  width: widthForLowerImage,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/loyality_points/image_lower.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get heightForUpperImage {
    return widget.isInCheckOutPage ? widget.height / 3 : widget.height / 2.5;
  }

  double get widthForUpperImage {
    return widget.isInCheckOutPage ? 42 : 44;
  }

  double get heightForLowerImage {
    return widget.isInCheckOutPage ? widget.height / 1.8 : widget.height / 1.1;
  }

  double get widthForLowerImage {
    return 28;
  }

  List<Widget> get checkoutPage {
    return [
      CustomText(
        text: 'Loyalty Points'.tr(),
        textStyle:
            LoyalityPointsFontstyles.lpLightWeightSubHeadingTextStyle.copyWith(
          color: LoyalityPointsColors.lpMainTitleTextColor,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: 'Your order will earn you'.tr(),
            textStyle: LoyalityPointsFontstyles.lpLightWeightTextStyle.copyWith(
              color: LoyalityPointsColors.lpMainTitleTextColor,
            ),
          ),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.orderPoints
                      .toStringAsFixed(2), // First part of the text
                  style:
                      LoyalityPointsFontstyles.lpSubHeadingTextStyle.copyWith(
                    color: LoyalityPointsColors.lpCurrentPointsTextColor,
                  ),
                ),
                TextSpan(
                  text: ' ',
                  // Part with different color
                  style:
                      LoyalityPointsFontstyles.lpLightWeight2TextStyle.copyWith(
                    color: LoyalityPointsColors.lpCurrentPointsTextColor,
                  ),
                ),
                TextSpan(
                  text: 'Points'.tr(),
                  // Part with different color
                  style:
                      LoyalityPointsFontstyles.lpLightWeight2TextStyle.copyWith(
                    color: LoyalityPointsColors.lpCurrentPointsTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 32),
    ];
  }
}
