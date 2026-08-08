import '../entities/barn/animal_model.dart';
import '../entities/mothers_and_babies.dart';

abstract class MothersBabiesRepoitory {
  Future<List<AnimalModel>> getAnimals(Map<String, dynamic> param);
  Future<MothersBabiesChart> getChart(String? animalCategory);
}
