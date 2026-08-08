import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/checkout_details.dart';
import 'package:ufc_mobile/global/shared/widgets/checkout_title.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/util/extension/num_extensions.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/models/order_summary_model/order_summary_model.dart';
import 'package:ufc_mobile/screens/feed_old/order_details/pages/receipt_page.dart';

import '../../../../../riverpod/order/order_history.dart';

class OrderDetailsOrderSummarySection extends ConsumerWidget {
  const OrderDetailsOrderSummarySection({
    super.key,
    required this.orderSummary,
    required this.orderHistory,
  });

  final OrderModel orderHistory;
  final List<OrderSummaryModel> orderSummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponAmount = (orderHistory.couponAmount ?? 0) +
        (orderHistory.deliveryCouponAmount ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkoutTitle(title: 'Order Summary', color: Colors.black),
        checkoutDetails(
            title: 'Items',
            amount: orderHistory.orderItems!.isEmpty
                ? "0"
                : orderHistory.orderItems!.length > 10
                    ? '${orderHistory.orderItems!.length}'
                    : '0${orderHistory.orderItems!.length}',
            fontWeight: FontWeight.w500),
        const Divider(),
        checkoutDetails(
          title: 'Sub Total',
          amountCurrency: ((orderHistory.amount ?? 0.00) +
                  (orderHistory.couponAmount ?? 0.00))
              .toStringAsFixed(2),
          fontWeight: FontWeight.w500,
        ),
        const Divider(),
        checkoutDetails(
          title: 'VAT Amount',
          amountCurrency: (orderHistory.vatAmount ?? 0.00).toStringAsFixed(2),
          fontWeight: FontWeight.w500,
          currency: true,
        ),
        if (orderHistory.deliveryVat.isGreaterThan(0)) const Divider(),
        checkoutDetails(
          title: 'deliveryVatAmount'.tr(),
          amountCurrency: (orderHistory.deliveryVat ?? 0.00).toStringAsFixed(2),
          fontWeight: FontWeight.w500,
        ),
        if (orderHistory.deliveryVat.isGreaterThan(0)) const Divider(),
        if (couponAmount.isGreaterThan(0))
          checkoutDetails(
            title: 'Coupon Discount',
            amountCurrency: '-${couponAmount.toStringAsFixed(2)}',
            fontWeight: FontWeight.w500,
          ),
        if (couponAmount.isGreaterThan(0)) const Divider(),
        checkoutDetails(
          title: 'Total Price ',
          subtitle: "(Including VAT ${orderHistory.user?.vatPercentage}%)".tr(),
          totalPrice: (orderHistory.totalWithVat ?? 0.00).toStringAsFixed(2),
          fontWeight: FontWeight.w600,
          priceColor: primaryColor,
        ),
        const SizedBox(height: 20),
        Center(
          child: orderHistory.paymentMethod == 'CASH'
              ? Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    CustomButton(
                      hasImage: true,
                      image: "assets/images/order/pdf.png",
                      imagePadding:
                          const EdgeInsets.only(left: 50, top: 10, bottom: 10),
                      title: 'View Receipt',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiptPage(
                              orderDetails: orderHistory,
                              orderSummary: orderSummary,
                            ),
                          ),
                        );
                      },
                    ),
                    if (orderHistory.orderStatus != 'SHIPPED' &&
                        orderHistory.orderStatus != 'COMPLETED')
                      CustomButton(
                        hasImage: false,
                        imagePadding: const EdgeInsets.only(
                            left: 50, top: 10, bottom: 10),
                        title: 'cancelOrder'.tr(),
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('cancelOrderTitle'.tr()),
                              content: Text('cancelOrderContent'.tr()),
                              actions: [
                                TextButton(
                                  child: Text('no'.tr()),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: Text('yes'.tr()),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );
                          if (confirm != true) return;
                          EasyLoading.show(status: 'loading'.tr());

                          final orderNotifier =
                              ref.read(orderHistoryProvider.notifier);
                          try {
                            final success = await orderNotifier
                                .cancelOrder(orderHistory.id!);
                            EasyLoading.dismiss();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'orderCancelledSuccessfully'.tr())),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            EasyLoading.dismiss();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          }
                        },
                      ),
                  ],
                )
              : CustomButton(
                  hasImage: true,
                  image: "assets/images/order/pdf.png",
                  imagePadding:
                      const EdgeInsets.only(left: 50, top: 10, bottom: 10),
                  title: 'View Receipt',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptPage(
                          orderDetails: orderHistory,
                          orderSummary: orderSummary,
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
