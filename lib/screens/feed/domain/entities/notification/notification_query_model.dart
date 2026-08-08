class NotificationQueryParams {
  final int page;
  final int limit;

  NotificationQueryParams({this.page = 1, this.limit = 10});

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
  };
}
