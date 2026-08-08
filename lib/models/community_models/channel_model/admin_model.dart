import 'package:ufc_mobile/global/util/common/common_utils.dart';

class CommunityAdminModel {
  int? id;
  String? name;

  CommunityAdminModel({this.id, this.name});

  CommunityAdminModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    name = parseString(json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
