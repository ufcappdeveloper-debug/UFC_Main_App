import 'package:collection/collection.dart';

class UserAddress {
  int? id;
  int? userId;
  double? latitude;
  double? longitude;
  String? address;
  dynamic city;
  String? label;
  dynamic landmark;
  String? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic phoneNumber;
  dynamic firstName;
  dynamic lastName;

  UserAddress({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.label,
    this.landmark,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.phoneNumber,
    this.firstName,
    this.lastName,
  });

  @override
  String toString() {
    return 'UserAddress(id: $id, userId: $userId, latitude: $latitude, longitude: $longitude, address: $address, city: $city, label: $label, landmark: $landmark, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, phoneNumber: $phoneNumber, firstName: $firstName, lastName: $lastName)';
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        latitude: (json['latitude'] as double?),
        longitude: (json['longitude'] as double?),
        address: json['address'] as String?,
        city: json['city'] as dynamic,
        label: json['label'] as String?,
        landmark: json['landmark'] as dynamic,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        phoneNumber: json['phone_number'] as dynamic,
        firstName: json['first_name'] as dynamic,
        lastName: json['last_name'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'label': label,
        'landmark': landmark,
        'deleted_at': deletedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'phone_number': phoneNumber,
        'first_name': firstName,
        'last_name': lastName,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserAddress) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      address.hashCode ^
      city.hashCode ^
      label.hashCode ^
      landmark.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      phoneNumber.hashCode ^
      firstName.hashCode ^
      lastName.hashCode;
}
