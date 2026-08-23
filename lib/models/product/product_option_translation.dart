class ProductOptionTranslation {
  final int id;
  final int optionId;
  final String language;
  final String optionInfo;

  const ProductOptionTranslation({
    required this.id,
    required this.optionId,
    required this.language,
    required this.optionInfo,
  });

  factory ProductOptionTranslation.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductOptionTranslation(
      id: json['id'],
      optionId: json['optionId'],
      language: json['language'],
      optionInfo: json['optionInfo'],
    );
  }
}