import '../../../../../global/shared/constants/constants.dart';

class VaccineModel {
  int? id;
  String? vaccineEn;
  String? vaccineAr;
  String? date;
  String? duration;

  VaccineModel({
    this.id,
    this.vaccineEn,
    this.vaccineAr,
    this.duration,
    this.date,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      vaccineAr: json['vaccine_ar'],
      vaccineEn: json['vaccine_en'],
    );
  }

  String get vaccineName =>
      isArabic ? vaccineAr ?? vaccineEn ?? '' : vaccineEn ?? '';

  /// The "Other / أخرى" vaccine type: the user types the vaccine name.
  bool get isOther {
    final values = [vaccineEn, vaccineAr]
        .whereType<String>()
        .map((v) => v.trim().toLowerCase());
    return values.any((v) =>
        v == 'other' ||
        v == 'others' ||
        v.startsWith('other ') ||
        v.startsWith('أخرى') ||
        v.startsWith('اخرى') ||
        v.startsWith('أخري') ||
        v.startsWith('اخري'));
  }
}

class VaccineParam {
  String? gender;
  String? animal;
  bool isCategory;
  List<VaccineSchedules> vaccineSchedules;

  VaccineParam({
    this.gender,
    this.animal,
    required this.vaccineSchedules,
    this.isCategory = false,
  });

  Map<String, dynamic> toJson() {
    return {
      if (gender == 'male' || gender == 'female') "gender": gender,
      if (animal != null && animal != 'All livestock')
        if (isCategory)
          "animal_category": animal
        else
          "animal_unique_key": animal,
      "vaccine_schedules": vaccineSchedules.map((e) => e.toJson()).toList(),
    };
  }
}

class VaccineSchedules {
  /// API field for the name typed for an "Other" vaccine.
  static const otherNameField = 'vaccine_name';

  int? vaccineTypeId;
  int? prohibitionPeriod;
  String? vaccinationDate;

  /// Set for the "Other" vaccine type.
  bool isOther;
  String? otherName;

  VaccineSchedules({
    this.vaccineTypeId,
    this.prohibitionPeriod,
    this.vaccinationDate,
    this.isOther = false,
    this.otherName,
  });

  Map<String, dynamic> toJson() {
    return {
      if (vaccineTypeId != null) "vaccine_type_id": vaccineTypeId,
      if (prohibitionPeriod != null) "prohibition_period": prohibitionPeriod,
      if (vaccinationDate != null) "vaccination_date": vaccinationDate,
      if (isOther && (otherName?.trim().isNotEmpty ?? false))
        otherNameField: otherName!.trim(),
    };
  }
}
