import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Roboto';

  // Font sizes from tokens
  static const double fontSizeXs = 12;
  static const double fontSizeSm = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 20;
  static const double fontSizeXl = 24;

  // Font weights from tokens
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Line heights from tokens
  static const double lineHeightSm = 16;
  static const double lineHeightMd = 20;
  static const double lineHeightLg = 28;

  // Typography styles based on typographyRef
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: fontWeightBold,
    height: lineHeightLg / fontSizeLg,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMd,
    fontWeight: fontWeightBold,
    height: lineHeightMd / fontSizeMd,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightMedium,
    height: lineHeightMd / fontSizeSm,
    color: AppColors.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightMedium,
    height: lineHeightSm / fontSizeXs,
    color: AppColors.textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    height: lineHeightMd / fontSizeSm,
    color: AppColors.textSecondary,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightRegular,
    height: lineHeightSm / fontSizeXs,
    color: AppColors.textSecondary,
  );

  static const TextStyle value = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight: fontWeightBold,
    height: lineHeightLg / fontSizeXl,
    color: AppColors.textPrimary,
  );

  // Helper method to get text style by typographyRef
  static TextStyle getTextStyle(String typographyRef) {
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
        return body; // fallback
    }
  }

  // Apply text transform
  static String applyTransform(String text, String? transform) {
    if (transform == null) return text;
    switch (transform) {
      case 'uppercase':
        return text.toUpperCase();
      case 'lowercase':
        return text.toLowerCase();
      default:
        return text;
    }
  }
}
