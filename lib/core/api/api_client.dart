import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient()
      : baseUrl = dotenv.env['API_BASE_URL']!;

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Request failed: ${response.statusCode}',
    );
  }
}