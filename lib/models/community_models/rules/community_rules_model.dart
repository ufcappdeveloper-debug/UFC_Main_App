class CommunityRulesModel {
  int? id;
  String? titleEn;
  String? titleAr;
  String? titleUr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionUr;
  String? createdAt;
  String? updatedAt;

  CommunityRulesModel(
      {this.id,
      this.titleEn,
      this.titleAr,
      this.titleUr,
      this.descriptionEn,
      this.descriptionAr,
      this.descriptionUr,
      this.createdAt,
      this.updatedAt});

  CommunityRulesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    titleUr = json['title_ur'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    descriptionUr = json['description_ur'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title_en'] = titleEn;
    data['title_ar'] = titleAr;
    data['title_ur'] = titleUr;
    data['description_en'] = descriptionEn;
    data['description_ar'] = descriptionAr;
    data['description_ur'] = descriptionUr;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
