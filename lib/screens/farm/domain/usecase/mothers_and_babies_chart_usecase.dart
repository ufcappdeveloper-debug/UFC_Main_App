import '../entities/mothers_and_babies.dart';
import '../repositories/mothers_babies_repo.dart';

class MothersAndbabiesChartUsecase {
  final MothersBabiesRepoitory repository;

  MothersAndbabiesChartUsecase(this.repository);

  Future<MothersBabiesChart> call(String? animalCategory) {
    return repository.getChart(animalCategory);
  }
}
