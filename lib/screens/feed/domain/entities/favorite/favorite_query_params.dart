class FavoriteQueryParams {
  final int page;
  final int limit;
  final int? shopId;
  final String? productType;
  final String? search;
  final double? size;
  final double? maxPrice;

  const FavoriteQueryParams({
    this.page = 1,
    this.limit = 10,
    this.shopId,
    this.productType,
    this.search,
    this.size,
    this.maxPrice
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "shop_id": shopId,
      'product_type': productType,
      'search': search,
      'size': size,
      'max_price': maxPrice,
    };
  }

  FavoriteQueryParams copyWith({
    int? page,
    int? limit,
    int? shopId,
    String? productType,
    String? search,
    double? size,
    double? maxPrice,
  }) {
    return FavoriteQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      shopId: shopId ?? this.shopId,
      productType: productType ?? this.productType,
      search: search ?? this.search,
      size: size ?? this.size,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}
