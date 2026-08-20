import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class AboutImageBanner extends StatelessWidget {
  final String imageUrl;

  const AboutImageBanner({
    super.key,
    this.imageUrl = 'https://picsum.photos/seed/tilolab-about/800/500',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surfaceElevated,
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_outlined,
              size: 40,
              color: AppColors.darkText,
            ),
          ),
        ),
      ),
    );
  }
}