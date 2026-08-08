import 'package:collection/collection.dart';

class Address {
  int? id;
  int? userId;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? address;
  dynamic city;
  String? label;
  dynamic landmark;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic countryCode;
  String? phoneNumber;
  dynamic alphaCode;
  String? firstName;
  String? lastName;

  Address({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.address,
    this.city,
    this.label,
    this.landmark,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.countryCode,
    this.phoneNumber,
    this.alphaCode,
    this.firstName,
    this.lastName,
  });

  @override
  String toString() {
    return 'Address(id: $id, userId: $userId, latitude: $latitude, longitude: $longitude, isDefault: $isDefault, address: $address, city: $city, label: $label, landmark: $landmark, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, countryCode: $countryCode, phoneNumber: $phoneNumber, alphaCode: $alphaCode, firstName: $firstName, lastName: $lastName)';
  }

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        isDefault: json['is_default'] as bool?,
        address: json['address'] as String?,
        city: json['city'] as dynamic,
        label: json['label'] as String?,
        landmark: json['landmark'] as dynamic,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        countryCode: json['country_code'] as dynamic,
        phoneNumber: json['phone_number'] as String?,
        alphaCode: json['alpha_code'] as dynamic,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
        'is_default': isDefault,
        'address': address,
        'city': city,
        'label': label,
        'landmark': landmark,
        'deleted_at': deletedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'country_code': countryCode,
        'phone_number': phoneNumber,
        'alpha_code': alphaCode,
        'first_name': firstName,
        'last_name': lastName,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Address) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      isDefault.hashCode ^
      address.hashCode ^
      city.hashCode ^
      label.hashCode ^
      landmark.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      countryCode.hashCode ^
      phoneNumber.hashCode ^
      alphaCode.hashCode ^
      firstName.hashCode ^
      lastName.hashCode;
}
