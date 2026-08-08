class ProfileAddressModel {
  final int id;
  final int userId;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final String address;
  final String? city;
  final String label;
  final String? landmark;
  final String? countryCode;
  final String? phoneNumber;
  final String? alphaCode;
  final String? firstName;
  final String? lastName;

  ProfileAddressModel({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.address,
    this.city,
    required this.label,
    this.landmark,
    this.countryCode,
    this.phoneNumber,
    this.alphaCode,
    this.firstName,
    this.lastName,
  });

  /// ✅ copyWith
  ProfileAddressModel copyWith({
    int? id,
    int? userId,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? address,
    String? city,
    String? label,
    String? landmark,
    String? countryCode,
    String? phoneNumber,
    String? alphaCode,
    String? firstName,
    String? lastName,
  }) {
    return ProfileAddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      address: address ?? this.address,
      city: city ?? this.city,
      label: label ?? this.label,
      landmark: landmark ?? this.landmark,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      alphaCode: alphaCode ?? this.alphaCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  /// ✅ toJson (convert object → Map for API or storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'address': address,
      'city': city,
      'label': label,
      'landmark': landmark,
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'alpha_code': alphaCode,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  /// ✅ fromJson (convert API response → object)
  factory ProfileAddressModel.fromJson(Map<String, dynamic> json) {
    return ProfileAddressModel(
      id: json['id'],
      userId: json['user_id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isDefault: json['is_default'] ?? false,
      address: json['address'],
      city: json['city'],
      label: json['label'],
      landmark: json['landmark'],
      countryCode: json['country_code'],
      phoneNumber: json['phone_number'],
      alphaCode: json['alpha_code'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
