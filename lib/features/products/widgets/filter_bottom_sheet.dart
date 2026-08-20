import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProductFilters {
  final RangeValues priceRange;
  final Set<String> categories;

  const ProductFilters({
    this.priceRange = const RangeValues(0, 5000),
    this.categories = const {},
  });

  ProductFilters copyWith({
    RangeValues? priceRange,
    Set<String>? categories,
  }) {
    return ProductFilters(
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final ProductFilters initialFilters;
  final List<String> availableCategories;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.availableCategories,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues priceRange = widget.initialFilters.priceRange;
  late Set<String> selectedCategories = {...widget.initialFilters.categories};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Фільтри', style: AppTextStyles.h3),
                TextButton(
                  onPressed: () {
                    setState(() {
                      priceRange = const RangeValues(0, 5000);
                      selectedCategories = {};
                    });
                  },
                  child: Text(
                    'Скинути',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Text('Категорії', style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSpacing.sm),

            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: widget.availableCategories.map((category) {
                final isSelected = selectedCategories.contains(category);

                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
                      }
                    });
                  },
                  showCheckmark: false,
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                  labelStyle: AppTextStyles.caption.copyWith(
                    color: isSelected ? AppColors.bg : AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text('Ціна, грн', style: AppTextStyles.bodyMedium),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 5000,
              divisions: 50,
              activeColor: AppColors.accent,
              inactiveColor: AppColors.borderNeutral,
              labels: RangeLabels(
                priceRange.start.round().toString(),
                priceRange.end.round().toString(),
              ),
              onChanged: (values) => setState(() => priceRange = values),
            ),

            const SizedBox(height: AppSpacing.md),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    ProductFilters(
                      priceRange: priceRange,
                      categories: selectedCategories,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bg,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Показати результати',
                  style: AppTextStyles.button.copyWith(color: AppColors.bg),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}