class ProductImage {
  final int id;
  final int imgId;
  final String path;

  const ProductImage({
    required this.id,
    required this.imgId,
    required this.path,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imgId: json['imgId'],
      path: json['path'] ?? '',
    );
  }
}