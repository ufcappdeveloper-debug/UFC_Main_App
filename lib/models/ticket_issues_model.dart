import 'package:collection/collection.dart';

class TicketIssuesModel {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  TicketIssuesModel({this.id, this.name, this.createdAt, this.updatedAt});

  @override
  String toString() {
    return 'TicketIssuesModel(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory TicketIssuesModel.fromJson(Map<String, dynamic> json) {
    return TicketIssuesModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! TicketIssuesModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}
