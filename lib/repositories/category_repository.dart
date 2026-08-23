import '../core/api/api_client.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository({
    required this.apiClient,
  });

  Future<dynamic> getCategories() async {
    return apiClient.get('/api/categories');
  }
}