import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class BankDetailsModel {
  int? id;
  int? shopId;
  String? iban;
  String? bankName;
  String? bankBranch;
  String? bankAccountName;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  BankDetailsModel({
    this.id,
    this.shopId,
    this.iban,
    this.bankName,
    this.bankBranch,
    this.bankAccountName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString().toTryInt();
    shopId = json['shop_id']?.toString().toTryInt();
    iban = json['iban'];
    bankName = json['bank_name'];
    bankBranch = json['bank_branch'];
    bankAccountName = json['bank_account_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['iban'] = iban;
    data['bank_name'] = bankName;
    data['bank_branch'] = bankBranch;
    data['bank_account_name'] = bankAccountName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
