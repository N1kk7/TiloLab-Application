import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomeStep({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          const Spacer(),

          Image.asset(
            'assets/images/logo.png',
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: AppSpacing.xl),
          

          Text(
            'Вітаємо в застосунку!',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Ми відкриваємо нові межі для Вашого задоволення, '
            'близкості та нових відчуттів.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Відкрий для себе колекцію товарів, '
            'і знайди те що підійде саме тобі.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),


          const Spacer(),

          AppButton(
            text: 'Розпочати',
            onPressed: onContinue,
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}