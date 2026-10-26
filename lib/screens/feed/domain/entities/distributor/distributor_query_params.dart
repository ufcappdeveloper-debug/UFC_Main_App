class DistributorListParams {
  final int page;
  final int limit;
  final String? search;

  const DistributorListParams({this.page = 1, this.limit = 20, this.search});

  DistributorListParams copyWith({int? page, String? search}) =>
      DistributorListParams(
        page: page ?? this.page,
        limit: limit,
        search: search ?? this.search,
      );

  Map<String, dynamic> toQuery() => {
        'page': page,
        'limit': limit,
        if (search != null && search!.isNotEmpty) 'search': search,
      };
}

class DistributorProductParams {
  final int distributorId;
  final int? categoryId;
  final int page;
  final int limit;
  final String? search;

  /// 2 newest (default), 3 price high to low, 4 price low to high,
  /// 5 biggest discount.
  final int? sort;
  final double? minPrice;
  final double? maxPrice;
  final bool isOffer;
  final bool inStock;

  const DistributorProductParams({
    required this.distributorId,
    this.categoryId,
    this.page = 1,
    this.limit = 20,
    this.search,
    this.sort,
    this.minPrice,
    this.maxPrice,
    this.isOffer = false,
    this.inStock = false,
  });

  DistributorProductParams copyWith({
    int? page,
    int? categoryId,
    bool clearCategory = false,
    String? search,
  }) =>
      DistributorProductParams(
        distributorId: distributorId,
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        page: page ?? this.page,
        limit: limit,
        search: search ?? this.search,
        sort: sort,
        minPrice: minPrice,
        maxPrice: maxPrice,
        isOffer: isOffer,
        inStock: inStock,
      );

  Map<String, dynamic> toQuery() => {
        'distributor_id': distributorId,
        if (categoryId != null) 'distributor_category_id': categoryId,
        'page': page,
        'limit': limit,
        'fetch_favorite': 1,
        if (search != null && search!.isNotEmpty) 'search': search,
        if (sort != null) 'sort': sort,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (isOffer) 'is_offer': 1,
        if (inStock) 'in_stock': 1,
      };
}

class DistributorPlaceOrderParams {
  final String paymentMethod;
  final String orderType;
  final int? addressId;
  final int? distributorId;
  final String? couponCode;
  final String? note;
  final String? bookingDateTime;
  final String? driverPlate;
  final bool force;

  const DistributorPlaceOrderParams({
    required this.paymentMethod,
    required this.orderType,
    this.addressId,
    this.distributorId,
    this.couponCode,
    this.note,
    this.bookingDateTime,
    this.driverPlate,
    this.force = false,
  });

  DistributorPlaceOrderParams copyWith({bool? force}) =>
      DistributorPlaceOrderParams(
        paymentMethod: paymentMethod,
        orderType: orderType,
        addressId: addressId,
        distributorId: distributorId,
        couponCode: couponCode,
        note: note,
        bookingDateTime: bookingDateTime,
        driverPlate: driverPlate,
        force: force ?? this.force,
      );

  /// Never sends `use_wallet`: wallet isn't available for distributor orders.
  Map<String, dynamic> toJson() => {
        'payment_method': paymentMethod,
        'order_type': orderType,
        'platform': 'MOBILE',
        if (addressId != null) 'address_id': addressId,
        if (distributorId != null) 'distributor_id': distributorId,
        if (couponCode != null && couponCode!.isNotEmpty)
          'coupon_code': couponCode,
        if (note != null && note!.isNotEmpty) 'note': note,
        if (bookingDateTime != null) 'booking_date_time': bookingDateTime,
        if (driverPlate != null && driverPlate!.isNotEmpty)
          'driver_plate': driverPlate,
        if (force) 'force': true,
      };
}

/// "Order Now" on a distributor product: `POST distributor/buy_product`.
/// Buys one product directly; the distributor cart is not read or changed.
class DistributorBuyProductParams {
  final int productId;
  final int variantId;
  final int quantity;
  final DistributorPlaceOrderParams order;

  const DistributorBuyProductParams({
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.order,
  });

  /// Same fields as place_order plus the product. `platform` is DASHBOARD
  /// (as in the station flow) so MADA/CARD responses carry checkout_id and
  /// integrity. Never sends `use_wallet`.
  Map<String, dynamic> toJson() => {
        ...order.toJson(),
        'distributor_product_id': productId,
        'distributor_variant_id': variantId,
        'quantity': quantity,
        'platform': 'DASHBOARD',
      }..remove('distributor_id')..remove('force');
}
