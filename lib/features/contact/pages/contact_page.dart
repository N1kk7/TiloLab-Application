import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/working_hours.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const phoneNumber = '+380933270400';
  static const instagramUrl = 'https://instagram.com/tilolab';

  Future<void> callUs() async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> openInstagram() async {
    final uri = Uri.parse(instagramUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = isStoreOpenNow();
    final today = DateTime.now().weekday;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text("Зв'язатися з нами", style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Ми завжди на звʼязку і готові відповісти на будь-які '
              'запитання про товари, доставку чи замовлення. Оберіть '
              'зручний спосіб звʼязку нижче.',
              style: AppTextStyles.bodySmall.copyWith(height: 1.6),
            ),

            const SizedBox(height: AppSpacing.lg),

            // статус зараз
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isOpen ? AppColors.successBg : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: isOpen
                    ? Border.all(color: AppColors.successBorder)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isOpen ? Icons.check_circle_outline : Icons.access_time,
                    size: 20,
                    color: isOpen ? AppColors.successBorder : AppColors.darkText,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      isOpen ? 'Зараз ми на звʼязку' : 'Зараз ми не працюємо',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isOpen ? AppColors.successText : AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text('Графік роботи', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: List.generate(7, (index) {
                  final weekday = index + 1;
                  final range = workingHours[weekday];
                  final isToday = weekday == today;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            weekdayLabels[index],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isToday ? AppColors.accent : AppColors.textGrey,
                              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          range?.label ?? 'Вихідний',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isToday ? AppColors.accent : AppColors.text,
                            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            if (isOpen)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: callUs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.bg,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  icon: const Icon(Icons.call_outlined, size: 18),
                  label: Text(
                    'Подзвонити',
                    style: AppTextStyles.button.copyWith(color: AppColors.bg),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.sm),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: openInstagram,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.borderNeutral),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: const Icon(Icons.camera_alt_outlined, size: 18, color: AppColors.textGrey),
                label: Text(
                  'Instagram',
                  style: AppTextStyles.button.copyWith(color: AppColors.textGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}