import 'package:flutter/material.dart';

import 'package:tilolab_app/core/services/app_tooltip.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:tilolab_app/features/addreses/data/address_model.dart';
import 'package:tilolab_app/features/checkout/data/payment_method.dart';
import 'package:tilolab_app/features/checkout/pages/contact_info_page.dart';
import 'package:tilolab_app/features/checkout/pages/delivery_info_page.dart';
import 'package:tilolab_app/features/checkout/services/checkout_store.dart';
import 'package:tilolab_app/features/checkout/widgets/certificate_field.dart';
import 'package:tilolab_app/features/checkout/widgets/checkout_note.dart';
import 'package:tilolab_app/features/checkout/widgets/info_status_tile.dart';
import 'package:tilolab_app/features/checkout/widgets/payment_method_group.dart';
import 'package:tilolab_app/features/cart/widgets/cart_item_card.dart';
import 'package:tilolab_app/features/cart/widgets/order_summary.dart';

import 'package:tilolab_app/core/api/api_client.dart';

import '../../../features/checkout/data/certificate_repository.dart';
import '../../../features/checkout/data/order_repository.dart';
import '../../../features/checkout/data/payment_repository.dart';

class CartLineItem {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  int quantity;
  final bool isCertificate;

  CartLineItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.isCertificate = false,
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

  final orderRepository = OrderRepository(ApiClient());
  final paymentRepository = PaymentRepository(ApiClient());
  final certificateRepository = CertificateRepository(ApiClient());

  PaymentMethod paymentMethod = PaymentMethod.online;
  String? certificateCode;
  final commentController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  bool get cartContainsCertificate => items.any((item) => item.isCertificate);

  int get subtotal => items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get discount => certificateCode == null ? 0 : (subtotal * 0.1).round();

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

  bool get canSubmitOrder =>
      items.isNotEmpty && CheckoutStore.instance.hasContact && CheckoutStore.instance.hasDelivery;

  Future<void> submitOrder() async {
    if (items.isEmpty) {
      AppToast.warning(context, 'Кошик порожній');
      return;
    }

    if (paymentMethod == PaymentMethod.certificate &&
        certificateCode == null) {
      AppToast.warning(context, 'Введіть код сертифіката');
      return;
    }

    if (paymentMethod == PaymentMethod.certificate && cartContainsCertificate) {
      AppToast.warning(
        context,
        "Дія існуючого сертифіката не розповсюджується на придбання іншого сертифіката",
      );
      return;
    }

    final contact = CheckoutStore.instance.contact!;
    final delivery = CheckoutStore.instance.delivery!;

    setState(() => isSubmitting = true);

    try {
      // 1. створюємо отримувача в НП
      final recipient = await orderRepository.createRecipient(
        firstName: contact.firstName,
        lastName: contact.lastName,
        formattedPhone: contact.phone.replaceAll(RegExp(r'[\s()-]'), ''),
      );

      // 2. створюємо замовлення
      final orderResult = await orderRepository.createOrder(
        userId: null, // TODO: підставити id залогіненого юзера, якщо є
        contact: contact,
        delivery: delivery,
        paymentMethod: paymentMethod,
        items: items
            .map((item) => OrderItemPayload(
                  productId: item.id,
                  quantity: item.quantity,
                  price: item.price,
                  title: item.name,
                ))
            .toList(),
        certificateCode: certificateCode ?? '',
        comment: commentController.text.trim(),
        recipient: recipient,
      );

      if (paymentMethod == PaymentMethod.certificate) {
        // 3a. перевіряємо сертифікат і залишок суми
        final check = await certificateRepository.checkCertificate(
          code: certificateCode!,
          orderTotalPrice: orderResult.totalPrice,
        );

        if (check.isNeedToSurcharge) {
          // TODO: показати екран/модалку доплати різниці — аналог
          // modalStore.showModal("SurchargeCertificate", ...) з веб-версії
          if (!mounted) return;
          AppToast.warning(context, 'Потрібна доплата різниці суми');
          return;
        }

        // 3b. застосовуємо сертифікат до замовлення
        await orderRepository.completeOrderWithCertificate(
          orderId: orderResult.orderId,
          certificateCode: check.certificate.code,
        );

        if (!mounted) return;
        AppToast.success(context, 'Сертифікат успішно застосовано');
        // TODO: навігація на сторінку summary + очищення кошика
      } else {
        // 3c. звичайна оплата — створюємо інвойс Monobank
        final amount = paymentMethod == PaymentMethod.online
            ? orderResult.totalPrice
            : 200; // передоплата при оплаті при отриманні

        final payment = await paymentRepository.createPayment(
          orderId: orderResult.orderId,
          amount: amount,
        );

        // TODO: відкрити payment.pageUrl (наприклад, через url_launcher
        // або WebView всередині застосунку) + очистити кошик
        if (!mounted) return;
        AppToast.success(context, 'Переходимо до оплати');
      }
    } on OrderApiException catch (error) {
      if (!mounted) return;
      AppToast.error(context, error.message);
    } on PaymentApiException catch (error) {
      if (!mounted) return;
      AppToast.error(context, error.message);
    } on CertificateApiException catch (error) {
      if (!mounted) return;
      AppToast.error(context, error.message);
    } catch (error) {
      if (!mounted) return;
      AppToast.error(context, 'Не вдалося оформити замовлення. Спробуйте ще раз.');
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
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
      child: ListenableBuilder(
        listenable: CheckoutStore.instance,
        builder: (context, _) {
          final contact = CheckoutStore.instance.contact;
          final delivery = CheckoutStore.instance.delivery;

          return Column(
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
                    Text('Оформлення замовлення', style: AppTextStyles.h1),

                    const SizedBox(height: AppSpacing.lg),

                    Text('Товари', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),

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

                    const SizedBox(height: AppSpacing.lg),

                    InfoStatusTile(
                      title: 'Контактні дані',
                      subtitle: contact?.fullName,
                      isComplete: contact != null,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ContactInfoPage()),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    InfoStatusTile(
                      title: 'Дані доставки',
                      subtitle: delivery == null
                          ? null
                          : '${delivery.city} · ${delivery.type.label}',
                      isComplete: delivery != null,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DeliveryInfoPage()),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text('Оплата', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),

                    PaymentMethodGroup(
                      value: paymentMethod,
                      onChanged: (value) => setState(() => paymentMethod = value),
                    ),

                    if (paymentMethod == PaymentMethod.certificate) ...[
                      const SizedBox(height: AppSpacing.sm),
                      CertificateField(
                        cartContainsCertificate: cartContainsCertificate,
                        appliedCode: certificateCode,
                        onApplied: (code) => setState(() => certificateCode = code),
                        onRemove: () => setState(() => certificateCode = null),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    Text('Коментар до замовлення', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),

                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      style: AppTextStyles.bodySmall,
                      decoration: InputDecoration(
                        hintText: 'Необовʼязково',
                        hintStyle: AppTextStyles.bodySmall,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CheckoutNote(isCertificatePayment: paymentMethod == PaymentMethod.certificate),

                    const SizedBox(height: AppSpacing.lg),

                    OrderSummary(subtotal: subtotal, discount: discount),
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
                  border: Border(top: BorderSide(color: AppColors.borderNeutral)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (canSubmitOrder && !isSubmitting) ? submitOrder : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      disabledBackgroundColor: AppColors.surfaceElevated,
                      foregroundColor: AppColors.bg,
                      disabledForegroundColor: AppColors.darkText,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Оформити замовлення',
                            style: AppTextStyles.button.copyWith(
                              color: canSubmitOrder ? AppColors.bg : AppColors.darkText,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
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
            const Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.darkText),
            const SizedBox(height: AppSpacing.md),
            Text('Кошик порожній', style: AppTextStyles.h3),
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