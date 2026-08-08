import 'package:ufc_mobile/global/util/common/common_utils.dart';

class ProductImageModel {
  int? id;
  int? productId;
  String? location;
  String? createdAt;
  String? updatedAt;
  String? externalRefId;
  ProductImageModel({
    this.id,
    this.productId,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.externalRefId,
  });

  ProductImageModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    productId = parseInt(json['product_id']);
    location = parseString(json['location']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    externalRefId = parseString(json['external_ref_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['external_ref_id'] = externalRefId;
    return data;
  }
}
