import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'category_chip.dart';

class CategoryItem {
  final String label;
  final IconData icon;

  const CategoryItem({
    required this.label,
    required this.icon,
  });
}

class CategoryList extends StatelessWidget {
  final List<CategoryItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];

          return CategoryChip(
            label: category.label,
            icon: category.icon,
            isSelected: index == selectedIndex,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}