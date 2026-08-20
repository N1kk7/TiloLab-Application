import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PromoCodeField extends StatefulWidget {
  final ValueChanged<String> onApply;
  final String? appliedCode;
  final VoidCallback onRemove;

  const PromoCodeField({
    super.key,
    required this.onApply,
    this.appliedCode,
    required this.onRemove,
  });

  @override
  State<PromoCodeField> createState() => _PromoCodeFieldState();
}

class _PromoCodeFieldState extends State<PromoCodeField> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appliedCode != null) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.successBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.successBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, size: 18, color: AppColors.successBorder),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                'Промокод "${widget.appliedCode}" застосовано',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.successText),
              ),
            ),
            GestureDetector(
              onTap: widget.onRemove,
              child: const Icon(Icons.close, size: 18, color: AppColors.successText),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTextStyles.bodySmall,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Промокод',
              hintStyle: AppTextStyles.bodySmall,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              widget.onApply(controller.text.trim());
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.accent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Text(
              'Застосувати',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}