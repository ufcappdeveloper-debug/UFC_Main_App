import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/models/order_summary_model/order_summary_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/order_service.dart';

// import '../../data/order_service.dart';
// import '../../models/order_history_model.dart';

part "order_summary.g.dart";

@Riverpod(keepAlive: true)
class OrderSummary extends _$OrderSummary {
  // late OrderService _orderHistoryService;

  @override
  FutureOr<List<OrderSummaryModel>> build() async {
    // _orderHistoryService = OrderService();
    return [];
  }

  Future<void> getOrderSummary(int? orderId) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "order_id": orderId,
      "page": 1,
      "limit": 10,
    };
    try {
      state = AsyncValue.data(await OrderService().getOrderSummary(data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // Future<void> getOrderSummary(int id) async {
  //   state = const AsyncValue.loading();
  //   // final Map<String, dynamic> data = {
  //   //   "id": id,
  //   // };

  //   try {
  //     final orderSummaryModel = await OrderService().getOrderSummary(id: id);
  //     // final orderSummary = state.value!;
  //     // int index = orderSummary.indexWhere((element) => element.id == id);
  //     // orderSummary[index] = orderSummaryModel;
  //     int index = state.value!.indexWhere((element) => element.id == id);
  //     state.value?[index + 1] = orderSummaryModel;
  //     state = AsyncValue.data(state.value!);
  //     // int index = orderSummary.indexWhere((element) => element.id == id);
  //     // orderSummary[index] = orderSummaryModel;
  //     // print("dsfgdsgf ${orderSummary[index]}");
  //     // state = AsyncValue.data(orderSummary.toList());
  //     // } catch (e) {
  //     //   log(state.toString());
  //   } on DioException catch (e) {
  //     state = AsyncValue.error(e.dioMessage, StackTrace.current);
  //   } catch (e) {
  //     log(e.toString());
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  // }
  // }
  //   try {
  //     state = AsyncValue.data((await OrderService().getOrderSummary(data)));
  //   } on DioException catch (e) {
  //     state = AsyncValue.error(e.dioMessage, StackTrace.current);
  //   } catch (e) {
  //     log(e.toString());
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  // }

  // Future<String?> loadOrders(
  //   final int id,
  // ) async {
  //   final Map<String, dynamic> data = {
  //     "id": id,
  //   };
  //   try {
  //     OrderSummaryModel result =
  //         await OrderService().getOrderSummary(data);
  //     if (result.isEmpty) {
  //       return "empty";
  //     }

  //     state.value?.addAll(result);
  //   } on DioException catch (e) {
  //     state = AsyncValue.error(e.dioMessage, StackTrace.current);
  //   } catch (e) {
  //     log(e.toString());
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  //   return null;
  // }
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
