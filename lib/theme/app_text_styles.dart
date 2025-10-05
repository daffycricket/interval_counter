import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte de l'application (tokens de typographie)
class AppTextStyles {
  AppTextStyles._();

  // Typography tokens
  static const String _fontFamily = 'Roboto';

  /// titleLarge - Titres principaux
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700, // bold
    height: 1.4, // lineHeight 28 / fontSize 20
    color: AppColors.textPrimary,
  );

  /// label - Labels en majuscules
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // medium
    height: 1.33, // lineHeight 16 / fontSize 12
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  /// value - Valeurs numériques/temps
  static const TextStyle value = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // bold
    height: 1.17, // lineHeight 28 / fontSize 24
    color: AppColors.textPrimary,
  );

  /// title - Titres secondaires
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700, // bold
    height: 1.25, // lineHeight 20 / fontSize 16
    color: AppColors.textPrimary,
  );

  /// body - Texte de corps
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // regular
    height: 1.43, // lineHeight 20 / fontSize 14
    color: AppColors.textSecondary,
  );

  /// buttonLabel - Labels de boutons
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500, // medium
    height: 1.43,
    letterSpacing: 0.5,
  );

  /// buttonTitle - Titres de boutons CTA
  static const TextStyle buttonTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700, // bold
    height: 1.25,
    letterSpacing: 0.5,
  );
}