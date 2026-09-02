enum NpWarehouseCategory { branch, postomat }

class NpWarehouse {
  final String ref;
  final String description;
  final String shortAddress;
  final NpWarehouseCategory category;

  const NpWarehouse({
    required this.ref,
    required this.description,
    required this.shortAddress,
    required this.category,
  });

  factory NpWarehouse.fromJson(Map<String, dynamic> json) {
    final categoryRaw = json['CategoryOfWarehouse'] as String? ?? 'Branch';

    return NpWarehouse(
      ref: json['Ref'] as String,
      description: json['Description'] as String,
      shortAddress: json['ShortAddress'] as String? ?? json['Description'] as String,
      category: categoryRaw == 'Postomat'
          ? NpWarehouseCategory.postomat
          : NpWarehouseCategory.branch,
    );
  }
}