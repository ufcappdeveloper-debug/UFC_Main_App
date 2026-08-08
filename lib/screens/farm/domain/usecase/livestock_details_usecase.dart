import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/livestock_repo.dart';

class GetLiveStockDetailsUseCase {
  final LiveStockRepository repository;

  GetLiveStockDetailsUseCase(this.repository);

  Future<LiveStockDetailsResponse> call(String animalRefId) {
    return repository.getLiveStockDetails(animalRefId);
  }
}
