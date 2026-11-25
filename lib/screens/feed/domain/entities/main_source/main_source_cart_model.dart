import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import 'main_source_json.dart';
import 'main_source_model.dart';

/// A cart line. [id] is the cart line id used by update / delete.
class MainSourceCartItemModel {
  final int? id;
  final int? productId;
  final int? variantId;
  final String? productNameEn;
  final String? productNameAr;
  final String? productNameUr;
  final String? image;
  final String? size;
  final double unitPrice;
  final double? originalPrice;
  final int quantity;
  final double total;
  final int stock;
  final bool isAvailable;

  const MainSourceCartItemModel({
    this.id,
    this.productId,
    this.variantId,
    this.productNameEn,
    this.productNameAr,
    this.productNameUr,
    this.image,
    this.size,
    this.unitPrice = 0,
    this.originalPrice,
    this.quantity = 0,
    this.total = 0,
    this.stock = 0,
    this.isAvailable = true,
  });

  factory MainSourceCartItemModel.fromJson(Map<String, dynamic> json) =>
      MainSourceCartItemModel(
        id: parseInt(json['id']),
        productId: parseInt(json['product_id']),
        variantId: parseInt(json['variant_id']),
        productNameEn: parseString(json['product_name_en']),
        productNameAr: parseString(json['product_name_ar']),
        productNameUr: parseString(json['product_name_ur']),
        image: parseString(json['image']),
        size: parseString(json['size']),
        unitPrice: money(json['unit_price']),
        originalPrice: parseDouble(json['original_price']),
        quantity: parseInt(json['quantity']) ?? 0,
        total: money(json['total']),
        stock: parseInt(json['stock']) ?? 0,
        isAvailable: parseBool(json['is_available']) ?? true,
      );

  String get name => localized(productNameEn, productNameAr, productNameUr);
  bool get hasDiscount => originalPrice != null && originalPrice! > unitPrice;
}

/// `GET /main-source/cart` (also returned by add / update / delete / clear).
class MainSourceCartModel {
  final MainSourceModel? mainSource;
  final List<MainSourceCartItemModel> items;
  final int itemsCount;
  final int quantity;
  final double subtotal;
  final bool hasUnavailableItems;

  const MainSourceCartModel({
    this.mainSource,
    this.items = const [],
    this.itemsCount = 0,
    this.quantity = 0,
    this.subtotal = 0,
    this.hasUnavailableItems = false,
  });

  static const empty = MainSourceCartModel();

  factory MainSourceCartModel.fromJson(Map<String, dynamic> json) =>
      MainSourceCartModel(
        mainSource: MainSourceModel.fromJsonOrNull(json['main_source']),
        items: asList(json['items'], MainSourceCartItemModel.fromJson),
        itemsCount: parseInt(json['items_count']) ?? 0,
        quantity: parseInt(json['quantity']) ?? 0,
        subtotal: money(json['subtotal']),
        hasUnavailableItems:
            parseBool(json['has_unavailable_items']) ?? false,
      );

  bool get isEmpty => items.isEmpty;

  /// Something a stable Equatable key can be built from.
  String get signature =>
      '${mainSource?.id}|${items.map((e) => '${e.id}:${e.quantity}:${e.unitPrice}:${e.isAvailable}').join(',')}|$subtotal';
}

/// `GET /main-source/cart/count`.
class MainSourceCartCount {
  final int items;
  final int quantity;

  const MainSourceCartCount({this.items = 0, this.quantity = 0});

  factory MainSourceCartCount.fromJson(Map<String, dynamic> json) =>
      MainSourceCartCount(
        items: parseInt(json['items']) ?? 0,
        quantity: parseInt(json['quantity']) ?? 0,
      );
}
