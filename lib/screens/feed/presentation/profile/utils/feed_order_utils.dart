import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/distributor/distributor_cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/feed_channel/feed_channel_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/feed_channel/feed_channel_state.dart';
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
    // Read the (app-level) cubits up front: this context's route is removed
    // below.
    final bottomNav = context.read<FeedBottomNavCubit>();
    final appBarHeight = context.read<AppBarHeightCubit>();
    final background = context.read<FeedBackgroundCubit>();
    final appBar = context.read<AppBarCubit>();
    final channel = context.read<FeedChannelCubit>();
    final navigator = Navigator.of(context);

    if (order.isDistributor) {
      // Distributor orders: /distributor/place_order_again replaces the
      // distributor cart; the shop endpoint returns 400 for them.
      try {
        final skipped = await context
            .read<DistributorCartCubit>()
            .placeOrderAgain(order.id!);
        if (skipped.isNotEmpty && context.mounted) {
          CustomSnackBar.message(
              context, 'Some items are no longer available');
        }
      } catch (e) {
        if (context.mounted) CustomSnackBar.error(context, e.toString());
        return;
      }
      await channel.setChannel(FeedChannel.distributor);
    } else {
      context.read<CartCubit>().addPastOrders(order.id!);
      await channel.setChannel(FeedChannel.station);
    }

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => BottomBar(initialIndex: 0)),
      (route) => false, // removes all previous routes
    );
    bottomNav.changeTab(2);
    appBarHeight.setHeight(31);
    background.updateBackground(AppImages.feedSmallBg);
    appBar.setMode(AppBarMode.channel);
  }
}
