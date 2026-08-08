import 'package:ufc_mobile/global/shared/constants/constants.dart';

class BarnModel {
  final int? id;
  final int? userId;
  int? barnNumber;
  String? barnNameEn;
  String? barnNameAr;
  final int? feedQuantity;
  final double? barnLatitude;
  final double? barnLongitude;
  final String? barnAddress;
  final String? barnImage;

  BarnModel({
    this.id,
    this.userId,
    this.barnNameEn,
    this.barnNameAr,
    this.feedQuantity,
    this.barnLatitude,
    this.barnLongitude,
    this.barnAddress,
    this.barnImage,
    this.barnNumber,
  });

  factory BarnModel.fromJson(Map<String, dynamic> json) {
    return BarnModel(
      id: json['id'] != null
          ? int.tryParse(json['id']?.toString() ?? '')
          : json['barn_id'] != null
              ? int.tryParse(json['barn_id']?.toString() ?? '')
              : null,
      barnNumber: json['barn_number'] != null
          ? int.tryParse(json['barn_number'].toString())
          : null,
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      barnNameEn: json['barn_name_en']?.toString(),
      barnNameAr: json['barn_name_ar']?.toString(),
      feedQuantity: json['feed_quantity'] != null
          ? int.tryParse(json['feed_quantity'].toString())
          : null,
      barnLatitude: json['barn_lattitude'] != null
          ? double.tryParse(json['barn_lattitude'].toString())
          : null,
      barnLongitude: json['barn_longitude'] != null
          ? double.tryParse(json['barn_longitude'].toString())
          : null,
      barnAddress: json['barn_address']?.toString(),
      barnImage: json['barn_image']?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['barn_name_en'] = barnNameEn;
    data['barn_name_ar'] = barnNameAr;
    data['feed_quantity'] = feedQuantity;
    data['barn_lattitude'] = barnLatitude;
    data['barn_longitude'] = barnLongitude;
    data['barn_address'] = barnAddress;
    data['barn_image'] = barnImage;

    return data;
  }

  String get name =>
      isArabic ? barnNameAr ?? barnNameEn ?? '' : barnNameEn ?? '';
}
