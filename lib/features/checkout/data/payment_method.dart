enum PaymentMethod { online, cashOnDelivery, certificate }

extension PaymentMethodLabel on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.online:
        return 'Онлайн на сайті';
      case PaymentMethod.cashOnDelivery:
        return 'Оплата при отриманні';
      case PaymentMethod.certificate:
        return 'У мене є сертифікат';
    }
  }

  String? get description {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return '200 грн передплата · сума товарів від 200 грн';
      default:
        return null;
    }
  }
}