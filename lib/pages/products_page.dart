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

// PAGES
import '../features/product-item/pages/product_detail_page.dart';

import 'package:tilolab_app/core/api/api_client.dart';

import '../features/home/data/category_repository.dart';
import '../models/category/category.dart';

import '../models/product/product.dart';
import '../../repositories/product_repository.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int selectedCategory = 0;
  ProductFilters filters = const ProductFilters();

  final categoryRepository = CategoryRepository(
    apiClient: ApiClient(),
  );

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();

    loadCategories();
    loadProducts();
  }

  bool isLoadingCategories = false;
  bool isLoadingProducts = false;
  bool isLoadingMore = false;

  Future<void> loadCategories() async {
    setState(() {
      isLoadingCategories = true;
    });

    try {
      final result = await categoryRepository.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
      });
    } catch (error) {
      print('ERROR LOAD CATEGORIES: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingCategories = false;
        });
      }
    }
  }

Future<void> loadProducts() async {
  if (isLoadingProducts) return;

  setState(() {
    isLoadingProducts = true;
  });

  try {
    final result = await productRepository.getProducts(
      page: 1,
      limit: 20,
    );

    if (!mounted) return;

    setState(() {
      products = result.products;
      currentPage = 1;
      hasNextPage = result.hasNextPage;
    });
  } catch (error) {
    print('ERROR LOAD PRODUCTS: $error');
  } finally {
    if (mounted) {
      setState(() {
        isLoadingProducts = false;
      });
    }
  }
}

  Future<void> loadMoreProducts() async {
  if (isLoadingMore || !hasNextPage) return;

  setState(() {
    isLoadingMore = true;
  });

  try {
    final result = await productRepository.getProducts(
      page: currentPage + 1,
      limit: 20,
    );

    if (!mounted) return;

    setState(() {
      products.addAll(result.products);

      currentPage++;

      hasNextPage = result.hasNextPage;
    });
  } catch (error) {
    print('ERROR LOAD MORE: $error');
  } finally {
    if (mounted) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }
}
  
  List<Product> products = [];

  bool isLoading = false;
  // bool isLoadingMore = false;
  bool hasNextPage = true;

  int currentPage = 1;

  final ProductRepository productRepository =
      ProductRepository(ApiClient());


  Future<void> openFilters() async {
    final result = await showModalBottomSheet<ProductFilters>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        initialFilters: filters,
      availableCategories: categories
        .map((category) => category.title)
        .toList(),
      ),
    );

    if (result != null) {
      setState(() => filters = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: заменить на реальную фильтрацию из filters/selectedCategory
    final filteredProducts = products;

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

          if (isLoadingCategories)
            const SizedBox(
              height: 40,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            CategoryList(
              categories: categories,
              selectedIndex: selectedCategory,
              onSelected: (index) {
                setState(() {
                  selectedCategory = index;
                });
              },
            ),

          const SizedBox(height: AppSpacing.md),

        if (isLoadingProducts)
          const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
         Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  0,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];

                      return ProductCard(
                        name: product.title,
                        imageUrl: product.mainImage ?? '',
                        price: product.productPrice.toInt(),
                        isSoldOut: product.availableStock <= 0,

                        onTap: () {

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                product: product,
                              ),
                            ),
                          );

                        },
                      );
                    },
                    childCount: products.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.58,
                  ),
                ),
              ),


              if (hasNextPage)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoadingMore
                            ? null
                            : loadMoreProducts,
                        child: isLoadingMore
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Завантажити ще',
                              ),
                      ),
                    ),
                  ),
                ),


              const SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSpacing.xl,
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