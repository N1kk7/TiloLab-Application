import 'package:flutter/material.dart';




import 'package:tilolab_app/core/theme/app_colors.dart';
import 'package:tilolab_app/core/theme/app_spacing.dart';
import 'package:tilolab_app/core/theme/app_text_styles.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_spacing.dart';
// import '../../../core/theme/app_text_styles.dart';
import '../data/order_model.dart';
import '../widgets/order_card.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  static final _orders = [
    OrderItem(
      id: '1',
      number: '10245',
      date: DateTime(2026, 8, 12),
      itemsCount: 2,
      total: 2090,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: '2',
      number: '10198',
      date: DateTime(2026, 7, 28),
      itemsCount: 1,
      total: 1200,
      status: OrderStatus.shipped,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Історія замовлень', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: _orders.isEmpty
            ? Center(
                child: Text('У вас ще немає замовлень', style: AppTextStyles.bodySmall),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) => OrderCard(
                  order: _orders[index],
                  onTap: () {
                    // TODO: сторінка деталей замовлення
                  },
                ),
              ),
      ),
    );
  }
}