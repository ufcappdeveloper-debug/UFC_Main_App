import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import 'main_source_json.dart';
import 'main_source_model.dart';

/// A size / unit of a product. The cart and checkout always use [id].
class MainSourceVariantModel {
  final int? id;
  final String? size;
  final double price;
  final double? originalPrice;
  final int stock;
  final bool isAvailable;

  const MainSourceVariantModel({
    this.id,
    this.size,
    this.price = 0,
    this.originalPrice,
    this.stock = 0,
    this.isAvailable = true,
  });

  factory MainSourceVariantModel.fromJson(Map<String, dynamic> json) =>
      MainSourceVariantModel(
        id: parseInt(json['id']),
        size: parseString(json['size']),
        price: money(json['price']),
        originalPrice: parseDouble(json['original_price']),
        stock: parseInt(json['stock']) ?? 0,
        isAvailable: parseBool(json['is_available']) ?? true,
      );

  /// Show [originalPrice] struck through only when it is higher.
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}

/// `GET /main-source/products` item and `GET /main-source/products/{id}`.
class MainSourceProductModel {
  final int? id;
  final int? mainSourceId;
  final MainSourceModel? mainSource;
  final MainSourceCategoryModel? category;
  final String? nameEn;
  final String? nameAr;
  final String? nameUr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? descriptionUr;
  final String? sku;
  final String? image;
  final List<String> images;
  final double minPrice;
  final double maxPrice;
  final bool inStock;
  final List<MainSourceVariantModel> variants;

  const MainSourceProductModel({
    this.id,
    this.mainSourceId,
    this.mainSource,
    this.category,
    this.nameEn,
    this.nameAr,
    this.nameUr,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionUr,
    this.sku,
    this.image,
    this.images = const [],
    this.minPrice = 0,
    this.maxPrice = 0,
    this.inStock = true,
    this.variants = const [],
  });

  factory MainSourceProductModel.fromJson(Map<String, dynamic> json) {
    final category = asMapOrNull(json['category']);
    return MainSourceProductModel(
      id: parseInt(json['id']),
      mainSourceId: parseInt(json['main_source_id']),
      mainSource: MainSourceModel.fromJsonOrNull(json['main_source']),
      category:
          category == null ? null : MainSourceCategoryModel.fromJson(category),
      nameEn: parseString(json['name_en']),
      nameAr: parseString(json['name_ar']),
      nameUr: parseString(json['name_ur']),
      descriptionEn: parseString(json['description_en']),
      descriptionAr: parseString(json['description_ar']),
      descriptionUr: parseString(json['description_ur']),
      sku: parseString(json['sku']),
      image: parseString(json['image']),
      images: asStringList(json['images']),
      minPrice: money(json['min_price']),
      maxPrice: money(json['max_price']),
      inStock: parseBool(json['in_stock']) ?? false,
      variants: asList(json['variants'], MainSourceVariantModel.fromJson),
    );
  }

  String get name => localized(nameEn, nameAr, nameUr);
  String get description =>
      localized(descriptionEn, descriptionAr, descriptionUr);

  /// All pictures, the main [image] first, without duplicates.
  List<String> get gallery => {
        if (image != null && image!.isNotEmpty) image!,
        ...images.where((e) => e.isNotEmpty),
      }.toList();

  /// The first size that can be bought, or the first size.
  MainSourceVariantModel? get defaultVariant =>
      variants.where((v) => v.isAvailable).firstOrNull ?? variants.firstOrNull;

  bool get hasPriceRange => maxPrice > minPrice;
}

/// `GET /main-source/home`.
class MainSourceHomeModel {
  final List<MainSourceModel> mainSources;
  final List<MainSourceProductModel> latestProducts;

  const MainSourceHomeModel({
    this.mainSources = const [],
    this.latestProducts = const [],
  });

  factory MainSourceHomeModel.fromJson(Map<String, dynamic> json) =>
      MainSourceHomeModel(
        mainSources: asList(json['main_sources'], MainSourceModel.fromJson),
        latestProducts:
            asList(json['latest_products'], MainSourceProductModel.fromJson),
      );

  List<MainSourceCategoryModel> get categories =>
      mainSources.expand((s) => s.categories).toList();
}
