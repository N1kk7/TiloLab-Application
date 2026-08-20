import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailingText,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.errorText : AppColors.text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.errorBg
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 18, color: color),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(color: color),
                ),
              ),

              if (trailingText != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Text(
                    trailingText!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.darkText),
                  ),
                ),

              if (!isDestructive)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.darkText,
                ),
            ],
          ),
        ),
      ),
    );
  }
}