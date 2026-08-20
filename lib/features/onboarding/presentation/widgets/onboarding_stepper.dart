import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingStepper({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(
          totalSteps,
          (index) {
            final isActive = index <= currentStep;

            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 4,
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1
                      ? 0
                      : AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.accent
                      : AppColors.accentGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}