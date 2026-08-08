class ProductListQueryParams {
  final int page;
  final int limit;
  final int? shopId;
  final int? categoryId;
  final int? sort;
  final double? size;
  final int? isOffer;
  final int? minPrice;
  final double? maxPrice;
  final String? search;
  final int? createdWithin;
  final String? productType;
  final List<int>? animalType;
  final int? isFavorite;
  final int? userId;
  final int? removeNullPrice;

  const ProductListQueryParams({
    this.page = 1,
    this.limit = 20,
    this.shopId,
    this.categoryId,
    this.sort,
    this.size,
    this.isOffer,
    this.minPrice,
    this.maxPrice,
    this.search,
    this.createdWithin,
    this.productType,
    this.animalType,
    this.isFavorite = 1,
    this.userId,
    this.removeNullPrice = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "shop_id": shopId,
      if (sort != null) "sort": sort,
      if (search != null) "search": search,
      if (categoryId != null) "category_id": categoryId,
      if (productType != null) "product_type": productType,
      if (size != null) "size": size,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (createdWithin != null) "created_within": createdWithin,
      if (isOffer != null) "is_offer": isOffer,
      if (animalType != null) "product_subtypes_relations": animalType,
      "fetch_favorite": isFavorite,
      if (userId != null) "user_id": userId,
      "remove_null_price": removeNullPrice,
    };
  }

  ProductListQueryParams copyWith({
    int? page,
    int? limit,
    int? shopId,
    int? categoryId,
    int? sort,
    double? size,
    int? isOffer,
    int? minPrice,
    double? maxPrice,
    String? search,
    int? createdWithin,
    String? productType,
    List<int>? animalType,
    int? isFavorite,
    int? userId,
  }) {
    return ProductListQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      shopId: shopId ?? this.shopId,
      categoryId: categoryId ?? this.categoryId,
      sort: sort ?? this.sort,
      size: size ?? this.size,
      isOffer: isOffer ?? this.isOffer,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      search: search ?? this.search,
      createdWithin: createdWithin ?? this.createdWithin,
      productType: productType ?? this.productType,
      animalType: animalType ?? this.animalType,
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
    );
  }
}
