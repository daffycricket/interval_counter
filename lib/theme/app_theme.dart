import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
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
      ),
      textTheme: _buildTextTheme(),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.sliderActive,
        inactiveTrackColor: AppColors.sliderInactive,
        thumbColor: AppColors.sliderThumb,
        trackHeight: 4.0,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      useMaterial3: false,
    );
  }

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

  // Helper methods for spacing and radius from tokens
  static double getSpacing(String size) {
    switch (size) {
      case 'xxs':
        return 4;
      case 'xs':
        return 8;
      case 'sm':
        return 12;
      case 'md':
        return 16;
      case 'lg':
        return 24;
      case 'xl':
        return 32;
      default:
        return 16; // fallback
    }
  }

  static double getRadius(String size) {
    switch (size) {
      case 'sm':
        return 4;
      case 'md':
        return 8;
      case 'lg':
        return 12;
      case 'xl':
        return 20;
      default:
        return 8; // fallback
    }
  }
}
