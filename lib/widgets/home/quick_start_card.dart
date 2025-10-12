import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../value_control.dart';

/// Carte de configuration rapide des intervalles
class QuickStartCard extends StatelessWidget {
  final bool isExpanded;
  final int reps;
  final int workSeconds;
  final int restSeconds;
  final VoidCallback onToggle;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementReps;
  final VoidCallback onIncrementWork;
  final VoidCallback onDecrementWork;
  final VoidCallback onIncrementRest;
  final VoidCallback onDecrementRest;
  final VoidCallback onSave;
  final VoidCallback onStart;
  final String Function(int) formatSeconds;
  final bool canDecrementReps;
  final bool canIncrementReps;
  final bool canDecrementWork;
  final bool canIncrementWork;
  final bool canDecrementRest;
  final bool canIncrementRest;

  const QuickStartCard({
    super.key,
    required this.isExpanded,
    required this.reps,
    required this.workSeconds,
    required this.restSeconds,
    required this.onToggle,
    required this.onIncrementReps,
    required this.onDecrementReps,
    required this.onIncrementWork,
    required this.onDecrementWork,
    required this.onIncrementRest,
    required this.onDecrementRest,
    required this.onSave,
    required this.onStart,
    required this.formatSeconds,
    required this.canDecrementReps,
    required this.canIncrementReps,
    required this.canDecrementWork,
    required this.canIncrementWork,
    required this.canDecrementRest,
    required this.canIncrementRest,
  });

  @override
  Widget build(BuildContext context) {
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
            // En-tête avec titre et bouton de repli/dépli
            Row(
              key: const Key('interval_timer_home__Container-7'),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Démarrage rapide',
                  key: const Key('interval_timer_home__Text-8'),
                  style: AppTextStyles.titleLarge,
                ),
                IconButton(
                  key: const Key('interval_timer_home__IconButton-9'),
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  color: AppColors.textSecondary,
                  iconSize: 24,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  onPressed: onToggle,
                  tooltip: isExpanded
                      ? 'Replier la section Démarrage rapide'
                      : 'Déplier la section Démarrage rapide',
                ),
              ],
            ),

            // Contenu de la carte (visible seulement si expanded)
            if (isExpanded) ...[
              const SizedBox(height: 16),

              // Contrôle répétitions
              ValueControl(
                label: 'RÉPÉTITIONS',
                value: reps.toString(),
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

              const SizedBox(height: 24),

              // Contrôle temps de travail
              ValueControl(
                label: 'TRAVAIL',
                value: formatSeconds(workSeconds),
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

              const SizedBox(height: 24),

              // Contrôle temps de repos
              ValueControl(
                label: 'REPOS',
                value: formatSeconds(restSeconds),
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

              const SizedBox(height: 24),

              // Bouton Sauvegarder
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  key: const Key('interval_timer_home__Button-22'),
                  onPressed: onSave,
                  icon: const Icon(
                    Icons.save,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'SAUVEGARDER',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Bouton COMMENCER (CTA)
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  key: const Key('interval_timer_home__Button-23'),
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cta,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: const BorderSide(
                        color: AppColors.cta,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  icon: const Icon(
                    Icons.bolt,
                    size: 20,
                    color: AppColors.accent,
                  ),
                  label: const Text(
                    'COMMENCER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

