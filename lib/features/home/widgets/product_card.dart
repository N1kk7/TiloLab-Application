import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

// STORES

import '../../../store/favorites_store.dart';

// MODELS
import '../../../models/favorites/favorite_product.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int? oldPrice;
  final bool isSoldOut;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    this.isSoldOut = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceElevated,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: ListenableBuilder(
                    listenable: FavoritesStore.instance,
                    builder: (context, _) {
                      final isFavorite = FavoritesStore.instance.isFavorite(id);

                      return Material(
                        color: AppColors.bg.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => FavoritesStore.instance.toggle(
                            FavoriteProduct(
                              id: id,
                              name: name,
                              imageUrl: imageUrl,
                              price: price,
                              oldPrice: oldPrice,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isFavorite ? AppColors.accentRed : AppColors.text,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (isSoldOut)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.warningButtonActive,
                      alignment: Alignment.center,
                      child: Text(
                        'Товар закінчується',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.bg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.text),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        '$price грн',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: oldPrice == null ? AppColors.text : AppColors.discountPrice,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (oldPrice != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            '$oldPrice грн',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.darkText,
                              decoration: TextDecoration.lineThrough,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}