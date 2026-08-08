// lib/features/address/domain/entities/address_query_params.dart
class AddressQueryParams {
  final int page;
  final int limit;

  AddressQueryParams({this.page = 1, this.limit = 10});

  Map<String, dynamic> toMap() => {
    'page': page,
    'limit': limit,
  };
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}
