import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tilolab_app/core/theme/app_spacing.dart';
import 'package:tilolab_app/core/theme/app_text_styles.dart';

import 'package:tilolab_app/providers/product_provider.dart';
import 'package:tilolab_app/providers/category_provider.dart';

import '../features/home/widgets/category_list.dart';
import '../features/home/widgets/product_card.dart';

import '../features/products/widgets/filter_bar.dart';
import '../features/products/widgets/filter_bottom_sheet.dart';
import '../features/products/widgets/search_field.dart';

import '../features/product-item/pages/product_detail_page.dart';

import '../features/home/widgets/category_list_skeleton.dart';
import '../features/home/widgets/product_card_skeleton.dart';


// ============================================================
// PRODUCTS PAGE
// ============================================================

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({
    super.key,
  });

  @override
  ConsumerState<ProductsPage> createState() =>
      _ProductsPageState();
}


// ============================================================
// STATE
// ============================================================

class _ProductsPageState
    extends ConsumerState<ProductsPage> {

  int selectedCategory = 0;

  ProductFilters filters =
      const ProductFilters();


  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      // ------------------------------------------------------
      // LOAD CATEGORIES
      // ------------------------------------------------------

      ref
          .read(categoryProvider.notifier)
          .loadCategories();


      // ------------------------------------------------------
      // LOAD PRODUCTS
      // ------------------------------------------------------

      ref
          .read(productProvider.notifier)
          .loadProducts();
    });
  }


  // ==========================================================
  // FILTERS
  // ==========================================================

  Future<void> openFilters() async {

    final categoryState =
        ref.read(categoryProvider);


    final result =
        await showModalBottomSheet<ProductFilters>(

      context: context,

      backgroundColor:
          Colors.transparent,

      isScrollControlled:
          true,

      builder: (context) {

        return FilterBottomSheet(

          initialFilters:
              filters,

          availableCategories:
              categoryState.categories
                  .map(
                    (category) =>
                        category.title,
                  )
                  .toList(),
        );
      },
    );


    if (result != null) {

      setState(() {
        filters = result;
      });
    }
  }


  // ==========================================================
  // CATEGORY SELECT
  // ==========================================================

  void onCategorySelected(int index) {

    setState(() {
      selectedCategory = index;
    });


    // TODO:
    //
    // Позже здесь можно будет сделать:
    //
    // ref
    //   .read(productProvider.notifier)
    //   .loadProducts(
    //     categoryId: ...
    //   );
  }


  // ==========================================================
  // LOAD MORE
  // ==========================================================

  void loadMoreProducts() {

    ref
        .read(productProvider.notifier)
        .loadMoreProducts();
  }


  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    // ========================================================
    // PROVIDER STATE
    // ========================================================

    final productState =
        ref.watch(productProvider);

    final categoryState =
        ref.watch(categoryProvider);


    // ========================================================
    // UI
    // ========================================================

    return SafeArea(

      top: false,

      child: Column(
        children: [

          // ====================================================
          // HEADER
          // ====================================================

          Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  AppSpacing.lg,
            ),

            child: Column(
              children: [

                const SizedBox(
                  height:
                      AppSpacing.md,
                ),


                Text(
                  'Каталог',
                  style:
                      AppTextStyles.h1,
                ),


                const SizedBox(
                  height:
                      AppSpacing.md,
                ),


                const SearchField(),


                const SizedBox(
                  height:
                      AppSpacing.md,
                ),


                FilterBar(

                  activeFiltersCount:
                      filters.categories.length,

                  onFilterTap:
                      openFilters,

                  onSortTap: () {

                    // TODO:
                    // bottom sheet сортировки
                  },
                ),
              ],
            ),
          ),


          const SizedBox(
            height:
                AppSpacing.md,
          ),


          // ====================================================
          // CATEGORIES
          // ====================================================

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

              onSelected:
                  onCategorySelected,
            ),


          const SizedBox(
            height:
                AppSpacing.md,
          ),


          // ====================================================
          // PRODUCTS
          // ====================================================

          if (productState.isLoading)

            // --------------------------------------------------
            // INITIAL LOADING
            // --------------------------------------------------

            Expanded(

              child:
                  GridView.builder(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      AppSpacing.lg,
                ),

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount:
                      2,

                  mainAxisSpacing:
                      AppSpacing.sm,

                  crossAxisSpacing:
                      AppSpacing.sm,

                  childAspectRatio:
                      0.58,
                ),

                itemCount:
                    6,

                itemBuilder:
                    (context, index) {

                  return const
                      ProductCardSkeleton();
                },
              ),
            )

          else

            // --------------------------------------------------
            // PRODUCT GRID
            // --------------------------------------------------

            Expanded(

              child:
                  CustomScrollView(

                slivers: [

                  // ==========================================
                  // PRODUCTS
                  // ==========================================

                  SliverPadding(

                    padding:
                        const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      0,
                    ),

                    sliver:
                        SliverGrid(

                      delegate:
                          SliverChildBuilderDelegate(

                        (context, index) {

                          final product =
                              productState
                                  .products[index];


                          return ProductCard(

                            id:
                                product.id.toString(),

                            name:
                                product.title,

                            imageUrl:
                                product.mainImage ??
                                    '',

                            price:
                                product.productPrice
                                    .toInt(),

                            isSoldOut:
                                product.availableStock <=
                                    0,

                            onTap: () {

                              Navigator.of(
                                context,
                              ).push(

                                MaterialPageRoute(

                                  builder: (_) =>
                                      ProductDetailPage(
                                    product:
                                        product,
                                  ),
                                ),
                              );
                            },
                          );
                        },

                        childCount:
                            productState
                                .products
                                .length,
                      ),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount:
                            2,

                        mainAxisSpacing:
                            AppSpacing.sm,

                        crossAxisSpacing:
                            AppSpacing.sm,

                        childAspectRatio:
                            0.58,
                      ),
                    ),
                  ),


                  // ==========================================
                  // LOAD MORE
                  // ==========================================

                  if (
                    productState.hasNextPage
                  )

                    SliverToBoxAdapter(

                      child:
                          Padding(

                        padding:
                            const EdgeInsets.all(
                          AppSpacing.lg,
                        ),

                        child:
                            SizedBox(

                          width:
                              double.infinity,

                          child:
                              ElevatedButton(

                            onPressed:
                                productState
                                        .isLoadingMore
                                    ? null
                                    : loadMoreProducts,

                            child:
                                productState
                                        .isLoadingMore

                                    ? const SizedBox(

                                        width:
                                            20,

                                        height:
                                            20,

                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,
                                        ),
                                      )

                                    : const Text(
                                        'Завантажити ще',
                                      ),
                          ),
                        ),
                      ),
                    ),


                  // ==========================================
                  // BOTTOM SPACE
                  // ==========================================

                  const SliverToBoxAdapter(

                    child:
                        SizedBox(
                      height:
                          AppSpacing.xl,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}