import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_style.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../../../../../global/extensions/saudi_riyal_icon.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel? product;
  final VoidCallback onTap;
  final VoidCallback onTapOfFavorite;
  final bool showFavoriteIcon;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onTapOfFavorite,
    this.showFavoriteIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isOutOfStock = !(product?.isInStock ?? false);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: ksymmetric(10, 12),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProductUtils.favoriteButton(
                        onTap: onTapOfFavorite,
                        product: product,
                        showFavoriteIcon: showFavoriteIcon),
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                          child: Stack(
                            children: [
                              ImageWithPlaceHolder(
                                width: constraints.maxWidth,
                                height: constraints.maxWidth,
                                fit: BoxFit.contain,
                                imageUrl: (product?.images ?? []).isNotEmpty
                                    ? product!.images![0].location
                                    : null,
                              ),
                              if (isOutOfStock)
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: CustomText(
                                      maxLines: 2,
                                      text: 'no_stock',
                                      textStyle: AppFontStyle.getMediumStyleV2(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Product Name
                    SizedBox(
                      width: constraints.maxWidth,
                      child: CustomText(
                        text: ProductUtils.productName(product),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        textStyle: AppFontStyle.getMediumStyleV2(fontSize: 14),
                      ),
                    ),
                    // ✅ Show Price
                    priceText(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper: Extract product price & original price from the first variant
  static Map<String, double?> productPrices(ProductModel? product) {
    final firstVariant =
        product?.variants?.isNotEmpty == true ? product?.variants?.first : null;

    return {
      "price": firstVariant?.price,
      "originalPrice": firstVariant?.originalPrice,
    };
  }

  String normalizeNumberLocale(String locale) {
    final l = locale.toLowerCase();
    if (l.startsWith('ar')) return 'ar';
    if (l.startsWith('ur')) return 'ur';
    return 'en';
  }

  Widget priceText() {
    final prices = productPrices(product);
    final price = prices["price"];
    final originalPrice = prices["originalPrice"];

    if (price == null) {
      return const SizedBox.shrink();
    }

    final currentLocale = normalizeNumberLocale(Intl.getCurrentLocale());
    final formattedPrice =
        NumberFormat.decimalPattern(currentLocale).format(price);
    final formattedOriginal = (originalPrice != null && originalPrice > price)
        ? NumberFormat.decimalPattern(currentLocale).format(originalPrice)
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (formattedOriginal != null) ...[
          SaudiRiyalIcon(
            color: PetVeterinaryColors.backgroundRed,
            size: 13,
          ),
          CustomText(
            text: formattedOriginal,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: PetVeterinaryColors.backgroundRed,
            decoration: TextDecoration.lineThrough,
          ),
          const SizedBox(width: 10),
        ],
        SaudiRiyalIcon(color: Colors.black, size: 13),
        Text(
          formattedPrice,
          style: AppFontStyle.getMediumStyleV2(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
