import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/certificate_card.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final certificates = [
      CertificateCard(
        balance: 1000,
        code: 'TILO-8F2K-91XZ',
        expiresAt: DateTime(2027, 1, 15),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Мої сертифікати', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: certificates.isEmpty
            ? Center(
                child: Text('У вас немає сертифікатів', style: AppTextStyles.bodySmall),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: certificates.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) => certificates[index],
              ),
      ),
    );
  }
}