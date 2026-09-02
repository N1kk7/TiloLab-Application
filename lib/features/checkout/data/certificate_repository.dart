import 'package:tilolab_app/core/api/api_client.dart';

class CertificateApiException implements Exception {
  final String message;
  CertificateApiException(this.message);
}

class CertificateInfo {
  final String code;
  final int amount;

  const CertificateInfo({required this.code, required this.amount});

  factory CertificateInfo.fromJson(Map<String, dynamic> json) => CertificateInfo(
        code: json['code'] as String,
        amount: (json['amount'] as num).toInt(),
      );
}

class CertificateCheckResult {
  final CertificateInfo certificate;
  final bool isNeedToSurcharge;

  const CertificateCheckResult({
    required this.certificate,
    required this.isNeedToSurcharge,
  });
}

class CertificateRepository {
  final ApiClient _client;

  CertificateRepository(this._client);

  /// Аналог validateCertificate — перевірка коду і залишку суми.
  Future<CertificateCheckResult> checkCertificate({
    required String code,
    required int orderTotalPrice,
  }) async {
    try {
      final response = await _client.post('/api/certificates/get-certificate', data: {
        'certificateCode': code,
      });

      final certificate = CertificateInfo.fromJson(response['data'] as Map<String, dynamic>);
      final isNeedToSurcharge = certificate.amount < orderTotalPrice;

      return CertificateCheckResult(
        certificate: certificate,
        isNeedToSurcharge: isNeedToSurcharge,
      );
    } catch (error) {
      throw CertificateApiException(
        'Щось пішло не так, спробуйте ще раз пізніше',
      );
    }
  }
}