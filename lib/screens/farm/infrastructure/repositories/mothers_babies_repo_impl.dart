import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';

import 'package:ufc_mobile/screens/farm/domain/entities/mothers_and_babies.dart';

import '../../domain/repositories/mothers_babies_repo.dart';
import '../data_scourse/mothers_and_babies/mothers_and_babies_data_source.dart';

class MothersBabiesRepoImpl implements MothersBabiesRepoitory{
  final MothersAndBabiesDataSource dataSource;

  MothersBabiesRepoImpl(this.dataSource);

  @override
  Future<List<AnimalModel>> getAnimals(Map<String, dynamic> param) async {
    return await dataSource.getAnimals(param);
  }

  @override
  Future<MothersBabiesChart> getChart(String? animalCategory) async {
    return await dataSource.getChart(animalCategory);
  }
}