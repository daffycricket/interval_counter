import 'package:flutter/material.dart';

/// Couleurs de l'application basées sur les tokens du design system
class AppColors {
  AppColors._();

  // Couleurs principales
  static const Color primary = Color(0xFF2E7D32);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Couleurs de texte
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF555555);
  
  // Couleurs d'interface
  static const Color divider = Color(0xFFDDDDDD);
  static const Color accent = Color(0xFFFFC107);
  static const Color border = Color(0xFFCCCCCC);
  
  // Couleurs du slider
  static const Color sliderActive = Color(0xFF3F51B5);
  static const Color sliderInactive = Color(0xFFBDBDBD);
  static const Color sliderThumb = Color(0xFFFFFFFF);
  
  // Couleurs spécifiques
  static const Color headerBackground = Color(0xFF455A64);
  static const Color ghostButtonBg = Color(0xFFEEEEEE);
  static const Color presetCardBg = Color(0xFFFAFAFA);
}
