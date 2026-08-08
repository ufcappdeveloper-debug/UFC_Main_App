import '../repositories/livestock_repo.dart';

class DeleteVaccineUsecase {
  final LiveStockRepository repository;

  DeleteVaccineUsecase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteVaccine(id);
  }
}
