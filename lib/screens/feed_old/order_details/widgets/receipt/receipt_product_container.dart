import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/order_hh/order_item.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';

class ReceiptProductContainer extends StatelessWidget {
  const ReceiptProductContainer({
    super.key,
    required this.orderItem,
  });
  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 120,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            padding: EdgeInsets.symmetric(
                horizontal: product!.images!.isEmpty ? 10 : 0, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffE8FFCF),
            ),
            child: product!.images!.isEmpty
                ? CachedNetworkImage(
                    imageUrl: "assets/images/global/No-Image-Placeholder.svg",
                    placeholder: loadingPlaceholder,
                    errorWidget: errorWidget,
                    fit: BoxFit.contain)
                : CachedNetworkImage(
                    imageUrl: product!.images![0].location ?? "",
                    placeholder: loadingPlaceholder,
                    errorWidget: errorWidget,
                    fit: BoxFit.contain),
          )),
          const SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      CustomText(
                        text: ProductUtils.productName(product),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        text: ProductUtils.productDescription(product)??'',
                        maxLines: 1,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.clip,
                        color: const Color(0xff9C9CA0),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    // CustomText(
                                    //   text: "SAR",
                                    //   fontFamily: 'Poppins',
                                    //   fontSize: 10,
                                    //   textAlign: TextAlign.start,
                                    //   fontWeight: FontWeight.w300,
                                    // ),
                                    SaudiRiyalIcon(
                                      size: 10,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),

                                    CustomText(
                                      text: (orderItem.orderPrice ?? 0.00)
                                          .toStringAsFixed(2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            text: orderItem.quantity! > 1
                                ? "${orderItem.quantity} ${"Items".tr()}"
                                : "${orderItem.quantity} ${"Item".tr()}",
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  ProductModel? get product {
    return orderItem.product;
  }
}
