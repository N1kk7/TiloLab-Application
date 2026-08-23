import 'product_image.dart';
import 'product_option.dart';
import 'product_translation.dart';

class Product {
  final int id;
  final int categoryId;

  final bool visible;
  final bool stockState;

  final int? listPosition;
  final int? stockValue;
  final int? stockReserved;

  final int? discountPercent;

  final String? productSize;

  final double productPrice;

  final bool isCertificate;

  final int availableStock;

  final List<ProductTranslation> translations;
  final List<ProductImage> images;
  final List<ProductOption> options;

  const Product({
    required this.id,
    required this.categoryId,
    required this.visible,
    required this.stockState,
    this.listPosition,
    this.stockValue,
    this.stockReserved,
    this.discountPercent,
    this.productSize,
    required this.productPrice,
    required this.isCertificate,
    required this.availableStock,
    required this.translations,
    required this.images,
    required this.options,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    return Product(
      id: json['id'],
      categoryId: json['categoryId'],
      visible: json['visible'] ?? false,
      stockState: json['stockState'] ?? false,

      listPosition: json['listPosition'],
      stockValue: json['stockValue'],
      stockReserved: json['stockReserved'],

      discountPercent: json['discountPercent'],

      productSize: json['productSize'],

      productPrice:
          (json['productPrice'] as num).toDouble(),

      isCertificate:
          json['isCertificate'] ?? false,

      availableStock:
          json['availableStock'] ?? 0,

      translations:
          (json['translations'] as List? ?? [])
              .map(
                (item) => ProductTranslation.fromJson(item),
              )
              .toList(),

      images:
          (json['img'] as List? ?? [])
              .map(
                (item) => ProductImage.fromJson(item),
              )
              .toList(),

      options:
          (json['options'] as List? ?? [])
              .map(
                (item) => ProductOption.fromJson(item),
              )
              .toList(),
    );
  }

  String get title {
    if (translations.isEmpty) {
      return '';
    }

    return translations.first.title;
  }

  String? get description {
    if (translations.isEmpty) {
      return null;
    }

    return translations.first.productDescription;
  }

  String? get mainImage {
    if (images.isEmpty) {
      return null;
    }

    return images.first.path;
  }
}