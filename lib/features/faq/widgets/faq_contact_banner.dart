import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class FaqContactBanner extends StatelessWidget {
  final VoidCallback onContactTap;

  const FaqContactBanner({super.key, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              'https://picsum.photos/seed/faq-support/800/450',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceElevated,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.support_agent_outlined,
                  size: 40,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Не знайшли відповідь?', style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Напишіть нам — відповімо протягом кількох годин.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContactTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.bg,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      'Звʼязатися з нами',
                      style: AppTextStyles.button.copyWith(color: AppColors.bg),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}