import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../models/product/product.dart';
import '../repositories/product_repository.dart';


// ============================================================
// REPOSITORY
// ============================================================

final productRepositoryProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepository(
    ApiClient(),
  );
});


// ============================================================
// STATE
// ============================================================

class ProductState {
  final List<Product> products;

  final bool isLoaded;
  final bool isLoading;
  final bool isLoadingMore;

  final bool hasNextPage;
  final int currentPage;

  const ProductState({
    this.products = const [],
    this.isLoaded = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasNextPage = true,
    this.currentPage = 1,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoaded,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? currentPage,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}


// ============================================================
// NOTIFIER
// ============================================================

class ProductNotifier extends Notifier<ProductState> {

  late final ProductRepository repository;

  @override
  ProductState build() {

    repository = ref.read(
      productRepositoryProvider,
    );

    return const ProductState();
  }


  // ==========================================================
  // LOAD FIRST PAGE
  // ==========================================================

  Future<void> loadProducts() async {

    if (state.isLoading) {
      return;
    }

    if (state.isLoaded) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
    );

    try {

      final result =
          await repository.getProducts(
        page: 1,
        limit: 20,
      );

      state = state.copyWith(
        products: result.products,
        isLoaded: true,
        currentPage: 1,
        hasNextPage: result.hasNextPage,
        isLoading: false,
      );

    } catch (error, stackTrace) {

      print(
        'ERROR LOAD PRODUCTS: $error',
      );

      print(stackTrace);

      state = state.copyWith(
        isLoading: false,
      );
    }
  }


  // ==========================================================
  // LOAD MORE
  // ==========================================================

  Future<void> loadMoreProducts() async {

    if (state.isLoadingMore) {
      return;
    }

    if (!state.hasNextPage) {
      return;
    }

    state = state.copyWith(
      isLoadingMore: true,
    );

    try {

      final nextPage =
          state.currentPage + 1;

      final result =
          await repository.getProducts(
        page: nextPage,
        limit: 20,
      );

      state = state.copyWith(
        products: [
          ...state.products,
          ...result.products,
        ],
        currentPage: nextPage,
        hasNextPage: result.hasNextPage,
        isLoadingMore: false,
      );

    } catch (error, stackTrace) {

      print(
        'ERROR LOAD MORE PRODUCTS: $error',
      );

      print(stackTrace);

      state = state.copyWith(
        isLoadingMore: false,
      );
    }
  }


  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refresh() async {

    state = const ProductState();

    await loadProducts();
  }
}


// ============================================================
// PROVIDER
// ============================================================

final productProvider =
    NotifierProvider<
      ProductNotifier,
      ProductState
    >(
      ProductNotifier.new,
    );