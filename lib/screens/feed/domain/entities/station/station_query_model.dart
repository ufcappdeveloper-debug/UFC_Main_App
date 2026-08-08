// domain/params/station_query_params.dart
class StationQueryParams {
  final int page;
  final int limit;
  final String? search;
  final double? latitude;
  final double? longitude;

  StationQueryParams({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    if (search != null) 'search': search,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
  };
}
