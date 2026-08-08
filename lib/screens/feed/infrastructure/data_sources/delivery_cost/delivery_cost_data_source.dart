import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';

abstract class DeliveryCostRemoteDataSource {
  Future<DeliveryCostResponse> calculateDeliveryCost(
      int shopId, int userAddressId);
}
