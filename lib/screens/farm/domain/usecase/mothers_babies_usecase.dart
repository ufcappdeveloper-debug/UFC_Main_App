import '../entities/barn/animal_model.dart';
import '../repositories/mothers_babies_repo.dart';

class MothersBabiesUsecase {
  final MothersBabiesRepoitory repository;

  MothersBabiesUsecase(this.repository);

  Future<List<AnimalModel>> call(Map<String, dynamic> param) {
    return repository.getAnimals(param);
  }
}
