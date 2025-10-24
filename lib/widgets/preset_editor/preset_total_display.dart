import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';

/// Widget d'affichage du temps total
class PresetTotalDisplay extends StatelessWidget {
  final String formattedTotal;

  const PresetTotalDisplay({
    super.key,
    required this.formattedTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.textPrimary, // Noir
      ),
      child: Text(
        formattedTotal,
        key: const Key('preset_editor__text-28'),
        textAlign: TextAlign.right,
        style: AppTextStyles.value.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimary, // Blanc
        ),
      ),
    );
  }
}

