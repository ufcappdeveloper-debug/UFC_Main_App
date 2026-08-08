import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/order_summary_model/delivery_order_summary_model.dart';
import 'package:ufc_mobile/screens/feed_old/cart/extensions/cart_colors.dart';
import 'package:ufc_mobile/screens/feed_old/orders/widgets/delivery_order/delivery_order_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class OrderDetailsCardView extends StatelessWidget {
  const OrderDetailsCardView({
    super.key,
    required this.order,
  });
  final OrderData? order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CartColors.orderDetailsBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtitleAndValue(
                      title: 'Date'.tr(),
                      value: order?.createdAt.toString() ?? '-'),
                  const SizedBox(height: 20),
                  customtitleAndValue(
                      title: '${'Order'.tr()} #',
                      value: order?.orderId.toString() ?? '-'),
                  const SizedBox(
                    height: 20,
                  ),
                  customtitleAndValue(
                    title: 'From'.tr(),
                    value: isArabic
                        ? order?.fromAr ?? order?.from ?? '-'
                        : isEnglish
                            ? order?.from ?? '-'
                            : order?.fromAr ?? '-',
                  ),
                ],
              ),
              const SizedBox(width: 80),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtitleAndValue(
                      title: 'Date'.tr(),
                      value: order?.createdAt.toString() ?? '-'),
                  const SizedBox(height: 20),
                  customtitleAndValue(
                      title: 'Customer name'.tr(),
                      value: order?.customerName ?? '-'),
                  const SizedBox(
                    height: 20,
                  ),
                  customtitleAndValue(
                      title: 'To'.tr(),
                      value: order?.to?.split(',').firstOrNull ?? '-'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (order?.driver != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: driverContactCardView(
                title: 'Driver Name'.tr(),
                context: context,
                value: order?.driver?.name,
                driverImg: order?.driver?.photo,
                customerPhone: order?.driver?.phone.toString() ?? '-',
              ),
            ),
        ],
      ),
    );
  }
}
