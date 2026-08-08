import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../../../global/shared/constants/constants.dart';
import 'livestock_reports_model.dart';

class PredefinedAnimalDetails {
  String? animalTypeIcon;
  String? animalTypeNameEn;
  String? animalTypeNameAr;
  String? animalTypeNameUr;
  String? gender;
  String? animalRef;
  String? birthDate;
  String? animalMother;
  String? animalFather;
  Weight? weight;

   PredefinedAnimalDetails({
    this.animalTypeIcon,
    this.animalTypeNameAr,
    this.animalTypeNameEn,
    this.animalTypeNameUr,
    this.gender,
    this.animalRef,
    this.birthDate,
    this.animalMother,
    this.animalFather,
    this.weight,
  });


  PredefinedAnimalDetails.fromJson(Map<String, dynamic> json) {
    animalTypeIcon = parseString(json['animal_type']?['animal_icon']);
    animalTypeNameEn = parseString(json['animal_type']?['animal_type']);
    animalTypeNameAr = parseString(json['animal_type']?['animal_type_ar']);
    animalTypeNameUr = parseString(json['animal_type']?['animal_type_ur']);
    gender = parseString(_extractValue(json, 'gender'));
    animalRef = parseString(_extractValue(json, 'animal_ref'));
    birthDate = parseString(_extractValue(json, 'birth_date'));
    animalMother = parseString(_extractValue(json, 'animal_mother'));
    animalFather = parseString(_extractValue(json, 'animal_father'));
    weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
  }

  static dynamic _extractValue(Map<String, dynamic> json, String key) {
    if (json[key] != null && json[key] is Map<String, dynamic>) {
      final inner = json[key];
      if (inner['question_key'] == 'animal_mother' &&
          inner.containsKey('animal_mother')) {
        return inner['animal_mother'];
      }

      if (inner.containsKey('value')) {
        return inner['value'];
      }
    }
    return null;
  }

  String get animalTypeName => isArabic
      ? animalTypeNameAr ?? animalTypeNameEn ?? ''
      : isUrdu
          ? animalTypeNameUr ?? animalTypeNameEn ?? ''
          : animalTypeNameEn ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['animal_type'] = animalTypeIcon;
    data['gender'] = gender;
    if (weight != null) {
      data['weight'] = weight!.toJson();
    }
    return data;
  }
}

class Weight {
  double? weight;
  String? weightDate;

  Weight({this.weight, this.weightDate});

  Weight.fromJson(Map<String, dynamic> json) {
    weight = parseDouble(json['weight']);
    weightDate = parseString(json['weight_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weight'] = weight;
    data['weight_date'] = weightDate;
    return data;
  }
}


class AnimalDetailsAsAnswer {
  Answer? animalType;
  Answer? gender;
  Answer? animalRef;
  Answer? birthDate;
  Answer? animalMother;
  Answer? animalFather;

  AnimalDetailsAsAnswer({
    this.animalFather,
    this.animalMother,
    this.animalRef,
    this.animalType,
    this.birthDate,
    this.gender,
  });

  AnimalDetailsAsAnswer.fromJson(Map<String, dynamic> json) {
    animalType = _extractValue(json, 'animal_type');
    gender = _extractValue(json, 'gender');
    animalRef = _extractValue(json, 'animal_ref');
    birthDate = _extractValue(json, 'birth_date');
    animalMother = _extractValue(json, 'animal_mother');
    animalFather = _extractValue(json, 'animal_father');
  }

static Answer? _extractValue(Map<String, dynamic> json, String key) {
    for (final entry in json.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        if (value['question_key'] == key) {
        final answer = Answer.fromJson(value);
          return answer;
        }
      }
    }
    return null;
  }
}
