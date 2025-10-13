import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/value_control.dart';
import 'quick_start_header.dart';

/// Carte de configuration rapide d'intervalle
class QuickStartCard extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onSave;
  
  const QuickStartCard({
    super.key,
    required this.onStart,
    required this.onSave,
  });
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<IntervalTimerHomeState>();
    
    return Card(
      key: const Key('interval_timer_home__Card-6'),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            const QuickStartHeader(),
            
            // Contenu (visible uniquement si expanded)
            if (state.quickStartExpanded) ...[
              const SizedBox(height: 16),
              
              // ValueControl RÉPÉTITIONS
              ValueControl(
                label: 'RÉPÉTITIONS',
                value: state.reps.toString(),
                onDecrease: state.decrementReps,
                onIncrease: state.incrementReps,
                decreaseKey: 'interval_timer_home__IconButton-11',
                valueKey: 'interval_timer_home__Text-12',
                increaseKey: 'interval_timer_home__IconButton-13',
                decreaseSemanticLabel: 'Diminuer les répétitions',
                increaseSemanticLabel: 'Augmenter les répétitions',
                decreaseEnabled: state.reps > state.minReps,
                increaseEnabled: state.reps < state.maxReps,
              ),
              
              const SizedBox(height: 16),
              
              // ValueControl TRAVAIL
              ValueControl(
                label: 'TRAVAIL',
                value: state.formatTime(state.workSeconds),
                onDecrease: state.decrementWorkTime,
                onIncrease: state.incrementWorkTime,
                decreaseKey: 'interval_timer_home__IconButton-15',
                valueKey: 'interval_timer_home__Text-16',
                increaseKey: 'interval_timer_home__IconButton-17',
                decreaseSemanticLabel: 'Diminuer le temps de travail',
                increaseSemanticLabel: 'Augmenter le temps de travail',
                decreaseEnabled: state.workSeconds > 5,
                increaseEnabled: state.workSeconds < 3600,
              ),
              
              const SizedBox(height: 16),
              
              // ValueControl REPOS
              ValueControl(
                label: 'REPOS',
                value: state.formatTime(state.restSeconds),
                onDecrease: state.decrementRestTime,
                onIncrease: state.incrementRestTime,
                decreaseKey: 'interval_timer_home__IconButton-19',
                valueKey: 'interval_timer_home__Text-20',
                increaseKey: 'interval_timer_home__IconButton-21',
                decreaseSemanticLabel: 'Diminuer le temps de repos',
                increaseSemanticLabel: 'Augmenter le temps de repos',
                decreaseEnabled: state.restSeconds > 0,
                increaseEnabled: state.restSeconds < 3600,
              ),
              
              const SizedBox(height: 16),
              
              // Bouton SAUVEGARDER
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  key: const Key('interval_timer_home__Button-22'),
                  onPressed: onSave,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('SAUVEGARDER'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: AppTextStyles.label,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Bouton COMMENCER (CTA principal)
              ElevatedButton.icon(
                key: const Key('interval_timer_home__Button-23'),
                onPressed: onStart,
                icon: const Icon(Icons.bolt, color: AppColors.accent),
                label: const Text('COMMENCER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cta,
                  foregroundColor: AppColors.onPrimary,
                  textStyle: AppTextStyles.title.copyWith(fontSize: 16),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

