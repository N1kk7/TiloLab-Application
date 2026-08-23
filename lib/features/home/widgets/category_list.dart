import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../models/category/category.dart';
import 'category_chip.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(
          width: AppSpacing.sm,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];

          return CategoryChip(
            label: category.title,
            imageUrl: category.categoryImg,
            isSelected: index == selectedIndex,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}