import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tilolab_app/core/theme/app_colors.dart';
import 'package:tilolab_app/core/theme/app_radius.dart';
import 'package:tilolab_app/core/theme/app_spacing.dart';
import 'package:tilolab_app/core/theme/app_text_styles.dart';

import 'package:tilolab_app/providers/category_provider.dart';
import 'package:tilolab_app/providers/home_products_provider.dart';

import '../features/home/models/hero_banner_data.dart';
import '../features/home/widgets/hero_banner_slider.dart';
import '../features/home/widgets/home_search_bar.dart';
import '../features/home/widgets/category_list.dart';
import '../features/home/widgets/product_section.dart';
import '../features/home/widgets/feature_highlights.dart';
import '../features/home/widgets/category_list_skeleton.dart';
import '../features/home/widgets/product_card_skeleton.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage> {
  int selectedCategory = 0;

  static const _banners = [
    HeroBannerData(
      title: 'Секс-девайси про\nніжність до тіла',
      imageUrl:
          'https://picsum.photos/seed/hero1/800/900',
    ),
    HeroBannerData(
      title: 'Нова колекція\nдля неї',
      imageUrl:
          'https://picsum.photos/seed/hero2/800/900',
    ),
    HeroBannerData(
      title: 'Знижки до 30%\nна аксесуари',
      imageUrl:
          'https://picsum.photos/seed/hero3/800/900',
    ),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadHomeData);
  }

  // ============================================================
  // LOAD HOME DATA
  // ============================================================

  Future<void> _loadHomeData() async {
    try {
      final categoryNotifier =
          ref.read(categoryProvider.notifier);

      final homeProductNotifier =
          ref.read(homeProductProvider.notifier);

      // ----------------------------------------------------------
      // 1. LOAD CATEGORIES
      // ----------------------------------------------------------

      await categoryNotifier.loadCategories();

      // ----------------------------------------------------------
      // 2. GET CATEGORIES FROM PROVIDER
      // ----------------------------------------------------------

      final categories =
          ref.read(categoryProvider).categories;

      // ----------------------------------------------------------
      // 3. LOAD HOME PRODUCTS
      //
      // Внутри HomeProductNotifier:
      //
      // FOR HER ─────┐
      //              ├── Future.wait()
      // FOR HIM ─────┘
      //
      // ----------------------------------------------------------

      await homeProductNotifier.loadProducts(
        categories: categories,
      );
    } catch (error) {
      debugPrint(
        'ERROR LOAD HOME DATA: $error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState =
        ref.watch(categoryProvider);

    final homeProductState =
        ref.watch(homeProductProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.xxl,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const SizedBox(
            height: AppSpacing.md,
          ),

          // ======================================================
          // HERO
          // ======================================================

          HeroBannerSlider(
            banners: _banners,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          // ======================================================
          // CTA
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),

            child: SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  // TODO:
                  // Navigator.push(...)
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.accent,

                  foregroundColor:
                      AppColors.bg,

                  elevation: 0,

                  minimumSize:
                      const Size(
                    double.infinity,
                    52,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      AppRadius.md,
                    ),
                  ),
                ),

                child: Text(
                  'Обрати девайс',

                  style:
                      AppTextStyles.button
                          .copyWith(
                    color: AppColors.bg,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          // ======================================================
          // SEARCH
          // ======================================================

          HomeSearchBar(
            onTap: () {
              // TODO:
              // Navigator.push(...)
            },

            onFilterTap: () {
              // TODO:
              // filters
            },
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          // ======================================================
          // CATEGORIES
          // ======================================================

          if (categoryState.isLoading)

            const CategoryListSkeleton()

          else if (
              categoryState.categories.isNotEmpty
          )

            CategoryList(
              categories:
                  categoryState.categories,

              selectedIndex:
                  selectedCategory,

              onSelected: (index) {
                setState(() {
                  selectedCategory =
                      index;
                });
              },
            ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          // ======================================================
          // PRODUCTS
          // ======================================================

          if (homeProductState.isLoading)

            GridView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              padding:
                  const EdgeInsets.symmetric(
                horizontal:
                    AppSpacing.lg,
              ),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                mainAxisSpacing:
                    AppSpacing.sm,

                crossAxisSpacing:
                    AppSpacing.sm,

                childAspectRatio: 0.58,
              ),

              itemCount: 6,

              itemBuilder:
                  (context, index) {
                return const
                    ProductCardSkeleton();
              },
            )

          else ...[
            // ====================================================
            // FOR HER
            // ====================================================

            if (homeProductState
                .forHer
                .isNotEmpty)

              ProductSection(
                title: 'Для неї',

                products:
                    homeProductState.forHer,

                onSeeAll: () {
                  // TODO:
                  // ProductsPage
                },
              ),

            if (homeProductState
                .forHer
                .isNotEmpty)

              const SizedBox(
                height: AppSpacing.xl,
              ),

            // ====================================================
            // FOR HIM
            // ====================================================

            if (homeProductState
                .forHim
                .isNotEmpty)

              ProductSection(
                title: 'Для нього',

                products:
                    homeProductState.forHim,

                onSeeAll: () {
                  // TODO:
                  // ProductsPage
                },
              ),

            if (homeProductState
                .forHim
                .isNotEmpty)

              const SizedBox(
                height: AppSpacing.xl,
              ),

            // ====================================================
            // CERTIFICATE
            // ====================================================

            const _CertificateCard(),

            const SizedBox(
              height: AppSpacing.xl,
            ),
          ],

          // ======================================================
          // FEATURES
          // ======================================================

          const FeatureHighlights(),

          const SizedBox(
            height: AppSpacing.xl,
          ),
        ],
      ),
    );
  }
}


// ============================================================
// CERTIFICATE CARD
// ============================================================

class _CertificateCard extends StatelessWidget {
  const _CertificateCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Container(
        width: double.infinity,
        height: 210,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage(
              'assets/images/faq-main.png',
            ),
            fit: BoxFit.cover,
          ),
        ),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.65),
                Colors.transparent,
              ],
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                'Подарунковий сертифікат',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              Text(
                'Подаруй можливість обрати щось особливе',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Обрати сертифікат',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}