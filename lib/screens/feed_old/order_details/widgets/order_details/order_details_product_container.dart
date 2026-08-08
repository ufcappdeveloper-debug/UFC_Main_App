import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/order_hh/order_item.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';

class OrderDetailsProductContainer extends StatelessWidget {
  const OrderDetailsProductContainer({
    super.key,
    required this.orderItem,
  });
  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageWithPlaceHolder(
                width: 30,
                height: 30,
                imageUrl: orderItem.product?.images?.first.location,
              ),

              // ...e.product!.images!
              //     .map(
              //       (e) =>

              //           // Image.asset(
              //           //     'assets/images/home/product_sample1.png',
              //           //     height: 30,
              //           //     width: 30)
              //           CachedNetworkImage(
              //               imageUrl: e.location ?? "",
              //               placeholder: loadingPlaceholder,
              //               errorWidget: errorWidget,
              //               fit: BoxFit.cover,
              //               height: 30,
              //               width: 30),
              //     )
              //     .toList(),

              const SizedBox(width: 5),
              Text.rich(TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: "${orderItem.quantity} ",
                    style: const TextStyle(
                      color: Color(0xff929292),
                      fontFamily: "Kanit",
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ProductUtils.productName(orderItem.product),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              )),
            ],
          ),
          Text.rich(TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: (orderItem.orderPrice ?? 0.00).toStringAsFixed(2),
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              // const TextSpan(
              //   text: 'SARyyy',
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontFamily: 'Poppins',
              //     fontWeight: FontWeight.w300,
              //   ),
              // ),
              WidgetSpan(
                child: SaudiRiyalIcon(
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
