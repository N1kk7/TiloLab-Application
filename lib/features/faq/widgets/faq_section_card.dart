import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/faq_data.dart';

class FaqSectionCard extends StatefulWidget {
  final FaqSection section;

  const FaqSectionCard({super.key, required this.section});

  @override
  State<FaqSectionCard> createState() => _FaqSectionCardState();
}

class _FaqSectionCardState extends State<FaqSectionCard> {
  late bool _collapsed = widget.section.bullets.length > 3;

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final isCollapsible = section.bullets.length > 3;
    final visibleBullets =
        _collapsed ? section.bullets.take(2).toList() : section.bullets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // заголовок вынесен за пределы карточки
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(section.icon, size: 16, color: AppColors.accent),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(section.title, style: AppTextStyles.h3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),

        // градиентный разделитель под заголовком
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.5),
                AppColors.accent.withOpacity(0),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // сама карточка теперь просто "контент"
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderNeutral),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.intro != null) ...[
                Text(
                  section.intro!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              if (section.bullets.isNotEmpty)
                ...visibleBullets.map(
                  (bullet) => Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.xs,
                      left: bullet.isNested ? AppSpacing.md : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          bullet.isNested
                              ? Icons.circle
                              : Icons.check_circle_outline,
                          size: bullet.isNested ? 6 : 15,
                          color: bullet.isNested
                              ? AppColors.darkText
                              : AppColors.accent,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            bullet.text,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: bullet.isNested
                                  ? AppColors.darkText
                                  : AppColors.textGrey,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (isCollapsible)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: InkWell(
                    onTap: () => setState(() => _collapsed = !_collapsed),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _collapsed ? 'Показати ще' : 'Згорнути',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          _collapsed
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          size: 16,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                ),

              if (section.outro != null && !_collapsed) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  section.outro!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}