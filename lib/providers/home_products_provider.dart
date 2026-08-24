import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../models/product/product.dart';
import '../models/category/category.dart';
import '../models/product/product_page.dart';
import '../repositories/product_repository.dart';


// ============================================================
// REPOSITORY
// ============================================================

final homeProductRepositoryProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepository(
    ApiClient(),
  );
});


// ============================================================
// STATE
// ============================================================

class HomeProductState {

  final List<Product> forHer;
  final List<Product> forHim;

  final bool isLoaded;
  final bool isLoading;

  const HomeProductState({
    this.forHer = const [],
    this.forHim = const [],
    this.isLoaded = false,
    this.isLoading = false,
  });


  HomeProductState copyWith({
    List<Product>? forHer,
    List<Product>? forHim,
    bool? isLoaded,
    bool? isLoading,
  }) {
    return HomeProductState(
      forHer: forHer ?? this.forHer,
      forHim: forHim ?? this.forHim,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


// ============================================================
// NOTIFIER
// ============================================================

class HomeProductNotifier
    extends Notifier<HomeProductState> {

  late final ProductRepository repository;


  @override
  HomeProductState build() {

    repository = ref.read(
      homeProductRepositoryProvider,
    );

    return const HomeProductState();
  }


  // ==========================================================
  // FIND CATEGORY
  // ==========================================================

  Category? findCategory({
    required List<Category> categories,
    required List<String> groups,
    required String title,
  }) {

    for (final category in categories) {

      // Сначала проверяем group
      if (groups.contains(category.group)) {
        return category;
      }

      // Потом title
      if (
        category.title.trim().toLowerCase() ==
        title.trim().toLowerCase()
      ) {
        return category;
      }
    }

    return null;
  }


  // ==========================================================
  // LOAD
  // ==========================================================

  Future<void> loadProducts({
    required List<Category> categories,
  }) async {

    // Уже загружаем
    if (state.isLoading) {
      return;
    }

    // Уже загружены
    if (state.isLoaded) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
    );

    try {

      // --------------------------------------------------------
      // FIND "FOR HER"
      // --------------------------------------------------------

      final herCategory = findCategory(
        categories: categories,
        groups: [
          'Dlya-neyi',
          'Dlya-nee',
          'Dlya-nei',
        ],
        title: 'Для неї',
      );


      // --------------------------------------------------------
      // FIND "FOR HIM"
      // --------------------------------------------------------

      final himCategory = findCategory(
        categories: categories,
        groups: [
          'Dlya-nego',
          'Dlya-nogo',
        ],
        title: 'Для нього',
      );


      print(
        'HER CATEGORY: '
        '${herCategory?.id} / '
        '${herCategory?.group} / '
        '${herCategory?.title}',
      );

      print(
        'HIM CATEGORY: '
        '${himCategory?.id} / '
        '${himCategory?.group} / '
        '${himCategory?.title}',
      );


      // --------------------------------------------------------
      // PREPARE REQUESTS
      // --------------------------------------------------------

      final futures = <Future<ProductPage>>[];


      if (herCategory != null) {

        futures.add(
          repository.getProducts(
            page: 1,
            limit: 10,
            categoryId: herCategory.id,
          ),
        );
      }


      if (himCategory != null) {

        futures.add(
          repository.getProducts(
            page: 1,
            limit: 10,
            categoryId: himCategory.id,
          ),
        );
      }


      // --------------------------------------------------------
      // NOTHING TO LOAD
      // --------------------------------------------------------

      if (futures.isEmpty) {

        state = state.copyWith(
          isLoaded: true,
          isLoading: false,
        );

        return;
      }


      // --------------------------------------------------------
      // LOAD
      // --------------------------------------------------------

      final results =
          await Future.wait(futures);


      int resultIndex = 0;

      List<Product> newForHer = [];
      List<Product> newForHim = [];


      if (herCategory != null) {

        newForHer =
            results[resultIndex].products;

        resultIndex++;
      }


      if (himCategory != null) {

        newForHim =
            results[resultIndex].products;
      }


      print(
        'FOR HER PRODUCTS: '
        '${newForHer.length}',
      );

      print(
        'FOR HIM PRODUCTS: '
        '${newForHim.length}',
      );


      // --------------------------------------------------------
      // UPDATE
      // --------------------------------------------------------

      state = state.copyWith(
        forHer: newForHer,
        forHim: newForHim,
        isLoaded: true,
        isLoading: false,
      );

    } catch (error, stackTrace) {

      print(
        'ERROR LOAD HOME PRODUCTS: $error',
      );

      print(stackTrace);

      state = state.copyWith(
        isLoading: false,
      );
    }
  }


  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refresh({
    required List<Category> categories,
  }) async {

    state = const HomeProductState();

    await loadProducts(
      categories: categories,
    );
  }
}


// ============================================================
// PROVIDER
// ============================================================

final homeProductProvider =
    NotifierProvider<
      HomeProductNotifier,
      HomeProductState
    >(
      HomeProductNotifier.new,
    );