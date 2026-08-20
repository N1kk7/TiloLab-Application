import 'package:flutter/material.dart';

class FaqBullet {
  final String text;
  final bool isNested;

  const FaqBullet(this.text, {this.isNested = false});
}

class FaqSection {
  final String title;
  final String tabLabel;
  final IconData icon;
  final String? intro;
  final List<FaqBullet> bullets;
  final String? outro;

  const FaqSection({
    required this.title,
    required this.tabLabel,
    required this.icon,
    this.intro,
    this.bullets = const [],
    this.outro,
  });
}

final List<FaqSection> faqSections = [
  const FaqSection(
    title: 'Як відбувається доставка',
    tabLabel: 'Доставка',
    icon: Icons.local_shipping_outlined,
    bullets: [
      FaqBullet('Куди доставляємо? По всій Україні Новою Поштою.'),
      FaqBullet('Час доставки: 1–3 робочі дні.'),
      FaqBullet('Чи можлива анонімна доставка? Так, упаковка непрозора.'),
      FaqBullet('Вартість: за тарифами Нової Пошти.'),
    ],
  ),
  const FaqSection(
    title: 'Оплата',
    tabLabel: 'Оплата',
    icon: Icons.credit_card_outlined,
    bullets: [
      FaqBullet('Онлайн оплата (Visa / Mastercard / Apple Pay / Google Pay)'),
      FaqBullet('Післяплата'),
    ],
  ),
  const FaqSection(
    title: 'Чи можна повернути замовлення?',
    tabLabel: 'Повернення',
    icon: Icons.assignment_return_outlined,
    bullets: [
      FaqBullet(
        'Згідно з Постановою КМУ №172 від 19.03.1994, інтимні вироби не '
        'підлягають поверненню чи обміну з міркувань гігієни.',
      ),
      FaqBullet('Поверненню підлягають лише неякісні або несправні товари.'),
    ],
  ),
  const FaqSection(
    title: 'Чи є гарантія?',
    tabLabel: 'Гарантія',
    intro: 'Ми надаємо гарантію.',
    icon: Icons.verified_user_outlined,
    bullets: [
      FaqBullet('Якщо ви отримали товар із дефектом, зверніться до нас протягом 48 годин, надавши:'),
      FaqBullet('Номер замовлення та ПІБ', isNested: true),
      FaqBullet('Фото або відео дефекту', isNested: true),
      FaqBullet('Опис проблеми', isNested: true),
    ],
    outro: 'Ми обміняємо товар на новий або повернемо кошти.',
  ),
  const FaqSection(
    title: 'Які використовуються матеріали?',
    tabLabel: 'Матеріали',
    icon: Icons.science_outlined,
    intro:
        'Ми продаємо виключно товари з безпечних матеріалів: медичний '
        'силікон, ABS-пластик, алюміній тощо.',
  ),
  const FaqSection(
    title: 'Як правильно доглядати за інтимною продукцією?',
    tabLabel: 'Догляд',
    icon: Icons.clean_hands_outlined,
    bullets: [
      FaqBullet('Мийте девайс до та після використання теплою водою та спеціальним засобом.'),
      FaqBullet('Не використовуйте спирт або агресивні миючі засоби.'),
      FaqBullet('Зберігайте в сухому місці, окремо від інших девайсів.'),
    ],
  ),
  const FaqSection(
    title: 'Який лубрикант підійде?',
    tabLabel: 'Лубрикант',
    icon: Icons.water_drop_outlined,
    bullets: [
      FaqBullet('Для силіконових іграшок підходить тільки водна основа.'),
      FaqBullet('Для скляних та металевих девайсів підійдуть будь-які.'),
    ],
  ),
];