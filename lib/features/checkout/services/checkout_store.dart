import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/contact_info.dart';
import '../data/delivery_info.dart';

class CheckoutStore extends ChangeNotifier {
  CheckoutStore._();
  static final CheckoutStore instance = CheckoutStore._();

  static const _contactKey = 'checkout_contact_info';
  static const _deliveryKey = 'checkout_delivery_info';

  ContactInfo? contact;
  DeliveryInfo? delivery;
  bool isLoaded = false;

  bool get hasContact => contact != null;
  bool get hasDelivery => delivery != null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final rawContact = prefs.getString(_contactKey);
    if (rawContact != null) {
      contact = ContactInfo.fromJson(jsonDecode(rawContact) as Map<String, dynamic>);
    }

    final rawDelivery = prefs.getString(_deliveryKey);
    if (rawDelivery != null) {
      delivery = DeliveryInfo.fromJson(jsonDecode(rawDelivery) as Map<String, dynamic>);
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<void> saveContact(ContactInfo info) async {
    contact = info;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactKey, jsonEncode(info.toJson()));
  }

  Future<void> saveDelivery(DeliveryInfo info) async {
    delivery = info;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deliveryKey, jsonEncode(info.toJson()));
  }
}