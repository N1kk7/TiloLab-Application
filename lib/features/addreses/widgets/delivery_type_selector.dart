import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/address_model.dart';

class DeliveryTypeSelector extends StatelessWidget {
  final DeliveryType value;
  final ValueChanged<DeliveryType> onChanged;

  const DeliveryTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: DeliveryType.values.map((type) {
        final isSelected = type == value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: type == DeliveryType.values.last ? 0 : AppSpacing.sm,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChanged(type),
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.borderNeutral,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        type.icon,
                        size: 18,
                        color: isSelected ? AppColors.bg : AppColors.textGrey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected ? AppColors.bg : AppColors.textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}