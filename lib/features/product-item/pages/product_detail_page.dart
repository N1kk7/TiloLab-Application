import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import '../widgets/glass_icon_button.dart';
import '../widgets/product_attribute_grid.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_image_carousel.dart';

import '../../../models/product/product.dart';

class ProductDetailPage extends StatefulWidget {

  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState
    extends State<ProductDetailPage> {

  bool isFavorite = false;

  static const double _imageHeight = 440;

  final attributes = const [
    ProductAttribute(
      icon: Icons.category_outlined,
      label: 'Матеріал',
      value: 'Силікон',
    ),

    ProductAttribute(
      icon: Icons.bolt_outlined,
      label: 'Живлення',
      value: 'USB',
    ),

    ProductAttribute(
      icon: Icons.tune,
      label: 'Режими',
      value: '10',
    ),

    ProductAttribute(
      icon: Icons.water_drop_outlined,
      label: 'Захист',
      value: 'IPX7',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    final product = widget.product;

    final imageUrls = product.images
        .map((image) => image.path)
        .where(
          (path) => path.trim().isNotEmpty,
        )
        .toList();

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

                  backgroundColor:
                      AppColors.bg,

                  elevation: 0,

                  expandedHeight:
                      _imageHeight,

                  collapsedHeight:
                      kToolbarHeight,

                  flexibleSpace:
                      FlexibleSpaceBar(

                    collapseMode:
                        CollapseMode.pin,

                    background:
                        ProductImageCarousel(
                      imageUrls:
                          imageUrls,
                    ),
                  ),

                  leading: Padding(
                    padding:
                        const EdgeInsets.only(
                      left: AppSpacing.sm,
                    ),

                    child: GlassIconButton(
                      icon:
                          Icons.arrow_back_ios_new,

                      onTap: () =>
                          Navigator.of(context)
                              .maybePop(),
                    ),
                  ),

                  actions: [

                    GlassIconButton(
                      icon: isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,

                      iconColor: isFavorite
                          ? AppColors.accentRed
                          : Colors.white,

                      onTap: () {

                        setState(() {
                          isFavorite =
                              !isFavorite;
                        });

                      },
                    ),

                    const SizedBox(
                      width: AppSpacing.sm,
                    ),

                    GlassIconButton(
                      icon:
                          Icons.ios_share,

                      onTap: () {},
                    ),

                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                  ],
                ),

                SliverToBoxAdapter(

                  child: Transform.translate(
                    offset:
                        const Offset(0, -20),

                    child: Container(

                      decoration:
                          const BoxDecoration(
                        color: AppColors.bg,

                        borderRadius:
                            BorderRadius.vertical(
                          top: Radius.circular(
                            AppRadius.lg,
                          ),
                        ),
                      ),

                      padding:
                          const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // Индикатор
                          Center(
                            child: Container(
                              width: 36,
                              height: 4,

                              margin:
                                  const EdgeInsets.only(
                                bottom:
                                    AppSpacing.md,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    AppColors
                                        .borderNeutral,

                                borderRadius:
                                    BorderRadius
                                        .circular(2),
                              ),
                            ),
                          ),

                          // Название
                          Text(
                            product.title,
                            style:
                                AppTextStyles.h2,
                          ),

                          const SizedBox(
                            height: AppSpacing.sm,
                          ),

                          // Цена
                          Text(
                            '${product.productPrice.toInt()} грн',
                            style:
                                AppTextStyles.h3,
                          ),

                          const SizedBox(
                            height: AppSpacing.sm,
                          ),

                          // Наличие
                          Text(
                            product.availableStock > 0
                                ? 'В наявності'
                                : 'Немає в наявності',

                            style: AppTextStyles
                                .bodySmall
                                .copyWith(
                              color:
                                  product.availableStock >
                                          0
                                      ? Colors.green
                                      : AppColors
                                          .accentRed,
                            ),
                          ),

                          const SizedBox(
                            height: AppSpacing.lg,
                          ),

                          // Характеристики
                          Container(

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical:
                                  AppSpacing.md,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  AppColors.surface,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                AppRadius.lg,
                              ),
                            ),

                            child:
                                ProductAttributeGrid(
                              attributes:
                                  attributes,
                            ),
                          ),

                          const SizedBox(
                            height: AppSpacing.lg,
                          ),

                          // Описание
                          Text(
                            'Опис',
                            style:
                                AppTextStyles.h3,
                          ),

                          const SizedBox(
                            height: AppSpacing.sm,
                          ),

                          Text(
                            product.description ??
                                'Опис відсутній.',

                            style: AppTextStyles
                                .bodySmall
                                .copyWith(
                              color:
                                  AppColors.textGrey,
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

          // Нижняя панель
          Container(

            padding:
                const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),

            decoration:
                const BoxDecoration(
              color: AppColors.bg,

              border: Border(
                top: BorderSide(
                  color:
                      AppColors.borderNeutral,
                ),
              ),
            ),

            child: SafeArea(
              top: false,

              child: ProductBottomBar(

                price:
                    product.productPrice.toInt(),

                onAddToCart: () {

                  // TODO:
                  // добавить product в корзину

                  print(
                    'ADD PRODUCT: ${product.id}',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}