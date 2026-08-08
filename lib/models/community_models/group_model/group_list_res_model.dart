import 'package:collection/collection.dart';
import 'package:ufc_mobile/models/pagination/pagination_model.dart';

import 'group_model.dart';

class GroupListResponseModel {
  String? status;
  List<GroupModel>? data;
  Pagination? pagination;

  GroupListResponseModel({this.status, this.data, this.pagination});

  GroupListResponseModel copyWith({
    String? status,
    List<GroupModel>? data,
    Pagination? pagination,
  }) {
    return GroupListResponseModel(
        status: this.status,
        data: data ?? this.data,
        pagination: this.pagination);
  }

  @override
  String toString() {
    return 'GroupListResponseModel(status: $status, data: $data, pagination: $pagination)';
  }

  factory GroupListResponseModel.fromJson(Map<String, dynamic> json) =>
      GroupListResponseModel(
        status: json['status'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
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
    if (other is! GroupListResponseModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ pagination.hashCode;
}
