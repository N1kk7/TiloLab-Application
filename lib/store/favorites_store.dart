import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// MODELS 
import '../models/favorites/favorite_product.dart';

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();
  static final FavoritesStore instance = FavoritesStore._();

  static const _storageKey = 'favorite_products';

  final Map<String, FavoriteProduct> _items = {};
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  List<FavoriteProduct> get items => _items.values.toList();

  Future<void> load() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw != null) {
      final List decoded = jsonDecode(raw) as List;
      for (final entry in decoded) {
        final product = FavoriteProduct.fromJson(entry as Map<String, dynamic>);
        _items[product.id] = product;
      }
    }

    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(String id) => _items.containsKey(id);

  Future<void> toggle(FavoriteProduct product) async {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items[product.id] = product;
    }

    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.values.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}