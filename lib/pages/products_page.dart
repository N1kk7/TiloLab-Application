import 'package:flutter/material.dart';

// import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../features/home/widgets/category_list.dart';
import '../features/home/widgets/product_card.dart';
import '../features/home/widgets/product_section.dart';
import '../features/products/widgets/filter_bar.dart';
import '../features/products/widgets/filter_bottom_sheet.dart';
import '../features/products/widgets/search_field.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int selectedCategory = 0;
  ProductFilters filters = const ProductFilters();

  final categories = const [
    CategoryItem(label: 'Всі', icon: Icons.apps),
    CategoryItem(label: 'Для неї', icon: Icons.favorite_border),
    CategoryItem(label: 'Для нього', icon: Icons.male_outlined),
    CategoryItem(label: 'Лубриканти', icon: Icons.water_drop_outlined),
    CategoryItem(label: 'Подарунки', icon: Icons.card_giftcard_outlined),
  ];

  final allProducts = const [
    ProductSectionItem(
      name: 'Вібратор Silky Touch',
      imageUrl: 'https://picsum.photos/seed/1/400',
      price: 1200,
    ),
    ProductSectionItem(
      name: 'Набір для масажу',
      imageUrl: 'https://picsum.photos/seed/2/400',
      price: 890,
      oldPrice: 1100,
    ),
    ProductSectionItem(
      name: 'Кільце ніжності',
      imageUrl: 'https://picsum.photos/seed/3/400',
      price: 650,
      isSoldOut: true,
    ),
    ProductSectionItem(
      name: 'Мастурбатор Pulse',
      imageUrl: 'https://picsum.photos/seed/4/400',
      price: 1500,
    ),
    ProductSectionItem(
      name: 'Кільце витривалості',
      imageUrl: 'https://picsum.photos/seed/5/400',
      price: 400,
    ),
    ProductSectionItem(
      name: 'Набір для двох',
      imageUrl: 'https://picsum.photos/seed/6/400',
      price: 2200,
      oldPrice: 2600,
    ),
  ];

  Future<void> openFilters() async {
    final result = await showModalBottomSheet<ProductFilters>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        initialFilters: filters,
        availableCategories: categories.map((c) => c.label).toList(),
      ),
    );

    if (result != null) {
      setState(() => filters = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: заменить на реальную фильтрацию из filters/selectedCategory
    final filteredProducts = allProducts;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),

                Text('Каталог', style: AppTextStyles.h1),

                const SizedBox(height: AppSpacing.md),

                const SearchField(),

                const SizedBox(height: AppSpacing.md),

                FilterBar(
                  activeFiltersCount: filters.categories.length,
                  onFilterTap: openFilters,
                  onSortTap: () {
                    // TODO: bottom sheet сортировки (за ціною, новизною і т.д.)
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          CategoryList(
            categories: categories,
            selectedIndex: selectedCategory,
            onSelected: (index) => setState(() => selectedCategory = index),
          ),

          const SizedBox(height: AppSpacing.md),

          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      'Товарів не знайдено',
                      style: AppTextStyles.bodySmall,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.58,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return ProductCard(
                        name: product.name,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        oldPrice: product.oldPrice,
                        isSoldOut: product.isSoldOut,
                        onTap: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}