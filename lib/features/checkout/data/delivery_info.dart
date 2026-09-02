import 'package:tilolab_app/features/addreses/data/address_model.dart';

class DeliveryInfo {
  final DeliveryType type;
  final String city;
  final String description; // "Відділення №5, вул. ..." / адреса для кур'єра

  const DeliveryInfo({
    required this.type,
    required this.city,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'city': city,
        'description': description,
      };

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) => DeliveryInfo(
        type: DeliveryType.values.byName(json['type'] as String),
        city: json['city'] as String,
        description: json['description'] as String,
      );
}