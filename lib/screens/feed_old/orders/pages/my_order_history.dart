import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/shared/widgets/custom_pagination_header.dart';
import '../../../feed/domain/entities/order/order_model.dart';
import '../../../../riverpod/order/order_history.dart';
import '../../order_details/pages/order_details.dart';
import '../../saved_address/widget/refresh_footer.dart';
import '../widgets/custom_order.dart';

class MyOrderHistory extends ConsumerStatefulWidget {
  const MyOrderHistory({super.key});

  @override
  ConsumerState<MyOrderHistory> createState() => _MyOrderHistoryState();
}

class _MyOrderHistoryState extends ConsumerState<MyOrderHistory>
    with ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;
  late RefreshController controller;

  @override
  void initState() {
    super.initState();
    page = 1;
    pageLimit = null;
    Future(() => ref.read(orderHistoryProvider.notifier).getOrders());
    controller = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref.read(orderHistoryProvider.notifier).getOrders();
    if (mounted) setState(() {});
    controller.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref.read(orderHistoryProvider.notifier).loadOrders(
          page,
        );
    if (mounted) setState(() {});
    controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final orderHistoryList = ref.watch(orderHistoryProvider);
    ref.listen(orderHistoryProvider, (previous, next) {
      if (mounted && next.isLoading) {
        page = 1;
        controller.resetNoData();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonBackAppBar(title: "My Order History"),
      body: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: controller,
        header: const CustomPaginationHeader(),
        footer: const RefreshFooter(),
        physics: const BouncingScrollPhysics(),
        child: orderHistoryList.when(
          data: (List<OrderModel> data) {
            final orderList = _filterOrderList(data);
            return orderList.isEmpty
                ? Center(
                    child: CustomText(
                      text: "No Order Exist",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : ListView.separated(
                    itemCount: orderList.length,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    itemBuilder: (context, index) {
                      final order = orderList[index];
                      return InkWell(
                        onTap: () {
                          if (order.orderStatus != "CANCELLED") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                  orderHistory: order,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('orderCancelledMessage'.tr())),
                            );
                          }
                        },
                        child: CustomOrder(
                          orderModel: order,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      final order = orderList[index];
                      return order.orderItems!.first.product != null
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  );
          },
          error: (error, stack) => CustomReloadProvider(
            height: 118,
            onPressed: () =>
                ref.read(orderHistoryProvider.notifier).getOrders(),
          ),
          loading: () => const SizedBox(
            height: 157,
            child: Center(
              child: CustomIndicator(padding: 50),
            ),
          ),
        ),
      ),
    );
  }

  List<OrderModel> _filterOrderList(List<OrderModel> data) =>
      data.where((e) => !isListEmpty(e.orderItems)).toList();
}
