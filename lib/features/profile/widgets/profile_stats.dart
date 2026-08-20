import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileStatItem {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const ProfileStatItem({
    required this.value,
    required this.label,
    this.onTap,
  });
}

class ProfileStats extends StatelessWidget {
  final List<ProfileStatItem> items;

  const ProfileStats({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) {
            return const SizedBox(
              height: 32,
              child: VerticalDivider(color: AppColors.borderNeutral, width: 1),
            );
          }

          final item = items[i ~/ 2];

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: item.onTap,
                child: Column(
                  children: [
                    Text(item.value, style: AppTextStyles.h3),
                    const SizedBox(height: 2),
                    Text(item.label, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}