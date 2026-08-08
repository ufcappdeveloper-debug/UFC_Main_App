import 'package:ufc_mobile/screens/feed/domain/entities/order/order_details_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/my_orders_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/my_orders_data_source.dart';

class MyOrdersRepositoryImpl implements MyOrdersRepository {
  final MyOrdersRemoteDataSource remoteDataSource;

  MyOrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<OrderListModel?> getMyOrders(OrderQueryParams params) async {
    try {
      final result = await remoteDataSource.getMyOrders(params.toJson());

      return result;
   } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderListModel?> getOrderDetails(OrderDetailsQueryParams params) async {
    try {
      final result = await remoteDataSource.getOrderDetails(params.toJson());

      return result;
      } catch (e) {
      rethrow;
    }
  }
}
