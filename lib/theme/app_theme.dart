import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Thème de l'application basé sur les design tokens
class AppTheme {
  /// Rayon de bordure
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 20;

  /// Espacement
  static const double spacingXxs = 4;
  static const double spacingXs = 8;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  /// Ombres
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x14000000), // rgba(0,0,0,0.08)
    offset: Offset(0, 1),
    blurRadius: 2,
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x1F000000), // rgba(0,0,0,0.12)
    offset: Offset(0, 2),
    blurRadius: 6,
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x29000000), // rgba(0,0,0,0.16)
    offset: Offset(0, 6),
    blurRadius: 20,
  );

  /// Récupère un rayon par nom
  static double getRadius(String? radiusName) {
    switch (radiusName) {
      case 'sm':
        return radiusSm;
      case 'md':
        return radiusMd;
      case 'lg':
        return radiusLg;
      case 'xl':
        return radiusXl;
      default:
        return radiusMd; // Fallback
    }
  }

  /// Récupère un espacement par nom
  static double getSpacing(String spacingName) {
    switch (spacingName) {
      case 'xxs':
        return spacingXxs;
      case 'xs':
        return spacingXs;
      case 'sm':
        return spacingSm;
      case 'md':
        return spacingMd;
      case 'lg':
        return spacingLg;
      case 'xl':
        return spacingXl;
      default:
        return spacingMd; // Fallback
    }
  }

  /// Thème principal de l'application
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      background: AppColors.background,
      onBackground: AppColors.textPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.onPrimary,
      error: AppColors.warning,
      onError: Colors.white,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerBackgroundDark,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: _buildTextTheme(),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.sliderActive,
        inactiveTrackColor: AppColors.sliderInactive,
        thumbColor: AppColors.sliderThumb,
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cta,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingMd,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingSm,
            vertical: spacingXs,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXs,
            vertical: spacingXs,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: AppColors.divider),
        ),
        margin: EdgeInsets.zero,
      ),
      useMaterial3: false,
    );
  }

  /// Construction du thème de texte
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.title,
      titleSmall: AppTextStyles.subtitle,
      labelLarge: AppTextStyles.label,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.muted,
      headlineSmall: AppTextStyles.value,
    );
  }
}
