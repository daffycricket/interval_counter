import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens from design.json.
/// Font characteristics per UI_MAPPING_GUIDE rule:font/size.
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // Font family
  static const String _fontFamily = 'Roboto';

  /// For section titles like "Démarrage rapide"
  /// fontSize=22, fontWeight=bold, height=1.4
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// For section headings like "VOS PRÉRÉGLAGES", preset names
  /// fontSize=22, fontWeight=bold, height=1.25
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  /// For labels (RÉPÉTITIONS, TRAVAIL, REPOS, button text)
  /// fontSize=14, fontWeight=w500, height=1.33
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// For value displays (16, 00:44, 00:15, 14:22)
  /// fontSize=24, fontWeight=bold, height=1.2
  static const TextStyle value = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// For body text and preset details
  /// fontSize=14, fontWeight=regular, height=1.43
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  /// For button text on CTA button
  /// fontSize=16, fontWeight=bold
  static const TextStyle buttonCta = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );
}
