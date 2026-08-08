import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/cart/pages/cart_page.dart';
import 'package:ufc_mobile/screens/feed_old/orders/pages/delivery_order_status_page.dart';
import 'package:ufc_mobile/screens/feed_old/orders/pages/order_status_page.dart';

class OrderUtils {
  static Future<void> onOrderStatusPressed(BuildContext context, WidgetRef ref,
      {required OrderModel order}) async {
    if (order.orderStatus != "COMPLETED") {
      if (order.orderType == "DELIVERY") {
        // Navigate to the page for delivery
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryOrderStatusPage(
              orderId: order.id,
            ),
          ),
        );
      } else {
        // Navigate to the page for other orders
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderStatusPage(
              orderId: order.id,
            ),
          ),
        );
      }
    } else {
      if (order.id == null) {
        CustomSnackBar.error(context,
            "We couldn't find your order. Please reach out to support for help.");
        return;
      }
      final future = ref.read(cartProvider).addPastOrder(order.id!);
      await LoadingDialog.show(context, future);
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CartPage(
            isPush: true,
          ),
        ),
      );
    }
  }
}
