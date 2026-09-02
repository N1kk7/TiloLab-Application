import 'package:tilolab_app/core/api/api_client.dart';

import 'np_city.dart';
import 'np_warehouse.dart';

class NovaPoshtaRepository {
  final ApiClient _client;

  NovaPoshtaRepository(this._client);

  /// Аналог getCitiesNp — пошук міст за назвою.
  Future<List<NpCity>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final response = await _client.post('/api/np/cities', data: {'city': query});

    final data = response['data'] as List?;
    if (data == null || data.isEmpty) return [];

    final addresses = (data.first as Map<String, dynamic>)['Addresses'] as List?;
    if (addresses == null) return [];

    return addresses
        .map((e) => NpCity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NpWarehouse>> searchWarehouses({
    required String cityName,
    required String postNumber,
  }) async {
    if (postNumber.trim().isEmpty) return [];

    final response = await _client.post('/api/np/postOffice', data: {
      'cityName': cityName,
      'postNumber': postNumber,
    });

    final data = response['data'] as List?;
    if (data == null) return [];

    return data
        .map((e) => NpWarehouse.fromJson(e as Map<String, dynamic>))
        .where((w) => w.category == NpWarehouseCategory.branch)
        .toList();
  }

  Future<List<NpWarehouse>> searchPostomats({
    required String cityName,
    required String postomatNumber,
  }) async {
    if (postomatNumber.trim().isEmpty) return [];

    final response = await _client.post('/api/np/postomatNumber', data: {
      'cityName': cityName,
      'postomatNumber': postomatNumber,
    });

    final data = response['data'] as List?;
    if (data == null) return [];

    return data
        .map((e) => NpWarehouse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> createCounterparty({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final response = await _client.post('/api/np/create-counterparty', data: {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    });

    final data = response['data'] as List;
    return data.first['Ref'] as String;
  }

  Future<String> createContactPerson({
    required String firstName,
    required String lastName,
    required String phone,
    required String counterPartyId,
  }) async {
    final response = await _client.post('/api/np/create-contact-person', data: {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'counterPartyId': counterPartyId,
    });

    final data = response['data'] as List;
    return data.first['Ref'] as String;
  }
}