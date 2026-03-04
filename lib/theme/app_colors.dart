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
  static const Color textActive = Color(0xFFFFFFFF);
  static const Color textInactive = Color(0xFFE0E0E0);
  
  // Séparateurs et bordures
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFDDDDDD);
  
  // Accents
  static const Color accent = Color(0xFFFFC107);
  
  // Slider
  static const Color sliderActive = Color(0xFFFFFFFF);
  static const Color sliderInactive = Color(0xFF90A4AE);
  static const Color sliderActiveDark = Color(0xFF212121);
  static const Color sliderInactiveDark = Color(0xFF90A4AE);
  
  // CTA et boutons
  static const Color cta = Color(0xFF607D8B);
  
  // Spécifiques
  static const Color headerBackgroundDark = Color(0xFF455A64);
  static const Color presetCardBg = Color(0xFFFAFAFA);
  
  // Sémantiques (pour usage futur)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Workout Screen - Couleurs des étapes
  static const Color workColor = Color(0xFF4CD27E); // Vert pour Travail
  static const Color restColor = Color(0xFF2196F3); // Bleu pour Repos
  static const Color prepareColor = Color(0xFFFFCC00); // Jaune pour Préparation
  static const Color cooldownColor = Color.fromARGB(255, 203, 128, 216); // Violet pour Refroidissement
  static const Color ghostButtonBg = Color.fromARGB(255, 85, 85, 85); // Gris foncé pour boutons ghost

  // Advanced Preset Editor
  static const Color advancedBg = Color(0xFF000000);
  static const Color advancedCardBg = Color(0xFF1C1C1C);
  static const Color advancedHeaderBg = Color(0xFF111111);
  static const Color advancedInputBorder = Color(0xFF555555);
  static const Color advancedTextPrimary = Color(0xFFFFFFFF);
  static const Color advancedTextSecondary = Color(0xFFAAAAAA);
  static const Color addButtonBg = Color(0xFFFFFFFF);
  static const Color addButtonFg = Color(0xFF000000);

  // Step colors (Advanced mode)
  static const Color stepMagenta = Color(0xFFCC1177);
  static const Color stepLavender = Color(0xFFB39DDB);
  static const Color stepGreen = Color(0xFF388E3C);
  static const Color stepRed = Color(0xFFD32F2F);
  static const Color finishYellow = Color(0xFFCDDC39);

  /// Preset step color palette for the color picker.
  static const List<Color> stepColorPalette = [
    stepMagenta,
    stepLavender,
    stepGreen,
    stepRed,
    Color(0xFF2196F3), // blue
    Color(0xFFFF9800), // orange
    Color(0xFF9C27B0), // purple
    Color(0xFF00BCD4), // cyan
    Color(0xFFFFEB3B), // yellow
    Color(0xFF795548), // brown
  ];
}

