import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/delivery_cost_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/delivery_cost/delivery_cost_data_source.dart';

class DeliveryCostRepositoryImpl implements DeliveryCostRepository {
  final DeliveryCostRemoteDataSource remoteDataSource;
  DeliveryCostRepositoryImpl(this.remoteDataSource);

  @override
  Future<DeliveryCostResponse> calculateDeliveryCost(
      {required int shopId, required int userAddressId}) async {
    try {
      final result =
          await remoteDataSource.calculateDeliveryCost(shopId, userAddressId);

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
