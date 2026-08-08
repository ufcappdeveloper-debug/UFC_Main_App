class ShopCarrierGroupModel {
  int? id;
  String? nameEn;
  String? nameAr;
  String? image;
  String? descriptionEn;
  String? descriptionAr;
  String? externalRefId;
  String? createdAt;
  String? updatedAt;
  List<ShopCarriermodel>? shopCarriers;

  ShopCarrierGroupModel(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.image,
      this.descriptionEn,
      this.descriptionAr,
      this.externalRefId,
      this.createdAt,
      this.updatedAt,
      this.shopCarriers});

  ShopCarrierGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
    image = json['image'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    externalRefId = json['external_ref_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['shop_carriers'] != null) {
      shopCarriers = <ShopCarriermodel>[];
      json['shop_carriers'].forEach((v) {
        shopCarriers!.add(ShopCarriermodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    data['image'] = image;
    data['description_en'] = descriptionEn;
    data['description_ar'] = descriptionAr;
    data['external_ref_id'] = externalRefId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (shopCarriers != null) {
      data['shop_carriers'] = shopCarriers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopCarriermodel {
  int? id;
  int? shopId;
  int? shopCarrierGroupId;
  String? countryCode;
  String? phoneNumber;
  String? alphaCode;
  String? externalRefId;
  String? createdAt;
  String? updatedAt;

  ShopCarriermodel(
      {this.id,
      this.shopId,
      this.shopCarrierGroupId,
      this.countryCode,
      this.phoneNumber,
      this.alphaCode,
      this.externalRefId,
      this.createdAt,
      this.updatedAt});

  ShopCarriermodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    shopCarrierGroupId = json['shop_carrier_group_id'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    alphaCode = json['alpha_code'];
    externalRefId = json['external_ref_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['shop_carrier_group_id'] = shopCarrierGroupId;
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['alpha_code'] = alphaCode;
    data['external_ref_id'] = externalRefId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
