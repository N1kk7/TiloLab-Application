import '../../models/product/product_page.dart';
import '../core/api/api_client.dart';

class ProductRepository {
  final ApiClient apiClient;

  ProductRepository(this.apiClient);

Future<ProductPage> getProducts({
  int page = 1,
  int limit = 12,
  int? categoryId,
  double? minPrice,
  double? maxPrice,
}) async {
  final queryParameters = <String, String>{
    'getMethod': 'page',
    'page': page.toString(),
    'limit': limit.toString(),
  };

  if (categoryId != null) {
    queryParameters['category'] = categoryId.toString();
  }

  if (minPrice != null) {
    queryParameters['minPrice'] = minPrice.toString();
  }

  if (maxPrice != null) {
    queryParameters['maxPrice'] = maxPrice.toString();
  }

  final query = Uri(
    queryParameters: queryParameters,
  ).query;

  final response = await apiClient.get(
    '/api/products?$query',
  );

  return ProductPage.fromJson(
    response,
    page: page,
    limit: limit,
  );
}
}