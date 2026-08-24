import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/address_model.dart';
import '../widgets/address_card.dart';
import 'add_address_page.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final List<DeliveryAddress> addresses = [
    const DeliveryAddress(
      id: '1',
      city: 'Біла Церква',
      type: DeliveryType.warehouse,
      description: 'Відділення №5, вул. Ярослава Мудрого 22',
      isDefault: true,
    ),
    const DeliveryAddress(
      id: '2',
      city: 'Київ',
      type: DeliveryType.postomat,
      description: 'Поштомат №1147, вул. Хрещатик 22',
    ),
  ];

  Future<void> openAddAddress({DeliveryAddress? existing}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddAddressPage(existing: existing),
      ),
    );
    // TODO: після повернення — оновити список з бекенду
  }

  void removeAddress(String id) {
    setState(() => addresses.removeWhere((a) => a.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Адреси доставки', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: addresses.isEmpty
            ? _EmptyAddresses(onAdd: () => openAddAddress())
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  ...addresses.map(
                    (address) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AddressCard(
                        address: address,
                        onEdit: () => openAddAddress(existing: address),
                        onDelete: () => removeAddress(address.id),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  OutlinedButton.icon(
                    onPressed: () => openAddAddress(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppColors.accent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: AppColors.accent),
                    label: Text(
                      'Додати адресу',
                      style: AppTextStyles.button.copyWith(color: AppColors.accent),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyAddresses({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined, size: 56, color: AppColors.darkText),
            const SizedBox(height: AppSpacing.md),
            Text('Немає збережених адрес', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Додайте адресу, щоб оформлювати замовлення швидше',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bg,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Додати адресу',
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