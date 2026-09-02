import 'package:tilolab_app/core/api/api_client.dart';

class PaymentApiException implements Exception {
  final String message;
  PaymentApiException(this.message);
}

class PaymentResult {
  final String invoiceId;
  final String pageUrl;

  const PaymentResult({required this.invoiceId, required this.pageUrl});
}

class PaymentRepository {
  final ApiClient _client;

  PaymentRepository(this._client);

  /// Аналог createPayment — створення інвойсу Monobank.
  Future<PaymentResult> createPayment({
    required String orderId,
    required int amount,
  }) async {
    final response = await _client.post('/api/monobank/create', data: {
      'orderId': orderId,
      'amount': amount,
    });

    if (response['statusCode'] != 200) {
      throw PaymentApiException(
        response['statusMessage'] as String? ?? 'Щось пішло не так',
      );
    }

    return PaymentResult(
      invoiceId: response['invoiceId'] as String,
      pageUrl: response['pageUrl'] as String,
    );
  }
}