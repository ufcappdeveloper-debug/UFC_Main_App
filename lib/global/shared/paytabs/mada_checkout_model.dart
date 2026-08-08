class MadaCheckoutModel {
  String? token;
  String? transactionReference;
  String? transactionType;
  String? cartID;
  String? cartDescription;
  String? cartCurrency;
  String? cartAmount;
  PaymentResult? paymentResult;
  PaymentInfo? paymentInfo;

  MadaCheckoutModel(
      {this.token,
      this.transactionReference,
      this.transactionType,
      this.cartID,
      this.cartDescription,
      this.cartCurrency,
      this.cartAmount,
      this.paymentInfo,
      this.paymentResult});

  MadaCheckoutModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    transactionReference = json['transactionReference'];
    transactionType = json['transactionType'];
    cartID = json['cartID'];
    cartDescription = json['cartDescription'];
    cartCurrency = json['cartCurrency'];
    cartAmount = json['cartAmount'];
    paymentInfo = json['paymentInfo'] != null
        ? PaymentInfo.fromJson(json['paymentInfo'])
        : null;
    paymentResult = json['paymentResult'] != null
        ? PaymentResult.fromJson(json['paymentResult'])
        : null;
  }
}

class PaymentResult {
  String? responseStatus;
  String? responseCode;
  String? responseMessage;

  PaymentResult({this.responseStatus, this.responseCode, this.responseMessage});

  PaymentResult.fromJson(Map<String, dynamic> json) {
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
  }
}

class PaymentInfo {
  String? cardType;
  String? cardScheme;
  String? paymentDescription;

  PaymentInfo({this.cardType, this.cardScheme, this.paymentDescription});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    cardType = json['cardType'];
    cardScheme = json['cardScheme'];
    paymentDescription = json['paymentDescription'];
  }
}
