import 'package:flutter/material.dart';
import '../../models/preset.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Carte affichant un préréglage sauvegardé
class PresetCard extends StatelessWidget {
  final Preset preset;
  final VoidCallback onTap;

  const PresetCard({
    super.key,
    required this.preset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('interval_timer_home__Card-28'),
      color: AppColors.presetCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête: nom et durée
              Row(
                key: const Key('interval_timer_home__Container-29'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    preset.name,
                    key: const Key('interval_timer_home__Text-30'),
                    style: AppTextStyles.titleLarge,
                  ),
                  Text(
                    preset.formattedDuration,
                    key: const Key('interval_timer_home__Text-31'),
                    style: AppTextStyles.value.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Détails du préréglage
              Text(
                'RÉPÉTITIONS ${preset.repetitions}x',
                key: const Key('interval_timer_home__Text-32'),
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                'TRAVAIL ${_formatTime(preset.workSeconds)}',
                key: const Key('interval_timer_home__Text-33'),
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                'REPOS ${_formatTime(preset.restSeconds)}',
                key: const Key('interval_timer_home__Text-34'),
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formatte les secondes en MM:SS
  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}

