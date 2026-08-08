class OrderQueryParams {
  final int page;
  final int limit;
  final String? orderStatus;

  const OrderQueryParams({
    this.page = 1,
    this.limit = 10,
    this.orderStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      if (orderStatus != null) "order_status": orderStatus,
    };
  }

  OrderQueryParams copyWith({
    int? page,
    int? limit,
    String? orderStatus,
  }) {
    return OrderQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}
