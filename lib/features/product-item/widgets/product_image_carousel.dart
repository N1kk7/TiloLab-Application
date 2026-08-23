import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
  });

  @override
  State<ProductImageCarousel> createState() =>
      _ProductImageCarouselState();
}

class _ProductImageCarouselState
    extends State<ProductImageCarousel> {

  late final PageController _pageController;

  int currentPage = 0;

  static const String fallbackImage =
      'https://picsum.photos/seed/product-fallback/800/1000';

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;

      if (page != currentPage) {
        setState(() {
          currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final images = widget.imageUrls
        .where((url) => url.trim().isNotEmpty)
        .toList();

    final actualImages = images.isEmpty
        ? [fallbackImage]
        : images;

    return Stack(
      children: [

        PageView.builder(
          controller: _pageController,
          itemCount: actualImages.length,

          itemBuilder: (context, index) {

            final imageUrl = actualImages[index];

            return Image.network(
              imageUrl,

              width: double.infinity,
              height: double.infinity,

              fit: BoxFit.cover,

              loadingBuilder:
                  (context, child, loadingProgress) {

                if (loadingProgress == null) {
                  return child;
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },

              errorBuilder:
                  (context, error, stackTrace) {

                return Container(
                  color: AppColors.surface,

                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            );
          },
        ),

        // Индикаторы
        if (actualImages.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: List.generate(
                actualImages.length,
                (index) {

                  final isActive =
                      index == currentPage;

                  return AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 200),

                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),

                    width: isActive ? 20 : 6,
                    height: 6,

                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white54,

                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}