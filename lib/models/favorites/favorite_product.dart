class FavoriteProduct {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int? oldPrice;

  const FavoriteProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'oldPrice': oldPrice,
      };

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: json['price'] as int,
      oldPrice: json['oldPrice'] as int?,
    );
  }
}