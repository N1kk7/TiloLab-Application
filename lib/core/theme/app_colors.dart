import 'package:flutter/material.dart';

abstract final class AppColors {
  // Base
  static const bg = Color(0xFF0D0C0D);
  static const text = Color(0xFFFFFFFF);
  static const darkText = Color(0xFF8E8E8E);
  static const textGrey = Color(0xFFDBDBDB);

  // Accent
  static const accent = Color(0xFFFFA9D6);
  static const accentRed = Color(0xFFFF0070);
  static const accentGrey = Color(0xFF686768);

  // Buttons
  static const button = Color(0x73FFA9D6);
  static const buttonHover = Color(0x99FFA9D6);
  static const buttonActive = Color(0xFFFF86BB);

  // Borders / fills
  static const border = Color(0xB3FFA9D6);
  static const transparentFill = Color(0x4DFEFDFE);

  // Links
  static const link = accent;
  static const linkHover = Color(0xFFFF9FC8);
  static const linkActive = buttonActive;

  // Discount
  static const discountPrice = Color(0xFFFF0070);

  // Error
  static const errorBg = Color(0xFF240E18);
  static const errorBorder = Color(0xFFFF4080);
  static const errorText = Color(0xFFFF8EC0);
  static const errorButton = Color(0x59FF4080);
  static const errorButtonHover = Color(0x8CFF4080);
  static const errorButtonActive = Color(0xFFFF4080);

  // Warning
  static const warningBg = Color(0xFF24160E);
  static const warningBorder = Color(0xFFFFAA55);
  static const warningText = Color(0xFFFFD0A0);
  static const warningButton = Color(0x59FFAA55);
  static const warningButtonHover = Color(0x8CFFAA55);
  static const warningButtonActive = Color(0xFFFFAA55);

  // Success
  static const successBg = Color(0xFF071212);
  static const successBorder = Color(0xFF40E0D0);
  static const successText = Color(0xFFA0FFF0);
  static const successButton = Color(0x5940E0D0);
  static const successButtonHover = Color(0x8C40E0D0);
  static const successButtonActive = Color(0xFF40E0D0);

  // Animated background
  static const gradientPink = Color(0xFF5A183D);
  static const gradientPinkDark = Color(0xFF2A1020);
  static const gradientPurple = Color(0xFF24152B);
  static const borderNeutral = Color(0x33FFFFFF);

  static const surface = Color(0xFF1A181B);
  static const surfaceElevated = Color(0xFF221F22);
}