import '../entities/barn/animal_model.dart';
import '../repositories/death_repo.dart';

class DeathUsecase {
  final DeathRepository repository;

  DeathUsecase(this.repository);

  Future<List<AnimalModel>> call(Map<String, dynamic> param) {
    return repository.getDeath(param);
  }
}
