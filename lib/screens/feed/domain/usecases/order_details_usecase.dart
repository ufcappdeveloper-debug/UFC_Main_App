import 'package:ufc_mobile/screens/feed/domain/entities/order/order_details_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/my_orders_repo.dart';

class GetOrderDetailsUseCase {
  final MyOrdersRepository repository;
  GetOrderDetailsUseCase(this.repository);

  Future<OrderListModel?> call(OrderDetailsQueryParams params) {
    return repository.getOrderDetails(params);
  }
}