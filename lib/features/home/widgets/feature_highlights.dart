import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class FeatureHighlight {
  final IconData icon;
  final String label;

  const FeatureHighlight({required this.icon, required this.label});
}

class FeatureHighlights extends StatelessWidget {
  const FeatureHighlights({super.key});

  static const _items = [
    FeatureHighlight(icon: Icons.verified_outlined, label: 'Якісні\nматеріали'),
    FeatureHighlight(icon: Icons.lock_outline, label: 'Конфіден-\nційність'),
    FeatureHighlight(icon: Icons.local_shipping_outlined, label: 'Швидка\nдоставка'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _items
            .map(
              (item) => Expanded(
                child: Column(
                  children: [
                    Icon(item.icon, color: AppColors.accent, size: 26),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}