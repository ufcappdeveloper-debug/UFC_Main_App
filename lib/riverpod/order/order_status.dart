import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/models/order_summary_model/order_delivery_status.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/order_service.dart';

// import '../../data/order_service.dart';
// import '../../models/order_history_model.dart';

part "order_status.g.dart";

@Riverpod(keepAlive: true)
class OrderStatus extends _$OrderStatus {
  // late OrderService _orderHistoryService;

  @override
  FutureOr<List<OrderDeliveryStatus>> build() async {
    // _orderHistoryService = OrderService();
    return [];
  }

  Future<void> getOrderStatus(final int orderId) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 10,
      "order_id": orderId,
    };
    try {
      state = AsyncValue.data(await OrderService().getDeliveryStatus(data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadOrders(
    final int page,
    final int orderId,
  ) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 10,
      "order_id": orderId,
    };
    try {
      List<OrderDeliveryStatus> result =
          await OrderService().getDeliveryStatus(data);
      if (result.isEmpty) {
        return "empty";
      }

      state.value?.addAll(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return null;
  }
}

// Future<void> initialLoad(int page, int limit) async {
//   state = const AsyncValue.loading();
//   try {
//     final orderHistoryList =
//         await _orderHistoryService.getUserOrders(page, limit);
//     state = AsyncValue.data(orderHistoryList);
//   } catch (e) {
//     state = AsyncValue.error(e.toString(), StackTrace.current);
//   }
// }

// Future<bool> loadMore(int page, int limit) async {
//   try {
//     final orderHistoryList =
//         await _orderHistoryService.getUserOrders(page, limit);
//     if (orderHistoryList.isEmpty || orderHistoryList.length < limit) {
//       return false;
//     }

//     state = AsyncValue.data([...state.value!, ...orderHistoryList]);
//   } catch (e) {
//     state = AsyncValue.error(e.toString(), StackTrace.current);
//   }
//   return true;
// }
