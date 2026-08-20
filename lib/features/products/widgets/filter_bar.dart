import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class FilterBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final String sortLabel;
  final int activeFiltersCount;

  const FilterBar({
    super.key,
    required this.onFilterTap,
    required this.onSortTap,
    this.sortLabel = 'За популярністю',
    this.activeFiltersCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BarButton(
            icon: Icons.tune,
            label: activeFiltersCount == 0
                ? 'Фільтри'
                : 'Фільтри ($activeFiltersCount)',
            onTap: onFilterTap,
            highlighted: activeFiltersCount > 0,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _BarButton(
            icon: Icons.swap_vert,
            label: sortLabel,
            onTap: onSortTap,
          ),
        ),
      ],
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: highlighted ? AppColors.accent : AppColors.borderNeutral,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: highlighted ? AppColors.accent : AppColors.textGrey,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: highlighted ? AppColors.accent : AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}