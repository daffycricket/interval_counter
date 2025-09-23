import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte de l'application basés sur les tokens typographiques
class AppTextStyles {
  AppTextStyles._();

  // Styles principaux
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Roboto',
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Roboto',
  );

  // Variantes pour le titre
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  // Styles pour les boutons
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  // Styles pour les valeurs numériques
  static const TextStyle valueText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Roboto',
  );

  // Style pour texte sur fond sombre
  static const TextStyle onDark = TextStyle(
    color: AppColors.onPrimary,
    fontFamily: 'Roboto',
  );
}
