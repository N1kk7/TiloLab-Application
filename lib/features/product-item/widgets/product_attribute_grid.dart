import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProductAttribute {
  final IconData icon;
  final String label;
  final String value;

  const ProductAttribute({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ProductAttributeGrid extends StatelessWidget {
  final List<ProductAttribute> attributes;

  const ProductAttributeGrid({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: attributes
          .map(
            (attribute) => Expanded(
              child: Column(
                children: [
                  Icon(attribute.icon, size: 20, color: AppColors.accent),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    attribute.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    attribute.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.darkText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}