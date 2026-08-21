import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/glass_icon_button.dart';
import '../widgets/product_attribute_grid.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_image_carousel.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false;

  static const double _imageHeight = 440;

  final attributes = const [
    ProductAttribute(icon: Icons.category_outlined, label: 'Матеріал', value: 'Силікон'),
    ProductAttribute(icon: Icons.bolt_outlined, label: 'Живлення', value: 'USB'),
    ProductAttribute(icon: Icons.tune, label: 'Режими', value: '10'),
    ProductAttribute(icon: Icons.water_drop_outlined, label: 'Захист', value: 'IPX7'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.bg,
                  elevation: 0,
                  expandedHeight: _imageHeight,
                  collapsedHeight: kToolbarHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: const ProductImageCarousel(
                      imageUrls: [
                        'https://picsum.photos/seed/product1/800/1000',
                        'https://picsum.photos/seed/product2/800/1000',
                        'https://picsum.photos/seed/product3/800/1000',
                      ],
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: GlassIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  actions: [
                    GlassIconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFavorite ? AppColors.accentRed : Colors.white,
                      onTap: () => setState(() => isFavorite = !isFavorite),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GlassIconButton(
                      icon: Icons.ios_share,
                      onTap: () {},
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.lg),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ручка-индикатор, чисто визуальный акцент
                          Center(
                            child: Container(
                              width: 36,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.borderNeutral,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          Text('Snake Plant', style: AppTextStyles.h2),
                          const SizedBox(height: 2),
                          Text('Sansevieria trifasciata', style: AppTextStyles.bodySmall),

                          const SizedBox(height: AppSpacing.sm),

                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text(
                                '4.8 (120)',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.text),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text(
                                  'Тихий режим',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textGrey),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // ── характеристики выше описания ──
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: ProductAttributeGrid(attributes: attributes),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // ── описание ниже ──
                          Text('Опис', style: AppTextStyles.h3),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Ергономічний дизайн, медичний силікон та 10 '
                            'режимів вібрації. Тихий мотор дозволяє '
                            'використовувати девайс делікатно, не '
                            'привертаючи зайвої уваги. Повністю водостійкий '
                            'корпус — можна використовувати в душі або ванні. '
                            'Заряджається через USB-кабель у комплекті, '
                            'однієї зарядки вистачає приблизно на 2 години '
                            'активного використання.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textGrey,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              border: Border(
                top: BorderSide(color: AppColors.borderNeutral),
              ),
            ),
            child: SafeArea(
              top: false,
              child: ProductBottomBar(
                price: 1200,
                onAddToCart: () {
                  // TODO: добавить товар в корзину
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}