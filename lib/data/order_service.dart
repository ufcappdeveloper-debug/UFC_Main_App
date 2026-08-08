import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:ufc_mobile/models/order_summary_model/delivery_order_summary_model.dart';

import '../global/config/dio.dart';
import '../models/order_summary_model/order_delivery_status.dart';
import '../models/order_summary_model/order_summary_model.dart';
import '../screens/feed/domain/entities/order/order_model.dart';

class OrderService {
  Future<bool> placeOrder(final data) async {
    Response response = await api.post("api/ufc/v1/place_order", data: data);
    return response.statusCode == 200;
  }

  Future<List<OrderModel>> getUserOrders(final data) async {
    Response response = await api.get('api/ufc/v1/get_user_orders', data: data);
    return (response.data["data"]["data"] as List<dynamic>)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  Future<List<OrderSummaryModel>> getOrderSummary(final data) async {
    final response = await api.get(
      "api/ufc/v1/get_order_summary",
      queryParameters: data,
    );
    return (response.data["data"]["data"] as List<dynamic>)
        .map((e) => OrderSummaryModel.fromJson(e))
        .toList();
  }

  Future<List<OrderDeliveryStatus>> getDeliveryStatus(final data) async {
    Response response = await api.get(
        "api/ufc/v1/order_delivery_status/get_delivery_status",
        data: data);

    return (response.data["data"]["data"] as List<dynamic>)
        .map((e) => OrderDeliveryStatus.fromJson(e))
        .toList();
  }

  //  }
  // OrderSummaryModel.fromJson(response.data['project']);
  // Completer<OrderSummaryModel> completer = Completer();
  // OrderSummaryModel youtubeLinkData;
  // try {
  //   Response response = await api.get(
  //     'api/ufc/v1/get_order_summary',
  //     queryParameters: queryParams,
  //   );

  //   youtubeLinkData = OrderSummaryModel.fromJson(response.data['data']);
  //   completer.complete(youtubeLinkData);

  // } catch (e) {
  //   completer.completeError("Error parsing youtube link: ${e.toString()}");
  //   // throw debugdebugPrint("Error parsing youtube link: ${e.toString()}");
  // }

  // return completer.future;

  // debugPrint(response);
  // if (response.data["data"] != null) {

  //   debugPrint("sadfasdfasdfdasF ${response.data["data"]}");
  //   return (response.data["data"] as List<dynamic>)
  //       .map((e) => OrderSummaryModel.fromJson(e))
  //       .toList();
  // }
  // return [];
  // }
  Future getOrderInvoice(final int? orderId, final savePath) async {
    Response response = await api.download(
        "api/ufc/v1/get_order_invoice?order_id=$orderId", savePath);
    return response;
  }

  Future<DeliveryOrderSummary?> getDeliveryOrderStatusDetails(
      final int orderNumber) async {
    try {
      final response =
          await api.get("/api/ufc/v1/order_status_details/$orderNumber"); 

      return DeliveryOrderSummary.fromJson(response.data);
    } catch (e) {
      debugPrint("Error fetching order status details: $e");
      return null;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await api.post(
        "/api/ufc/v1/cancel_order",
        data: {"order_id": orderId},
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error canceling order: $e");
      return false;
    }
  }
}
