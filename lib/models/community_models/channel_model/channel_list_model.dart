import 'package:collection/collection.dart';
import 'package:ufc_mobile/models/pagination/pagination_model.dart';

import 'datum.dart';

class ChannelListResponseModel {
  String? status;
  List<ChannelModel>? data;
  Pagination? pagination;

  ChannelListResponseModel({this.status, this.data, this.pagination});

  ChannelListResponseModel copyWith(
      {List<ChannelModel>? data, Pagination? pagination, String? status}) {
    return ChannelListResponseModel(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return 'ChannelListResponseModel(status: $status, data: $data, pagination: $pagination)';
  }

  factory ChannelListResponseModel.fromJson(Map<String, dynamic> json) =>
      ChannelListResponseModel(
        status: json['status'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] == null
            ? null
            : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.map((e) => e.toJson()).toList(),
        'pagination': pagination?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ChannelListResponseModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ pagination.hashCode;
}
