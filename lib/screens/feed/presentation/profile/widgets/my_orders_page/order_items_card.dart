import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/cart/feed_cart_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/price_label.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../../../../../models/order_hh/order_item.dart';

class OrderItemsCard extends StatelessWidget {
  final List<OrderItem>? items;
  final List<FeedCartItemModel>? cartItems;
  final ProductModel? productItem;
  final int? quantity;
  final EdgeInsetsGeometry? padding;
  const OrderItemsCard(
      {super.key,
      this.items,
      this.cartItems,
      this.productItem,
      this.quantity,
      this.padding});

  Widget priceRow(double? price, {Color? color}) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            text: (price ?? 0.00).toStringAsFixed(2),
            fontSize: 16,
          ),
          SaudiRiyalIcon(color: color ?? Colors.black, size: 15),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final isWide = ScreenWidthUtils.isWide(context);
    final data = items ?? cartItems ?? [];

    return InfoCard(
      padding: padding,
      title: 'My Order'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          if (productItem != null)
            _buildProductTile(productItem, quantity, isWide: isWide),
          ...List.generate(data.length, (index) {
            final item = data[index];
            Widget? tile;

            if (item is OrderItem) {
              tile = ListTile(
                dense: true,
                title: CustomText(
                  text: ProductUtils.productName(item.product),
                  fontSize: isWide ? 15 : 13,
                  height: isWide ? 2 : 1.6,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: PriceLabel(
                  qty: item.quantity ?? 0,
                  unitPrice: item.variationPrice ?? 0,
                  isArOrUr: isArOrUr,
                  isWide: isWide,
                ),
                trailing: priceRow(item.orderPrice),
              );
            } else if (item is FeedCartItemModel) {
              tile = ListTile(
                dense: true,
                title: (item.variant != null)
                    ? CustomText(
                        text: ProductUtils.productName(item.variant?.product),
                        fontSize: isWide ? 15 : 13,
                        height: isWide ? 2 : 1.6,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                subtitle: PriceLabel(
                  qty: item.quantity ?? 0,
                  unitPrice: item.variant?.price ?? 0,
                  isArOrUr: isArOrUr,
                  isWide: isWide,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: ((item.price ?? 0.00) * (item.quantity ?? 0))
                          .toStringAsFixed(2),
                      fontSize: 15,
                    ),
                    const SaudiRiyalIcon(color: Colors.black, size: 14),
                  ],
                ),
              );
            }
            return Column(
              children: [
                if (tile != null) tile,
                if (index != data.length - 1)
                  const CustomDivider(
                    horizontalPadding: 16,
                    thickness: 0.25,
                    color: PetVeterinaryColors.newPetLightGray,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

Widget _buildProductTile(ProductModel? product, int? quantity,
    {isWide = false}) {
  return ListTile(
    dense: true,
    title: CustomText(
      text: ProductUtils.productName(product),
      fontSize: isWide ? 15 : 13,
      height: isWide ? 2 : 1.6,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: PriceLabel(
      qty: quantity ?? 0,
      unitPrice: product?.variants == null ||
              product!.variants!.isEmpty ||
              product.variants?.first.price == null
          ? 0.00
          : (product.variants?.first.price ?? 0.00),
      isArOrUr: isArOrUr,
      isWide: isWide,
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          text: product?.variants == null ||
                  product!.variants!.isEmpty ||
                  product.variants?.first.price == null
              ? "0.00"
              : ((product.variants?.first.price ?? 0.00) * (quantity ?? 0))
                  .toStringAsFixed(2),
          fontSize: 15,
        ),
        const SaudiRiyalIcon(color: Colors.black, size: 14),
      ],
    ),
  );
}
