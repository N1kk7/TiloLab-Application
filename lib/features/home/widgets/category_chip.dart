import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected
                  ? AppColors.accent
                  : AppColors.borderNeutral,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null) ...[
                ClipOval(
                  child: Image.network(
                    imageUrl!,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                      );
                    },
                  ),
                ),

                const SizedBox(
                  width: AppSpacing.xs,
                ),
              ],

              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected
                      ? AppColors.bg
                      : AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}