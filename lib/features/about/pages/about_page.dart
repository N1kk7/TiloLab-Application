import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/about_image_banner.dart';
import '../widgets/about_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Про нас', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          // вступ — без иконки, крупнее остального текста
          Text(
            'Tilo Lab — це сучасний простір дослідження інтимного здоров\'я, '
            'задоволення та тілесної гармонії. Ми створили лабораторію, де '
            'інновації, наука та турбота про тіло поєднуються у відповідальний '
            'та делікатний сервіс.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.text,
              height: 1.7,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          const AboutSection(
            title: 'Наша філософія',
            icon: Icons.science_outlined,
            text:
                'Наша філософія базується на ідеї, що чуттєвість — це природна '
                'частина людини. Саме тому ми ретельно досліджуємо кожен продукт, '
                'який потрапляє в нашу колекцію: від складу та матеріалів до '
                'ефективності й безпеки.',
          ),
          const SizedBox(height: AppSpacing.lg),

          // картинка — по центру контента
          const AboutImageBanner(),
          const SizedBox(height: AppSpacing.lg),

          const AboutSection(
            title: 'Простір довіри',
            icon: Icons.privacy_tip_outlined,
            text:
                'У Tilo Lab ми прагнемо створити простір, де кожен може вільно й '
                'безпечно пізнавати себе, розширювати межі власного комфорту та '
                'насолоди. Ми забезпечуємо повну конфіденційність, професійний '
                'супровід і естетичний підхід до кожної деталі — від консультацій '
                'до оформлення замовлень.',
          ),
          const SizedBox(height: AppSpacing.lg),

          const AboutSection(
            title: 'Наша місія',
            icon: Icons.favorite_outline,
            text:
                'Наше завдання — не просто продавати девайси та косметику. Ми '
                'формуємо культуру тілесної обізнаності, підтримуємо '
                'індивідуальні дослідження власної чуттєвості та допомагаємо '
                'людям будувати здорові, усвідомлені стосунки зі своїм тілом.',
          ),
          const SizedBox(height: AppSpacing.xl),

          // закрывающая фраза — акцентная, по центру
          Center(
            child: Text(
              'Tilo Lab — лабораторія,\nде кожне відкриття починається з тебе.',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.accent,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}