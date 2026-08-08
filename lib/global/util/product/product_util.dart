import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_svg_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_variant_model.dart';

class ProductUtils {
  static String productName(ProductModel? product) {
    if (isArabic) {
      return product?.nameAr ?? product?.nameEn ?? product?.nameUr ?? '';
    } else if (isUrdu) {
      return product?.nameUr ?? product?.nameEn ?? product?.nameAr ?? '';
    } else {
      return product?.nameEn ?? product?.nameAr ?? product?.nameUr ?? '';
    }
  }

  static String? productDescription(ProductModel? product) {
    if (isArabic) {
      return product?.descriptionAr ??
          product?.descriptionEn ??
          product?.descriptionUr;
    } else if (isUrdu) {
      return product?.descriptionUr ??
          product?.descriptionEn ??
          product?.descriptionAr;
    } else {
      return product?.descriptionEn ??
          product?.descriptionAr ??
          product?.descriptionUr;
    }
  }

  static String? packingName(ProductModel? product) {
    final packName = product?.variants
            ?.firstWhere(
              (v) => v.packingType?.name != null,
              orElse: () => ProductVariantModel(),
            )
            .packingType
            ?.name ??
        '';
    return packName;
  }

  static Widget favoriteButton({
    required VoidCallback onTap,
    required ProductModel? product,
     bool showFavoriteIcon = false,
  }) {
     final bool shouldShowChosenIcon = showFavoriteIcon || (product?.isFavorite ?? false);
    return Align(
      alignment: isArOrUr ? Alignment.topLeft : Alignment.topRight,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          child: SvgPicture.asset(
        shouldShowChosenIcon
                ? AppSvgImages.chosenFavoriteIcon
                : AppSvgImages.favoriteIcon,
            fit: BoxFit.cover,
            height: 16,
            width: 16,
          ),
        ),
      ),
    );
  }
}
