import '../../../core/api/api_client.dart';
import '../../../models/category/category.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository({
    required this.apiClient,
  });

  Future<List<Category>> getCategories() async {
    final response = await apiClient.get('/api/category');

    final data = response['data'] as List<dynamic>;

    return data
        .map(
          (item) => Category.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}