// REPOSITORIES
import 'package:tilolab_app/repositories/product_repository.dart';

// MODELS
import 'package:tilolab_app/models/product/product.dart';


class ProductStore {
  final ProductRepository repository;

  ProductStore(this.repository);

  List<Product> products = [];

  bool isLoaded = false;
  bool isLoading = false;

  int currentPage = 1;
  bool hasNextPage = true;

  Future<void> loadProducts() async {
    if (isLoaded || isLoading) return;

    isLoading = true;

    try {
      final result = await repository.getProducts(
        page: 1,
        limit: 20,
      );

      products = result.products;
      currentPage = 1;
      hasNextPage = result.hasNextPage;

      isLoaded = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading || !hasNextPage) return;

    isLoading = true;

    try {
      final result = await repository.getProducts(
        page: currentPage + 1,
        limit: 20,
      );

      products.addAll(result.products);

      currentPage++;
      hasNextPage = result.hasNextPage;
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh() async {
    isLoaded = false;
    currentPage = 1;
    hasNextPage = true;
    products.clear();

    await loadProducts();
  }
}