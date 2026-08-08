import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/order_service.dart';
import 'package:ufc_mobile/models/order_summary_model/delivery_order_summary_model.dart';

part 'delivery_order_status.g.dart';

@riverpod
class DeliveryOrderStatus extends _$DeliveryOrderStatus {
  late final OrderService _orderService;

  @override
  FutureOr<DeliveryOrderSummary?> build() async {
    _orderService = OrderService();
    return null;
  }

  Future<DeliveryOrderSummary?> fetchOrderStatus({
    required int orderId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response =
          await _orderService.getDeliveryOrderStatusDetails(orderId);

      if (response?.status == 'success') {
        state = AsyncValue.data(response);
        return response;
      } else {
        state = AsyncValue.error(
            'Failed to fetch order status. Status: ${response?.status}',
            StackTrace.current);
        return null;
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return null;
    }
  }
}
