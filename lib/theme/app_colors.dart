import 'package:flutter/material.dart';

/// Couleurs sémantiques de l'application, extraites de design.json tokens.colors
class AppColors {
  // Couleurs primaires
  static const Color primary = Color(0xFF607D8B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Couleurs de fond
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Couleurs de texte
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  
  // Couleurs de division et bordures
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFDDDDDD);
  
  // Couleurs d'accent et CTA
  static const Color accent = Color(0xFFC107);
  static const Color cta = Color(0xFF607D8B);
  
  // Couleurs de slider
  static const Color sliderActive = Color(0xFFFFFFFF);
  static const Color sliderInactive = Color(0xFF90A4AE);
  static const Color sliderThumb = Color(0xFFFFFFFF);
  
  // Couleurs d'état
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Couleurs spécifiques
  static const Color headerBackgroundDark = Color(0xFF455A64);
  static const Color presetCardBg = Color(0xFAFAFA);
  
  AppColors._(); // Constructeur privé pour empêcher l'instanciation
}

