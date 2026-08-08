class AnimalDeathModel {
  final int? id;
  final int? userId;
  final String? animalRef;
  final String? animalUniqueKey;
  final DateTime? deathDate;
  final String? deathReason;
  final String? deathCause;

  AnimalDeathModel({
    this.id,
    this.userId,
    this.animalRef,
    this.animalUniqueKey,
    this.deathDate,
    this.deathReason,
    this.deathCause,
  });

  factory AnimalDeathModel.fromJson(Map<String, dynamic> json) {
    return AnimalDeathModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      animalRef: json['animal_ref']?.toString(),
      animalUniqueKey: json['animal_unique_key']?.toString(),
      deathDate: DateTime.tryParse(json['death_date']?.toString() ?? ''),
      deathReason: json['death_reason']?.toString(),
      deathCause: json['death_cause']?.toString(),
    );
  }
}
