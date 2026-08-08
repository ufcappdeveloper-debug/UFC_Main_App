class CheckoutModel {
  CheckoutSummaryModel? checkoutSummary;
  GoPayModel? goPay;
  String? checkoutId;
  String? integrity;

  CheckoutModel({
    this.checkoutSummary,
    this.goPay,
  });

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    checkoutSummary = CheckoutSummaryModel.fromJson(order ?? json);
    goPay = json['go_pay'] != null ? GoPayModel.fromJson(json['go_pay']) : null;
    checkoutId = json['checkout_id'];
    integrity = json['integrity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (checkoutSummary != null) {
      data['data'] = checkoutSummary!.toJson();
    }
    if (goPay != null) {
      data['go_pay'] = goPay!.toJson();
    }
    data['checkout_id'] = checkoutId;
    data['integrity'] = integrity;
    return data;
  }
}

class CheckoutSummaryModel {
  int? userId;
  String? paymentMethod;
  int? shopId;
  String? orderStatus;
  String? paymentStatus;
  String? updatedAt;
  String? createdAt;
  int? id;
  double? amount;
  double? vatAmount;
  double? totalWithVat;
  String? orderType;

  CheckoutSummaryModel(
      {this.userId,
      this.paymentMethod,
      this.shopId,
      this.orderStatus,
      this.paymentStatus,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.amount,
      this.vatAmount,
      this.totalWithVat,
      this.orderType});

  CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    paymentMethod = json['payment_method'];
    shopId = json['shop_id'];
    orderStatus = json['order_status'];
    paymentStatus = json['payment_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    orderType = json['order_type'];
    id = json['id'];
    amount =
        json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0;
    vatAmount = json['vat_amount'] == null
        ? 0.0
        : double.parse(json['vat_amount'].toString());
    totalWithVat = json['total_with_vat'] == null
        ? 0.0
        : double.parse(json['total_with_vat'].toString());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['payment_method'] = paymentMethod;
    data['shop_id'] = shopId;
    data['order_status'] = orderStatus;
    data['payment_status'] = paymentStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['amount'] = amount;
    data['vat_amount'] = vatAmount;
    data['total_with_vat'] = totalWithVat;
    data['order_type'] = orderType;
    return data;
  }
}

class GoPayModel {
  int? id;
  int? orderId;
  String? billNumber;
  String? entityActivityId;
  String? customerFullName;
  String? customerMobileNumber;
  String? issueDate;
  String? expireDate;
  String? amount;
  String? sadadNumber;
  String? createdAt;
  String? updatedAt;

  GoPayModel(
      {this.id,
      this.orderId,
      this.billNumber,
      this.entityActivityId,
      this.customerFullName,
      this.customerMobileNumber,
      this.issueDate,
      this.expireDate,
      this.amount,
      this.sadadNumber,
      this.createdAt,
      this.updatedAt});

  GoPayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    billNumber = json['bill_number'];
    entityActivityId = json['entity_activity_id'];
    customerFullName = json['customer_full_name'];
    customerMobileNumber = json['customer_mobile_number'];
    issueDate = json['issue_date'];
    expireDate = json['expire_date'];
    amount = json['amount'];
    sadadNumber = json['sadad_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['bill_number'] = billNumber;
    data['entity_activity_id'] = entityActivityId;
    data['customer_full_name'] = customerFullName;
    data['customer_mobile_number'] = customerMobileNumber;
    data['issue_date'] = issueDate;
    data['expire_date'] = expireDate;
    data['amount'] = amount;
    data['sadad_number'] = sadadNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
