import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_radius.dart';

class AgeVerificationStep extends StatefulWidget {
  final VoidCallback onVerified;

  const AgeVerificationStep({
    super.key,
    required this.onVerified,
  });

  @override
  State<AgeVerificationStep> createState() =>
      _AgeVerificationStepState();
}

class _AgeVerificationStepState extends State<AgeVerificationStep> {
  DateTime? birthDate;

  Future<void> selectBirthDate() async {
    final now = DateTime.now();

    final initialDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: birthDate ?? initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (selectedDate == null) return;

    setState(() {
      birthDate = selectedDate;
    });
  }

  bool isAdult(DateTime birthDate) {
    final today = DateTime.now();

    final adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );

    return !adultDate.isAfter(today);
  }

  void continueToNextStep() {
    if (birthDate == null) {
      return;
    }

    if (isAdult(birthDate!)) {
      widget.onVerified();
      return;
    }

    showUnderageDialog();
  }

  void showUnderageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Доступ обмежено',
            style: AppTextStyles.h3,
          ),
          content: const Text(
            'Для використання цього застосунку вам має бути не менше 18 років.',
            style: AppTextStyles.bodySmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Зрозуміло',
                style: TextStyle(
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          const Spacer(),

          Text(
            'Перевірка віку',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          const Text(
            'Для продовження підтвердьте свою дату народження.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          OutlinedButton(
            onPressed: selectBirthDate,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: AppColors.transparentFill,
              side: BorderSide(
                color: birthDate == null ? AppColors.borderNeutral : AppColors.accent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  birthDate == null
                      ? 'Оберіть дату народження'
                      : '${birthDate!.day.toString().padLeft(2, '0')}.'
                        '${birthDate!.month.toString().padLeft(2, '0')}.'
                        '${birthDate!.year}',
                  style: birthDate == null
                      ? AppTextStyles.bodySmall
                      : AppTextStyles.body,
                ),
                const Icon(Icons.calendar_today_outlined, color: AppColors.accent, size: 20),
              ],
            ),
          ),

          const Spacer(),

          AppButton(
            text: 'Продовжити',
            onPressed: birthDate == null
                ? null
                : continueToNextStep,
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),
        ],
      ),
    );
  }
}