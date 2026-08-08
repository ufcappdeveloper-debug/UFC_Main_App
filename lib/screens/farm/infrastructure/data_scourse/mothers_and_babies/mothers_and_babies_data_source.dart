import '../../../domain/entities/barn/animal_model.dart';
import '../../../domain/entities/mothers_and_babies.dart';

abstract class MothersAndBabiesDataSource {
  Future<List<AnimalModel>> getAnimals(Map<String, dynamic> param);
  Future<MothersBabiesChart> getChart(String? animalCategory);
}
