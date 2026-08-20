import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../features/home/widgets/category_list.dart';

// import '../widgets/category_list.dart';
import '../features/home/widgets/hero_banner.dart';
import '../features/home/widgets/product_section.dart';
import '../features/home/widgets/feature_highlights.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int selectedCategory = 0;

  final categories = const [
    CategoryItem(label: 'Всі', icon: Icons.apps),
    CategoryItem(label: 'Для неї', icon: Icons.favorite_border),
    CategoryItem(label: 'Для нього', icon: Icons.male_outlined),
    CategoryItem(label: 'Лубриканти', icon: Icons.water_drop_outlined),
    CategoryItem(label: 'Подарунки', icon: Icons.card_giftcard_outlined),
  ];

  final certificates = const [
    ProductSectionItem(
      name: 'Подарунковий сертифікат 5000 грн',
      imageUrl: 'https://picsum.photos/seed/cert1/400',
      price: 5000,
      isSoldOut: true,
    ),
    ProductSectionItem(
      name: 'Подарунковий сертифікат 1000 грн',
      imageUrl: 'https://picsum.photos/seed/cert2/400',
      price: 1000,
    ),
  ];

  final forHer = const [
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
  ];

  final forHim = const [
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),

          HeroBanner(
            title: 'Секс-девайси про\nніжність до тіла',
            imageUrl: 'https://picsum.photos/seed/hero/800/900',
            ctaLabel: 'Обрати девайс',
            onCtaTap: () {},
          ),

          const SizedBox(height: AppSpacing.xl),

          CategoryList(
            categories: categories,
            selectedIndex: selectedCategory,
            onSelected: (index) => setState(() => selectedCategory = index),
          ),

          const SizedBox(height: AppSpacing.xl),

          ProductSection(
            title: 'Для неї',
            products: forHer,
            onSeeAll: () {},
          ),

          const SizedBox(height: AppSpacing.xl),

          ProductSection(
            title: 'Для нього',
            products: forHim,
            onSeeAll: () {},
          ),

          const SizedBox(height: AppSpacing.xl),

          ProductSection(
            title: 'Подарункові сертифікати',
            products: certificates,
            onSeeAll: () {},
          ),

          const SizedBox(height: AppSpacing.xl),

          const FeatureHighlights(),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}