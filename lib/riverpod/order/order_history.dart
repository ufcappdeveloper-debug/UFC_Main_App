import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/order_service.dart';
import '../../screens/feed/domain/entities/order/order_model.dart';

// import '../../data/order_service.dart';
// import '../../models/order_history_model.dart';

part "order_history.g.dart";

@Riverpod(keepAlive: true)
class OrderHistory extends _$OrderHistory {
  // late OrderService _orderHistoryService;

  @override
  FutureOr<List<OrderModel>> build() async {
    // _orderHistoryService = OrderService();
    return [];
  }

  Future<bool> placeOrder(final data) async {
    try {
      final result = await OrderService().placeOrder(data);
      if (!result) {
        throw "Failed to place the order";
      }
      return result;
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      log(e.toString());
      throw e.toString();
    }
  }

  Future<void> getOrders() async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 10,
    };
    try {
      state = AsyncValue.data(await OrderService().getUserOrders(data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> getAllOrders() async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 100000,
    };
    try {
      state = AsyncValue.data(await OrderService().getUserOrders(data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadOrders(
    final int page,
  ) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 10,
    };
    try {
      List<OrderModel> result = await OrderService().getUserOrders(data);
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

  Future<bool> cancelOrder(int orderId) async {
    try {
      final result = await OrderService().cancelOrder(orderId);
      if (!result) {
        throw "Failed to cancel the order";
      }

      // Optional: Refresh the order list after cancellation
      await getAllOrders();

      return result;
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      log("Cancel Order Error: $e");
      throw e.toString();
    }
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
