import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../value_control.dart';

/// Carte de configuration rapide
class QuickStartCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;
  final VoidCallback? onDecrementRepetitions;
  final VoidCallback? onIncrementRepetitions;
  final VoidCallback? onDecrementWorkTime;
  final VoidCallback? onIncrementWorkTime;
  final VoidCallback? onDecrementRestTime;
  final VoidCallback? onIncrementRestTime;
  final VoidCallback? onSave;
  final VoidCallback? onStart;
  final bool canDecrementRepetitions;
  final bool canIncrementRepetitions;
  final bool canDecrementWorkTime;
  final bool canIncrementWorkTime;
  final bool canDecrementRestTime;
  final bool canIncrementRestTime;

  const QuickStartCard({
    super.key,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
    this.onDecrementRepetitions,
    this.onIncrementRepetitions,
    this.onDecrementWorkTime,
    this.onIncrementWorkTime,
    this.onDecrementRestTime,
    this.onIncrementRestTime,
    this.onSave,
    this.onStart,
    this.canDecrementRepetitions = true,
    this.canIncrementRepetitions = true,
    this.canDecrementWorkTime = true,
    this.canIncrementWorkTime = true,
    this.canDecrementRestTime = true,
    this.canIncrementRestTime = true,
  });

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('interval_timer_home__Card-6'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et bouton collapse
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
                Semantics(
                  label: isExpanded
                      ? 'Replier la section Démarrage rapide'
                      : 'Déplier la section Démarrage rapide',
                  button: true,
                  child: IconButton(
                    key: const Key('interval_timer_home__IconButton-9'),
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    color: AppColors.textSecondary,
                    onPressed: onToggleExpanded,
                  ),
                ),
              ],
            ),

            // Contenu collapsible
            if (isExpanded) ...[
              const SizedBox(height: 16),

              // Répétitions
              ValueControl(
                label: 'RÉPÉTITIONS',
                value: repetitions.toString(),
                onDecrease: onDecrementRepetitions,
                onIncrease: onIncrementRepetitions,
                decreaseKey: 'interval_timer_home__IconButton-11',
                valueKey: 'interval_timer_home__Text-12',
                increaseKey: 'interval_timer_home__IconButton-13',
                decreaseSemanticLabel: 'Diminuer les répétitions',
                increaseSemanticLabel: 'Augmenter les répétitions',
                decreaseEnabled: canDecrementRepetitions,
                increaseEnabled: canIncrementRepetitions,
              ),

              const SizedBox(height: 16),

              // Travail
              ValueControl(
                label: 'TRAVAIL',
                value: _formatDuration(workSeconds),
                onDecrease: onDecrementWorkTime,
                onIncrease: onIncrementWorkTime,
                decreaseKey: 'interval_timer_home__IconButton-15',
                valueKey: 'interval_timer_home__Text-16',
                increaseKey: 'interval_timer_home__IconButton-17',
                decreaseSemanticLabel: 'Diminuer le temps de travail',
                increaseSemanticLabel: 'Augmenter le temps de travail',
                decreaseEnabled: canDecrementWorkTime,
                increaseEnabled: canIncrementWorkTime,
              ),

              const SizedBox(height: 16),

              // Repos
              ValueControl(
                label: 'REPOS',
                value: _formatDuration(restSeconds),
                onDecrease: onDecrementRestTime,
                onIncrease: onIncrementRestTime,
                decreaseKey: 'interval_timer_home__IconButton-19',
                valueKey: 'interval_timer_home__Text-20',
                increaseKey: 'interval_timer_home__IconButton-21',
                decreaseSemanticLabel: 'Diminuer le temps de repos',
                increaseSemanticLabel: 'Augmenter le temps de repos',
                decreaseEnabled: canDecrementRestTime,
                increaseEnabled: canIncrementRestTime,
              ),

              const SizedBox(height: 8),

              // Bouton Sauvegarder
              Align(
                alignment: Alignment.centerRight,
                child: Semantics(
                  label: 'Sauvegarder le préréglage rapide',
                  button: true,
                  child: TextButton.icon(
                    key: const Key('interval_timer_home__Button-22'),
                    onPressed: onSave,
                    icon: const Icon(Icons.save, size: 16),
                    label: const Text('SAUVEGARDER'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton Commencer
              Semantics(
                label: 'Démarrer l\'intervalle',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const Key('interval_timer_home__Button-23'),
                    onPressed: onStart,
                    icon: const Icon(Icons.bolt, color: AppColors.accent),
                    label: const Text('COMMENCER'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cta,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      textStyle: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
