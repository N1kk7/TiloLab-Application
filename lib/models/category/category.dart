import './category_translation.dart';

class Category {
  final int id;
  final String group;
  final int listPosition;
  final bool visible;
  final String? categoryImg;
  final int? parentId;

  final List<Category> subcategories;
  final List<CategoryTranslation> translations;

  const Category({
    required this.id,
    required this.group,
    required this.listPosition,
    required this.visible,
    this.categoryImg,
    this.parentId,
    this.subcategories = const [],
    this.translations = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      group: json['group'] as String,
      listPosition: json['listPosition'] as int,
      visible: json['visible'] as bool,
      categoryImg: json['categoryImg'] as String?,
      parentId: json['parentId'] as int?,

      subcategories: (json['subcategories'] as List<dynamic>? ?? [])
          .map(
            (item) => Category.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      translations: (json['translations'] as List<dynamic>? ?? [])
          .map(
            (item) => CategoryTranslation.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  String get title {
    final translation = translations.where(
      (item) => item.language == 'uk',
    );

    if (translation.isNotEmpty) {
      return translation.first.title;
    }

    return group;
  }
}