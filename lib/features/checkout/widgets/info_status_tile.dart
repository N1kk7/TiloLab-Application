import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class InfoStatusTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isComplete;
  final VoidCallback onTap;

  const InfoStatusTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.isComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.error_outline,
                color: isComplete ? AppColors.successBorder : AppColors.errorBorder,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? 'Не заповнено',
                      style: AppTextStyles.caption.copyWith(
                        color: isComplete ? AppColors.textGrey : AppColors.errorText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.darkText, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}