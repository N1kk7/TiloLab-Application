import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/address_model.dart';
import '../widgets/delivery_type_selector.dart';

class AddAddressPage extends StatefulWidget {
  final DeliveryAddress? existing;

  const AddAddressPage({super.key, this.existing});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late DeliveryType type = widget.existing?.type ?? DeliveryType.warehouse;
  final cityController = TextEditingController();
  final warehouseController = TextEditingController();
  final streetController = TextEditingController();
  final apartmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      cityController.text = widget.existing!.city;
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    warehouseController.dispose();
    streetController.dispose();
    apartmentController.dispose();
    super.dispose();
  }

  void save() {
    // TODO: зберегти адресу через бекенд/API Нової Пошти
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.existing == null ? 'Нова адреса' : 'Редагувати адресу',
          style: AppTextStyles.h3,
        ),
      ),
      body: SafeArea(
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
                  Text('Тип доставки', style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  DeliveryTypeSelector(
                    value: type,
                    onChanged: (value) => setState(() => type = value),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // TODO: замінити на автокомплит через API Нової Пошти
                  // (пошук міст: /Address/searchSettlements)
                  AppTextField(
                    label: 'Місто',
                    controller: cityController,
                    hint: 'Почніть вводити назву міста',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (type != DeliveryType.courier) ...[
                    // TODO: замінити на список відділень/поштоматів
                    // по обраному місту (/AddressGeneral/getWarehouses)
                    AppTextField(
                      label: type == DeliveryType.warehouse
                          ? 'Відділення'
                          : 'Поштомат',
                      controller: warehouseController,
                      hint: 'Оберіть зі списку',
                    ),
                  ] else ...[
                    AppTextField(
                      label: 'Вулиця, будинок',
                      controller: streetController,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Квартира / офіс',
                      controller: apartmentController,
                      hint: 'Необовʼязково',
                    ),
                  ],
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
                border: Border(top: BorderSide(color: AppColors.borderNeutral)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.bg,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Зберегти адресу',
                    style: AppTextStyles.button.copyWith(color: AppColors.bg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}