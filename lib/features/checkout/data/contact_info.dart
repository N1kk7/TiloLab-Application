class ContactInfo {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  const ContactInfo({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
      };

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
      );
}