class CategoryTranslation {
  final int id;
  final int categoryId;
  final String language;
  final String title;
  final String? description;
  final String? groupText;

  const CategoryTranslation({
    required this.id,
    required this.categoryId,
    required this.language,
    required this.title,
    this.description,
    this.groupText,
  });

  factory CategoryTranslation.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryTranslation(
      id: json['id'] as int,
      categoryId: json['categoryId'] as int,
      language: json['language'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      groupText: json['groupText'] as String?,
    );
  }
}