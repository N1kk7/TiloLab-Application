class ProductTranslation {
  final int id;
  final int productId;
  final String language;
  final String title;
  final String? productDescription;
  final String? productColor;
  final String? productMaterial;
  final String? productManufacture;

  const ProductTranslation({
    required this.id,
    required this.productId,
    required this.language,
    required this.title,
    this.productDescription,
    this.productColor,
    this.productMaterial,
    this.productManufacture,
  });

  factory ProductTranslation.fromJson(Map<String, dynamic> json) {
    return ProductTranslation(
      id: json['id'],
      productId: json['productId'],
      language: json['language'],
      title: json['title'],
      productDescription: json['productDescription'],
      productColor: json['productColor'],
      productMaterial: json['productMaterial'],
      productManufacture: json['productManufacture'],
    );
  }
}