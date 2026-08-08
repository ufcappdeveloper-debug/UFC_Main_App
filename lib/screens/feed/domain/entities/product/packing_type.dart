import 'package:ufc_mobile/global/util/common/common_utils.dart';

class PackingType {
  int? id;
  String? name;
  String? description;
  int? multiplier;
  String? createdAt;
  String? updatedAt;
  String? externalRefId;

  PackingType({
    this.id,
    this.name,
    this.description,
    this.multiplier,
    this.createdAt,
    this.updatedAt,
    this.externalRefId,
  });

  PackingType.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    name = parseString(json['name']);
    description = parseString(json['description']);
    multiplier = parseInt(json['multiplier']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    externalRefId = parseString(json['external_ref_id']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['multiplier'] = multiplier;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['external_ref_id'] = externalRefId;
    return data;
  }
}
