import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';

class AnimalData {
  final List<AnimalModel>? animals;
  final List<AnimalCategoryModel>? animalCategories;
  String? selectedAnimalRef;
  String? selectedAnimalKey;

  AnimalData({
    this.animals,
    this.animalCategories,
    this.selectedAnimalRef,
    this.selectedAnimalKey,
  });

  factory AnimalData.fromJson(Map<String, dynamic> json) {
    return AnimalData(
      animals: (json['animals'] as List<dynamic>?)
          ?.map((e) => AnimalModel.fromJson(e))
          .toList(),
      animalCategories: (json['animals_categories'] as List<dynamic>?)
          ?.map((e) => AnimalCategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animals': animals?.map((e) => e.toJson()).toList(),
      'animals_categories': animalCategories,
    };
  }
}

class Animal {
  final String? animalRef;
  final String? stringAnswer;
  final String? animalUniqueKey;

  Animal({
    this.animalRef,
    this.stringAnswer,
    this.animalUniqueKey,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      animalRef: json['animal_ref'] as String?,
      stringAnswer: json['string_answer'] as String?,
      animalUniqueKey: json['animal_unique_key'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animal_ref': animalRef,
      'string_answer': stringAnswer,
      'animal_unique_key': animalUniqueKey,
    };
  }
}
