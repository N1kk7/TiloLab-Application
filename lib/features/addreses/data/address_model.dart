import 'package:flutter/material.dart';

enum DeliveryType { warehouse, postomat, courier }

extension DeliveryTypeLabel on DeliveryType {
  String get label {
    switch (this) {
      case DeliveryType.warehouse:
        return 'Відділення';
      case DeliveryType.postomat:
        return 'Поштомат';
      case DeliveryType.courier:
        return 'Кур\'єрська доставка';
    }
  }

  IconData get icon {
    switch (this) {
      case DeliveryType.warehouse:
        return Icons.store_outlined;
      case DeliveryType.postomat:
        return Icons.inventory_2_outlined;
      case DeliveryType.courier:
        return Icons.local_shipping_outlined;
    }
  }
}

class DeliveryAddress {
  final String id;
  final String city;
  final DeliveryType type;
  final String description; // "Відділення №5, вул. Хрещатик 22" / адреса для кур'єра
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.city,
    required this.type,
    required this.description,
    this.isDefault = false,
  });
}