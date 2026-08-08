import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

class FeedOrderUtils {
  static Future<void> onOrderStatusPressed(BuildContext context,
      {required OrderModel order}) async {
    // if (order.orderStatus != "COMPLETED") {
    //   if (order.orderType == "DELIVERY") {
    //     // Navigate to the page for delivery
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => DeliveryOrderStatusPage(
    //           orderId: order.id,
    //         ),
    //       ),
    //     );
    //   } else {
    //     // Navigate to the page for other orders
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => OrderStatusPage(
    //           orderId: order.id,
    //         ),
    //       ),
    //     );
    //   }
    // }

    //else

    if (order.id == null) {
      CustomSnackBar.error(context,
          "We couldn't find your order. Please reach out to support for help.");
      return;
    }
    // final future = ref.read(cartProvider).addPastOrder(order.id!);
    context.read<CartCubit>().addPastOrders(order.id!);
    // await LoadingDialog.show(context, future);
    if (!context.mounted) return;
    //
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => BottomBar(initialIndex: 0)),
      (route) => false, // removes all previous routes
    );
    context.read<FeedBottomNavCubit>().changeTab(2);
    context.read<AppBarHeightCubit>().setHeight(31);
    context.read<FeedBackgroundCubit>().updateBackground(AppImages.feedSmallBg);
    context.read<AppBarCubit>().setMode(AppBarMode.channel);
  }
}
