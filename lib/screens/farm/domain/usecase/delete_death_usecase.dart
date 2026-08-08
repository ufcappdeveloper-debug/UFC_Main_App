import '../repositories/livestock_repo.dart';

class DeleteDeathUseCase {
  final LiveStockRepository repository;

  DeleteDeathUseCase(this.repository);

  Future<void> call(int deathId) async {
    await repository.deleteDeath(deathId);
  }
}
