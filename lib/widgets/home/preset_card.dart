import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/preset.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Carte de préréglage
class PresetCard extends StatelessWidget {
  final Preset preset;

  const PresetCard({
    super.key,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('interval_timer_home__card_28_${preset.id}'),
      color: AppColors.presetCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(2),
        onTap: () {
          context.read<IntervalTimerHomeState>().loadPreset(preset);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Préréglage "${preset.name}" chargé'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : nom et durée totale
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      preset.name,
                      style: AppTextStyles.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    preset.formattedTotalDuration,
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Détails : répétitions
              Text(
                'RÉPÉTITIONS ${preset.reps}x',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),

              // Détails : temps de travail
              Text(
                'TRAVAIL ${_formatTime(preset.workSeconds)}',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),

              // Détails : temps de repos
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

