import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/address_model.dart';

class AddressCard extends StatelessWidget {
  final DeliveryAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: address.isDefault
            ? Border.all(color: AppColors.accent)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(address.type.icon, size: 18, color: AppColors.accent),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.city, style: AppTextStyles.bodyMedium),
                    if (address.isDefault) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Основна',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.bg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  address.type.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                ),
                const SizedBox(height: 4),
                Text(
                  address.description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),

          Column(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.darkText),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline, size: 18, color: AppColors.errorText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}