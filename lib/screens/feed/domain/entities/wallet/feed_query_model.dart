class WalletQueryParams {
  final String timeZone;

  WalletQueryParams({required this.timeZone});

  Map<String, dynamic> toJson() => {
    'time_zone': timeZone,
  };
}
