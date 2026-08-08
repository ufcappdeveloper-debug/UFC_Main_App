import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/my_orders_repo.dart';

class GetMyOrdersUseCase {
  final MyOrdersRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<OrderListModel?> call(OrderQueryParams params) {
    return repository.getMyOrders(params);
  }
}
