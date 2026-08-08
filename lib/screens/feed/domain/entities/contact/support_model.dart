class SupportRequest {
  final String email;
  final String name;
  final String countryCode;
  final String phoneNumber;
  final String city;
  final String subject;
  final String comment;

  SupportRequest({
    required this.email,
    required this.name,
    required this.countryCode,
    required this.phoneNumber,
    required this.city,
    required this.subject,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "country_code": countryCode,
      "phone_number": phoneNumber,
      "city": city,
      "subject": subject,
      "comment": comment,
    };
  }
}
