import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';

import '../../../domain/entities/main_source/main_source_product_model.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';

/// Grid card: image, name, "from" price (struck-through original price on
/// a discount) and an out-of-stock overlay.
class MainSourceProductCard extends StatelessWidget {
  final MainSourceProductModel product;
  final VoidCallback onTap;

  const MainSourceProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final variant = product.defaultVariant;
    final single = product.variants.length <= 1;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageWithPlaceHolder(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        fit: BoxFit.contain,
                        imageUrl: product.image,
                      ),
                      if (!product.inStock)
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Out of stock'.tr(),
                              textAlign: TextAlign.center,
                              style: DistributorStyle.style(
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                    ],
                  ),
                ),
              ),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: DistributorStyle.style(size: 14, weight: FontWeight.w500),
              ),
              if (single && (variant?.size ?? '').isNotEmpty)
                Text(variant!.size!,
                    style: DistributorStyle.style(
                        size: 11, color: DistributorStyle.priceGrey)),
              const SizedBox(height: 2),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  if (product.hasPriceRange)
                    Text('From'.tr(),
                        style: DistributorStyle.style(
                            size: 11, color: DistributorStyle.priceGrey)),
                  if (single && (variant?.hasDiscount ?? false))
                    RiyalAmount(variant!.originalPrice,
                        size: 13,
                        weight: FontWeight.w300,
                        color: DistributorStyle.error,
                        strike: true),
                  RiyalAmount(single ? (variant?.price ?? product.minPrice)
                      : product.minPrice),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
