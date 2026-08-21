import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProductBottomBar extends StatelessWidget {
  final int price;
  final int? oldPrice;
  final VoidCallback onAddToCart;

  const ProductBottomBar({
    super.key,
    required this.price,
    this.oldPrice,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$price грн',
              style: AppTextStyles.h2.copyWith(
                color: oldPrice == null ? AppColors.text : AppColors.discountPrice,
              ),
            ),
            if (oldPrice != null)
              Text(
                '$oldPrice грн',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.darkText,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),

        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.bg,
              elevation: 0,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
            label: Text(
              'Додати в кошик',
              style: AppTextStyles.button.copyWith(color: AppColors.bg),
            ),
          ),
        ),
      ],
    );
  }
}