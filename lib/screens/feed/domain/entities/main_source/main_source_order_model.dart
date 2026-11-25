import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../distributor/bank_account_model.dart';
import 'main_source_json.dart';
import 'main_source_model.dart';
import 'main_source_quote_model.dart';

class MainSourceOrderStatus {
  static const pending = 'PENDING';
  static const scheduled = 'SCHEDULED';
  static const processing = 'PROCESSING';
  static const shipped = 'SHIPPED';
  static const completed = 'COMPLETED';
  static const cancelled = 'CANCELLED';
  static const rejected = 'REJECTED';
}

class MainSourcePaymentStatus {
  static const pending = 'PENDING';
  static const paid = 'PAID';
  static const failed = 'FAILED';
  static const pendingVerification = 'PENDING_VERIFICATION';
  static const rejected = 'REJECTED';
  static const refunded = 'REFUNDED';
}

/// The pinned delivery location of an order.
class MainSourceDelivery {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? landmark;

  const MainSourceDelivery({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.landmark,
  });

  factory MainSourceDelivery.fromJson(Map<String, dynamic> json) =>
      MainSourceDelivery(
        latitude: parseDouble(json['latitude']),
        longitude: parseDouble(json['longitude']),
        address: parseString(json['address']),
        city: parseString(json['city']),
        landmark: parseString(json['landmark']),
      );

  bool get hasCoordinates => latitude != null && longitude != null;
}

/// SADAD bill (`go_pay`).
class MainSourceGoPay {
  final String? billNumber;
  final String? sadadNumber;
  final double? amount;
  final String? expireDate;

  const MainSourceGoPay({
    this.billNumber,
    this.sadadNumber,
    this.amount,
    this.expireDate,
  });

  factory MainSourceGoPay.fromJson(Map<String, dynamic> json) =>
      MainSourceGoPay(
        billNumber: parseString(json['bill_number']),
        sadadNumber: parseString(json['sadad_number']),
        amount: parseDouble(json['amount']),
        expireDate: parseString(json['expire_date']),
      );

  static MainSourceGoPay? fromJsonOrNull(dynamic json) {
    final map = asMapOrNull(json);
    return map == null ? null : MainSourceGoPay.fromJson(map);
  }
}

/// The latest receipt of a BANK order (`bank_transfer`).
class MainSourceBankTransfer {
  static const statusPending = 'pending';
  static const statusApproved = 'approved';
  static const statusRejected = 'rejected';

  final int? id;
  final String? status;
  final double? amount;
  final String? referenceNumber;
  final String? transferDate;
  final String? receiptUrl;
  final String? rejectionReason;
  final BankAccountModel? bankAccount;
  final DateTime? createdAt;
  final DateTime? reviewedAt;

  const MainSourceBankTransfer({
    this.id,
    this.status,
    this.amount,
    this.referenceNumber,
    this.transferDate,
    this.receiptUrl,
    this.rejectionReason,
    this.bankAccount,
    this.createdAt,
    this.reviewedAt,
  });

  factory MainSourceBankTransfer.fromJson(Map<String, dynamic> json) {
    final account = asMapOrNull(json['bank_account']);
    return MainSourceBankTransfer(
      id: parseInt(json['id']),
      status: parseString(json['status']),
      amount: parseDouble(json['amount']),
      referenceNumber: parseString(json['reference_number']),
      transferDate: parseString(json['transfer_date']),
      receiptUrl: parseString(json['receipt_url']),
      rejectionReason: parseString(json['rejection_reason']),
      bankAccount: account == null ? null : BankAccountModel.fromJson(account),
      createdAt: parseDate(json['created_at']),
      reviewedAt: parseDate(json['reviewed_at']),
    );
  }

  static MainSourceBankTransfer? fromJsonOrNull(dynamic json) {
    final map = asMapOrNull(json);
    return map == null ? null : MainSourceBankTransfer.fromJson(map);
  }

  bool get isPending => status == statusPending;
  bool get isApproved => status == statusApproved;
  bool get isRejected => status == statusRejected;

  /// The receipt link may point to a PDF.
  bool get isPdf =>
      (Uri.tryParse(receiptUrl ?? '')?.path ?? '').toLowerCase().endsWith('.pdf');
}

/// A customer-facing timeline entry (`status_history[]`).
class MainSourceStatusHistory {
  final String? fromStatus;
  final String? toStatus;
  final String? note;
  final DateTime? createdAt;

  const MainSourceStatusHistory({
    this.fromStatus,
    this.toStatus,
    this.note,
    this.createdAt,
  });

  factory MainSourceStatusHistory.fromJson(Map<String, dynamic> json) =>
      MainSourceStatusHistory(
        fromStatus: parseString(json['from_status']),
        toStatus: parseString(json['to_status']),
        note: parseString(json['note']),
        createdAt: parseDate(json['created_at']),
      );

  /// Payment events keep the status (`from_status == to_status`).
  bool get isPaymentEvent => fromStatus != null && fromStatus == toStatus;
}

/// A Main Source order. The list endpoint returns a short version
/// (with [itemsCount] and [image]); details return everything.
class MainSourceOrderModel {
  final int? id;
  final String? orderNumber;
  final String? orderStatus;
  final String? paymentMethod;
  final String? paymentStatus;
  final MainSourceModel? mainSource;
  final MainSourceDelivery? delivery;
  final List<MainSourceOrderLine> items;
  final int itemsCount;
  final String? image;
  final double subtotal;
  final String? couponCode;
  final double couponAmount;
  final double deliveryFee;
  final double deliveryCouponAmount;
  final double vatAmount;
  final double deliveryVat;
  final double totalWithVat;
  final double walletAmountUsed;
  final double payableAmount;
  final MainSourceGoPay? goPay;
  final MainSourceBankTransfer? bankTransfer;
  final List<BankAccountModel> bankAccounts;
  final bool canUploadReceipt;
  final String? note;
  final bool canCancel;
  final bool canPay;
  final List<MainSourceStatusHistory> statusHistory;
  final DateTime? createdAt;

  const MainSourceOrderModel({
    this.id,
    this.orderNumber,
    this.orderStatus,
    this.paymentMethod,
    this.paymentStatus,
    this.mainSource,
    this.delivery,
    this.items = const [],
    this.itemsCount = 0,
    this.image,
    this.subtotal = 0,
    this.couponCode,
    this.couponAmount = 0,
    this.deliveryFee = 0,
    this.deliveryCouponAmount = 0,
    this.vatAmount = 0,
    this.deliveryVat = 0,
    this.totalWithVat = 0,
    this.walletAmountUsed = 0,
    this.payableAmount = 0,
    this.goPay,
    this.bankTransfer,
    this.bankAccounts = const [],
    this.canUploadReceipt = false,
    this.note,
    this.canCancel = false,
    this.canPay = false,
    this.statusHistory = const [],
    this.createdAt,
  });

  factory MainSourceOrderModel.fromJson(Map<String, dynamic> json) {
    final delivery = asMapOrNull(json['delivery']);
    final items = asList(json['items'], MainSourceOrderLine.fromJson);
    return MainSourceOrderModel(
      id: parseInt(json['id']),
      orderNumber: parseString(json['order_number']),
      orderStatus: parseString(json['order_status']),
      paymentMethod: parseString(json['payment_method']),
      paymentStatus: parseString(json['payment_status']),
      mainSource: MainSourceModel.fromJsonOrNull(json['main_source']),
      delivery: delivery == null ? null : MainSourceDelivery.fromJson(delivery),
      items: items,
      itemsCount: parseInt(json['items_count']) ?? items.length,
      image: parseString(json['image']) ?? items.firstOrNull?.image,
      subtotal: money(json['subtotal']),
      couponCode: parseString(json['coupon_code']),
      couponAmount: money(json['coupon_amount']),
      deliveryFee: money(json['delivery_fee']),
      deliveryCouponAmount: money(json['delivery_coupon_amount']),
      vatAmount: money(json['vat_amount']),
      deliveryVat: money(json['delivery_vat']),
      totalWithVat: money(json['total_with_vat']),
      walletAmountUsed: money(json['wallet_amount_used']),
      payableAmount: money(json['payable_amount']),
      goPay: MainSourceGoPay.fromJsonOrNull(json['go_pay']),
      bankTransfer: MainSourceBankTransfer.fromJsonOrNull(json['bank_transfer']),
      bankAccounts: BankAccountModel.listFromJson(json['bank_accounts']),
      canUploadReceipt: parseBool(json['can_upload_receipt']) ?? false,
      note: parseString(json['note']),
      canCancel: parseBool(json['can_cancel']) ?? false,
      canPay: parseBool(json['can_pay']) ?? false,
      statusHistory:
          asList(json['status_history'], MainSourceStatusHistory.fromJson),
      createdAt: parseDate(json['created_at']),
    );
  }

  bool get isPaid => paymentStatus == MainSourcePaymentStatus.paid;
  bool get isBank => paymentMethod == MainSourcePaymentMethod.bank;
  bool get isMada => paymentMethod == MainSourcePaymentMethod.mada;
  bool get isSadad => paymentMethod == MainSourcePaymentMethod.sadad;

  /// Delivery fee and VAT, after the delivery coupon.
  double get itemsAfterDiscount => subtotal - couponAmount;
  double get deliveryAfterDiscount => deliveryFee - deliveryCouponAmount;
}
