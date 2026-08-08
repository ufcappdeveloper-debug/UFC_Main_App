import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/screens/tier_list_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/claimed_vouchers.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/utilities/points_calculator.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/button_dow.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/loyality_points/loyality_points_product_section.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/loyality_points/loyality_points_voucher_section.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/progress_bar.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class LoyalityPointsPage extends ConsumerStatefulWidget {
  const LoyalityPointsPage({super.key});

  @override
  ConsumerState<LoyalityPointsPage> createState() => _LoyalityPointsPageState();
}

class _LoyalityPointsPageState extends ConsumerState<LoyalityPointsPage>
    with ScreenEngagementTracker {
  bool isProducts = true;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(userPointsProvider.notifier).fetchUserTierPoints();
      await ref.read(claimedVouchersProvider.notifier).fetchClaimedVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    int tierMinPoints = 0;
    int tierMaxPoints = 0;
    final points = ref.watch(userPointsProvider);
    bool isRTL = isArabic;

    final tiers = points.value?.data?.tiers ?? [];

    if (tiers.isNotEmpty) {
      tierMinPoints = tiers.last.tierMinPoints ?? 0;

      tierMaxPoints = tiers.last.tierMaxPoints ?? 0;
    } else {
      debugPrint(
          'Tiers list is empty or null. Using default tierMinPoints and tierMaxPoints as 0.');
    }

    final tierName = points.value?.data?.tiers?.isNotEmpty == true
        ? points.value?.data?.tiers?.last.name ?? 'Tier'
        : 'Tier';
    final tierMaxPointsDisplay = tierMaxPoints > 0
        ? '${NumberFormat.decimalPattern('en').format(tierMaxPoints)} ${'Points'.tr()}'
        : 'N/A';

    final tierDescription = points.value?.data?.tiers?.isNotEmpty == true
        ? (isArabic
            ? points.value?.data?.tiers?.last.descriptionAr ??
                'Reward unavailable'.tr()
            : isEnglish
                ? points.value?.data?.tiers?.last.description ??
                    'Reward unavailable'.tr()
                : points.value?.data?.tiers?.last.descriptionAr ??
                    'Reward unavailable'.tr())
        : 'Reward unavailable'.tr();

// Get user points
    final int userPoints = points.value?.data?.userPoints ?? 0;

// Calculate progress
    final double progress = calculateUserPointsPercentage(
      userPoints,
      tierMinPoints,
      tierMaxPoints,
    );

    final int remainingPoints =
        calculateRemainingPoints(userPoints, tierMaxPoints);

    final List<Product> productsData =
        (points.value?.data?.products ?? []).map((product) {
      return Product(
          id: product.id ?? 0,
          nameEn: product.nameEn ?? "Product".tr(),
          descriptionEn: product.descriptionEn ?? "No Description".tr(),
          productImage:
              product.productImage ?? "https://via.placeholder.com/150",
          quantity: product.quantity ?? 0,
          tierId: product.tierId ?? 0,
          tierMaxPoints: product.tierMaxPoints ?? 0,
          variantId: product.variantId,
          stock: product.stock ?? 0,
          price: product.price ?? 0);
    }).toList();
    final List<Voucher> voucherData =
        (points.value?.data?.vouchers ?? []).map((voucher) {
      return Voucher(
        id: voucher.id,
        code: voucher.code ?? "Product",
        discountValue: voucher.discountValue ?? 0,
        type: voucher.type,
        expiryDate: voucher.expiryDate ?? "",
        pivot: voucher.pivot,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loyalty Points'.tr(),
          style: TextStyle(
              fontSize: 15, color: LoyalityPointsColors.lpMainTitleTextColor),
        ),
        backgroundColor: LoyalityPointsColors.lpBgColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Stack(clipBehavior: Clip.hardEdge, children: [
              Container(
                  height: 167,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: LoyalityPointsColors.lpBgColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            points.value?.data?.tiers?.isNotEmpty == true
                                ? (points.value?.data?.tiers?.last.name ??
                                        'Tier')
                                    .tr()
                                : 'Tier',
                            style: LoyalityPointsFontstyles
                                .lpCurrentTierTitleTextStyle
                                .copyWith(
                                    color: LoyalityPointsColors
                                        .lpMainTitleTextColor)),
                        Text(
                          '${NumberFormat.decimalPattern('en').format(userPoints)} ${'Points'.tr()}',
                          style: LoyalityPointsFontstyles
                              .lpCurrentPointsTextStyle
                              .copyWith(
                                  color: LoyalityPointsColors
                                      .lpCurrentPointsTextColor),
                        ),
                        const SizedBox(height: 8),
                        ProgressBar(progress: progress),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.decimalPattern('en')
                                  .format(tierMinPoints.toInt()),
                              style: LoyalityPointsFontstyles
                                  .lpPointsScaleTextStyle
                                  .copyWith(
                                      color: LoyalityPointsColors
                                          .lpPointsScaleTextColor),
                            ),
                            Text(
                              NumberFormat.decimalPattern('en')
                                  .format(tierMaxPoints.toInt()),
                              style: LoyalityPointsFontstyles
                                  .lpPointsScaleTextStyle
                                  .copyWith(
                                      color: LoyalityPointsColors
                                          .lpPointsScaleTextColor),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
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
                                  color:
                                      LoyalityPointsColors.lpMainTitleTextColor,
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
                                text:
                                    '${'Points more to get to next Tier'.tr()}!',
                                style: LoyalityPointsFontstyles
                                    .lpRemainingPointsIndicatorTextStyle
                                    .copyWith(
                                        color: LoyalityPointsColors
                                            .lpMainTitleTextColor),
                              ),
                            ],
                          ),
                        ),
                      ])),
              Positioned(
                right: isRTL ? null : 0,
                left: isRTL ? 0 : null,
                top: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      isRTL ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                  child: Container(
                    height: 80,
                    width: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/loyality_points/image_upper.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: isRTL ? null : 0,
                right: isRTL ? 0 : null,
                bottom: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      isRTL ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                  child: Container(
                    height: 66,
                    width: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/loyality_points/image_lower.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TierListPage()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        '${tierName.tr()} ($tierMaxPointsDisplay)',
                        style: LoyalityPointsFontstyles
                            .lpTierPointsScaleTextStyle
                            .copyWith(
                                color:
                                    LoyalityPointsColors.lpSubHeadingTextColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        tierDescription.tr(),
                        style: LoyalityPointsFontstyles
                            .lpRemainingPointsIndicatorTextStyle
                            .copyWith(
                                color:
                                    LoyalityPointsColors.lpSubHeadingTextColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                Image.asset(
                  'assets/images/loyality_points/Subtract.png',
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ButtonRow(
              onIndexChanged: (index) {
                setState(() {
                  isProducts = index == 0;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
            child: Text(
              'Rewards'.tr(),
              style: LoyalityPointsFontstyles.lpBoldSubHeadingTextStyle
                  .copyWith(color: LoyalityPointsColors.lpSubHeadingTextColor),
            ),
          ),
          if (isProducts)
            Expanded(
              child: LoyalityPointsProductSection(
                products: productsData,
              ),
            ),
          if (!isProducts)
            Expanded(
              child: LoyalityPointsVoucherSection(
                vouchers: voucherData,
              ),
            ),
        ],
      ),
    );
  }
}

double roundToTwoDecimalPlaces(double value) {
  return (value * 100).roundToDouble() / 100;
}

Widget rewardsTitle(
    {required String title, String? itemCount, EdgeInsets? margin}) {
  return Container(
    margin: margin ?? const EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title.tr(),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(30, 51, 84, 1),
        ),
        itemCount != null
            ? CustomText(
                text: itemCount,
                fontWeight: FontWeight.w300,
                color: const Color.fromRGBO(153, 153, 153, 1))
            : const SizedBox.shrink(),
      ],
    ),
  );
}
