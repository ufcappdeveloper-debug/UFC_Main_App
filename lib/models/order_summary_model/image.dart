import 'package:collection/collection.dart';

class Image {
  int? id;
  int? productId;
  String? location;
  DateTime? createdAt;
  DateTime? updatedAt;

  Image({
    this.id,
    this.productId,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Image(id: $id, productId: $productId, location: $location, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json['id'] as int?,
        productId: json['product_id'] as int?,
        location: json['location'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'location': location,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Image) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      productId.hashCode ^
      location.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
