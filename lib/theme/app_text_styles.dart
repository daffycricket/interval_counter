import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte de l'application
/// Source: design.json tokens.typography et UI_MAPPING_GUIDE rule:font/size
class AppTextStyles {
  AppTextStyles._(); // Constructeur privé pour empêcher l'instanciation

  // Famille de police par défaut
  static const String _fontFamily = 'Roboto';

  /// Style titleLarge (fontSize = 22, fontWeight = bold, height = 1.4)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Style title (fontSize = 22, fontWeight = bold, height = 1.25)
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  /// Style label (fontSize = 14, fontWeight = w500, height = 1.33)
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// Style body (fontSize = 16, fontWeight = regular, height = 1.25)
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: AppColors.textSecondary,
  );

  /// Style value (fontSize = 24, fontWeight = bold, height = 1.17)
  static const TextStyle value = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.17,
    color: AppColors.textPrimary,
  );
}

