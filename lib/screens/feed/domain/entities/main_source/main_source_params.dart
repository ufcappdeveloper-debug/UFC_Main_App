/// Query of `GET /main-source/products` (plan §2).
class MainSourceProductParams {
  static const sortNewest = 'newest';
  static const sortPriceAsc = 'price_asc';
  static const sortPriceDesc = 'price_desc';
  static const sortName = 'name';

  final int? mainSourceId;
  final int? categoryId;
  final String? search;
  final bool inStockOnly;

  /// `null` = the admin's order.
  final String? sort;
  final int page;
  final int limit;

  const MainSourceProductParams({
    this.mainSourceId,
    this.categoryId,
    this.search,
    this.inStockOnly = false,
    this.sort,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQuery() => {
        if (mainSourceId != null) 'main_source_id': mainSourceId,
        if (categoryId != null) 'category_id': categoryId,
        if (search != null && search!.trim().isNotEmpty)
          'search': search!.trim(),
        if (inStockOnly) 'in_stock': 1,
        if (sort != null) 'sort': sort,
        'page': page,
        'limit': limit,
      };

  MainSourceProductParams copyWith({
    int? page,
    int? Function()? categoryId,
    String? Function()? search,
    String? Function()? sort,
    bool? inStockOnly,
  }) =>
      MainSourceProductParams(
        mainSourceId: mainSourceId,
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        search: search != null ? search() : this.search,
        inStockOnly: inStockOnly ?? this.inStockOnly,
        sort: sort != null ? sort() : this.sort,
        page: page ?? this.page,
        limit: limit,
      );
}

/// The delivery location picked at checkout (GPS or map pin).
class MainSourceLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;

  const MainSourceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
  });

  @override
  bool operator ==(Object other) =>
      other is MainSourceLocation &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address &&
      other.city == city;

  @override
  int get hashCode => Object.hash(latitude, longitude, address, city);
}

/// "Buy now": one variant, without the cart.
class MainSourceBuyNow {
  final int variantId;
  final int quantity;

  const MainSourceBuyNow({required this.variantId, this.quantity = 1});
}

/// Body of the quote and of place order (plan §4.3 / §4.4).
class MainSourceCheckoutParams {
  final MainSourceLocation? location;
  final bool useWallet;
  final String? paymentMethod;
  final String? couponCode;
  final String? deliveryCouponCode;
  final MainSourceBuyNow? buyNow;
  final String? landmark;
  final String? note;
  final bool force;

  const MainSourceCheckoutParams({
    this.location,
    this.useWallet = false,
    this.paymentMethod,
    this.couponCode,
    this.deliveryCouponCode,
    this.buyNow,
    this.landmark,
    this.note,
    this.force = false,
  });

  static String? _text(String? value) {
    final v = value?.trim();
    return v == null || v.isEmpty ? null : v;
  }

  Map<String, dynamic> toQuoteJson() => {
        if (location != null) ...{
          'latitude': location!.latitude,
          'longitude': location!.longitude,
        },
        'use_wallet': useWallet,
        if (_text(paymentMethod) != null) 'payment_method': paymentMethod,
        if (_text(couponCode) != null) 'coupon_code': _text(couponCode),
        if (_text(deliveryCouponCode) != null)
          'delivery_coupon_code': _text(deliveryCouponCode),
        if (buyNow != null) ...{
          'variant_id': buyNow!.variantId,
          'quantity': buyNow!.quantity,
        },
      };

  /// Never sends order_type, address_id, booking_date_time or a plate.
  Map<String, dynamic> toOrderJson() => {
        'payment_method': paymentMethod,
        if (location != null) ...{
          'latitude': location!.latitude,
          'longitude': location!.longitude,
          if (_text(location!.address) != null)
            'address': _cut(location!.address!, 500),
          if (_text(location!.city) != null) 'city': location!.city,
        },
        if (_text(landmark) != null) 'landmark': _text(landmark),
        'use_wallet': useWallet,
        if (_text(couponCode) != null) 'coupon_code': _text(couponCode),
        if (_text(deliveryCouponCode) != null)
          'delivery_coupon_code': _text(deliveryCouponCode),
        if (_text(note) != null) 'note': _cut(_text(note)!, 1000),
        if (buyNow != null) ...{
          'variant_id': buyNow!.variantId,
          'quantity': buyNow!.quantity,
        },
        if (force) 'force': true,
        'platform': 'MOBILE',
      };

  static String _cut(String value, int max) =>
      value.length > max ? value.substring(0, max) : value;

  MainSourceCheckoutParams copyWith({bool? force, String? paymentMethod}) =>
      MainSourceCheckoutParams(
        location: location,
        useWallet: useWallet,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        couponCode: couponCode,
        deliveryCouponCode: deliveryCouponCode,
        buyNow: buyNow,
        landmark: landmark,
        note: note,
        force: force ?? this.force,
      );
}

/// Body of `POST /main-source/orders/{id}/bank-transfer` (multipart).
class MainSourceBankTransferParams {
  final int bankAccountId;
  final String filePath;
  final String? fileName;
  final double amount;
  final String? referenceNumber;

  /// `YYYY-MM-DD`.
  final String? transferDate;

  const MainSourceBankTransferParams({
    required this.bankAccountId,
    required this.filePath,
    this.fileName,
    required this.amount,
    this.referenceNumber,
    this.transferDate,
  });
}
