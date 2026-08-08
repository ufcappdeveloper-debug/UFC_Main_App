enum PaymentOptionsEnum { none, cash, bank, mada, sadad, wallet } // walletSadad

extension PaymentOptionsEnumData on PaymentOptionsEnum {
  String get getValue {
    switch (this) {
      case PaymentOptionsEnum.none:
        return "";
      case PaymentOptionsEnum.cash:
        return "CASH";
      case PaymentOptionsEnum.bank:
        return "BANK";
      case PaymentOptionsEnum.mada:
        return "MADA";
      case PaymentOptionsEnum.sadad:
        return "SADAD";
      case PaymentOptionsEnum.wallet:
        return "WALLET";
      // case PaymentOptionsEnum.walletSadad:
      //   return "WALLET_SADAD";
    }
  }
}
