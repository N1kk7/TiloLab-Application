import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onCatalog;
  final VoidCallback onAbout;
  final VoidCallback onFaq;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.onHome,
    required this.onCatalog,
    required this.onAbout,
    required this.onFaq,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 140,
              margin: const EdgeInsets.only(top: AppSpacing.md),
              alignment: Alignment.center,
              child: Image.asset(
                'lib/images/logo.png',
                color: AppColors.text,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Divider(color: AppColors.borderNeutral),
            ),

            const SizedBox(height: AppSpacing.sm),

            DrawerItem(
              icon: Icons.home_outlined,
              label: 'Головна',
              onTap: onHome,
            ),
            DrawerItem(
              icon: Icons.grid_view_outlined,
              label: 'Каталог',
              onTap: onCatalog,
            ),
            DrawerItem(
              icon: Icons.info_outline,
              label: 'Про нас',
              onTap: onAbout,
            ),
            DrawerItem(
              icon: Icons.help_outline,
              label: 'FAQ',
              onTap: onFaq,
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Divider(color: AppColors.borderNeutral),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: DrawerItem(
                icon: Icons.logout,
                label: 'Вийти',
                onTap: onLogout,
                isDestructive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}