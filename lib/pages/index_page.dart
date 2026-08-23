import 'package:flutter/material.dart';

import 'package:tilolab_app/core/api/api_client.dart';

import '../../../core/theme/app_spacing.dart';

import '../features/home/widgets/category_list.dart';
import '../features/home/widgets/hero_banner.dart';
import '../features/home/widgets/product_section.dart';
import '../features/home/widgets/feature_highlights.dart';

import 'package:tilolab_app/core/theme/app_text_styles.dart';

import '../features/home/data/category_repository.dart';

import '../models/category/category.dart';
import '../models/product/product.dart';

import '../../repositories/product_repository.dart';
import '../models/product/product_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // ============================================================
  // REPOSITORIES
  // ============================================================

  final categoryRepository = CategoryRepository(
    apiClient: ApiClient(),
  );

  final ProductRepository productRepository =
      ProductRepository(ApiClient());

  // ============================================================
  // CATEGORIES
  // ============================================================

  List<Category> categories = [];

  int selectedCategory = 0;

  bool isLoadingCategories = false;

  // ============================================================
  // PRODUCTS
  // ============================================================

  List<Product> forHer = [];
  List<Product> forHim = [];

  bool isLoadingProducts = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadHomeData();
  }

  // ============================================================
  // FIND CATEGORY
  // ============================================================

  Category? findCategory({
    required List<String> groups,
    required String title,
  }) {
    for (final category in categories) {
      // Сначала проверяем group
      if (groups.contains(category.group)) {
        return category;
      }

      // Если group отличается — проверяем украинский title
      if (category.title.trim().toLowerCase() ==
          title.trim().toLowerCase()) {
        return category;
      }
    }

    return null;
  }

  // ============================================================
  // LOAD HOME DATA
  // ============================================================

  Future<void> loadHomeData() async {
    if (mounted) {
      setState(() {
        isLoadingCategories = true;
        isLoadingProducts = true;
      });
    }

    try {
      // ----------------------------------------------------------
      // 1. CATEGORIES
      // ----------------------------------------------------------

      final loadedCategories =
          await categoryRepository.getCategories();

      if (!mounted) return;

      setState(() {
        categories = loadedCategories;
        isLoadingCategories = false;
      });

      // ----------------------------------------------------------
      // DEBUG
      // ----------------------------------------------------------

      for (final category in categories) {
        print(
          'CATEGORY: '
          'id=${category.id}, '
          'group=${category.group}, '
          'title=${category.title}',
        );
      }

      // ----------------------------------------------------------
      // 2. FIND "FOR HER"
      // ----------------------------------------------------------

      final herCategory = findCategory(
        groups: [
          'Dlya-neyi',
          'Dlya-nee',
          'Dlya-nei',
        ],
        title: 'Для неї',
      );

      // ----------------------------------------------------------
      // 3. FIND "FOR HIM"
      // ----------------------------------------------------------

      final himCategory = findCategory(
        groups: [
          'Dlya-nego',
          'Dlya-nogo',
          'Dlya-nego',
        ],
        title: 'Для нього',
      );

      print(
        'HER CATEGORY: '
        '${herCategory?.id} / ${herCategory?.group} / ${herCategory?.title}',
      );

      print(
        'HIM CATEGORY: '
        '${himCategory?.id} / ${himCategory?.group} / ${himCategory?.title}',
      );

      // ----------------------------------------------------------
      // 4. PREPARE REQUESTS
      // ----------------------------------------------------------

      final futures = <Future<ProductPage>>[];

      if (herCategory != null) {
        futures.add(
          productRepository.getProducts(
            page: 1,
            limit: 10,
            categoryId: herCategory.id,
          ),
        );
      }

      if (himCategory != null) {
        futures.add(
          productRepository.getProducts(
            page: 1,
            limit: 10,
            categoryId: himCategory.id,
          ),
        );
      }

      // ----------------------------------------------------------
      // 5. LOAD PRODUCTS
      // ----------------------------------------------------------

      if (futures.isEmpty) {
        if (mounted) {
          setState(() {
            isLoadingProducts = false;
          });
        }

        return;
      }

      final results = await Future.wait(futures);

      if (!mounted) return;

      // ----------------------------------------------------------
      // 6. DISTRIBUTE RESULTS
      // ----------------------------------------------------------

      int resultIndex = 0;

      List<Product> newForHer = [];
      List<Product> newForHim = [];

      if (herCategory != null) {
        newForHer = results[resultIndex].products;
        resultIndex++;
      }

      if (himCategory != null) {
        newForHim = results[resultIndex].products;
        resultIndex++;
      }

      print('FOR HER PRODUCTS: ${newForHer.length}');
      print('FOR HIM PRODUCTS: ${newForHim.length}');

      // ----------------------------------------------------------
      // 7. UPDATE STATE
      // ----------------------------------------------------------

      setState(() {
        forHer = newForHer;
        forHim = newForHim;

        isLoadingProducts = false;
      });
    } catch (error, stackTrace) {
      print('ERROR LOAD HOME DATA: $error');
      print(stackTrace);

      if (mounted) {
        setState(() {
          isLoadingCategories = false;
          isLoadingProducts = false;
        });
      }
    }
  }

  // ============================================================
  // CATEGORY SELECT
  // ============================================================

  void onCategorySelected(int index) {
    setState(() {
      selectedCategory = index;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ======================================================
          // HERO
          // ======================================================

          const SizedBox(
            height: AppSpacing.md,
          ),

          HeroBanner(
            title: 'Секс-девайси про\nніжність до тіла',
            imageUrl:
                'https://picsum.photos/seed/hero/800/900',
            ctaLabel: 'Обрати девайс',
            onCtaTap: () {},
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          // ======================================================
          // CATEGORIES
          // ======================================================

          if (isLoadingCategories)
            const SizedBox(
              height: 40,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (categories.isNotEmpty)
            CategoryList(
              categories: categories,
              selectedIndex: selectedCategory,
              onSelected: onCategorySelected,
            ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          // ======================================================
          // PRODUCTS
          // ======================================================

          if (isLoadingProducts)

            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.xl,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )

          else ...[

            // ====================================================
            // FOR HER
            // ====================================================

            if (forHer.isNotEmpty)
              ProductSection(
                title: 'Для неї',
                products: forHer,
                onSeeAll: () {
                  // TODO:
                  // открыть ProductsPage
                },
              ),

            if (forHer.isNotEmpty)
              const SizedBox(
                height: AppSpacing.xl,
              ),

            // ====================================================
            // FOR HIM
            // ====================================================

            if (forHim.isNotEmpty)
              ProductSection(
                title: 'Для нього',
                products: forHim,
                onSeeAll: () {
                  // TODO:
                  // открыть ProductsPage
                },
              ),

            if (forHim.isNotEmpty)
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


// ================================================================
// CERTIFICATE CARD
// ================================================================

class _CertificateCard extends StatelessWidget {
  const _CertificateCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: NetworkImage(
              'https://picsum.photos/seed/gift-certificate/1000/500',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                onPressed: () {
                  // TODO:
                  // открыть страницу сертификатов
                },
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