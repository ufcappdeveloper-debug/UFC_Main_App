// import 'package:collection/collection.dart';

// class UserPointsModel {
//   String? status;
//   UserData? data;

//   UserPointsModel({this.status, this.data});

//   factory UserPointsModel.fromJson(Map<String, dynamic> json) {
//     return UserPointsModel(
//       status: json['status'] as String?,
//       data: json['data'] != null ? UserData.fromJson(json['data']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'status': status,
//         'data': data?.toJson(),
//       };

//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     if (other is! UserPointsModel) return false;
//     final mapEquals = const DeepCollectionEquality().equals;
//     return mapEquals(other.toJson(), toJson());
//   }

//   @override
//   int get hashCode => status.hashCode ^ data.hashCode;
// }

// class UserData {
//   int? userPoints;
//   List<Tier>? tiers;
//   List<Voucher>? vouchers;
//   List<Product>? products;

//   UserData({this.userPoints, this.tiers, this.vouchers, this.products});

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       userPoints: json['user_points'] as int?,
//       tiers: (json['tiers'] as List<dynamic>?)
//           ?.map((e) => Tier.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       vouchers: (json['vouchers'] as List<dynamic>?)
//           ?.map((e) => Voucher.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       products: (json['products'] as List<dynamic>?)
//           ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'user_points': userPoints,
//         'tiers': tiers?.map((e) => e.toJson()).toList(),
//         'vouchers': vouchers?.map((e) => e.toJson()).toList(),
//         'products': products?.map((e) => e.toJson()).toList(),
//       };
// }

// class Tier {
//   int? id;
//   String? name;
//   String? description;
//   int? tierMinPoints;
//   int? tierMaxPoints;

//   Tier(
//       {this.id,
//       this.name,
//       this.description,
//       this.tierMinPoints,
//       this.tierMaxPoints});

//   factory Tier.fromJson(Map<String, dynamic> json) {
//     return Tier(
//       id: json['id'] as int?,
//       name: json['name'] as String?,
//       description: json['description'] as String?,
//       tierMinPoints: json['tier_min_points'] as int?,
//       tierMaxPoints: json['tier_max_points'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'description': description,
//         'tier_min_points': tierMinPoints,
//         'tier_max_points': tierMaxPoints,
//       };
// }

// class Voucher {
//   int? id;
//   String? code;
//   int? discountValue;
//   String? type;
//   String? expiryDate;
//   Pivot? pivot;
//   int? isExpired; // This field comes from the new response structure.

//   // Constructor updated to accept all fields, including isExpired for the new response.
//   Voucher({
//     this.id,
//     this.code,
//     this.discountValue,
//     this.type,
//     this.expiryDate,
//     this.pivot,
//     this.isExpired, // Optional for the first response.
//   });

//   // Factory method updated to handle both response structures.
//   factory Voucher.fromJson(Map<String, dynamic> json) {
//     if (json.containsKey('voucher_code')) {
//       // Parsing the new response structure
//       return Voucher(
//         code: json['voucher_code'] as String?,
//         discountValue: json['discount_value'] as int?,
//         type: json['voucher_type'] as String?,
//         expiryDate: json['expiry_date'] as String?,
//         id: json['voucher_id'] as int?,
//         isExpired: json['is_expired'] as int?,
//       );
//     } else {
//       // Parsing the old response structure with a pivot
//       return Voucher(
//         id: json['id'] as int?,
//         code: json['code'] as String?,
//         discountValue: json['discount_value'] as int?,
//         type: json['type'] as String?,
//         expiryDate: json['expiry_date'] as String?,
//         pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
//       );
//     }
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'code': code,
//         'discount_value': discountValue,
//         'type': type,
//         'expiry_date': expiryDate,
//         'pivot': pivot?.toJson(),
//         'is_expired': isExpired, // Added for the new response structure
//       };
// }

// class Pivot {
//   int? tierId;
//   int? voucherId;

//   Pivot({this.tierId, this.voucherId});

//   factory Pivot.fromJson(Map<String, dynamic> json) {
//     return Pivot(
//       tierId: json['tier_id'] as int?,
//       voucherId: json['voucher_id'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'tier_id': tierId,
//         'voucher_id': voucherId,
//       };
// }

// class Product {
//   int? id;
//   String? nameEn;
//   String? descriptionEn;
//   String? productImage;
//   int? quantity;
//   int? tierId;
//   int? tierMaxPoints;
//   int? variantId;
//   int? stock;
//   int? price;

//   Product(
//       {this.id,
//       this.nameEn,
//       this.descriptionEn,
//       this.productImage,
//       this.quantity,
//       this.tierId,
//       this.tierMaxPoints,
//       this.variantId,
//       this.stock,
//       this.price});

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//         id: json['id'] as int?,
//         nameEn: json['name_en'] as String?,
//         descriptionEn: json['description_en'] as String?,
//         productImage: json['product_image'] as String?,
//         quantity: json['quantity'] as int?,
//         tierId: json['tier_id'] as int?,
//         tierMaxPoints: json['tier_max_points'] as int?,
//         variantId: json['variant_id'] as int?,
//         stock: json['stock'] as int?,
//         price: json['price'] as int?);
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name_en': nameEn,
//         'description_en': descriptionEn,
//         'product_image': productImage,
//         'quantity': quantity,
//         'tier_id': tierId,
//         'tier_max_points': tierMaxPoints,
//         'variant_id': variantId,
//         'stock': stock,
//       };
// }

import 'package:collection/collection.dart';

class UserPointsModel {
  String? status;
  UserData? data;

  UserPointsModel({this.status, this.data});

  factory UserPointsModel.fromJson(Map<String, dynamic> json) {
    return UserPointsModel(
      status: json['status'] as String?,
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserPointsModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode;
}

class UserData {
  int? userPoints;
  List<Tier>? tiers;
  List<Voucher>? vouchers;
  List<Product>? products;

  UserData({this.userPoints, this.tiers, this.vouchers, this.products});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userPoints: json['user_points'] as int?,
      tiers: (json['tiers'] as List<dynamic>?)
          ?.map((e) => Tier.fromJson(e as Map<String, dynamic>))
          .toList(),
      vouchers: (json['vouchers'] as List<dynamic>?)
          ?.map((e) => Voucher.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_points': userPoints,
        'tiers': tiers?.map((e) => e.toJson()).toList(),
        'vouchers': vouchers?.map((e) => e.toJson()).toList(),
        'products': products?.map((e) => e.toJson()).toList(),
      };
}

class Tier {
  int? id;
  String? name;
  String? description;
  String? descriptionAr;
  int? tierMinPoints;
  int? tierMaxPoints;

  Tier(
      {this.id,
      this.name,
      this.description,
      this.descriptionAr,
      this.tierMinPoints,
      this.tierMaxPoints});

  factory Tier.fromJson(Map<String, dynamic> json) {
    return Tier(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      tierMinPoints: json['tier_min_points'] as int?,
      tierMaxPoints: json['tier_max_points'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'description_ar': descriptionAr,
        'tier_min_points': tierMinPoints,
        'tier_max_points': tierMaxPoints,
      };
}

// class Voucher {
//   int? id;
//   String? code;
//   int? discountValue;
//   String? type;
//   String? expiryDate;
//   Pivot? pivot;

//   Voucher(
//       {this.id,
//       this.code,
//       this.discountValue,
//       this.type,
//       this.expiryDate,
//       this.pivot});

//   factory Voucher.fromJson(Map<String, dynamic> json) {
//     return Voucher(
//       id: json['id'] as int?,
//       code: json['code'] as String?,
//       discountValue: json['discount_value'] as int?,
//       type: json['type'] as String?,
//       expiryDate: json['expiry_date'] as String?,
//       pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'code': code,
//         'discount_value': discountValue,
//         'type': type,
//         'expiry_date': expiryDate,
//         'pivot': pivot?.toJson(),
//       };
// }

// class Pivot {
//   int? tierId;
//   int? voucherId;

//   Pivot({this.tierId, this.voucherId});

//   factory Pivot.fromJson(Map<String, dynamic> json) {
//     return Pivot(
//       tierId: json['tier_id'] as int?,
//       voucherId: json['voucher_id'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'tier_id': tierId,
//         'voucher_id': voucherId,
//       };
// }

class Voucher {
  int? id;
  String? code;
  int? discountValue;
  String? type;
  String? expiryDate;
  Pivot? pivot;
  int? isExpired; // This field comes from the new response structure.

  // Constructor updated to accept all fields, including isExpired for the new response.
  Voucher({
    this.id,
    this.code,
    this.discountValue,
    this.type,
    this.expiryDate,
    this.pivot,
    this.isExpired,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('voucher_code')) {
      return Voucher(
        code: json['voucher_code'] as String?,
        discountValue: json['discount_value'] as int?,
        type: json['voucher_type'] as String?,
        expiryDate: json['expiry_date'] as String?,
        id: json['voucher_id'] as int?,
        isExpired: json['is_expired'] as int?,
      );
    } else {
      // Parsing the old response structure with a pivot
      return Voucher(
        id: json['id'] as int?,
        code: json['code'] as String?,
        discountValue: json['discount_value'] as int?,
        type: json['type'] as String?,
        expiryDate: json['expiry_date'] as String?,
        pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'discount_value': discountValue,
        'type': type,
        'expiry_date': expiryDate,
        'pivot': pivot?.toJson(),
        'is_expired': isExpired, // Added for the new response structure
      };
}

class Pivot {
  int? tierId;
  int? voucherId;

  Pivot({this.tierId, this.voucherId});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      tierId: json['tier_id'] as int?,
      voucherId: json['voucher_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'tier_id': tierId,
        'voucher_id': voucherId,
      };
}

class Product {
  int? id;
  int? cartId;
  String? nameEn;
  String? descriptionEn;
  String? productImage;
  int? quantity;
  int? tierId;
  int? tierMaxPoints;
  int? variantId;
  int? stock;
  double? price;
  bool? isClaimed;

  Product(
      {this.id,
      this.cartId,
      this.nameEn,
      this.descriptionEn,
      this.productImage,
      this.quantity,
      this.tierId,
      this.tierMaxPoints,
      this.variantId,
      this.stock,
      this.price,
      this.isClaimed});

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      // Parse from nested product object
      final product = json['product'];
      return Product(
          nameEn: product['name_en'] as String?,
          descriptionEn: product['description_en'] as String?,
          productImage:
              (product['images'] != null && product['images'].isNotEmpty)
                  ? product['images'][0]['location']
                  : null,
          quantity: json['quantity'] as int?,
          id: json['product_id'] as int?,
          tierId: json['tier_id'] as int?,
          tierMaxPoints: json['tier_max_points'] as int?,
          variantId: json['variant_id'] as int?,
          stock: json['stock'] as int?,
          cartId: json['id'] as int?);
    } else {
      // Parse from direct response
      return Product(
          id: json['id'] as int?,
          nameEn: json['name_en'] as String?,
          descriptionEn: json['description_en'] as String?,
          productImage: json['product_image'] as String?,
          quantity: json['quantity'] as int?,
          tierId: json['tier_id'] as int?,
          tierMaxPoints: json['tier_max_points'] as int?,
          variantId: json['variant_id'] as int?,
          stock: json['stock'] as int?,
          // price: json['price'] as double?
          price: _parsePrice(json['price']),
          isClaimed: json['is_claimed']);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'description_en': descriptionEn,
        'product_image': productImage,
        'quantity': quantity,
        'tier_id': tierId,
        'tier_max_points': tierMaxPoints,
        'variant_id': variantId,
        'stock': stock,
        'price': price,
      };
}

double? _parsePrice(dynamic price) {
  if (price is int) {
    // If the price is an int, convert it to a double
    return price.toDouble();
  }
  return price as double?; // Return the price if it's already a double
}
