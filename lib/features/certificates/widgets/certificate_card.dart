import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CertificateCard extends StatelessWidget {
  final int balance;
  final String code;
  final DateTime expiresAt;

  const CertificateCard({
    super.key,
    required this.balance,
    required this.code,
    required this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientPink, AppColors.gradientPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.card_giftcard, color: AppColors.accent),
              Text(
                '$balance грн',
                style: AppTextStyles.h2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Код сертифіката', style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(code, style: AppTextStyles.bodyMedium.copyWith(letterSpacing: 1)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Дійсний до ${expiresAt.day.toString().padLeft(2, '0')}.'
            '${expiresAt.month.toString().padLeft(2, '0')}.'
            '${expiresAt.year}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}