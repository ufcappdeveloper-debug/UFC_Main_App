import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_category_model.dart';
import 'package:ufc_mobile/models/timing_model.dart';

class StationModel {
  int? id;
  String? nameAr;
  String? nameEn;
  String? nameUr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionUr;
  String? coverImage;
  String? logo;
  double? latitude;
  double? longitude;
  String? tel;
  String? tin;
  String? status;
  bool? isFeatured;
  bool? isOpen;
  int? sortingIndex;
  int? ratings;
  int? ratingsCount;
  String? tradeLicense;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? contactName;
  String? contactDesignation;
  String? contactNumber;
  String? contactEmail;
  String? statusDescription;
  String? address;
  List<CategoryModel>? category;
  List<TimingModel>? timings;
  double? km;

  StationModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.nameUr,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionUr,
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
    this.statusDescription,
    this.address,
    this.category,
    this.timings,
    this.km,
  });

  StationModel.fromJson(Map<String, dynamic> json, {double? lat, double? lng}) {
    id = parseInt(json['id']);
    nameAr = parseString(json['name_ar']);
    nameEn = parseString(json['name_en']);
    nameUr = parseString(json['name_ur']);
    descriptionEn = parseString(json['description_en']);
    descriptionAr = parseString(json['description_ar']);
    descriptionUr = parseString(json['description_ur']);
    coverImage = parseString(json['cover_image']);
    logo = parseString(json['logo']);  // ✅ fix here
    latitude = parseDouble(json['latitude']);  // ✅ add this
    longitude = parseDouble(json['longitude']);
    tel = parseString(json['tel']);
    tin = parseString(json['tin']);
    status = parseString(json['status']);
    isFeatured = parseBool(json['is_featured']);
    isOpen = parseBool(json['is_open']);
    sortingIndex = parseInt(json['sorting_index']);
    ratings = parseInt(json['ratings']);
    ratingsCount = parseInt(json['ratings_count']);
    tradeLicense = parseString(json['trade_license']);
    deletedAt = json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'].toString());
    createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'].toString());
    updatedAt = json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'].toString());
    contactName = parseString(json['contact_name']);
    contactDesignation = parseString(json['contact_designation']);
    contactNumber = parseString(json['contact_number']);
    contactEmail = parseString(json['contact_email']);
    address = parseString(json['address']);
    statusDescription = parseString(json['status_description']);
    if (json['category'] != null) {
      category = <CategoryModel>[];
      json['category'].forEach((v) {
        category!.add(CategoryModel.fromJson(v));
      });
    }
    if (json['timings'] != null) {
      timings = <TimingModel>[];
      json['timings'].forEach((v) {
        timings!.add(TimingModel.fromJson(v));
      });
    }
    km = 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['name_ur'] = nameUr;
    data['description_en'] = descriptionEn;
    data['description_ar'] = descriptionAr;
    data['description_ur'] = descriptionUr;
    data['cover_image'] = coverImage;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['tel'] = tel;
    data['tin'] = tin;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['is_open'] = isOpen;
    data['sorting_index'] = sortingIndex;
    data['ratings'] = ratings;
    data['ratings_count'] = ratingsCount;
    data['trade_license'] = tradeLicense;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['contact_name'] = contactName;
    data['contact_designation'] = contactDesignation;
    data['contact_number'] = contactNumber;
    data['contact_email'] = contactEmail;
    data['address'] = address;
    data['status_description'] = statusDescription;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    if (timings != null) {
      data['timings'] = timings!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  StationModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    String? nameUr,
    dynamic descriptionEn,
    dynamic descriptionAr,
    dynamic descriptionUr,
    String? coverImage,
    dynamic logo,
    double? latitude,
    double? longitude,
    dynamic tel,
    dynamic tin,
    String? status,
    bool? isFeatured,
    bool? isOpen,
    int? sortingIndex,
    int? ratings,
    int? ratingsCount,
    dynamic tradeLicense,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic contactName,
    dynamic contactDesignation,
    String? contactNumber,
    String? contactEmail,
    String? statusDescription,
    String? address,
    List<CategoryModel>? category,
    List<TimingModel>? timings,
    double? km,
  }) {
    return StationModel(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionUr: descriptionUr ?? this.descriptionUr,
      coverImage: coverImage ?? this.coverImage,
      logo: logo ?? this.logo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tel: tel ?? this.tel,
      tin: tin ?? this.tin,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      isOpen: isOpen ?? this.isOpen,
      sortingIndex: sortingIndex ?? this.sortingIndex,
      ratings: ratings ?? this.ratings,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      tradeLicense: tradeLicense ?? this.tradeLicense,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactName: contactName ?? this.contactName,
      contactDesignation: contactDesignation ?? this.contactDesignation,
      contactNumber: contactNumber ?? this.contactNumber,
      contactEmail: contactEmail ?? this.contactEmail,
      statusDescription: statusDescription ?? this.statusDescription,
      address: address ?? this.address,
      category: category ?? this.category,
      timings: timings ?? this.timings,
      km: km ?? this.km,
    );
  }
}
