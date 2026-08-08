import '../repositories/livestock_repo.dart';

class DeleteLivestockUsecase {
  final LiveStockRepository repository;

  DeleteLivestockUsecase(this.repository);

  Future<void> call(String animalKey) async {
    await repository.deleteLiveStock(animalKey);
  }
}
