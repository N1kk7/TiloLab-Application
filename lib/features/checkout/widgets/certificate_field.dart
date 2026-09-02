import 'package:flutter/material.dart';

import '../../../core/services/app_tooltip.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CertificateField extends StatefulWidget {
  final bool cartContainsCertificate;
  final ValueChanged<String> onApplied;
  final String? appliedCode;
  final VoidCallback onRemove;

  const CertificateField({
    super.key,
    required this.cartContainsCertificate,
    required this.onApplied,
    this.appliedCode,
    required this.onRemove,
  });

  @override
  State<CertificateField> createState() => _CertificateFieldState();
}

class _CertificateFieldState extends State<CertificateField> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _apply() {
    final code = controller.text.trim();
    if (code.isEmpty) return;

    if (widget.cartContainsCertificate) {
      AppToast.warning(
        context,
        "Дія існуючого сертифіката не розповсюджується на придбання іншого сертифіката",
      );
      controller.clear();
      return;
    }

    // TODO: реальна перевірка коду через API (аналог /api/certificates/get-certificate)
    widget.onApplied(code);
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
                'Сертифікат "${widget.appliedCode}" застосовано',
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
            textCapitalization: TextCapitalization.characters,
            style: AppTextStyles.bodySmall,
            decoration: InputDecoration(
              hintText: 'Код сертифіката',
              hintStyle: AppTextStyles.bodySmall,
              filled: true,
              fillColor: AppColors.surfaceElevated,
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
            onPressed: _apply,
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