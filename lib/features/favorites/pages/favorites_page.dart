import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/widgets/product_card.dart';
// import '../../home/widgets/product_section.dart';
// import '../../product-item/pages/product_detail_page.dart';



// import '../../product/pages/product_detail_page.dart';

// import 'package:flutter/material.dart';

import '../../../store/favorites_store.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_spacing.dart';
// import '../../../core/theme/app_text_styles.dart';
// import '../../home/widgets/product_card.dart';
// import '../../product-item/pages/product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Улюблені товари', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: FavoritesStore.instance,
          builder: (context, _) {
            final favorites = FavoritesStore.instance.items;

            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  'Поки немає улюблених товарів',
                  style: AppTextStyles.bodySmall,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.58,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];

                return ProductCard(
                  id: product.id,
                  name: product.name,
                  imageUrl: product.imageUrl,
                  price: product.price,
                  oldPrice: product.oldPrice,
                  onTap: () {
                    // TODO: сюда стоит прокинуть реальный Product по product.id,
                    // если ProductDetailPage должен показывать актуальные данные
                    // (у нас в сторе только снимок на момент лайка)
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}