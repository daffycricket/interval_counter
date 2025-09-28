import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF607D8B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color accent = Color(0xFFFFC107);
  static const Color sliderActive = Color(0xFFFFFFFF);
  static const Color sliderInactive = Color(0xFF90A4AE);
  static const Color sliderThumb = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDDDDDD);
  static const Color cta = Color(0xFF607D8B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  static const Color headerBackgroundDark = Color(0xFF455A64);
  static const Color presetCardBg = Color(0xFFFAFAFA);

  // Helper method to get color by token name
  static Color getColor(String token) {
    switch (token) {
      case 'primary':
        return primary;
      case 'onPrimary':
        return onPrimary;
      case 'background':
        return background;
      case 'surface':
        return surface;
      case 'textPrimary':
        return textPrimary;
      case 'textSecondary':
        return textSecondary;
      case 'divider':
        return divider;
      case 'accent':
        return accent;
      case 'sliderActive':
        return sliderActive;
      case 'sliderInactive':
        return sliderInactive;
      case 'sliderThumb':
        return sliderThumb;
      case 'border':
        return border;
      case 'cta':
        return cta;
      case 'success':
        return success;
      case 'warning':
        return warning;
      case 'info':
        return info;
      case 'headerBackgroundDark':
        return headerBackgroundDark;
      case 'presetCardBg':
        return presetCardBg;
      default:
        return primary; // fallback
    }
  }

  // Helper method with fallback
  static Color getColorOr(String token, Color fallback) {
    try {
      return getColor(token);
    } catch (e) {
      return fallback;
    }
  }
}
