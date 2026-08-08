import '../repositories/station_repo.dart';

class UpdatePreferredShopUseCase {
  final StationRepository repository;

  UpdatePreferredShopUseCase(this.repository);

  Future<void> call(String shopId) {
    return repository.updatePreferredShop(shopId);
  }
}
