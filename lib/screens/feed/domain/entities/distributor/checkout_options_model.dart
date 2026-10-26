import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import 'bank_account_model.dart';

class DistributorOrderType {
  static const pickup = 'PICKUP_ONLY';
  static const delivery = 'DELIVERY';
}

class DistributorPaymentMethod {
  static const cash = 'CASH';
  static const bank = 'BANK';
}

class OrderTypeOption {
  String? code;
  String? labelEn;
  String? labelAr;
  String? labelUr;
  String? subtitle;
  double? latitude;
  double? longitude;
  double? fee;

  OrderTypeOption.fromJson(Map<String, dynamic> json) {
    code = parseString(json['code']);
    labelEn = parseString(json['label_en']);
    labelAr = parseString(json['label_ar']);
    labelUr = parseString(json['label_ur']);
    subtitle = parseString(json['subtitle']);
    latitude = parseDouble(json['latitude']);
    longitude = parseDouble(json['longitude']);
    fee = parseDouble(json['fee']);
  }

  String get label => localized(labelEn, labelAr, labelUr);
  bool get isPickup => code == DistributorOrderType.pickup;
  bool get isDelivery => code == DistributorOrderType.delivery;
  bool get hasLocation => latitude != null && longitude != null;
}

class PaymentMethodOption {
  String? code;
  String? labelEn;
  String? labelAr;
  String? labelUr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionUr;
  List<BankAccountModel> bankAccounts = [];

  PaymentMethodOption.fromJson(Map<String, dynamic> json) {
    code = parseString(json['code']);
    labelEn = parseString(json['label_en']);
    labelAr = parseString(json['label_ar']);
    labelUr = parseString(json['label_ur']);
    descriptionEn = parseString(json['description_en']);
    descriptionAr = parseString(json['description_ar']);
    descriptionUr = parseString(json['description_ur']);
    bankAccounts = BankAccountModel.listFromJson(json['bank_accounts']);
  }

  String get label => localized(labelEn, labelAr, labelUr);
  String get description =>
      localized(descriptionEn, descriptionAr, descriptionUr);
  bool get isBank => code == DistributorPaymentMethod.bank;
  bool get isCash => code == DistributorPaymentMethod.cash;
  bool get isMada => code == 'MADA' || code == 'CARD';
  bool get isSadad => code == 'SADAD';
}

/// Order types and payment methods a distributor has switched on.
/// Never hard-code these: always render what the API returns.
class CheckoutOptionsModel {
  int? distributorId;
  bool isOpen;
  List<OrderTypeOption> orderTypes;
  List<PaymentMethodOption> paymentMethods;

  CheckoutOptionsModel({
    this.distributorId,
    this.isOpen = true,
    this.orderTypes = const [],
    this.paymentMethods = const [],
  });

  factory CheckoutOptionsModel.fromJson(Map<String, dynamic> json) =>
      CheckoutOptionsModel(
        distributorId: parseInt(json['distributor_id']),
        isOpen: parseBool(json['is_open']) ?? true,
        orderTypes: (json['order_types'] is List)
            ? (json['order_types'] as List)
                .whereType<Map<String, dynamic>>()
                .map(OrderTypeOption.fromJson)
                .toList()
            : [],
        paymentMethods: (json['payment_methods'] is List)
            ? (json['payment_methods'] as List)
                .whereType<Map<String, dynamic>>()
                .map(PaymentMethodOption.fromJson)
                .toList()
            : [],
      );

  static CheckoutOptionsModel? tryParse(dynamic json) =>
      json is Map<String, dynamic> ? CheckoutOptionsModel.fromJson(json) : null;

  OrderTypeOption? orderType(String? code) =>
      orderTypes.where((e) => e.code == code).firstOrNull;

  PaymentMethodOption? paymentMethod(String? code) =>
      paymentMethods.where((e) => e.code == code).firstOrNull;
}
