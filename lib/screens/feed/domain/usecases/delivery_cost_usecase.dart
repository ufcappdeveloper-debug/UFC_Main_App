import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/delivery_cost_repo.dart';

class CalculateDeliveryCostUseCase {
  final DeliveryCostRepository repository;

  CalculateDeliveryCostUseCase(this.repository);

  Future<DeliveryCostResponse?> call(
    int shopId,
    int userAddressId,
  ) {
    return repository.calculateDeliveryCost(
      shopId: shopId,
      userAddressId: userAddressId,
    );
  }
}
