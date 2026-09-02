import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/debouncer.dart';
import '../../nova-posta/data/nova_poshta_repository.dart';
import '../../nova-posta/data/np_city.dart';

class CityAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final NovaPoshtaRepository repository;
  final ValueChanged<NpCity> onCitySelected;

  const CityAutocompleteField({
    super.key,
    required this.controller,
    required this.repository,
    required this.onCitySelected,
  });

  @override
  State<CityAutocompleteField> createState() => _CityAutocompleteFieldState();
}

class _CityAutocompleteFieldState extends State<CityAutocompleteField> {
  final _debouncer = Debouncer();
  List<NpCity> _results = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    // якщо поле очистили — просто ховаємо список, без запиту
    if (value.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }

    _debouncer.run(() async {
      setState(() => _isLoading = true);

      try {
        final cities = await widget.repository.searchCities(value);
        if (!mounted) return;
        setState(() {
          _results = cities;
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

  void _select(NpCity city) {
    widget.controller.text = city.mainDescription;
    setState(() => _results = []);
    widget.onCitySelected(city);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Місто', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: widget.controller,
          onChanged: _onChanged,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: 'Почніть вводити назву міста',
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
                final city = _results[index];

                return ListTile(
                  dense: true,
                  onTap: () => _select(city),
                  title: Text(
                    city.present,
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