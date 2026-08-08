import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/extension/num_extensions.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';

class OrderDetailsCard extends StatelessWidget {
  final OrderModel order;
  final double walletPaid;
  const OrderDetailsCard(
      {super.key, required this.order, required this.walletPaid});
  @override
  Widget build(BuildContext context) {
    final couponAmount =
        (order.couponAmount ?? 0) + (order.deliveryCouponAmount ?? 0);
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              text: 'Order Details',
              // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            ),
          ),
          kHeight10,
          DetailTile(
            isAmount: false,
            title: 'Number of Items',
            amount: order.orderItems!.isEmpty
                ? "0"
                : order.orderItems!.length > 9
                    ? '${order.orderItems!.length}'
                    : '0${order.orderItems!.length}',
          ),
          Divider(height: 12, thickness: 0.5, color: Colors.grey[300]),
          if (couponAmount.isGreaterThan(0))
            DetailTile(
              isDiscount: true,
              title: 'Discount',
              amount: '- ${(order.couponAmount ?? 0.00).toStringAsFixed(2)}',
            ),
          if (couponAmount.isGreaterThan(0))
            Divider(height: 12, thickness: 0.5, color: Colors.grey[300]),
          DetailTile(
            title: 'VAT Amount',
            amount: (order.vatAmount ?? 0.00).toStringAsFixed(2),
          ),
          if (order.orderType == "DELIVERY")
            Divider(height: 12, thickness: 0.5, color: Colors.grey[300]),
          if (order.orderType == "DELIVERY")
            DetailTile(
              title: 'Delivery Fee',
              amount: (order.deliveryFee ?? 0.00).toStringAsFixed(2),
            ),
          if (order.deliveryVat.isGreaterThan(0))
            Divider(height: 12, thickness: 0.5, color: Colors.grey[300]),
          if (order.deliveryVat.isGreaterThan(0))
            DetailTile(
              title: 'Delivery VAT Amount',
              amount: (order.deliveryVat ?? 0.00).toStringAsFixed(2),
            ),
          Divider(thickness: 0.5, color: Colors.grey[300]),
          InfoTile(
              leadingWidget: Image.asset(
                order.paymentMethod == "SADAD"
                    ? "assets/images/global/sadad.png"
                    : order.paymentMethod == "MADA"
                        ? "assets/images/cart/mada_logo.png"
                        : order.paymentMethod == "WALLET"
                            ? "assets/images/profile/wallet.png"
                            : order.paymentMethod == "CASH"
                                ? 'assets/images/cart/cod_hand.png'
                                : '',
                height: 20,
                color: order.paymentMethod == "WALLET" ? Colors.grey : null,
              ),
              value: order.paymentMethod == "WALLET"
                  ? order.totalWithVat?.toStringAsFixed(2)
                  : order.payableAmount?.toStringAsFixed(2)),
          if (order.paymentMethod != "WALLET" && walletPaid > 0)
            Column(
              children: [
                Divider(thickness: 0.5, color: Colors.grey[300]),
                InfoTile(
                    leadingWidget: Image.asset(
                      "assets/images/profile/wallet.png",
                      height: 20,
                      color: Colors.grey,
                    ),
                    value: walletPaid.toStringAsFixed(2)),
              ],
            ),
          Divider(height: 12, thickness: 0.5, color: Colors.grey[300]),
          DetailTile(
            title: 'Total',
            amount: (order.totalWithVat ?? 0.00).toStringAsFixed(2),
          ),
        ],
      ),
    );
  }
}
