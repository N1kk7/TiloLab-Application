enum OrderStatus { processing, shipped, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.processing:
        return 'В обробці';
      case OrderStatus.shipped:
        return 'Відправлено';
      case OrderStatus.delivered:
        return 'Доставлено';
      case OrderStatus.cancelled:
        return 'Скасовано';
    }
  }
}

class OrderItem {
  final String id;
  final String number;
  final DateTime date;
  final int itemsCount;
  final int total;
  final OrderStatus status;

  const OrderItem({
    required this.id,
    required this.number,
    required this.date,
    required this.itemsCount,
    required this.total,
    required this.status,
  });
}