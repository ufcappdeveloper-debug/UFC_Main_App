import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';

import '../../../application/main_source/main_source_orders_cubit.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../pages/main_source_order_details_page.dart';
import '../utils/main_source_errors.dart';
import '../utils/main_source_status.dart';

/// "Stations & Distributors | Main Source" switch of My Orders.
class MainSourceOrdersSwitch extends StatelessWidget implements PreferredSizeWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const MainSourceOrdersSwitch(
      {super.key, required this.selected, required this.onChanged});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    Widget segment(String label, int index) {
      final isSelected = selected == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? DistributorStyle.green : Colors.transparent,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(label.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DistributorStyle.style(
                    size: 12,
                    weight: FontWeight.w500,
                    color: isSelected ? Colors.white : DistributorStyle.text)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: DistributorStyle.card(radius: 20),
        child: Row(
          children: [
            segment('Stations & Distributors', 0),
            segment('Main Source', 1),
          ],
        ),
      ),
    );
  }
}

/// Paginated Main Source orders (needs a [MainSourceOrdersCubit] above).
class MainSourceOrdersList extends StatelessWidget {
  const MainSourceOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSourceOrdersCubit, MainSourceOrdersState>(
      builder: (context, state) {
        final cubit = context.read<MainSourceOrdersCubit>();
        if (state.loading && state.orders.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: DistributorStyle.green));
        }
        if (state.error != null && state.orders.isEmpty) {
          return CustomReloadProviderV2(
            error: mainSourceErrorText(state.error!),
            height: 140,
            decoration: const BoxDecoration(color: Colors.transparent),
            onPressed: cubit.load,
          );
        }
        if (state.orders.isEmpty) {
          return RefreshIndicator(
            color: DistributorStyle.green,
            onRefresh: cubit.load,
            child: ListView(
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Text('No orders found'.tr(),
                      style: DistributorStyle.style(size: 16)),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: DistributorStyle.green,
          onRefresh: cubit.load,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 300) cubit.loadMore();
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              itemCount: state.orders.length + (state.loadingMore ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= state.orders.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: DistributorStyle.green)),
                  );
                }
                final order = state.orders[i];
                return _OrderCard(
                  order: order,
                  onTap: order.id == null
                      ? null
                      : () async {
                          await openMainSourceOrder(context, order.id!);
                          // Status / payment may have changed.
                          cubit.load();
                        },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final MainSourceOrderModel order;
  final VoidCallback? onTap;

  const _OrderCard({required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final created = order.createdAt;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: DistributorStyle.card(radius: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageWithPlaceHolder(
                  imageUrl: order.image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(order.orderNumber ?? '#${order.id}',
                            style: DistributorStyle.style(
                                size: 13, weight: FontWeight.w600)),
                      ),
                      OutlineChip(
                          label: orderStatusLabel(order.orderStatus),
                          color: orderStatusColor(order.orderStatus)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      order.mainSource?.name ?? '',
                      'ms_items_count'
                          .tr(namedArgs: {'count': '${order.itemsCount}'}),
                    ].where((e) => e.isNotEmpty).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DistributorStyle.style(
                        size: 12, color: DistributorStyle.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          [
                            if (created != null)
                              DateFormat('yyyy-MM-dd', 'en').format(created),
                            paymentStatusLabel(order.paymentStatus).tr(),
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DistributorStyle.style(
                              size: 11,
                              color: paymentStatusColor(order.paymentStatus)),
                        ),
                      ),
                      RiyalAmount(order.totalWithVat, size: 13),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
