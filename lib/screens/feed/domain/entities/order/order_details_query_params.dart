class OrderDetailsQueryParams {
  final int page;
  final int limit;
  final int orderId;

  const OrderDetailsQueryParams({
    this.page = 1,
    this.limit = 20,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "order_id": orderId,
    };
  }

  OrderDetailsQueryParams copyWith({
    int? page,
    int? limit,
    int? orderId,
  }) {
    return OrderDetailsQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      orderId: orderId ?? this.orderId,
    );
  }
}
