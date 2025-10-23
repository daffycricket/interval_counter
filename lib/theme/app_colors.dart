import 'package:flutter/material.dart';

/// Tokens de couleurs de l'application
/// Source: design.json tokens.colors
class AppColors {
  AppColors._(); // Constructeur privé pour empêcher l'instanciation

  // Couleurs principales
  static const Color primary = Color(0xFF607D8B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Fond
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Texte
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  
  // Séparateurs et bordures
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFDDDDDD);
  
  // Accents
  static const Color accent = Color(0xFFFFC107);
  
  // Slider
  static const Color sliderActive = Color(0xFFFFFFFF);
  static const Color sliderInactive = Color(0xFF90A4AE);
  static const Color sliderThumb = Color(0xFFFFFFFF);
  
  // CTA et boutons
  static const Color cta = Color(0xFF607D8B);
  
  // Spécifiques
  static const Color headerBackgroundDark = Color(0xFF455A64);
  static const Color presetCardBg = Color(0xFFFAFAFA);
  
  // Sémantiques (pour usage futur)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}

