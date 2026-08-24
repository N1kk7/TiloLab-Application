import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../features/home/data/category_repository.dart';
import '../models/category/category.dart';


// ============================================================
// REPOSITORY
// ============================================================

final categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) {
  return CategoryRepository(
    apiClient: ApiClient(),
  );
});


// ============================================================
// STATE
// ============================================================

class CategoryState {
  final List<Category> categories;

  final bool isLoaded;
  final bool isLoading;

  const CategoryState({
    this.categories = const [],
    this.isLoaded = false,
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoaded,
    bool? isLoading,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


// ============================================================
// NOTIFIER
// ============================================================

class CategoryNotifier extends Notifier<CategoryState> {

  late final CategoryRepository repository;

  @override
  CategoryState build() {
    repository = ref.read(
      categoryRepositoryProvider,
    );

    return const CategoryState();
  }


  // ==========================================================
  // LOAD
  // ==========================================================

  Future<void> loadCategories() async {

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

      final result =
          await repository.getCategories();

      state = state.copyWith(
        categories: result,
        isLoaded: true,
        isLoading: false,
      );

    } catch (error, stackTrace) {

      print(
        'ERROR LOAD CATEGORIES: $error',
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

  Future<void> refresh() async {

    state = const CategoryState();

    await loadCategories();
  }
}


// ============================================================
// PROVIDER
// ============================================================

final categoryProvider =
    NotifierProvider<
      CategoryNotifier,
      CategoryState
    >(
      CategoryNotifier.new,
    );