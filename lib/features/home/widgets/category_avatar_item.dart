import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CategoryAvatarItem extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryAvatarItem({
    super.key,
    required this.label,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.surface,
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.borderNeutral,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.category_outlined,
                        size: 20,
                        color: isSelected ? AppColors.accent : AppColors.darkText,
                      ),
                    ),
                  )
                : Icon(
                    Icons.category_outlined,
                    size: 20,
                    color: isSelected ? AppColors.accent : AppColors.darkText,
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: 64,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.accent : AppColors.textGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}