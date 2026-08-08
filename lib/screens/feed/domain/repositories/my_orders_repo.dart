import 'package:ufc_mobile/screens/feed/domain/entities/order/order_details_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_query_params.dart';

abstract class MyOrdersRepository {
  Future<OrderListModel?> getMyOrders(OrderQueryParams params);
  Future<OrderListModel?> getOrderDetails(OrderDetailsQueryParams params);
}
