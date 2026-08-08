import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/orders/utils/order_utils.dart';

import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../global/util/image_network_extension_method.dart';
import '../../../feed/domain/entities/order/order_model.dart';

class CustomOrder extends ConsumerWidget {
  const CustomOrder({
    super.key,
    required this.orderModel,
    this.buttonText = "Track Order",
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
  });

  final String? buttonText;
  final OrderModel orderModel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          if (orderModel.orderItems!.first.product != null)
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    height: 140,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffE8FFCF),
                    ),
                    child: orderModel.orderItems!.first.product!.images ==
                                null ||
                            orderModel
                                .orderItems!.first.product!.images!.isEmpty
                        ? SvgPicture.asset(
                            "assets/images/global/Pattens-Blue-Bg-No-Image-Placeholder.svg")
                        : CachedNetworkImage(
                            imageUrl: orderModel.orderItems!.first.product!
                                    .images![0].location ??
                                "",
                            placeholder: loadingPlaceholder,
                            errorWidget: errorWidget,
                          ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CustomText(
                                      text: "#${orderModel.id}",
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    const Spacer(),
                                    CustomText(
                                        text: DateFormat('dd-MM-yyyy', 'en')
                                            .format(DateTime.parse(orderModel
                                                .createdAt
                                                .toString())),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
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
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: 'Total',
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: const Color(0xff9C9CA0),
                                    ),
                                    kWidth10,
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        CustomText(
                                          text:
                                              (orderModel.totalWithVat ?? 0.00)
                                                  .toStringAsFixed(2),
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        // CustomText(
                                        //   text: "SAR",
                                        //   fontFamily: 'Poppins',
                                        //   fontSize: 10,
                                        //   textAlign: TextAlign.end,
                                        //   fontWeight: FontWeight.w500,
                                        // ),
                                        SaudiRiyalIcon(
                                          size: 10,
                                          style: TextStyle(
                                            fontFamily: 'SaudiRiyal',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: orderModel.orderStatus ?? "",
                                        fontSize: 14,
                                        color: primaryColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await OrderUtils.onOrderStatusPressed(
                                              context, ref,
                                              order: orderModel);
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Container(
                                          height: 28,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.5),
                                            border: Border.all(
                                                width: 1.0,
                                                color: orderModel.orderStatus ==
                                                        "COMPLETED"
                                                    ? const Color(0xffFFC53F)
                                                    : primaryColor),
                                          ),
                                          child: Text(
                                            (orderModel.orderStatus ==
                                                        "COMPLETED"
                                                    ? "Order again"
                                                    : "Track Order")
                                                .tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: orderModel.orderStatus ==
                                                      "COMPLETED"
                                                  ? const Color(0xffFFC53F)
                                                  : primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  ProductModel? get product {
    return orderModel.orderItems?[0].product;
  }
}
