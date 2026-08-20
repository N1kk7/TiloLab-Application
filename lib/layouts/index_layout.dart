import 'package:flutter/material.dart';
import 'package:tilolab_app/core/theme/app_colors.dart';

// PAGES
import '../pages/index_page.dart';
import '../pages/cart_page.dart';
import '../pages/products_page.dart';
import '../pages/profile_page.dart';
import '../features/faq/pages/faq_page.dart';
import '../features/about/pages/about_page.dart';

// COMPONENTS
import '../components/bottom_nav.dart';
import '../features/onboarding/presentation/widgets/app_drawer.dart';

// STYLES
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class IndexLayout extends StatefulWidget {
  const IndexLayout({super.key});

  @override
  State<IndexLayout> createState() => _IndexLayoutState();
}

class _IndexLayoutState extends State<IndexLayout> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const IndexPage(),
    const ProductsPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      backgroundColor: AppColors.bg,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppSpacing.lg,
      title: Text(
        'Tilo Lab',
        style: AppTextStyles.h3,
      ),
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.text),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ],
    ),
      drawer: AppDrawer(
        onHome: () {
          Navigator.of(context).pop();
          navigateBottomBar(0);
        },
        onCatalog: () {
          Navigator.of(context).pop();
          navigateBottomBar(1);
        },
        onAbout: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        },
        onFaq: () {
          // Navigator.of(context).pop();
          Navigator.of(context).pop(); 
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const FaqPage()),
  );
          // TODO: навигация на FAQ
        },
        onLogout: () {
          Navigator.of(context).pop();
          // TODO: логика выхода из аккаунта
        },
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTabChange: navigateBottomBar,
      ),
    );
  }
}