import 'package:flutter/material.dart';

import 'package:tilolab_app/core/api/api_client.dart';

import '../../../core/services/app_tooltip.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../addreses/data/address_model.dart';
import '../../addreses/widgets/delivery_type_selector.dart';
import '../../nova-posta/data/nova_poshta_repository.dart';
import '../data/delivery_info.dart';
import '../services/checkout_store.dart';
import '../widgets/city_autocomplete_field.dart';
import '../widgets/warehouse_autocomplete_field.dart';

class DeliveryInfoPage extends StatefulWidget {
  const DeliveryInfoPage({super.key});

  @override
  State<DeliveryInfoPage> createState() => _DeliveryInfoPageState();
}

class _DeliveryInfoPageState extends State<DeliveryInfoPage> {
  final novaPoshtaRepository = NovaPoshtaRepository(ApiClient());

  late DeliveryType type = CheckoutStore.instance.delivery?.type ?? DeliveryType.warehouse;

  late final cityController =
      TextEditingController(text: CheckoutStore.instance.delivery?.city ?? '');
  late final detailsController =
      TextEditingController(text: CheckoutStore.instance.delivery?.description ?? '');
  final streetController = TextEditingController();

  String? errorMessage;

  @override
  void dispose() {
    cityController.dispose();
    detailsController.dispose();
    streetController.dispose();
    super.dispose();
  }

  void _onWarehouseFieldChanged() {
    // аналог перевірки "Введіть місто" з веб-версії
    if (cityController.text.trim().isEmpty) {
      AppToast.warning(context, 'Введіть місто');
      detailsController.clear();
    }
  }

  Future<void> save() async {
    final isCourier = type == DeliveryType.courier;

    final error = Validators.firstError([
      () => Validators.required(cityController.text, message: 'Введіть місто'),
      () => Validators.required(
            isCourier ? streetController.text : detailsController.text,
            message: type == DeliveryType.warehouse
                ? 'Оберіть відділення'
                : type == DeliveryType.postomat
                    ? 'Оберіть поштомат'
                    : 'Введіть адресу',
          ),
    ]);

    if (error != null) {
      setState(() => errorMessage = error);
      return;
    }

    await CheckoutStore.instance.saveDelivery(
      DeliveryInfo(
        type: type,
        city: cityController.text.trim(),
        description: isCourier ? streetController.text.trim() : detailsController.text.trim(),
      ),
    );

    if (!mounted) return;
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
        title: Text('Дані доставки', style: AppTextStyles.h3),
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
                  Text('Спосіб доставки', style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  DeliveryTypeSelector(
                    value: type,
                    onChanged: (value) => setState(() {
                      type = value;
                      detailsController.clear();
                      streetController.clear();
                    }),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  CityAutocompleteField(
                    controller: cityController,
                    repository: novaPoshtaRepository,
                    onCitySelected: (city) {
                      // при зміні міста скидаємо раніше обране відділення/поштомат,
                      // бо воно прив'язане до попереднього міста
                      detailsController.clear();
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (type == DeliveryType.courier)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Вулиця, будинок', style: AppTextStyles.caption),
                        const SizedBox(height: AppSpacing.xs),
                        TextField(
                          controller: streetController,
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 14,
                            ),
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
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _onWarehouseFieldChanged,
                      child: WarehouseAutocompleteField(
                        controller: detailsController,
                        repository: novaPoshtaRepository,
                        cityName: cityController.text.trim(),
                        type: type,
                        onSelected: (_) {},
                      ),
                    ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    'Вартість доставки за тарифами перевізника (оплачується окремо)',
                    style: AppTextStyles.caption,
                  ),

                  if (errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.errorBorder),
                      ),
                      child: Text(
                        errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorText),
                        textAlign: TextAlign.center,
                      ),
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
                    'Зберегти',
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