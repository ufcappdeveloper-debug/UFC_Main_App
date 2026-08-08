enum DeliveryOptionsEnum { none, delivery, pickup }

extension DeliveryOptionsEnumData on DeliveryOptionsEnum {
  String get getValue {
    switch (this) {
      case DeliveryOptionsEnum.none:
        return "";
      case DeliveryOptionsEnum.delivery:
        return "Delivery";
      case DeliveryOptionsEnum.pickup:
        return "Pickup";
    }
  }
}
