import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_model.dart';

import '../../../../../global/shared/constants/constants.dart';

class BarnDetailsModelRes {
  String? status;
  String? message;
  BornDetailsModel? data;

  BarnDetailsModelRes({this.status, this.message, this.data});

  BarnDetailsModelRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? BornDetailsModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BornDetailsModel {
  BarnModel? barn;
  int? animalsCount;
  List<AnimalModel>? animals;
  List<AnimalCategory>? availableCategories;
  List<AnimalCategory>? availableFilters;

  BornDetailsModel({
    this.barn,
    this.animalsCount,
    this.animals,
    this.availableCategories,
    this.availableFilters,
  });

  BornDetailsModel.fromJson(Map<String, dynamic> json) {
    barn = json['barn'] != null ? BarnModel.fromJson(json['barn']) : null;
    animalsCount = json['animals_count'];
    if (json['animals'] != null) {
      animals = <AnimalModel>[];
      json['animals'].forEach((v) {
        animals!.add(AnimalModel.fromJson(v));
      });
    }
    if (json['available_categories'] != null) {
      availableCategories = <AnimalCategory>[];
      json['available_categories'].forEach((v) {
        availableCategories!.add(AnimalCategory.fromJson(v));
      });
    }
    if (json['available_filters'] != null) {
      availableFilters = <AnimalCategory>[];
      json['available_filters'].forEach((v) {
        availableFilters!.add(AnimalCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (barn != null) {
      data['barn'] = barn!.toJson();
    }
    data['animals_count'] = animalsCount;
    if (animals != null) {
      data['animals'] = animals!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  BornDetailsModel copyWith({
    BarnModel? barn,
    int? animalsCount,
    List<AnimalModel>? animals,
    List<AnimalCategory>? availableCategories,
  }) {
    return BornDetailsModel(
      barn: barn ?? this.barn,
      animalsCount: animalsCount ?? this.animalsCount,
      animals: animals ?? this.animals,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}

class AnimalCategory {
  final String? key;
  final String? content;
  final String? contentAr;
  final String? contentUr;

  AnimalCategory({
    this.key,
    this.content,
    this.contentAr,
    this.contentUr,
  });

  factory AnimalCategory.fromJson(Map<String, dynamic> json) {
    return AnimalCategory(
      key: json['key'],
      content: json['content'],
      contentAr: json['content_ar'],
      contentUr: json['content_ur'],
    );
  }

  String get name => isArabic
      ? contentAr ?? content ?? ''
      : isUrdu
          ? contentUr ?? content ?? ''
          : content ?? '';
}
