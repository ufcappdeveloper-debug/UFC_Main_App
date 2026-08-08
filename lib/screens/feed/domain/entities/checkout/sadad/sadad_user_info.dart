class SadadUserInfo {
  int? id;
  int? userId;
  String? customerFullName;
  String? customerMobileNumber;
  String? customerIdNumber;
  String? customerIdType;
  int? externalRefId;
  String? createdAt;
  String? updatedAt;

  SadadUserInfo(
      {this.id,
      this.userId,
      this.customerFullName,
      this.customerMobileNumber,
      this.customerIdNumber,
      this.customerIdType,
      this.externalRefId,
      this.createdAt,
      this.updatedAt});

  SadadUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    customerFullName = json['customer_full_name'];
    customerMobileNumber = json['customer_mobile_number'];
    customerIdNumber = json['customer_id_number'];
    customerIdType = json['customer_id_type'];
    externalRefId = json['external_ref_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['customer_full_name'] = customerFullName;
    data['customer_mobile_number'] = customerMobileNumber;
    data['customer_id_number'] = customerIdNumber;
    data['customer_id_type'] = customerIdType;
    data['external_ref_id'] = externalRefId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
