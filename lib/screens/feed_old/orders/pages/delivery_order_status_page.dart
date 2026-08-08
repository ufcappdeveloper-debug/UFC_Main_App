import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/cart/extensions/cart_colors.dart';
import 'package:ufc_mobile/screens/feed_old/cart/extensions/cart_fonts.dart';
import 'package:ufc_mobile/screens/feed_old/orders/widgets/delivery_order/order_details_card_view.dart';
import 'package:ufc_mobile/screens/feed_old/orders/widgets/delivery_order/vertical_line_with_points.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../riverpod/order/delivery_order_status.dart';

class DeliveryOrderStatusPage extends ConsumerStatefulWidget {
  const DeliveryOrderStatusPage({
    super.key,
    this.orderId,
  });
  final int? orderId;

  @override
  ConsumerState<DeliveryOrderStatusPage> createState() =>
      _DeliveryOrderStatusPageState();
}

class _DeliveryOrderStatusPageState
    extends ConsumerState<DeliveryOrderStatusPage>
    with ScreenEngagementTracker {
  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(deliveryOrderStatusProvider.notifier)
            .fetchOrderStatus(orderId: widget.orderId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderStatus = ref.watch(deliveryOrderStatusProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) {
            bool isRTL = isArabic;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Align(
                  alignment:
                      isRTL ? Alignment.centerRight : Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isRTL ? math.pi : 0),
                        child: Image.asset(
                          'assets/images/Back.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: isRTL ? null : 45,
                  right: isRTL ? 45 : null,
                  child: Text(
                    '${'Order'.tr()} #${widget.orderId}',
                    style: CartFonts.boldTitleTextStyle.copyWith(
                      color: CartColors.boldTitleTextColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: orderStatus.when(
        data: (data) {
          final order = data;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderDetailsCardView(order: order?.data),
                  kHeight20,
                  Text(
                    'Detail Status'.tr(),
                    style: CartFonts.boldHeadingStyle
                        .copyWith(color: CartColors.boldTextColor),
                  ),
                  kHeight20,
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: VerticalLineWithPoints(
                      statusChanges: order?.data?.statusChanges
                              ?.map(
                                (statusChange) => {
                                  'created_at': statusChange.createdAt ?? '',
                                  'description': statusChange.description ?? '',
                                },
                              )
                              .toList() ??
                          [],
                      driverName: order?.data?.driver?.name ?? 'Driver',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Error loading product status')),
      ),
    );
  }
}
