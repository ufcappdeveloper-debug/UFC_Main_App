import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/enum/order_status_enum.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_card.dart';

class OrdersList extends StatefulWidget {
  final OrderStatusEnum status;
  final List<OrderModel> orders;
  const OrdersList({super.key, required this.status, required this.orders});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? _pageLimit;

  Future<void> _onRefresh() async {
    _pageLimit = null;
    await context.read<MyOrdersCubit>().getMyOrders();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  Future<void> _onLoading() async {
    final cubit = context.read<MyOrdersCubit>();
    cubit.loadMore();
    final pagination = cubit.pagination;
    final bool loadNoMoreData =
        (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1);

    if (loadNoMoreData) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: const CustomPaginationHeader(),
        footer: CustomPaginationFooter(
          height: 30,
          pageLimit: _pageLimit,
          emptyDataText: "No more orders found",
        ),
        child: ListView.builder(
            itemCount: widget.orders.length,
            itemBuilder: (context, index) {
              final order = widget.orders[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 10 : 0),
                child: OrderCard(
                  status: widget.status,
                  order: order,
                ),
              );
            }));
  }
}
