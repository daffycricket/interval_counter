import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../value_control.dart';

/// Carte de configuration rapide du minuteur
class QuickStartCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final int repetitions;
  final String workTime;
  final String restTime;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementReps;
  final VoidCallback onIncrementWork;
  final VoidCallback onDecrementWork;
  final VoidCallback onIncrementRest;
  final VoidCallback onDecrementRest;
  final bool canIncrementReps;
  final bool canDecrementReps;
  final bool canIncrementWork;
  final bool canDecrementWork;
  final bool canIncrementRest;
  final bool canDecrementRest;
  final VoidCallback onSavePreset;
  final VoidCallback onStartInterval;
  final bool isStartEnabled;

  const QuickStartCard({
    super.key,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.repetitions,
    required this.workTime,
    required this.restTime,
    required this.onIncrementReps,
    required this.onDecrementReps,
    required this.onIncrementWork,
    required this.onDecrementWork,
    required this.onIncrementRest,
    required this.onDecrementRest,
    required this.canIncrementReps,
    required this.canDecrementReps,
    required this.canIncrementWork,
    required this.canDecrementWork,
    required this.canIncrementRest,
    required this.canDecrementRest,
    required this.onSavePreset,
    required this.onStartInterval,
    required this.isStartEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('interval_timer_home__Card-6'),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et bouton de repliement
            Row(
              key: const Key('interval_timer_home__Container-7'),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Démarrage rapide',
                  style: AppTextStyles.titleLarge,
                ),
                Semantics(
                  label: 'Replier la section Démarrage rapide',
                  button: true,
                  child: IconButton(
                    key: const Key('interval_timer_home__IconButton-9'),
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: onToggleExpanded,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    iconSize: 24,
                  ),
                ),
              ],
            ),

            // Contenu replié ou étendu
            if (isExpanded) ...[
              const SizedBox(height: 16),

              // ValueControl RÉPÉTITIONS
              ValueControl(
                label: 'RÉPÉTITIONS',
                value: repetitions.toString(),
                onDecrease: onDecrementReps,
                onIncrease: onIncrementReps,
                decreaseKey: 'interval_timer_home__IconButton-11',
                valueKey: 'interval_timer_home__Text-12',
                increaseKey: 'interval_timer_home__IconButton-13',
                decreaseSemanticLabel: 'Diminuer les répétitions',
                increaseSemanticLabel: 'Augmenter les répétitions',
                decreaseEnabled: canDecrementReps,
                increaseEnabled: canIncrementReps,
              ),

              const SizedBox(height: 16),

              // ValueControl TRAVAIL
              ValueControl(
                label: 'TRAVAIL',
                value: workTime,
                onDecrease: onDecrementWork,
                onIncrease: onIncrementWork,
                decreaseKey: 'interval_timer_home__IconButton-15',
                valueKey: 'interval_timer_home__Text-16',
                increaseKey: 'interval_timer_home__IconButton-17',
                decreaseSemanticLabel: 'Diminuer le temps de travail',
                increaseSemanticLabel: 'Augmenter le temps de travail',
                decreaseEnabled: canDecrementWork,
                increaseEnabled: canIncrementWork,
              ),

              const SizedBox(height: 16),

              // ValueControl REPOS
              ValueControl(
                label: 'REPOS',
                value: restTime,
                onDecrease: onDecrementRest,
                onIncrease: onIncrementRest,
                decreaseKey: 'interval_timer_home__IconButton-19',
                valueKey: 'interval_timer_home__Text-20',
                increaseKey: 'interval_timer_home__IconButton-21',
                decreaseSemanticLabel: 'Diminuer le temps de repos',
                increaseSemanticLabel: 'Augmenter le temps de repos',
                decreaseEnabled: canDecrementRest,
                increaseEnabled: canIncrementRest,
              ),

              const SizedBox(height: 16),

              // Bouton SAUVEGARDER (aligné à droite)
              Align(
                alignment: Alignment.centerRight,
                child: Semantics(
                  label: 'Sauvegarder le préréglage rapide',
                  button: true,
                  child: TextButton.icon(
                    key: const Key('interval_timer_home__Button-22'),
                    onPressed: onSavePreset,
                    icon: const Icon(
                      Icons.save,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    label: Text(
                      'SAUVEGARDER',
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton COMMENCER (pleine largeur)
              Semantics(
                label: 'Démarrer l\'intervalle',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const Key('interval_timer_home__Button-23'),
                    onPressed: isStartEnabled ? onStartInterval : null,
                    icon: const Icon(
                      Icons.bolt,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    label: Text(
                      'COMMENCER',
                      style: AppTextStyles.buttonTitle.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cta,
                      foregroundColor: AppColors.onPrimary,
                      disabledBackgroundColor: AppColors.divider,
                      disabledForegroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}