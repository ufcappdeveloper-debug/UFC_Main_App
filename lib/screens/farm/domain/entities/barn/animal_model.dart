class AnimalModel {
  String? animalRef;
  String? animalUniqueKey;
  String? animalType;
  String? animalIcon;
  String? gender;
  double? weightKg;
  String? birthDate;
  DateTime? deathDate;
  double? ageYears;
  String? category;
  int? categoryId;
  String? categoryKey;

  AnimalModel({
    this.animalRef,
    this.animalUniqueKey,
    this.animalType,
    this.animalIcon,
    this.gender,
    this.weightKg,
    this.birthDate,
    this.deathDate,
    this.ageYears,
    this.category,
    this.categoryId,
    this.categoryKey,
  });

  AnimalModel.fromJson(Map<String, dynamic> json) {
    animalRef = json['animal_ref'];
    animalUniqueKey = json['animal_unique_key'];
    animalType = json['animal_type']?.toString() ?? json['string_answer'];
    animalIcon = json['animal_icon'] ?? json['category_icon'];
    gender = json['gender'];
    weightKg = double.tryParse(
        json['weight_kg']?.toString() ?? json['weight']?.toString() ?? '');
    birthDate = json['birth_date'];
    deathDate = DateTime.tryParse(json['death_date']?.toString() ?? '');
    ageYears = double.tryParse(json['age_years']?.toString() ?? '');
    categoryId = int.tryParse(json['category_id']?.toString() ?? '');
    categoryKey = json['category_key'];
    category = json['category_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['animal_ref'] = animalRef;
    data['animal_type'] = animalType;
    data['animal_icon'] = animalIcon;
    data['gender'] = gender;
    data['weight_kg'] = weightKg;
    data['birth_date'] = birthDate;
    data['age_years'] = ageYears;
    return data;
  }
}

class AnimalCategoryModel {
  String? content;
  int? id;
  String? key;
  String? icon;
  bool? all;

  AnimalCategoryModel(
      {this.content, this.id, this.key, this.all = false, this.icon});

  AnimalCategoryModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    key = json['key'];
    content = json['content'];
    icon = json['icon'] ?? json['category_icon'];
  }
}
