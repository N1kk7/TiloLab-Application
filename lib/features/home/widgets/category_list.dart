import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../models/category/category.dart';
import 'category_avatar_item.dart';

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
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];

          return CategoryAvatarItem(
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