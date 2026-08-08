class AppUpdateModel {
  int? id;
  String? appVersion;
  int? isForceUpdate;
  String? createdAt;
  String? updatedAt;

  AppUpdateModel(
      {this.id,
      this.appVersion,
      this.isForceUpdate,
      this.createdAt,
      this.updatedAt});

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appVersion = json['app_version'];
    isForceUpdate = json['is_force_update'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_version'] = appVersion;
    data['is_force_update'] = isForceUpdate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
