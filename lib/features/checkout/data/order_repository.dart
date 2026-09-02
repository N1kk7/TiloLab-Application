import 'package:tilolab_app/core/api/api_client.dart';

import '../../nova-posta/data/nova_poshta_repository.dart';
import 'contact_info.dart';
import 'delivery_info.dart';
import 'order_result.dart';
import 'payment_method.dart';
import 'recipient_info.dart';
import '../../addreses/data/address_model.dart';

class OrderApiException implements Exception {
  final String message;
  OrderApiException(this.message);
}

class OrderItemPayload {
  final String productId;
  final String? optionId;
  final int quantity;
  final int price;
  final String title;

  const OrderItemPayload({
    required this.productId,
    this.optionId,
    required this.quantity,
    required this.price,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'optionId': optionId,
        'quantity': quantity,
        'price': price,
        'title': title,
      };
}

class OrderRepository {
  final ApiClient _client;
  final NovaPoshtaRepository _novaPoshta;

  OrderRepository(this._client) : _novaPoshta = NovaPoshtaRepository(_client);

  /// Аналог createRecipient — послідовно створює контрагента і контактну особу в НП.
  Future<RecipientInfo> createRecipient({
    required String firstName,
    required String lastName,
    required String formattedPhone,
  }) async {
    final recipientId = await _novaPoshta.createCounterparty(
      firstName: firstName,
      lastName: lastName,
      phone: formattedPhone,
    );

    final recipientContactId = await _novaPoshta.createContactPerson(
      firstName: firstName,
      lastName: lastName,
      phone: formattedPhone,
      counterPartyId: recipientId,
    );

    return RecipientInfo(
      recipientId: recipientId,
      recipientContactId: recipientContactId,
    );
  }

  /// Аналог createOrder — створення замовлення на бекенді.
  Future<OrderResult> createOrder({
    required String? userId,
    required ContactInfo contact,
    required DeliveryInfo delivery,
    required PaymentMethod paymentMethod,
    required List<OrderItemPayload> items,
    required String certificateCode,
    required String comment,
    required RecipientInfo recipient,
  }) async {
    final response = await _client.post('/api/orders/newOrder', data: {
      'userId': userId,
      'name': contact.firstName,
      'surname': contact.lastName,
      'paymentMethod': _paymentMethodKey(paymentMethod),
      'orderItems': items.map((e) => e.toJson()).toList(),
      'email': contact.email,
      'phoneNumber': contact.phone,
      'promoCode': certificateCode,
      'orderComment': comment,
      'shippingInfo': {
        'recipient': contact.fullName,
        'phoneNumber': contact.phone,
        'deliveryMethod': 'nova poshta',
        'postOffice': delivery.type == DeliveryType.warehouse ? delivery.description : '',
        'postomat': delivery.type == DeliveryType.postomat ? delivery.description : '',
        'city': delivery.city,
        'country': 'Ukraine',
        'warehouseType': delivery.type == DeliveryType.postomat ? 'Postomat' : 'Branch',
        'recipientId': recipient.recipientId,
        'recipientContactId': recipient.recipientContactId,
      },
    });

    if (response['statusCode'] != 200) {
      throw OrderApiException(response['message'] as String? ?? 'Не вдалося створити замовлення');
    }

    final data = response['data'] as Map<String, dynamic>;

    return OrderResult(
      orderId: data['id'] as String,
      totalPrice: (data['totalPrice'] as num).toInt(),
    );
  }

  /// Аналог proccessOrderByCertificate — завершення замовлення сертифікатом.
  Future<void> completeOrderWithCertificate({
    required String orderId,
    required String certificateCode,
  }) async {
    final response = await _client.post('/api/orders/complete-certificate', data: {
      'orderId': orderId,
      'certificateCode': certificateCode,
    });

    if (response['statusCode'] != 200) {
      throw OrderApiException(response['message'] as String? ?? 'Помилка застосування сертифіката');
    }
  }

  String _paymentMethodKey(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.online:
        return 'monobank';
      case PaymentMethod.cashOnDelivery:
        return 'cod';
      case PaymentMethod.certificate:
        return 'certificate';
    }
  }
}