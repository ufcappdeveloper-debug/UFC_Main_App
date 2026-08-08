import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/screens/loyality_points_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/utilities/loyality_points_utils.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/utilities/points_calculator.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/loyality_points_product_container.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/reward_product_bottom_sheet.dart';
import 'package:ufc_mobile/screens/feed_old/product/pages/product_details_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

class LoyalityPointsProductSection extends ConsumerStatefulWidget {
  const LoyalityPointsProductSection({
    super.key,
    required this.products,
  });
  final List<Product> products;

  @override
  ConsumerState<LoyalityPointsProductSection> createState() =>
      _LoyalityPointsProductSectionState();
}

class _LoyalityPointsProductSectionState
    extends ConsumerState<LoyalityPointsProductSection> {
  @override
  Widget build(BuildContext context) {
    final points = ref.watch(userPointsProvider);
    final tiers = points.value?.data?.tiers ?? [];
    final int tierMaxPoints = tiers.last.tierMaxPoints ?? 0;
    final int userPoints = points.value?.data?.userPoints ?? 0;
    final int remainingPoints =
        calculateRemainingPoints(userPoints, tierMaxPoints);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rewardsTitle(title: 'Products'),
        const SizedBox(height: 12),
        if (widget.products.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Text(
                "No reward products available".tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, child) {
                var claimedProducts = ref
                    .watch(cartProvider)
                    .cartItems
                    .where((item) => item.isClaimed)
                    .toList();

                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: widget.products.length + claimedProducts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 17,
                    childAspectRatio: 0.65,
                    maxCrossAxisExtent: 197,
                  ),
                  itemBuilder: (context, index) {
                    if (index < widget.products.length) {
                      final product = widget.products[index];

                      return LoyalityPointsProductContainer(
                        isClaimed: false,
                        isProductImageExist: true,
                        productImg: product.productImage ?? '',
                        quantity: product.quantity.toString(),
                        points: product.tierMaxPoints.toString(),
                        productDescription:
                            product.descriptionEn ?? 'No Description'.tr(),
                        productName: product.nameEn ?? 'No product name'.tr(),
                        onPressed: () {
                          if (product.id == null) {
                            CustomSnackBar.error(context,
                                "We couldn't find the product. Please try again.");
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                canBuy: true,
                                productId: product.id!,
                                isLoyaltyProduct: true,
                                onLoyalityProductClaimPressed: () async {
                                  await LoyalityPointsUtils.claimProduct(
                                      this, ref,
                                      product: product,
                                      remainingPoints: remainingPoints);
                                },
                              ),
                            ),
                          );
                        },
                        onClaim: () async => rewardClaimButtonAction(
                          context,
                          quantity: product.quantity ?? 0,
                          productImg: product.productImage ?? '',
                          productDescription:
                              product.descriptionEn ?? 'No Description'.tr(),
                          productName: product.nameEn ?? 'No product name',
                          originalPrice:
                              (product.quantity ?? 0) * (product.price ?? 0),
                          onButtonPressed: () async {
                            await LoyalityPointsUtils.claimProduct(this, ref,
                                product: product,
                                remainingPoints: remainingPoints);
                          },
                        ),
                      );
                    } else {
                      final claimedProduct =
                          claimedProducts[index - widget.products.length];
                      return LoyalityPointsProductContainer(
                        isClaimed: true,
                        isProductImageExist: true,
                        points: '',
                        productImg: claimedProduct
                                .variant?.product?.images?[0].location ??
                            '',
                        quantity: claimedProduct.quantity.toString(),
                        productDescription:
                            claimedProduct.variant?.product?.descriptionEn ??
                                'No Description'.tr(),
                        productName: claimedProduct.variant?.product?.nameEn ??
                            'No product name',
                        onClaim: () async {
                          await LoyalityPointsUtils.unclaimProduct(this, ref,
                              claimedProduct: claimedProduct);
                        },
                        onPressed: () {
                          final product = claimedProduct.variant?.product;
                          if (product?.id == null) {
                            CustomSnackBar.error(context,
                                "We couldn't find the product. Please try again.");
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                canBuy: true,
                                isLoyaltyProduct: true,
                                productId: product!.id!,
                                onLoyalityProductClaimPressed: () async {
                                  await LoyalityPointsUtils.unclaimProduct(
                                      this, ref,
                                      claimedProduct: claimedProduct);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
