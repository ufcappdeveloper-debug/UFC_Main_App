import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/status_step.dart';

// class OrderStatusCard extends StatelessWidget {
//   final List<OrderDeliveryStatus>? status;

//   const OrderStatusCard({super.key, this.status});

//   @override
//   Widget build(BuildContext context) {
//     final list = status ?? [];
//     return InfoCard(
//       padding: const EdgeInsets.only(bottom: 10),
//       title: 'Order Status',
//       child: FittedBox(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ...list.map((status) => Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: StatusStep(
//                     height: 24,
//                     label: status.description ?? '',
//                     direction: Axis.vertical,
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

class OrderStatusCard extends StatelessWidget {
  final OrderStatus currentStatus;
  final OrderModel order;

  const OrderStatusCard({
    super.key,
    required this.currentStatus,
    required this.order,
  });

  List<String> get steps {
    if (order.orderType != 'DELIVERY') {
      return const [
        "Order Placed",
        "Preparing",
        "Ready for Pickup",
        "Received",
      ];
    } else {
      return const [
        "Order Placed",
        "Preparing",
        "Shipped",
        "Delivered",
      ];
    }
  }

  int getStepIndex(OrderStatus status, String orderType) {
    final isPickup = orderType != 'DELIVERY';

    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.shipped:
        return isPickup ? -1 : 2; // shipped only exists for delivery
      case OrderStatus.scheduled:
        return isPickup ? 2 : -1; // scheduled only used for pickup
      case OrderStatus.completed:
        return 3;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = getStepIndex(currentStatus, order.orderType ?? '');

    return InfoCard(
      padding: const EdgeInsets.only(bottom: 10),
      title: 'Order Status',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isActive = index <= currentStep;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: StatusStep(
              height: 24,
              label: label,
              direction: Axis.vertical,
              isActive: isActive,
            ),
          );
        }).toList(),
      ),
    );
  }
}
