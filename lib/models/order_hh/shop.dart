import 'package:collection/collection.dart';

class Shop {
  int? id;
  String? nameAr;
  String? nameEn;
  String? descriptionEn;
  dynamic descriptionAr;
  String? coverImage;
  String? logo;
  double? latitude;
  double? longitude;
  dynamic tel;
  dynamic tin;
  String? status;
  bool? isFeatured;
  bool? isOpen;
  int? sortingIndex;
  int? ratings;
  int? ratingsCount;
  dynamic tradeLicense;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic contactName;
  dynamic contactDesignation;
  dynamic contactNumber;
  dynamic contactEmail;
  dynamic address;
  int? cityId;
  String? statusDescription;

  Shop({
    this.id,
    this.nameAr,
    this.nameEn,
    this.descriptionEn,
    this.descriptionAr,
    this.coverImage,
    this.logo,
    this.latitude,
    this.longitude,
    this.tel,
    this.tin,
    this.status,
    this.isFeatured,
    this.isOpen,
    this.sortingIndex,
    this.ratings,
    this.ratingsCount,
    this.tradeLicense,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.contactName,
    this.contactDesignation,
    this.contactNumber,
    this.contactEmail,
    this.address,
    this.cityId,
    this.statusDescription,
  });

  @override
  String toString() {
    return 'Shop(id: $id, nameAr: $nameAr, nameEn: $nameEn, descriptionEn: $descriptionEn, descriptionAr: $descriptionAr, coverImage: $coverImage, logo: $logo, latitude: $latitude, longitude: $longitude, tel: $tel, tin: $tin, status: $status, isFeatured: $isFeatured, isOpen: $isOpen, sortingIndex: $sortingIndex, ratings: $ratings, ratingsCount: $ratingsCount, tradeLicense: $tradeLicense, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, contactName: $contactName, contactDesignation: $contactDesignation, contactNumber: $contactNumber, contactEmail: $contactEmail, address: $address, cityId: $cityId, statusDescription: $statusDescription)';
  }

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json['id'] as int?,
        nameAr: json['name_ar'] as String?,
        nameEn: json['name_en'] as String?,
        descriptionEn: json['description_en'] as String?,
        descriptionAr: json['description_ar'] as dynamic,
        coverImage: json['cover_image'] as String?,
        logo: json['logo'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        tel: json['tel'] as dynamic,
        tin: json['tin'] as dynamic,
        status: json['status'] as String?,
        isFeatured: json['is_featured'] as bool?,
        isOpen: json['is_open'] as bool?,
        sortingIndex: json['sorting_index'] as int?,
        ratings: json['ratings'] as int?,
        ratingsCount: json['ratings_count'] as int?,
        tradeLicense: json['trade_license'] as dynamic,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        contactName: json['contact_name'] as dynamic,
        contactDesignation: json['contact_designation'] as dynamic,
        contactNumber: json['contact_number'] as dynamic,
        contactEmail: json['contact_email'] as dynamic,
        address: json['address'] as dynamic,
        cityId: json['city_id'] as int?,
        statusDescription: json['status_description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
        'description_en': descriptionEn,
        'description_ar': descriptionAr,
        'cover_image': coverImage,
        'logo': logo,
        'latitude': latitude,
        'longitude': longitude,
        'tel': tel,
        'tin': tin,
        'status': status,
        'is_featured': isFeatured,
        'is_open': isOpen,
        'sorting_index': sortingIndex,
        'ratings': ratings,
        'ratings_count': ratingsCount,
        'trade_license': tradeLicense,
        'deleted_at': deletedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'contact_name': contactName,
        'contact_designation': contactDesignation,
        'contact_number': contactNumber,
        'contact_email': contactEmail,
        'address': address,
        'city_id': cityId,
        'status_description': statusDescription,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Shop) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      nameAr.hashCode ^
      nameEn.hashCode ^
      descriptionEn.hashCode ^
      descriptionAr.hashCode ^
      coverImage.hashCode ^
      logo.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      tel.hashCode ^
      tin.hashCode ^
      status.hashCode ^
      isFeatured.hashCode ^
      isOpen.hashCode ^
      sortingIndex.hashCode ^
      ratings.hashCode ^
      ratingsCount.hashCode ^
      tradeLicense.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      contactName.hashCode ^
      contactDesignation.hashCode ^
      contactNumber.hashCode ^
      contactEmail.hashCode ^
      address.hashCode ^
      cityId.hashCode ^
      statusDescription.hashCode;
}
