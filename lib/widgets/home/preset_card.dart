import 'package:flutter/material.dart';
import '../../models/preset.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Carte d'affichage d'un préréglage
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
      key: Key('interval_timer_home__Card-28-${preset.id}'),
      color: AppColors.presetCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : nom et durée totale
              Row(
                key: Key('interval_timer_home__Container-29-${preset.id}'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nom du préréglage
                  Expanded(
                    child: Text(
                      preset.name,
                      style: AppTextStyles.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Durée totale
                  Text(
                    preset.formattedDuration,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Détails : répétitions, travail, repos
              Text(
                'RÉPÉTITIONS ${preset.repetitions}x',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                'TRAVAIL ${_formatTime(preset.workSeconds)}',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                'REPOS ${_formatTime(preset.restSeconds)}',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formate un temps en secondes vers MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}