import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/faq_data.dart';
import '../widgets/faq_contact_banner.dart';
import '../widgets/faq_section_card.dart';
import '../widgets/faq_tab_bar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  static const double _tabBarHeight = 52;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();

  late final List<GlobalKey> _sectionKeys =
      List.generate(faqSections.length, (_) => GlobalKey());
  late final List<GlobalKey> _tabKeys =
      List.generate(faqSections.length, (_) => GlobalKey());

  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
  if (!mounted) return;

  final listBox = context.findRenderObject() as RenderBox?;
  if (listBox == null || !listBox.attached) return;

  final threshold = kToolbarHeight +
      MediaQuery.of(context).padding.top +
      _tabBarHeight +
      AppSpacing.md;

  int newActive = _activeIndex;
  double bestPosition = double.negativeInfinity;

  for (int i = 0; i < _sectionKeys.length; i++) {
    final box = _sectionKeys[i].currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) continue;

    final position = box.localToGlobal(Offset.zero, ancestor: listBox).dy;

    if (position <= threshold && position > bestPosition) {
      bestPosition = position;
      newActive = i;
    }
  }

  if (newActive != _activeIndex) {
    setState(() => _activeIndex = newActive);

    final tabRenderObject = _tabKeys[newActive].currentContext?.findRenderObject();
    if (tabRenderObject != null && _tabScrollController.hasClients) {
      _tabScrollController.position.ensureVisible(
        tabRenderObject,
        alignment: 0.5,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }
}

  void _goToSection(int index) {
    final sectionContext = _sectionKeys[index].currentContext;
    if (sectionContext == null) return;

    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('FAQ', style: AppTextStyles.h3),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _FaqTabBarDelegate(
              height: _tabBarHeight,
              child: FaqTabBar(
                labels: faqSections.map((s) => s.tabLabel).toList(),
                activeIndex: _activeIndex,
                onTap: _goToSection,
                tabKeys: _tabKeys,
                scrollController: _tabScrollController,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == faqSections.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: FaqContactBanner(
                        onContactTap: () {
                          // TODO: перейти на екран підтримки
                        },
                      ),
                    );
                  }

                  return Padding(
                    key: _sectionKeys[index],
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: FaqSectionCard(section: faqSections[index]),
                  );
                },
                childCount: faqSections.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _FaqTabBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _FaqTabBarDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}