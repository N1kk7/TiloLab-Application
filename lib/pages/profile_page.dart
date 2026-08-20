import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
// import '../../../core/theme/app_text_styles.dart';
import '../features/profile/widgets/profile_header.dart';
import '../features/profile/widgets/profile_menu_tile.dart';
import '../features/profile/widgets/profile_section_label.dart';
import '../features/profile/widgets/profile_stats.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          ProfileHeader(
            name: 'Олена Ковальчук',
            email: 'olena.k@example.com',
            onEdit: () {
              // TODO: перейти на редагування профілю
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          ProfileStats(
            items: [
              ProfileStatItem(value: '12', label: 'Замовлення', onTap: () {}),
              ProfileStatItem(value: '5', label: 'Улюблені', onTap: () {}),
              ProfileStatItem(value: '2', label: 'Сертифікати', onTap: () {}),
            ],
          ),

          const ProfileSectionLabel(text: 'ЗАМОВЛЕННЯ'),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                ProfileMenuTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'Історія замовлень',
                  onTap: () {},
                ),
                const Divider(color: AppColors.borderNeutral, height: 1),
                ProfileMenuTile(
                  icon: Icons.favorite_border,
                  label: 'Улюблені товари',
                  onTap: () {},
                ),
                const Divider(color: AppColors.borderNeutral, height: 1),
                ProfileMenuTile(
                  icon: Icons.card_giftcard_outlined,
                  label: 'Мої сертифікати',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const ProfileSectionLabel(text: 'НАЛАШТУВАННЯ'),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                ProfileMenuTile(
                  icon: Icons.location_on_outlined,
                  label: 'Адреси доставки',
                  onTap: () {},
                ),
                const Divider(color: AppColors.borderNeutral, height: 1),
                ProfileMenuTile(
                  icon: Icons.notifications_none,
                  label: 'Сповіщення',
                  onTap: () {},
                ),
                const Divider(color: AppColors.borderNeutral, height: 1),
                ProfileMenuTile(
                  icon: Icons.lock_outline,
                  label: 'Конфіденційність',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const ProfileSectionLabel(text: 'ПІДТРИМКА'),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                ProfileMenuTile(
                  icon: Icons.help_outline,
                  label: 'FAQ',
                  onTap: () {},
                ),
                const Divider(color: AppColors.borderNeutral, height: 1),
                ProfileMenuTile(
                  icon: Icons.support_agent_outlined,
                  label: 'Звʼязатися з нами',
                  onTap: () {},
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
              icon: Icons.logout,
              label: 'Вийти з акаунту',
              isDestructive: true,
              onTap: () {
                // TODO: логіка виходу
              },
            ),
          ),
        ],
      ),
    );
  }
}