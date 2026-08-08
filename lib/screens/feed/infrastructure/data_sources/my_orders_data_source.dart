import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';

abstract class MyOrdersRemoteDataSource {
  Future<OrderListModel?> getMyOrders(Map<String, dynamic> params);
    Future<OrderListModel?> getOrderDetails(Map<String, dynamic> params);
}
