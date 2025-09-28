import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte de l'application basés sur les design tokens
class AppTextStyles {
  // Tailles de police
  static const double fontSizeXs = 12;
  static const double fontSizeSm = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 20;
  static const double fontSizeXl = 24;

  // Hauteurs de ligne
  static const double lineHeightSm = 16;
  static const double lineHeightMd = 20;
  static const double lineHeightLg = 28;

  // Styles principaux
  static const TextStyle titleLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.bold,
    height: lineHeightLg / fontSizeLg,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  static const TextStyle title = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: FontWeight.bold,
    height: lineHeightMd / fontSizeMd,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w500,
    height: lineHeightMd / fontSizeSm,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  static const TextStyle label = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: FontWeight.w500,
    height: lineHeightSm / fontSizeXs,
    color: AppColors.textSecondary,
    fontFamily: 'Roboto',
  );

  static const TextStyle body = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: FontWeight.normal,
    height: lineHeightMd / fontSizeSm,
    color: AppColors.textSecondary,
    fontFamily: 'Roboto',
  );

  static const TextStyle muted = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: FontWeight.normal,
    height: lineHeightSm / fontSizeXs,
    color: AppColors.textSecondary,
    fontFamily: 'Roboto',
  );

  static const TextStyle value = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: FontWeight.bold,
    height: lineHeightLg / fontSizeXl,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  /// Récupère un style par référence typographique
  static TextStyle getStyle(String typographyRef) {
    switch (typographyRef) {
      case 'titleLarge':
        return titleLarge;
      case 'title':
        return title;
      case 'subtitle':
        return subtitle;
      case 'label':
        return label;
      case 'body':
        return body;
      case 'muted':
        return muted;
      case 'value':
        return value;
      default:
        return body; // Fallback
    }
  }

  /// Applique une transformation de texte
  static String applyTransform(String text, String? transform) {
    if (transform == null) return text;
    switch (transform) {
      case 'uppercase':
        return text.toUpperCase();
      case 'lowercase':
        return text.toLowerCase();
      case 'none':
      default:
        return text;
    }
  }
}
