import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/preset.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Carte représentant un préréglage individuel
class PresetCard extends StatelessWidget {
  final Preset preset;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  
  const PresetCard({
    super.key,
    required this.preset,
    required this.onTap,
    this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<IntervalTimerHomeState>();
    
    return Card(
      key: Key('interval_timer_home__Card-28-${preset.id}'),
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entête: Nom + Durée
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nom du préréglage
                  Expanded(
                    child: Text(
                      preset.name,
                      key: Key('interval_timer_home__Text-30-${preset.id}'),
                      style: AppTextStyles.title.copyWith(fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Icône de suppression (si mode édition)
                  if (state.presetsEditMode && onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      color: AppColors.warning,
                      onPressed: onDelete,
                      tooltip: 'Supprimer le préréglage',
                    ),
                  
                  // Durée totale
                  if (!state.presetsEditMode)
                    Text(
                      preset.formattedDuration,
                      key: Key('interval_timer_home__Text-31-${preset.id}'),
                      style: AppTextStyles.body.copyWith(fontSize: 16),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Détails: RÉPÉTITIONS
              Text(
                'RÉPÉTITIONS ${preset.reps}x',
                key: Key('interval_timer_home__Text-32-${preset.id}'),
                style: AppTextStyles.body,
              ),
              
              const SizedBox(height: 4),
              
              // Détails: TRAVAIL
              Text(
                'TRAVAIL ${_formatTime(preset.workSeconds)}',
                key: Key('interval_timer_home__Text-33-${preset.id}'),
                style: AppTextStyles.body,
              ),
              
              const SizedBox(height: 4),
              
              // Détails: REPOS
              Text(
                'REPOS ${_formatTime(preset.restSeconds)}',
                key: Key('interval_timer_home__Text-34-${preset.id}'),
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

