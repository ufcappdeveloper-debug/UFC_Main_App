import 'package:ufc_mobile/models/banner_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

class HomeModel {
  List<ProductModel>? topOfWeek;
  List<BannerModel>? bannerBig;
  List<BannerModel>? bannerMini;

  HomeModel({this.topOfWeek, this.bannerBig, this.bannerMini});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      topOfWeek = <ProductModel>[];
      json['products'].forEach((v) {
        topOfWeek!.add(ProductModel.fromJson(v));
      });
    }
    if (json['banner_big'] != null) {
      bannerBig = <BannerModel>[];
      json['banner_big'].forEach((v) {
        bannerBig!.add(BannerModel.fromJson(v));
      });
    }
    if (json['banner_mini'] != null) {
      bannerMini = <BannerModel>[];
      json['banner_mini'].forEach((v) {
        bannerMini!.add(BannerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topOfWeek != null) {
      data['products'] = topOfWeek!.map((v) => v.toJson()).toList();
    }
    if (bannerBig != null) {
      data['banner_big'] = bannerBig!.map((v) => v.toJson()).toList();
    }
    if (bannerMini != null) {
      data['banner_mini'] = bannerMini!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class HomeProductModel {
//   int? id;
//   int? shopId;
//   int? categoryId;
//   String? nameAr;
//   String? nameEn;
//   String? descriptionEn;
//   String? descriptionAr;
//   String? productType;
//   String? sku;
//   String? createdAt;
//   String? updatedAt;
//   double? rating;
//   int? ratingCount;
//   int? orderCount;
//   List<ProductImageModel>? images;
//   CategoryModel? category;

//   HomeProductModel({
//     this.id,
//     this.shopId,
//     this.categoryId,
//     this.nameAr,
//     this.nameEn,
//     this.descriptionEn,
//     this.descriptionAr,
//     this.productType,
//     this.sku,
//     this.createdAt,
//     this.updatedAt,
//     this.rating,
//     this.ratingCount,
//     this.orderCount,
//     this.images,
//     this.category,
//   });

//   HomeProductModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     shopId = json['shop_id'];
//     categoryId = json['category_id'];
//     nameAr = json['name_ar'];
//     nameEn = json['name_en'];
//     descriptionEn = json['description_en'];
//     descriptionAr = json['description_ar'];
//     productType = json['product_type'];
//     sku = json['sku'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     rating = json['rating'] != null ? double.parse(json['rating']) : null;
//     ratingCount = json['rating_count'];
//     orderCount = json['order_count'];
//     if (json['images'] != null) {
//       images = <ProductImageModel>[];
//       json['images'].forEach((v) {
//         images!.add(ProductImageModel.fromJson(v));
//       });
//     }
//     category = json['category'] != null
//         ? CategoryModel.fromJson(json['category'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['shop_id'] = shopId;
//     data['category_id'] = categoryId;
//     data['name_ar'] = nameAr;
//     data['name_en'] = nameEn;
//     data['description_en'] = descriptionEn;
//     data['description_ar'] = descriptionAr;
//     data['product_type'] = productType;
//     data['sku'] = sku;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['rating'] = rating;
//     data['rating_count'] = ratingCount;
//     data['order_count'] = orderCount;
//     if (images != null) {
//       data['images'] = images!.map((v) => v.toJson()).toList();
//     }
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     return data;
//   }
// }
