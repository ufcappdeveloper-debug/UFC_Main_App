import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/vaccine_type_model.dart';

class Vaccinations {
  int? id;
  String? animalRef;
  String? animalUniqueKey;
  int? vaccineTypeId;
  int? userId;
  String? vaccinationDate;
  int? prohibitionPeriod;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  VaccineType? vaccineType;

  Vaccinations({
    this.id,
    this.animalRef,
    this.animalUniqueKey,
    this.vaccineTypeId,
    this.userId,
    this.vaccinationDate,
    this.prohibitionPeriod,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.vaccineType,
  });

  Vaccinations.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    animalRef = parseString(json['animal_ref']);
    animalUniqueKey = parseString(json['animal_unique_key']);
    vaccineTypeId = parseInt(json['vaccine_type_id']);
    userId = parseInt(json['user_id']);
    vaccinationDate = parseString(json['vaccination_date']);
    prohibitionPeriod = parseInt(json['prohibition_period']);
    deletedAt = parseString(json['deleted_at']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    vaccineType = json['vaccine_type'] != null
        ? VaccineType.fromJson(json['vaccine_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['animal_ref'] = animalRef;
    data['animal_unique_key'] = animalUniqueKey;
    data['vaccine_type_id'] = vaccineTypeId;
    data['user_id'] = userId;
    data['vaccination_date'] = vaccinationDate;
    data['prohibition_period'] = prohibitionPeriod;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (vaccineType != null) {
      data['vaccine_type'] = vaccineType!.toJson();
    }
    return data;
  }
}
