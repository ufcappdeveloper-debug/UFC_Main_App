import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderModel order;

  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    log("order: $order");
    return InfoCard(
      child: Column(
        children: [
          InfoTileV2(
              icon: 'assets/svg/feed/clock.svg',
              title: 'Ordered on',
              value: order.createdAt != null
                  ? DateFormat('MMMdd-yyyy', 'en')
                      .format(DateTime.parse(order.createdAt.toString()))
                  : 'N/A'),
          Divider(color: Colors.grey[400]),
          InfoTileV2(
              icon: 'assets/svg/feed/truck.svg',
              title: order.userAddress == null
                  ? 'Delivery Method'
                  : 'Delivery Address',
              value: order.userAddress == null
                  ? order.orderType == "DELIVERY"
                      ? 'Delivery'
                      : 'Pickup from Station'
                  : order.userAddress?.address ?? '-'),
          Divider(color: Colors.grey[400]),
          InfoTileV2(
              leadingWidget: SaudiRiyalIcon(color: primaryColor),
              title: 'Payment method',
              value:
                  order.paymentMethod != "SADAD" ? order.paymentMethod : null,
              trailingWidget: order.paymentMethod == "SADAD"
                  ? Image.asset("assets/images/global/sadad.png", height: 20)
                  : null),
        ],
      ),
    );
  }
}
