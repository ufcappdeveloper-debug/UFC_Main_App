import '../repositories/livestock_repo.dart';

class UpdateDeathUsecase {
  final LiveStockRepository repository;

  UpdateDeathUsecase(this.repository);

  Future<void> call(Map<String, dynamic> param, int deathId) async {
    await repository.updateDeath(param, deathId);
  }
}
