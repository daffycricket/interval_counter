import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte de l'application, extraits de design.json tokens.typography
/// et mappés selon UI_MAPPING_GUIDE rule:font/size
class AppTextStyles {
  // titleLarge : fontSize = 22, fontWeight = FontWeight.bold, height: 1.4
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  // title : fontSize = 22, fontWeight = FontWeight.bold, height = 1.25
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  
  // label : fontSize = 14, fontWeight = FontWeight.w500, height = 1.33
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textSecondary,
  );
  
  // value : fontSize = 22, fontWeight = FontWeight.bold (pour valeurs numériques)
  static const TextStyle value = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  
  // body : fontSize = 14, fontWeight = FontWeight.normal, height = 1.43
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.textSecondary,
  );
  
  AppTextStyles._(); // Constructeur privé pour empêcher l'instanciation
}

