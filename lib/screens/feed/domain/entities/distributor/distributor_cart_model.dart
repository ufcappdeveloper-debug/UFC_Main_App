import 'package:ufc_mobile/global/util/common/common_utils.dart';

import 'distributor_model.dart';
import 'distributor_product_model.dart';

class DistributorCartItemModel {
  int? id;
  int? distributorProductId;
  int? distributorVariantId;
  int quantity = 0;
  String? remarks;
  double price = 0;
  int? stock;
  bool isAvailable = true;
  DistributorProductModel? product;

  DistributorCartItemModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    distributorProductId = parseInt(json['distributor_product_id']);
    distributorVariantId = parseInt(json['distributor_variant_id']);
    quantity = parseInt(json['quantity']) ?? 0;
    remarks = parseString(json['remarks']);
    final variant = json['variant'];
    if (variant is Map) {
      price = parseDouble(variant['price']) ?? 0;
      stock = parseInt(variant['stock']);
      isAvailable = parseBool(variant['is_available']) ?? true;
    }
    product = json['product'] is Map<String, dynamic>
        ? DistributorProductModel.fromJson(json['product'])
        : null;
  }

  double get total => price * quantity;
  String get name => product?.name ?? '';
  String? get image => product?.image;
}

class DistributorCartModel {
  int? distributorId;
  DistributorModel? distributor;
  double totalAmount;
  List<DistributorCartItemModel> items;

  DistributorCartModel({
    this.distributorId,
    this.distributor,
    this.totalAmount = 0,
    this.items = const [],
  });

  factory DistributorCartModel.fromJson(Map<String, dynamic> json) =>
      DistributorCartModel(
        distributorId: parseInt(json['distributor_id']),
        distributor: json['distributor'] is Map<String, dynamic>
            ? DistributorModel.fromJson(json['distributor'])
            : null,
        totalAmount: parseDouble(json['total_amount']) ?? 0,
        items: json['cart'] is List
            ? (json['cart'] as List)
                .whereType<Map<String, dynamic>>()
                .map(DistributorCartItemModel.fromJson)
                .toList()
            : [],
      );

  bool get isEmpty => items.isEmpty;
  int get count => items.fold(0, (a, e) => a + e.quantity);
}

class AddDistributorCartParams {
  final int productId;
  final int variantId;
  final int quantity;
  final String? remarks;
  final bool replaceCart;

  const AddDistributorCartParams({
    required this.productId,
    required this.variantId,
    required this.quantity,
    this.remarks,
    this.replaceCart = false,
  });

  AddDistributorCartParams copyWith({bool? replaceCart}) =>
      AddDistributorCartParams(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
        remarks: remarks,
        replaceCart: replaceCart ?? this.replaceCart,
      );

  Map<String, dynamic> toJson() => {
        'distributor_product_id': productId,
        'distributor_variant_id': variantId,
        'quantity': quantity,
        if (remarks != null && remarks!.isNotEmpty) 'remarks': remarks,
        if (replaceCart) 'replace_cart': true,
      };
}
