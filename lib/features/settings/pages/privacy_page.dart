import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/settings_toggle_tile.dart';
import '../../profile/widgets/profile_menu_tile.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool personalizedRecommendations = true;
  bool usageAnalytics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Конфіденційність', style: AppTextStyles.h3),
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
                    label: 'Персоналізовані рекомендації',
                    subtitle: 'На основі ваших переглядів і покупок',
                    value: personalizedRecommendations,
                    onChanged: (v) => setState(() => personalizedRecommendations = v),
                  ),
                  const Divider(color: AppColors.borderNeutral, height: 1),
                  SettingsToggleTile(
                    label: 'Аналітика використання',
                    subtitle: 'Допомагає покращувати застосунок',
                    value: usageAnalytics,
                    onChanged: (v) => setState(() => usageAnalytics = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  ProfileMenuTile(
                    icon: Icons.description_outlined,
                    label: 'Політика конфіденційності',
                    onTap: () {
                      // TODO: відкрити веб-сторінку політики
                    },
                  ),
                  const Divider(color: AppColors.borderNeutral, height: 1),
                  ProfileMenuTile(
                    icon: Icons.gavel_outlined,
                    label: 'Публічна оферта',
                    onTap: () {
                      // TODO: відкрити веб-сторінку оферти
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: ProfileMenuTile(
                icon: Icons.delete_outline,
                label: 'Видалити акаунт',
                isDestructive: true,
                onTap: () {
                  // TODO: підтвердження + видалення акаунту
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}