import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';

abstract class DeliveryCostRepository {
  Future<DeliveryCostResponse> calculateDeliveryCost({
    required int shopId,
    required int userAddressId,
  });
}