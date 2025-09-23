import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Thème principal de l'application
class AppTheme {
  AppTheme._();

  /// Espacement basé sur les tokens de design
  static const double spacingXxs = 2;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;

  /// Rayons de bordure
  static const double radiusSm = 2;
  static const double radiusMd = 4;
  static const double radiusLg = 8;
  static const double radiusXl = 16;

  /// Ombres
  static const BoxShadow shadowSm = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    offset: Offset(0, 1),
    blurRadius: 2,
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.2),
    offset: Offset(0, 2),
    blurRadius: 4,
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.3),
    offset: Offset(0, 4),
    blurRadius: 8,
  );

  /// Thème complet de l'application
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: _createMaterialColor(AppColors.primary),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      
      // Configuration des app bars
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),

      // Configuration des cartes
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.15),
      ),

      // Configuration des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          backgroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          minimumSize: const Size(0, 48),
        ),
      ),

      // Configuration des boutons fantômes
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.ghostButtonBg,
          textStyle: AppTextStyles.buttonTextSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          side: BorderSide.none,
          minimumSize: const Size(0, 40),
        ),
      ),

      // Configuration des sliders
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.sliderActive,
        inactiveTrackColor: AppColors.sliderInactive,
        thumbColor: AppColors.sliderThumb,
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      ),

      // Configuration des boutons d'icône
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.all(8),
        ),
      ),

      // Thème de texte global
      textTheme: const TextTheme(
        headlineMedium: AppTextStyles.titleLarge,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.title,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.label,
      ),
    );
  }

  /// Utilitaire pour créer un MaterialColor à partir d'une couleur
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    
    return MaterialColor(color.value, swatch);
  }
}
