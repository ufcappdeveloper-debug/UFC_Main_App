import '../repositories/livestock_repo.dart';

class EditVaccineUsecase {
  final LiveStockRepository repository;

  EditVaccineUsecase(this.repository);

  Future<void> call(Map<String, dynamic> param) async {
    await repository.updateVaccine(param);
  }
}
