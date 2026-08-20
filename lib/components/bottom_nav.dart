import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabChange;
  final int cartItemsCount;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.cartItemsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(
            top: BorderSide(
              color: AppColors.borderNeutral,
              width: 1,
            ),
          ),
        ),
        child: GNav(
          selectedIndex: selectedIndex,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          gap: AppSpacing.xs,
          color: AppColors.darkText,
          activeColor: AppColors.bg,
          iconSize: 22,
          tabBackgroundColor: AppColors.accent,
          tabBorderRadius: 14,
          textStyle: AppTextStyles.caption.copyWith(
            color: AppColors.bg,
            fontWeight: FontWeight.w600,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          onTabChange: onTabChange,
          tabs: [
            const GButton(
              icon: Icons.home_outlined,
              text: 'Головна',
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            const GButton(
              icon: Icons.grid_view_outlined,
              text: 'Каталог',
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            GButton(
              icon: Icons.shopping_bag_outlined,
              text: 'Кошик',
              leading: cartItemsCount == 0 ? null : _buildCartIcon(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            const GButton(
              icon: Icons.person_outline,
              text: 'Профіль',
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          size: 22,
          color: selectedIndex == 2 ? AppColors.bg : AppColors.darkText,
        ),
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.accentRed,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            child: Text(
              '$cartItemsCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}