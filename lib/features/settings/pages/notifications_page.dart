import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/settings_toggle_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool orderUpdates = true;
  bool promotions = true;
  bool news = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Сповіщення', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  SettingsToggleTile(
                    label: 'Статус замовлення',
                    subtitle: 'Оновлення про доставку та оплату',
                    value: orderUpdates,
                    onChanged: (v) => setState(() => orderUpdates = v),
                  ),
                  const Divider(color: AppColors.borderNeutral, height: 1),
                  SettingsToggleTile(
                    label: 'Акції та знижки',
                    subtitle: 'Персональні пропозиції',
                    value: promotions,
                    onChanged: (v) => setState(() => promotions = v),
                  ),
                  const Divider(color: AppColors.borderNeutral, height: 1),
                  SettingsToggleTile(
                    label: 'Новини магазину',
                    subtitle: 'Нові колекції та оновлення',
                    value: news,
                    onChanged: (v) => setState(() => news = v),
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