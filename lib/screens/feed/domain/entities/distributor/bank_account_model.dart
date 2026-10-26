import 'package:ufc_mobile/global/util/common/common_utils.dart';

class BankAccountModel {
  int? id;
  String? bankName;
  String? accountName;
  String? iban;
  String? accountNumber;
  String? branch;

  BankAccountModel({
    this.id,
    this.bankName,
    this.accountName,
    this.iban,
    this.accountNumber,
    this.branch,
  });

  BankAccountModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    bankName = parseString(json['bank_name']);
    accountName = parseString(json['account_name']);
    iban = parseString(json['iban']);
    accountNumber = parseString(json['account_number']);
    branch = parseString(json['branch']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bank_name': bankName,
        'account_name': accountName,
        'iban': iban,
        'account_number': accountNumber,
        'branch': branch,
      };

  static List<BankAccountModel> listFromJson(dynamic json) => json is List
      ? json
          .whereType<Map<String, dynamic>>()
          .map(BankAccountModel.fromJson)
          .toList()
      : <BankAccountModel>[];
}
