import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_svg_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';

import '../../../domain/entities/distributor/distributor_product_model.dart';
import '../utils/distributor_style.dart';
import 'distributor_common_widgets.dart';

/// Grid card for a distributor product: heart, image, name, price
/// (struck-through original price on offers) and an out-of-stock overlay.
class DistributorProductCard extends StatelessWidget {
  final DistributorProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  const DistributorProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Align(
                alignment:
                    AlignmentDirectional.topEnd,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: SvgPicture.asset(
                    product.favorite
                        ? AppSvgImages.chosenFavoriteIcon
                        : AppSvgImages.favoriteIcon,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageWithPlaceHolder(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        fit: BoxFit.contain,
                        imageUrl: product.image,
                      ),
                      if (product.isOutOfStock)
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('no_stock'.tr(),
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
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  if (product.isOffer)
                    RiyalAmount(product.originalPrice,
                        size: 13,
                        weight: FontWeight.w300,
                        color: DistributorStyle.error,
                        strike: true),
                  RiyalAmount(product.price),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
