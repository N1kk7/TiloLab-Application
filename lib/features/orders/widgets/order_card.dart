import 'package:flutter/material.dart';

import 'package:tilolab_app/core/theme/app_colors.dart';
import 'package:tilolab_app/core/theme/app_radius.dart';
import 'package:tilolab_app/core/theme/app_spacing.dart';
import 'package:tilolab_app/core/theme/app_text_styles.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_radius.dart';
// import '../../../core/theme/app_spacing.dart';
// import '../../../core/theme/app_text_styles.dart';
import '../data/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  ({Color bg, Color text}) get _statusColors {
    switch (order.status) {
      case OrderStatus.delivered:
        return (bg: AppColors.successBg, text: AppColors.successText);
      case OrderStatus.shipped:
      case OrderStatus.processing:
        return (bg: AppColors.warningBg, text: AppColors.warningText);
      case OrderStatus.cancelled:
        return (bg: AppColors.errorBg, text: AppColors.errorText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Замовлення №${order.number}', style: AppTextStyles.bodyMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colors.bg,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      order.status.label,
                      style: AppTextStyles.caption.copyWith(color: colors.text),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${order.date.day.toString().padLeft(2, '0')}.'
                '${order.date.month.toString().padLeft(2, '0')}.'
                '${order.date.year} · ${order.itemsCount} товар(и)',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('${order.total} грн', style: AppTextStyles.h3),
            ],
          ),
        ),
      ),
    );
  }
}