import 'package:ufc_mobile/global/util/common/common_utils.dart';

import 'bank_account_model.dart';

/// `bank_transfer` block returned by place_order (BANK) and on unpaid
/// distributor orders. Null once the distributor marks the order paid.
class BankTransferModel {
  double? amount;
  String? reference;
  List<BankAccountModel> bankAccounts;

  BankTransferModel({this.amount, this.reference, this.bankAccounts = const []});

  factory BankTransferModel.fromJson(Map<String, dynamic> json) =>
      BankTransferModel(
        amount: parseDouble(json['amount']),
        reference: parseString(json['reference']),
        bankAccounts: BankAccountModel.listFromJson(json['bank_accounts']),
      );

  static BankTransferModel? tryParse(dynamic json) =>
      json is Map<String, dynamic> ? BankTransferModel.fromJson(json) : null;

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'reference': reference,
        'bank_accounts': bankAccounts.map((e) => e.toJson()).toList(),
      };
}
