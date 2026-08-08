import 'package:collection/collection.dart';
import 'package:ufc_mobile/models/ticket_model/ticket_model.dart';

class CreateTicketModel {
  String? status;
  TicketModel? data;

  CreateTicketModel({this.status, this.data});

  @override
  String toString() => 'CreateTicketModel(status: $status, data: $data)';

  factory CreateTicketModel.fromJson(Map<String, dynamic> json) {
    return CreateTicketModel(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : TicketModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CreateTicketModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode;
}
