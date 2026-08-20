import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';



import '../features/cart/widgets/cart_item_card.dart';
import '../features/cart/widgets/order_summary.dart';
import '../features/cart/widgets/promo_code_field.dart';




// import '../widgets/cart_item_card.dart';
// import '../widgets/order_summary.dart';
// import '../widgets/promo_code_field.dart';

class CartLineItem {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  int quantity;

  CartLineItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartLineItem> items = [
    CartLineItem(
      id: '1',
      name: 'Вібратор Silky Touch',
      imageUrl: 'https://picsum.photos/seed/1/200',
      price: 1200,
    ),
    CartLineItem(
      id: '2',
      name: 'Набір для масажу',
      imageUrl: 'https://picsum.photos/seed/2/200',
      price: 890,
      quantity: 2,
    ),
  ];

  String? promoCode;

  int get subtotal =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get discount => promoCode == null ? 0 : (subtotal * 0.1).round();

  void updateQuantity(String id, int quantity) {
    setState(() {
      items.firstWhere((item) => item.id == id).quantity = quantity;
    });
  }

  void removeItem(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyCart(onExplore: () {
        // TODO: перейти на вкладку каталогу
      });
    }

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              children: [
                Text('Кошик', style: AppTextStyles.h1),

                const SizedBox(height: AppSpacing.lg),

                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CartItemCard(
                      name: item.name,
                      imageUrl: item.imageUrl,
                      price: item.price,
                      quantity: item.quantity,
                      onQuantityChanged: (value) => updateQuantity(item.id, value),
                      onRemove: () => removeItem(item.id),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                PromoCodeField(
                  appliedCode: promoCode,
                  onApply: (code) => setState(() => promoCode = code),
                  onRemove: () => setState(() => promoCode = null),
                ),

                const SizedBox(height: AppSpacing.md),

                OrderSummary(
                  subtotal: subtotal,
                  discount: discount,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              border: Border(
                top: BorderSide(color: AppColors.borderNeutral),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: переход на оформлення замовлення
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bg,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Оформити замовлення',
                  style: AppTextStyles.button.copyWith(color: AppColors.bg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyCart({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: AppColors.darkText,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Кошик порожній',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Додайте товари з каталогу, щоб оформити замовлення',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onExplore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bg,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Перейти до каталогу',
                  style: AppTextStyles.button.copyWith(color: AppColors.bg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}