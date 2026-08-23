import 'product.dart';

class ProductPage {
  final List<Product> products;
  final int total;
  final int page;
  final int limit;

  const ProductPage({
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
  });

  bool get hasNextPage {
    return page * limit < total;
  }

  factory ProductPage.fromJson(
    Map<String, dynamic> json, {
    required int page,
    required int limit,
  }) {
    final products = (json['data'] as List? ?? [])
        .map(
          (item) => Product.fromJson(item),
        )
        .toList();

    return ProductPage(
      products: products,
      total: json['productTotal'] ?? 0,
      page: page,
      limit: limit,
    );
  }
}