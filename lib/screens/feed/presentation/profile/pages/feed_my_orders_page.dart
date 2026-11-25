import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_query_params.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/enum/order_status_enum.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_list.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/business_config/business_config_cubit.dart';
import '../../../application/main_source/main_source_orders_cubit.dart';
import '../../../domain/entities/order/order_model.dart';
import '../../main_source/widgets/main_source_orders_list.dart';

class FeedMyOrdersPage extends StatefulWidget {
  const FeedMyOrdersPage({super.key});

  @override
  State<FeedMyOrdersPage> createState() => _FeedMyOrdersPageState();
}

class _FeedMyOrdersPageState extends State<FeedMyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Main Source orders are stored apart (plan §5): 0 = station and
  /// distributor orders (unchanged), 1 = Main Source.
  late final MainSourceOrdersCubit _mainSourceOrders =
      sl<MainSourceOrdersCubit>();
  late int _section =
      context.read<BusinessConfigCubit>().state.isMainSource ? 1 : 0;

  @override
  void initState() {
    super.initState();
    if (!context.read<AuthCubit>().isGuest) _mainSourceOrders.load();

    _tabController =
        TabController(length: OrderStatusEnum.values.length, vsync: this);

    // Initial load (Pending as default, or first enum value)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchOrdersForStatus(OrderStatusEnum.values[_tabController.index]);
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _fetchOrdersForStatus(OrderStatusEnum.values[_tabController.index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mainSourceOrders.close();
    super.dispose();
  }

  /// The tab shows when there are Main Source orders or the mode is
  /// main_source, so older orders of every business stay visible.
  Widget _withMainSourceTab(Widget Function(PreferredSizeWidget? toggle) page) {
    return BlocProvider.value(
      value: _mainSourceOrders,
      child: BlocBuilder<MainSourceOrdersCubit, MainSourceOrdersState>(
        builder: (context, ms) {
          final show = context.watch<BusinessConfigCubit>().state.isMainSource ||
              ms.orders.isNotEmpty;
          if (!show) return page(null);
          final toggle = MainSourceOrdersSwitch(
            selected: _section,
            onChanged: (i) => setState(() => _section = i),
          );
          if (_section == 0) return page(toggle);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    size: 16, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: CustomText(
                  text: 'My Orders', fontSize: 17, fontWeight: FontWeight.w500),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0.5,
              bottom: toggle,
            ),
            body: const MainSourceOrdersList(),
          );
        },
      ),
    );
  }

  /// The existing tab bar, with the switch above it when shown.
  PreferredSizeWidget? _bottom(
      PreferredSizeWidget? tabBar, PreferredSizeWidget? toggle) {
    if (toggle == null) return tabBar;
    return PreferredSize(
      preferredSize: Size.fromHeight(toggle.preferredSize.height +
          (tabBar?.preferredSize.height ?? 0)),
      child: Column(children: [toggle, if (tabBar != null) tabBar]),
    );
  }

  void _fetchOrdersForStatus(OrderStatusEnum status) {
    context.read<MyOrdersCubit>().getMyOrders(
          params: OrderQueryParams(orderStatus: status.getValue),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = ScreenWidthUtils.isWide(context);
    return _withMainSourceTab((toggle) => BlocBuilder<MyOrdersCubit, MyOrdersState>(
      builder: (context, state) {
        final isLoading = state is MyOrdersLoading;
        final hasData = state is MyOrdersLoaded && state.orders.isNotEmpty;
        final orders = hasData ? state.orders : [OrderModel()];
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: _bottom(state is MyOrdersError && isNetworkError(state.message)
                ? null
                : TabBar(
                    controller: _tabController,
                    unselectedLabelColor: PetVeterinaryColors.newPetLightGray,
                    labelColor: Colors.black,
                    indicatorColor: PetVeterinaryColors.borderLeftColor,
                    tabs: OrderStatusEnum.values.map((status) {
                      return Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 9, color: status.color),
                            const SizedBox(width: 3),
                            CustomText(
                              text: status.name.capitalize(),
                              fontSize: isWide ? 15 : 13,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ), toggle),
            title: CustomText(
              text: state is MyOrdersError && isNetworkError(state.message)
                  ? ''
                  : 'My Orders',
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
          ),
          body: TabBarView(
            controller: _tabController,
            children: OrderStatusEnum.values.map((status) {
              return isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : state is MyOrdersError
                      ? isNetworkError(state.message)
                          ? NoInternet(
                              type: AppType.feed,
                              onTap: () => _fetchOrdersForStatus(
                                  OrderStatusEnum.values[_tabController.index]),
                            )
                          : SizedBox(
                              width: 100,
                              child: CustomReloadProviderV2(
                                height: 120,
                                error: state.message,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    _fetchOrdersForStatus(OrderStatusEnum
                                        .values[_tabController.index]);
                                  });
                                },
                              ),
                            )
                      : state is MyOrdersLoaded && state.orders.isEmpty
                          ? Center(
                              child: CustomText(
                                text: 'No orders found',
                                fontSize: 16,
                              ),
                            )
                          : OrdersList(
                              status: status,
                              orders: orders,
                            );
            }).toList(),
          ),
        );
      },
    ));
  }
}
