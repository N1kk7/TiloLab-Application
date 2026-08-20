import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class OrderSummary extends StatelessWidget {
  final int subtotal;
  final int discount;
  final int? deliveryPrice;

  const OrderSummary({
    super.key,
    required this.subtotal,
    this.discount = 0,
    this.deliveryPrice,
  });

  int get total => subtotal - discount + (deliveryPrice ?? 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          _Row(label: 'Підсумок', value: '$subtotal грн'),

          if (discount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _Row(
              label: 'Знижка',
              value: '−$discount грн',
              valueColor: AppColors.successBorder,
            ),
          ],

          const SizedBox(height: AppSpacing.sm),
          _Row(
            label: 'Доставка',
            value: deliveryPrice == null ? 'За тарифами перевізника' : '$deliveryPrice грн',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(color: AppColors.borderNeutral, height: 1),
          ),

          _Row(
            label: 'Разом',
            value: '$total грн',
            labelStyle: AppTextStyles.bodyMedium,
            valueStyle: AppTextStyles.h3,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ?? AppTextStyles.bodySmall,
        ),
        Text(
          value,
          style: (valueStyle ?? AppTextStyles.bodySmall).copyWith(
            color: valueColor ?? (valueStyle == null ? AppColors.textGrey : AppColors.text),
          ),
        ),
      ],
    );
  }
}