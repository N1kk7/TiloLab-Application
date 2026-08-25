import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.onTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.borderNeutral),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 20, color: AppColors.darkText),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Пошук товарів...',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.darkText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}