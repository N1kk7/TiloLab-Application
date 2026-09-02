import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/debouncer.dart';
import '../../nova-posta/data/nova_poshta_repository.dart';
import '../../nova-posta/data/np_warehouse.dart';
import '../../addreses/data/address_model.dart';

class WarehouseAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final NovaPoshtaRepository repository;
  final String cityName;
  final DeliveryType type; // warehouse або postomat
  final ValueChanged<NpWarehouse> onSelected;

  const WarehouseAutocompleteField({
    super.key,
    required this.controller,
    required this.repository,
    required this.cityName,
    required this.type,
    required this.onSelected,
  });

  @override
  State<WarehouseAutocompleteField> createState() => _WarehouseAutocompleteFieldState();
}

class _WarehouseAutocompleteFieldState extends State<WarehouseAutocompleteField> {
  final _debouncer = Debouncer();
  List<NpWarehouse> _results = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }

    if (widget.cityName.trim().isEmpty) {
      // той самий кейс, що й tooltip("Введіть місто") у веб-версії —
      // тут просто не робимо запит, повідомлення показує CheckoutStore/
      // виклик з батьківського віджету при потребі
      return;
    }

    _debouncer.run(() async {
      setState(() => _isLoading = true);

      try {
        final results = widget.type == DeliveryType.warehouse
            ? await widget.repository.searchWarehouses(
                cityName: widget.cityName,
                postNumber: value,
              )
            : await widget.repository.searchPostomats(
                cityName: widget.cityName,
                postomatNumber: value,
              );

        if (!mounted) return;
        setState(() {
          _results = results;
          _isLoading = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _results = [];
          _isLoading = false;
        });
      }
    });
  }

  void _select(NpWarehouse warehouse) {
    widget.controller.text = widget.type == DeliveryType.warehouse
        ? warehouse.description
        : warehouse.shortAddress;
    setState(() => _results = []);
    widget.onSelected(warehouse);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.type == DeliveryType.warehouse ? 'Відділення' : 'Поштомат';
    final hint = widget.type == DeliveryType.warehouse
        ? 'Введіть номер відділення'
        : 'Введіть номер поштомату';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          onChanged: _onChanged,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
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

        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.xs),
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(
                color: AppColors.borderNeutral,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final warehouse = _results[index];

                return ListTile(
                  dense: true,
                  onTap: () => _select(warehouse),
                  title: Text(
                    warehouse.description,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.text),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}