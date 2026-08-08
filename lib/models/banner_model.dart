class BannerModel {
  int? id;
  int? shopId;
  String? imageUrlEn;
  String? imageUrlAr;
  String? imageUrlUr;
  String? offerTitle;
  String? offerAt;
  String? offerAmount;
  int? offerIsPercentage;
  String? expiredAt;
  int? createdBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? shopIdList;
  int? productId;
  int? categoryId;
  String? productIdList;
  String? categoryIdList;
  String? goTo;
  String? mainHeading;
  String? subHeading;
  String? imageUrl;
  String? logoUrl;

  BannerModel({
    this.id,
    this.shopId,
    this.imageUrlEn,
    this.imageUrlAr,
    this.imageUrlUr,
    this.offerTitle,
    this.offerAt,
    this.offerAmount,
    this.offerIsPercentage,
    this.expiredAt,
    this.createdBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.shopIdList,
    this.productId,
    this.categoryId,
    this.productIdList,
    this.categoryIdList,
    this.goTo,
    this.mainHeading,
    this.subHeading,
    this.imageUrl,
    this.logoUrl,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    imageUrlEn = json['image_url_en'];
    imageUrlAr = json['image_url_ar'];
    imageUrlUr = json['image_url_ur'];
    offerTitle = json['offer_title'];
    offerAt = json['offer_at'];
    offerAmount = json['offer_amount'];
    offerIsPercentage = json['offer_is_percentage'];
    expiredAt = json['expired_at'];
    createdBy = json['created_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shopIdList = json['shop_id_list'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    productIdList = json['product_id_list'];
    categoryIdList = json['category_id_list'];
    goTo = json['go_to'];
    mainHeading = json['main_heading'];
    subHeading = json['sub_heading'];
    imageUrl = json['image_url'];
    logoUrl = json['logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['image_url_en'] = imageUrlEn;
    data['image_url_ar'] = imageUrlAr;
    data['image_url_ur'] = imageUrlUr;
    data['offer_title'] = offerTitle;
    data['offer_at'] = offerAt;
    data['offer_amount'] = offerAmount;
    data['offer_is_percentage'] = offerIsPercentage;
    data['expired_at'] = expiredAt;
    data['created_by'] = createdBy;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['shop_id_list'] = shopIdList;
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    data['product_id_list'] = productIdList;
    data['category_id_list'] = categoryIdList;
    data['go_to'] = goTo;
    return data;
  }
}
