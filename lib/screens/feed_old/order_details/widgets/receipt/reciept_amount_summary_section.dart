import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/checkout_details.dart';
import 'package:ufc_mobile/global/util/extension/num_extensions.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';

class RecieptAmountSummarySection extends StatelessWidget {
  const RecieptAmountSummarySection({
    super.key,
    required this.orderDetails,
  });
  final OrderModel orderDetails;

  @override
  Widget build(BuildContext context) {
    final couponAmount = (orderDetails.couponAmount ?? 0) +
        (orderDetails.deliveryCouponAmount ?? 0);
    return Column(
      children: [
        const SizedBox(height: 50),
        checkoutDetails(
            title: 'Items',
            amount: orderDetails.orderItems!.isEmpty
                ? "0"
                : orderDetails.orderItems!.length > 10
                    ? '${orderDetails.orderItems!.length}'
                    : '0${orderDetails.orderItems!.length}',
            fontWeight: FontWeight.w500),
        const Divider(),
        checkoutDetails(
            title: 'Sub Total',
            amountCurrency: ((orderDetails.amount ?? 0.00) +
                    (orderDetails.couponAmount ?? 0.00))
                .toStringAsFixed(2),
            fontWeight: FontWeight.w500),
        const Divider(),
        // --TODO: delivery feature is disabled
        // checkoutDetails(
        //   currency: true,
        //   title: 'Shipping Fee',
        //   amountCurrency: "50.0",
        //   //50.toString(),
        //   fontWeight: FontWeight.w500,
        // ),
        // const Divider(),
        checkoutDetails(
          title: 'VAT Amount',
          totalPrice: (orderDetails.vatAmount ?? 0.00).toStringAsFixed(2),
          fontWeight: FontWeight.w600,
          priceColor: primaryColor,
        ),
        const Divider(),
        if (orderDetails.deliveryVat.isGreaterThan(0))
          checkoutDetails(
            title: 'Delivery Vat Amount',
            totalPrice: (orderDetails.deliveryVat ?? 0.00).toStringAsFixed(2),
            fontWeight: FontWeight.w600,
            priceColor: primaryColor,
          ),
        if (orderDetails.deliveryVat.isGreaterThan(0)) const Divider(),
        if (couponAmount.isGreaterThan(0))
          checkoutDetails(
            title: 'Coupon Discount',
            totalPrice: '-${couponAmount.toStringAsFixed(2)}',
            fontWeight: FontWeight.w600,
            priceColor: carminePink,
          ),
        if (couponAmount.isGreaterThan(0)) const Divider(),
        checkoutDetails(
          title: 'Total Price ',
          subtitle: "(Including VAT ${orderDetails.user?.vatPercentage}%)".tr(),
          totalPrice: (orderDetails.totalWithVat ?? 0.00).toStringAsFixed(2),
          fontWeight: FontWeight.w600,
          priceColor: primaryColor,
        ),
        const Divider(),
      ],
    );
  }
}
