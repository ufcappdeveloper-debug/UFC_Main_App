import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class TimingModel {
  int? id;
  int? shopId;
  int? day;
  String? openingTime;
  String? closingTime;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? dayInTheWeek;
  String? dayInTheWeekAr;
  String? dayInTheWeekUr;

  TimingModel({
    this.id,
    this.shopId,
    this.day,
    this.openingTime,
    this.closingTime,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.dayInTheWeek,
    this.dayInTheWeekAr,
    this.dayInTheWeekUr,
  });

  TimingModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString().toTryInt();
    shopId = json['shop_id']?.toString().toTryInt();
    day = json['day']?.toString().toTryInt();
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dayInTheWeek = json['day_in_the_week'];
    dayInTheWeekAr = json['day_in_the_week_ar'];
    dayInTheWeekUr = json['day_in_the_week_ur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['day_in_the_week'] = dayInTheWeek;
    data['day_in_the_week_ar'] = dayInTheWeekAr;
    data['day_in_the_week_ur'] = dayInTheWeekUr;
    return data;
  }
}
