import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/my_orders_data_source.dart';

class MyOrdersRemoteDataSourceImpl implements MyOrdersRemoteDataSource {
  final Dio dio;

  MyOrdersRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderListModel?> getMyOrders(Map<String, dynamic> params) async {
    try {
      Response response =
          await api.get("api/ufc/v1/get_user_orders", queryParameters: params);
      OrderListModel? orderListModel =
          OrderResponseModel.fromJson(response.data).orders;
      return orderListModel;
      } catch (e) {
      rethrow;
    }
  }


   @override
  Future<OrderListModel?> getOrderDetails(Map<String, dynamic> params) async {
    try {
      Response response =
          await api.get("api/ufc/v1/get_order_summary", data: params);
      OrderListModel? orderListModel =
          OrderResponseModel.fromJson(response.data).orders;
      return orderListModel;
    } catch (e) {
      rethrow;
    }
  }
  
}
