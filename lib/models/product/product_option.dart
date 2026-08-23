import 'product_option_translation.dart';

class ProductOption {
  final int id;
  final int optionId;
  final String? optionImg;
  final double? optionPrice;
  final int? optionStock;
  final int? optionReserved;
  final int? discountPercent;

  final List<ProductOptionTranslation> translations;

  const ProductOption({
    required this.id,
    required this.optionId,
    this.optionImg,
    this.optionPrice,
    this.optionStock,
    this.optionReserved,
    this.discountPercent,
    required this.translations,
  });

  factory ProductOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductOption(
      id: json['id'],
      optionId: json['optionId'],
      optionImg: json['optionImg'],
      optionPrice: json['optionPrice']?.toDouble(),
      optionStock: json['optionStock'],
      optionReserved: json['optionReserved'],
      discountPercent: json['discountPercent'],
      translations: (json['translations'] as List? ?? [])
          .map(
            (item) => ProductOptionTranslation.fromJson(
              item,
            ),
          )
          .toList(),
    );
  }
}