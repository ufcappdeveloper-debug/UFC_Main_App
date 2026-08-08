enum PreferenceType {
  pushNotificationAll,
  pushNotificationAccountOrders,
  pushNotificationOffersPromotion,
  emailNotificationAll,
  emailNotificationOfferProducts,
  smsNotificationAccountOrders
}

class CommunicationPreferencesModel {
  bool? pushNotifAll;
  bool? pushNotifAccountOrders;
  bool? pushNotifOffersPromotion;
  bool? emailNotifAll;
  bool? emailNotifOfferProducts;
  bool? smsNotifAccountOrders;

  CommunicationPreferencesModel({
    this.pushNotifAll = false,
    this.pushNotifAccountOrders = false,
    this.pushNotifOffersPromotion = false,
    this.emailNotifAll = false,
    this.emailNotifOfferProducts = false,
    this.smsNotifAccountOrders = false,
  });

  Map<String, dynamic> get toJson => {
        "push_notif_all": pushNotifAll == true ? 1 : 0,
        "push_notif_account_orders": pushNotifAccountOrders == true ? 1 : 0,
        "push_notif_offers_promotion": pushNotifOffersPromotion == true ? 1 : 0,
        "email_notif_all": emailNotifAll == true ? 1 : 0,
        "email_notif_offer_products": emailNotifOfferProducts == true ? 1 : 0,
        "sms_notif_account_orders": smsNotifAccountOrders == true ? 1 : 0,
      };

  void updateCommunicationPreferences(
      bool value, PreferenceType preferenceType) {
    switch (preferenceType) {
      case PreferenceType.pushNotificationAll:
        pushNotifAll = value;
        break;
      case PreferenceType.pushNotificationAccountOrders:
        pushNotifAccountOrders = value;
        break;
      case PreferenceType.pushNotificationOffersPromotion:
        pushNotifOffersPromotion = value;
        break;
      case PreferenceType.emailNotificationAll:
        emailNotifAll = value;
        break;
      case PreferenceType.emailNotificationOfferProducts:
        emailNotifOfferProducts = value;
        break;
      case PreferenceType.smsNotificationAccountOrders:
        smsNotifAccountOrders = value;
        break;
    }
  }
}
