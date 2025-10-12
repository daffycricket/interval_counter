import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tokens de typographie du design system
class AppTextStyles {
  AppTextStyles._(); // Empêche l'instanciation

  // titleLarge: 22px, bold, h=1.4
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // title: 22px, bold, h=1.25
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // label: 14px, medium, h=1.33
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // body: 14px, regular
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // value: 24px, bold
  static const TextStyle value = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // subtitle: 16px, medium
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

