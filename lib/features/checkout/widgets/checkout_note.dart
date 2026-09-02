import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CheckoutNote extends StatelessWidget {
  final bool isCertificatePayment;

  const CheckoutNote({super.key, required this.isCertificatePayment});

  @override
  Widget build(BuildContext context) {
    final lines = isCertificatePayment
        ? const [
            'Сертифікат можна використати лише один раз, після використання він стає недійсним, а залишок не повертається.',
            'Якщо сума товарів у кошику перевищує номінал сертифіката, можна доплатити різницю або обрати товари на суму, еквівалентну номіналу.',
            'За сертифікатом можна придбати лише товари, наявні на сайті. Придбати інший сертифікат за сертифікатом не можна.',
          ]
        : const [
            'Замовлення з оплатою при отриманні відправляються за умови передплати 200 грн.',
            'У разі неотримання замовлення передплата не повертається.',
            'Сума передплати враховується у загальній вартості замовлення.',
            'Для замовлень на суму понад 2000 грн діє безкоштовна доставка.',
          ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: const Border(left: BorderSide(color: AppColors.accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Зверніть увагу', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.sm),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                '— $line',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}